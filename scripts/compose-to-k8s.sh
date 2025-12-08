#!/bin/bash
set -e

# Convert docker-compose.yml to Kubernetes manifests
# Usage: ./scripts/compose-to-k8s.sh [namespace] [domain]

NAMESPACE=${1:-default}
DOMAIN=${2:-""}
OUTPUT_DIR="k8s-manifests"

echo "🔄 Converting docker-compose.yml to Kubernetes manifests..."
echo "Namespace: $NAMESPACE"
echo "Domain: $DOMAIN"
echo ""

# Check if docker-compose.yml exists
if [ ! -f "docker-compose.yml" ]; then
    echo "❌ docker-compose.yml not found!"
    exit 1
fi

# Create output directory
mkdir -p "$OUTPUT_DIR"

# Check if kompose is installed
if ! command -v kompose &> /dev/null; then
    echo "Installing kompose..."
    curl -L https://github.com/kubernetes/kompose/releases/download/v1.31.2/kompose-linux-amd64 -o kompose
    chmod +x kompose
    sudo mv kompose /usr/local/bin/
fi

# Convert using kompose
echo "Converting with kompose..."
kompose convert -f docker-compose.yml -o "$OUTPUT_DIR/"

# Fix common issues with generated manifests
echo "Applying fixes to generated manifests..."

# Function to update manifests
fix_manifests() {
    local dir=$1
    
    # Update namespace in all manifests
    find "$dir" -name "*.yaml" -type f -exec sed -i "s/namespace: default/namespace: $NAMESPACE/g" {} \;
    
    # Change ClusterIP to LoadBalancer for app service
    if [ -f "$dir/app-service.yaml" ]; then
        sed -i 's/type: ClusterIP/type: LoadBalancer/g' "$dir/app-service.yaml"
    fi
    
    # Add resource limits
    find "$dir" -name "*-deployment.yaml" -type f | while read -r file; do
        if ! grep -q "resources:" "$file"; then
            # Add basic resource limits
            sed -i '/containers:/a\        resources:\n          requests:\n            memory: "128Mi"\n            cpu: "100m"\n          limits:\n            memory: "512Mi"\n            cpu: "500m"' "$file"
        fi
    done
}

fix_manifests "$OUTPUT_DIR"

# Create namespace manifest
cat > "$OUTPUT_DIR/00-namespace.yaml" <<EOF
apiVersion: v1
kind: Namespace
metadata:
  name: $NAMESPACE
  labels:
    name: $NAMESPACE
EOF

# Create secrets manifest from docker-compose environment
echo "Creating secrets manifest..."

# Extract DATABASE_URL from docker-compose.yml
DB_URL=$(grep "DATABASE_URL=" docker-compose.yml | head -1 | cut -d'=' -f2- | tr -d ' ')

cat > "$OUTPUT_DIR/01-secrets.yaml" <<EOF
apiVersion: v1
kind: Secret
metadata:
  name: app-secrets
  namespace: $NAMESPACE
type: Opaque
stringData:
  DATABASE_URL: "$DB_URL"
EOF

# Update deployment to use secrets
if [ -f "$OUTPUT_DIR/app-deployment.yaml" ]; then
    # Remove environment variables and use secretRef instead
    cat > "$OUTPUT_DIR/app-deployment.yaml.tmp" <<'EOF'
apiVersion: apps/v1
kind: Deployment
metadata:
  name: app
  namespace: NAMESPACE_PLACEHOLDER
spec:
  replicas: 2
  selector:
    matchLabels:
      app: app
  template:
    metadata:
      labels:
        app: app
    spec:
      containers:
      - name: app
        image: APP_IMAGE_PLACEHOLDER
        ports:
        - containerPort: 8080
        envFrom:
        - secretRef:
            name: app-secrets
        env:
        - name: NODE_ENV
          value: "production"
        - name: PORT
          value: "8080"
        resources:
          requests:
            memory: "256Mi"
            cpu: "100m"
          limits:
            memory: "512Mi"
            cpu: "500m"
        livenessProbe:
          httpGet:
            path: /health
            port: 8080
          initialDelaySeconds: 30
          periodSeconds: 10
        readinessProbe:
          httpGet:
            path: /health
            port: 8080
          initialDelaySeconds: 5
          periodSeconds: 5
