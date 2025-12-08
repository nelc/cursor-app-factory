#!/bin/bash

# Simple deployment script
# Usage: ./deploy-app.sh [app-folder-name]

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

echo ""
echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║              🚀 DEPLOYING APP TO GCP (DAMMAM)                 ║"
echo "╚═══════════════════════════════════════════════════════════════╝"
echo ""

# Get app directory
if [ -z "$1" ]; then
    # If no argument, assume we're in the app directory
    APP_DIR="$(pwd)"
    APP_NAME="$(basename "$APP_DIR")"
else
    # If argument provided, use that as the app folder
    APP_DIR="$1"
    APP_NAME="$(basename "$APP_DIR")"
fi

echo -e "${BLUE}📁 App Directory:${NC} $APP_DIR"
echo -e "${BLUE}📦 App Name:${NC} $APP_NAME"
echo ""

# Check docker-compose.yaml exists
if [ ! -f "$APP_DIR/docker-compose.yaml" ] && [ ! -f "$APP_DIR/docker-compose.yml" ]; then
    echo -e "${RED}❌ Error: No docker-compose.yaml found in $APP_DIR${NC}"
    echo "Make sure you're in your app directory or provide the path as an argument."
    exit 1
fi

# Set GCP project and region
export GCP_PROJECT_ID="app-sandbox-factory"
export GCP_REGION="me-central2"
export GKE_CLUSTER="app-factory-prod"

# Set up GKE auth
export USE_GKE_GCLOUD_AUTH_PLUGIN=True
export PATH="/opt/homebrew/share/google-cloud-sdk/bin:$PATH"

echo -e "${BLUE}🔧 GCP Project:${NC} $GCP_PROJECT_ID"
echo -e "${BLUE}🌍 Region:${NC} $GCP_REGION"
echo -e "${BLUE}☸️  Cluster:${NC} $GKE_CLUSTER"
echo ""

# Step 1: Build Docker image
echo -e "${GREEN}[1/5] Building Docker image...${NC}"
cd "$APP_DIR"
docker build -t "${APP_NAME}:latest" .
echo -e "${GREEN}✓ Image built${NC}"
echo ""

# Step 2: Tag and push to Artifact Registry
echo -e "${GREEN}[2/5] Pushing to Artifact Registry...${NC}"
REGISTRY="me-central2-docker.pkg.dev"
IMAGE_PATH="${REGISTRY}/${GCP_PROJECT_ID}/app-factory/${APP_NAME}:latest"

docker tag "${APP_NAME}:latest" "${IMAGE_PATH}"
docker push "${IMAGE_PATH}"
echo -e "${GREEN}✓ Image pushed${NC}"
echo ""

# Step 3: Convert docker-compose to Kubernetes
echo -e "${GREEN}[3/5] Converting to Kubernetes manifests...${NC}"
mkdir -p k8s-output

# Simple conversion (basic version)
cat > k8s-output/deployment.yaml << EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: ${APP_NAME}
spec:
  replicas: 1
  selector:
    matchLabels:
      app: ${APP_NAME}
  template:
    metadata:
      labels:
        app: ${APP_NAME}
    spec:
      containers:
      - name: app
        image: ${IMAGE_PATH}
        ports:
        - containerPort: 8080
        env:
        - name: DATABASE_URL
          value: "postgresql://appuser:apppass@${APP_NAME}-db:5432/appdb"
---
apiVersion: v1
kind: Service
metadata:
  name: ${APP_NAME}
spec:
  type: LoadBalancer
  ports:
  - port: 80
    targetPort: 8080
  selector:
    app: ${APP_NAME}
---
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: ${APP_NAME}-db
spec:
  serviceName: ${APP_NAME}-db
  replicas: 1
  selector:
    matchLabels:
      app: ${APP_NAME}-db
  template:
    metadata:
      labels:
        app: ${APP_NAME}-db
    spec:
      containers:
      - name: postgres
        image: postgres:16-alpine
        ports:
        - containerPort: 5432
        env:
        - name: POSTGRES_DB
          value: appdb
        - name: POSTGRES_USER
          value: appuser
        - name: POSTGRES_PASSWORD
          value: apppass
        volumeMounts:
        - name: data
          mountPath: /var/lib/postgresql/data
  volumeClaimTemplates:
  - metadata:
      name: data
    spec:
      accessModes: ["ReadWriteOnce"]
      resources:
        requests:
          storage: 10Gi
---
apiVersion: v1
kind: Service
metadata:
  name: ${APP_NAME}-db
spec:
  clusterIP: None
  ports:
  - port: 5432
  selector:
    app: ${APP_NAME}-db
EOF

echo -e "${GREEN}✓ Manifests generated${NC}"
echo ""

# Step 4: Get cluster credentials
echo -e "${GREEN}[4/5] Connecting to GKE cluster...${NC}"
gcloud container clusters get-credentials $GKE_CLUSTER \
  --region=$GCP_REGION \
  --project=$GCP_PROJECT_ID 2>/dev/null || true
echo -e "${GREEN}✓ Connected${NC}"
echo ""

# Step 5: Deploy to Kubernetes
echo -e "${GREEN}[5/5] Deploying to Kubernetes...${NC}"
kubectl apply -f k8s-output/deployment.yaml
echo -e "${GREEN}✓ Deployed${NC}"
echo ""

# Wait for LoadBalancer
echo -e "${BLUE}⏳ Waiting for LoadBalancer IP (this takes ~2 minutes)...${NC}"
echo ""

for i in {1..60}; do
    EXTERNAL_IP=$(kubectl get service ${APP_NAME} -o jsonpath='{.status.loadBalancer.ingress[0].ip}' 2>/dev/null || echo "")
    if [ ! -z "$EXTERNAL_IP" ]; then
        break
    fi
    echo -n "."
    sleep 2
done

echo ""
echo ""

if [ -z "$EXTERNAL_IP" ]; then
    echo -e "${BLUE}⏳ LoadBalancer is still being created...${NC}"
    echo ""
    echo "Run this command in a few minutes to get your URL:"
    echo "  kubectl get service ${APP_NAME}"
else
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo -e "${GREEN}✅ DEPLOYMENT SUCCESSFUL!${NC}"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo -e "${GREEN}🌐 Your app is live at:${NC}"
    echo -e "   ${BLUE}http://${EXTERNAL_IP}${NC}"
    echo ""
    echo "Share this URL with your team!"
fi

echo ""
echo "📊 Useful commands:"
echo "  kubectl get pods                    # Check app status"
echo "  kubectl logs -l app=${APP_NAME}     # View logs"
echo "  kubectl get service ${APP_NAME}     # Get URL"
echo ""

