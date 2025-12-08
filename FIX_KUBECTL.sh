#!/bin/bash

# Fix kubectl access to GKE cluster
# Run this script: bash FIX_KUBECTL.sh

echo "🔧 Step 1: Fixing .kube directory permissions..."
sudo chown -R $USER ~/.kube
sudo chmod -R 755 ~/.kube

echo ""
echo "✅ Permissions fixed!"
echo ""
echo "📦 Step 2: Installing GKE auth plugin..."
gcloud components install gke-gcloud-auth-plugin --quiet

echo ""
echo "✅ Plugin installed!"
echo ""
echo "🔧 Step 3: Updating shell configuration..."
# Add to shell profile if not already there
if ! grep -q "USE_GKE_GCLOUD_AUTH_PLUGIN" ~/.zshrc 2>/dev/null; then
  echo 'export USE_GKE_GCLOUD_AUTH_PLUGIN=True' >> ~/.zshrc
  echo 'export PATH="/opt/homebrew/share/google-cloud-sdk/bin:$PATH"' >> ~/.zshrc
  echo "✅ Added to ~/.zshrc"
else
  echo "✅ Already configured in ~/.zshrc"
fi

echo ""
echo "📥 Step 4: Getting cluster credentials..."
gcloud container clusters get-credentials app-factory-prod \
  --region=me-central2 \
  --project=app-sandbox-factory

echo ""
echo "🔧 Step 5: Setting up environment for current shell..."
export USE_GKE_GCLOUD_AUTH_PLUGIN=True
export PATH="/opt/homebrew/share/google-cloud-sdk/bin:$PATH"

echo ""
echo "🔍 Step 6: Testing kubectl connection..."
kubectl cluster-info

echo ""
echo "📋 Checking namespaces..."
kubectl get namespaces

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ SUCCESS! kubectl is now configured!"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "⚠️  IMPORTANT: Open a NEW terminal window for the PATH changes to take effect."
echo ""
echo "Or run this in your current terminal:"
echo "  export USE_GKE_GCLOUD_AUTH_PLUGIN=True"
echo "  export PATH=\"/opt/homebrew/share/google-cloud-sdk/bin:\$PATH\""
echo ""
echo "📖 Next steps:"
echo "  - Read START_HERE.md for deployment workflow"
echo "  - Deploy apps with: make deploy"
echo "  - Check status with: kubectl get all"
echo ""