EOF
    
    # Get image name from original file
    IMAGE_NAME=$(grep "image:" "$OUTPUT_DIR/app-deployment.yaml" | head -1 | awk '{print $2}')
    
    sed "s|NAMESPACE_PLACEHOLDER|$NAMESPACE|g" "$OUTPUT_DIR/app-deployment.yaml.tmp" | \
    sed "s|APP_IMAGE_PLACEHOLDER|$IMAGE_NAME|g" > "$OUTPUT_DIR/app-deployment.yaml"
    
    rm "$OUTPUT_DIR/app-deployment.yaml.tmp"
fi

# Create PostgreSQL StatefulSet (better than Deployment for databases)
cat > "$OUTPUT_DIR/db-statefulset.yaml" <<EOF
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: db
  namespace: $NAMESPACE
spec:
  serviceName: db
  replicas: 1
  selector:
    matchLabels:
      app: db
  template:
    metadata:
      labels:
        app: db
    spec:
      containers:
      - name: postgres
        image: postgres:16-alpine
        ports:
        - containerPort: 5432
          name: postgres
        env:
        - name: POSTGRES_DB
          value: appdb
        - name: POSTGRES_USER
          value: appuser
        - name: POSTGRES_PASSWORD
          value: apppass123
        - name: PGDATA
          value: /var/lib/postgresql/data/pgdata
        volumeMounts:
        - name: postgres-storage
          mountPath: /var/lib/postgresql/data
        resources:
          requests:
            memory: "256Mi"
            cpu: "100m"
          limits:
            memory: "1Gi"
            cpu: "500m"
        livenessProbe:
          exec:
            command:
            - pg_isready
            - -U
            - appuser
          initialDelaySeconds: 30
          periodSeconds: 10
        readinessProbe:
          exec:
            command:
            - pg_isready
            - -U
            - appuser
          initialDelaySeconds: 5
          periodSeconds: 5
  volumeClaimTemplates:
  - metadata:
      name: postgres-storage
    spec:
      accessModes: [ "ReadWriteOnce" ]
      resources:
        requests:
          storage: 10Gi
EOF

# Create PersistentVolumeClaims
cat > "$OUTPUT_DIR/02-pvcs.yaml" <<EOF
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: app-uploads
  namespace: $NAMESPACE
spec:
  accessModes:
    - ReadWriteMany
  resources:
    requests:
      storage: 10Gi
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: postgres-data
  namespace: $NAMESPACE
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 10Gi
EOF

# Create Ingress if domain is provided
if [ -n "$DOMAIN" ]; then
    echo "Creating Ingress for domain: $DOMAIN"
    cat > "$OUTPUT_DIR/ingress.yaml" <<EOF
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: app-ingress
  namespace: $NAMESPACE
  annotations:
    kubernetes.io/ingress.class: "nginx"
    cert-manager.io/cluster-issuer: "letsencrypt-prod"
    nginx.ingress.kubernetes.io/ssl-redirect: "true"
spec:
  tls:
  - hosts:
    - $DOMAIN
    secretName: app-tls
  rules:
  - host: $DOMAIN
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: app
            port:
              number: 8080
EOF
fi

echo ""
echo "✅ Conversion complete!"
echo ""
echo "📁 Manifests generated in: $OUTPUT_DIR/"
echo ""
echo "Next steps:"
echo "1. Build and push Docker image:"
echo "   docker build -t gcr.io/\$PROJECT_ID/app:latest ."
echo "   docker push gcr.io/\$PROJECT_ID/app:latest"
echo ""
echo "2. Update image in $OUTPUT_DIR/app-deployment.yaml"
echo ""
echo "3. Deploy to Kubernetes:"
echo "   kubectl apply -f $OUTPUT_DIR/"
echo ""
echo "4. Check status:"
echo "   kubectl get pods -n $NAMESPACE"
echo "   kubectl get svc -n $NAMESPACE"
echo ""



