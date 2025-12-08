#!/bin/bash
set -e

# Deploy docker-compose application to Google Kubernetes Engine (GKE)
# Usage: ./scripts/deploy-to-gke.sh [dev|prod]

ENVIRONMENT=${1:-dev}
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Load environment variables
if [ -f "$PROJECT_ROOT/.env" ]; then
    export $(cat "$PROJECT_ROOT/.env" | grep -v '^#' | xargs)
fi

# Set defaults if not provided
GCP_PROJECT_ID=${GCP_PROJECT_ID:-app-sandbox-factory}
GCP_REGION=${GCP_REGION:-us-central1}
SERVICE_NAME=${SERVICE_NAME:-my-app}

# Validate required environment variables
if [ -z "$GCP_PROJECT_ID" ] || [ -z "$GCP_REGION" ]; then
    echo "Error: Missing required environment variables"
    echo "Please ensure GCP_PROJECT_ID and GCP_REGION are set in .env"
    exit 1
fi

# Set environment-specific variables
if [ "$ENVIRONMENT" = "prod" ]; then
    NAMESPACE="${SERVICE_NAME}-prod"
    CLUSTER_NAME="${GCP_PROJECT_ID}-prod"
    REPLICAS=3
    DOMAIN="${SERVICE_NAME}.yourcompany.com"
    echo "🚀 Deploying to PRODUCTION..."
else
    NAMESPACE="${SERVICE_NAME}-dev"
    CLUSTER_NAME="${GCP_PROJECT_ID}-dev"
    REPLICAS=1
    DOMAIN="${SERVICE_NAME}-dev.yourcompany.com"
    echo "🚀 Deploying to DEVELOPMENT..."
fi

GKE_ZONE="${GCP_REGION}-a"
IMAGE_TAG="gcr.io/${GCP_PROJECT_ID}/${SERVICE_NAME}:$(git rev-parse --short HEAD 2>/dev/null || echo 'latest')"

echo "Project: $GCP_PROJECT_ID"
echo "Cluster: $CLUSTER_NAME"
echo "Namespace: $NAMESPACE"
echo "Image: $IMAGE_TAG"
echo "Domain: $DOMAIN"
echo ""

# Confirm production deployment
if [ "$ENVIRONMENT" = "prod" ]; then
    read -p "⚠️  Deploy to PRODUCTION? (yes/no): " -r
    if [[ ! $REPLY =~ ^[Yy][Ee][Ss]$ ]]; then
        echo "Deployment cancelled."
        exit 0
    fi
fi

# Set active GCP project
echo "Setting GCP project..."
gcloud config set project "$GCP_PROJECT_ID"

# Check if GKE cluster exists, create if not
echo ""
echo "Checking GKE cluster..."
if ! gcloud container clusters describe "$CLUSTER_NAME" --zone="$GKE_ZONE" &>/dev/null; then
    echo "Creating GKE cluster (this will take 5-10 minutes)..."
    gcloud container clusters create "$CLUSTER_NAME" \
        --zone="$GKE_ZONE" \
        --num-nodes=3 \
        --machine-type=e2-medium \
        --enable-autoscaling \
        --min-nodes=1 \
        --max-nodes=5 \
        --enable-autorepair \
        --enable-autoupgrade \
        --disk-size=20GB \
        --disk-type=pd-standard
    
    echo "✅ Cluster created"
else
    echo "✅ Cluster exists"
fi

# Get cluster credentials
echo ""
echo "Getting cluster credentials..."
gcloud container clusters get-credentials "$CLUSTER_NAME" --zone="$GKE_ZONE"

# Build Docker image
echo ""
echo "Building Docker image..."
cd "$PROJECT_ROOT"
docker build -t "$IMAGE_TAG" .

# Push to Google Container Registry
echo ""
echo "Pushing image to GCR..."
docker push "$IMAGE_TAG"

# Convert docker-compose to Kubernetes manifests
echo ""
echo "Converting docker-compose.yml to Kubernetes manifests..."
bash "$SCRIPT_DIR/compose-to-k8s.sh" "$NAMESPACE" "$DOMAIN"

# Update image in deployment manifest
echo ""
echo "Updating image in deployment manifest..."
if [ -f "k8s-manifests/app-deployment.yaml" ]; then
    sed -i.bak "s|image:.*|image: $IMAGE_TAG|g" k8s-manifests/app-deployment.yaml
    rm k8s-manifests/app-deployment.yaml.bak
fi

# Update replicas
sed -i.bak "s|replicas:.*|replicas: $REPLICAS|g" k8s-manifests/app-deployment.yaml
rm k8s-manifests/app-deployment.yaml.bak

# Apply Kubernetes manifests
echo ""
echo "Applying Kubernetes manifests..."
kubectl apply -f k8s-manifests/

# Wait for deployment to be ready
echo ""
echo "Waiting for deployment to be ready..."
kubectl wait --for=condition=available --timeout=300s deployment/app -n "$NAMESPACE" || {
    echo "⚠️  Deployment taking longer than expected. Checking logs..."
    kubectl logs -l app=app -n "$NAMESPACE" --tail=50
    echo ""
    echo "Check status with: kubectl get pods -n $NAMESPACE"
    exit 1
}

# Get service external IP
echo ""
echo "Getting service URL..."
SERVICE_IP=""
for i in {1..30}; do
    SERVICE_IP=$(kubectl get svc app -n "$NAMESPACE" -o jsonpath='{.status.loadBalancer.ingress[0].ip}' 2>/dev/null || echo "")
    if [ -n "$SERVICE_IP" ]; then
        break
    fi
    echo "Waiting for external IP... ($i/30)"
    sleep 10
done

if [ -z "$SERVICE_IP" ]; then
    echo "⚠️  External IP not assigned yet. Check later with:"
    echo "   kubectl get svc app -n $NAMESPACE"
else
    SERVICE_URL="http://${SERVICE_IP}:8080"
    echo ""
    echo "✅ Deployment complete!"
    echo "🌐 Service URL: $SERVICE_URL"
    echo ""
    echo "Test with: curl $SERVICE_URL/health"
    echo ""
    
    if [ -n "$DOMAIN" ]; then
        echo "📝 To use custom domain, add DNS A record:"
        echo "   $DOMAIN → $SERVICE_IP"
    fi
fi

# Show useful commands
echo ""
echo "Useful commands:"
echo "  View pods:     kubectl get pods -n $NAMESPACE"
echo "  View logs:     kubectl logs -f -l app=app -n $NAMESPACE"
echo "  View services: kubectl get svc -n $NAMESPACE"
echo "  Delete all:    kubectl delete namespace $NAMESPACE"
echo ""

# Save deployment info
cat > "$PROJECT_ROOT/deployment-info.txt" <<EOF
Deployment Information
=====================
Environment: $ENVIRONMENT
Namespace: $NAMESPACE
Cluster: $CLUSTER_NAME
Zone: $GKE_ZONE
Image: $IMAGE_TAG
Service IP: $SERVICE_IP
Service URL: $SERVICE_URL
Deployed: $(date)

Commands:
---------
View status: kubectl get all -n $NAMESPACE
View logs:   kubectl logs -f -l app=app -n $NAMESPACE
Scale up:    kubectl scale deployment/app --replicas=5 -n $NAMESPACE
Rollback:    kubectl rollout undo deployment/app -n $NAMESPACE
EOF

echo "📄 Deployment info saved to deployment-info.txt"

