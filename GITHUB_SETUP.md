# 🔧 GitHub Actions Setup (For Platform Team)

**One-time setup to enable automatic deployments from GitHub**

---

## 📋 What This Does

When business users push code to GitHub (main/master branch):
1. ✅ GitHub Actions automatically builds the Docker image
2. ✅ Pushes to Artifact Registry
3. ✅ Deploys to GKE cluster in Dammam
4. ✅ Comments on the commit with the live URL

**Business users don't need GCP credentials!**

---

## 🔐 Step 1: Create GCP Service Account

Run these commands:

```bash
# Set project
export GCP_PROJECT_ID="app-sandbox-factory"

# Create service account
gcloud iam service-accounts create github-actions \
  --display-name="GitHub Actions Deployment" \
  --project=$GCP_PROJECT_ID

# Get the service account email
export SA_EMAIL="github-actions@${GCP_PROJECT_ID}.iam.gserviceaccount.com"

# Grant necessary roles
gcloud projects add-iam-policy-binding $GCP_PROJECT_ID \
  --member="serviceAccount:${SA_EMAIL}" \
  --role="roles/container.developer"

gcloud projects add-iam-policy-binding $GCP_PROJECT_ID \
  --member="serviceAccount:${SA_EMAIL}" \
  --role="roles/artifactregistry.writer"

gcloud projects add-iam-policy-binding $GCP_PROJECT_ID \
  --member="serviceAccount:${SA_EMAIL}" \
  --role="roles/storage.admin"

# Create and download key
gcloud iam service-accounts keys create github-actions-key.json \
  --iam-account=$SA_EMAIL \
  --project=$GCP_PROJECT_ID

echo "✅ Service account key created: github-actions-key.json"
echo "⚠️  Keep this file secure! You'll add it to GitHub secrets next."
```

---

## 🔑 Step 2: Add Secret to GitHub

### For Each App Repository:

1. **Go to the GitHub repository**
   - Example: `https://github.com/your-org/task-manager`

2. **Navigate to Settings → Secrets and variables → Actions**

3. **Click "New repository secret"**

4. **Add the secret:**
   - Name: `GCP_SA_KEY`
   - Value: Copy the **entire contents** of `github-actions-key.json`
   
5. **Click "Add secret"**

---

## 📁 Step 3: Add Workflow File to Each App

Business users need this file in their repo:

```bash
# In their app repository
mkdir -p .github/workflows

# Copy the workflow file
cp ~/Documents/Cursor/cursor-app-factory/.github/workflows/deploy-to-gke.yaml \
   .github/workflows/deploy-to-gke.yaml

# Commit it
git add .github/
git commit -m "Add GitHub Actions deployment"
git push
```

---

## ✅ Step 4: Test It

1. Business user makes a change and pushes:
   ```bash
   git add .
   git commit -m "Update feature"
   git push origin main
   ```

2. GitHub Actions automatically runs (takes ~5-10 minutes)

3. Check the Actions tab: `https://github.com/your-org/repo-name/actions`

4. When complete, a comment appears on the commit with the live URL!

---

## 🎯 Template Repository Approach (Recommended)

### Create a Template Repository

Make this even easier by creating a **template repository**:

```bash
# 1. Create a new repo called "app-template"
cd ~/Documents
mkdir app-template
cd app-template

# 2. Copy the workflow file
mkdir -p .github/workflows
cp ~/Documents/Cursor/cursor-app-factory/.github/workflows/deploy-to-gke.yaml \
   .github/workflows/

# 3. Add basic files
cat > README.md << 'EOF'
# App Template

Ready-to-deploy app template with automatic GitHub Actions deployment.

## Quick Start

1. Use this template to create your app repo
2. Clone your new repo
3. Build your app with Cursor AI (use MAGIC_PROMPT)
4. Test locally: `docker-compose up -d`
5. Push to GitHub: `git push`
6. Auto-deploys to GKE!
EOF

# 4. Add .gitignore
cat > .gitignore << 'EOF'
node_modules/
*.log
.env
.DS_Store
postgres_data/
EOF

# 5. Push to GitHub and mark as template
git init
git add .
git commit -m "Initial template"
git remote add origin https://github.com/your-org/app-template.git
git push -u origin main
```

Then on GitHub:
- Go to repo Settings
- Check "Template repository"

Now business users just click "Use this template" to start new apps!

---

## 🔒 Security Best Practices

### 1. Service Account Key Rotation

Rotate keys every 90 days:

```bash
# Delete old key
gcloud iam service-accounts keys list \
  --iam-account=github-actions@app-sandbox-factory.iam.gserviceaccount.com

gcloud iam service-accounts keys delete KEY_ID \
  --iam-account=github-actions@app-sandbox-factory.iam.gserviceaccount.com

# Create new key
gcloud iam service-accounts keys create github-actions-key-new.json \
  --iam-account=github-actions@app-sandbox-factory.iam.gserviceaccount.com

# Update GitHub secret
```

### 2. Limit Permissions

The service account only has:
- `container.developer` - Deploy to GKE
- `artifactregistry.writer` - Push images
- `storage.admin` - Manage storage (for volumes)

**NO** owner/editor roles!

### 3. Branch Protection

Enable on main/master:
- Require pull request reviews
- Require status checks (deployment succeeds before merge)

### 4. Environment-Specific Deployments

For dev/staging/prod, use GitHub Environments:

```yaml
# In the workflow
jobs:
  deploy:
    environment: production  # Requires approval
```

---

## 📊 Monitoring Deployments

### View Active Deployments

```bash
# List all apps
kubectl get deployments --all-namespaces

# Get app URL
kubectl get services

# View logs
kubectl logs -l app=task-manager --tail=100
```

### Deployment Status Dashboard

Create a simple dashboard:

```bash
#!/bin/bash
# deployment-status.sh

echo "Active Applications in GKE"
echo "=========================="
echo ""

kubectl get deployments -o custom-columns=\
"NAME:.metadata.name,\
READY:.status.readyReplicas,\
IMAGE:.spec.template.spec.containers[0].image,\
AGE:.metadata.creationTimestamp"

echo ""
echo "LoadBalancer URLs"
echo "================="
echo ""

kubectl get services -o custom-columns=\
"NAME:.metadata.name,\
EXTERNAL-IP:.status.loadBalancer.ingress[0].ip,\
PORT:.spec.ports[0].port"
```

---

## 🚀 What Business Users See

### Their Workflow:

```bash
# 1. Build app in Cursor (use MAGIC_PROMPT)
# 2. Test locally
docker-compose up -d
# Visit http://localhost:8080

# 3. Push to GitHub
git add .
git commit -m "My awesome feature"
git push

# 4. Wait ~10 minutes
# 5. Get notification: "🚀 Your app is live at http://34.166.241.XX"
```

**That's it!** They never touch GCP, kubectl, or deployment scripts.

---

## 🔧 Troubleshooting

### Deployment Fails

Check GitHub Actions logs:
- Go to Actions tab
- Click failed run
- Check each step for errors

Common issues:
- `GCP_SA_KEY` secret not set → Add it
- Permission denied → Check service account roles
- Build fails → Fix Dockerfile
- Health check fails → App not listening on 8080

### LoadBalancer IP Not Ready

Sometimes takes 5-10 minutes:

```bash
# Check manually
kubectl get service APP-NAME

# Wait for it
kubectl get service APP-NAME --watch
```

---

## 📝 Summary

✅ **One-time setup**: Create service account, add to GitHub  
✅ **Per-app setup**: Add workflow file + secret  
✅ **User workflow**: Just `git push`  
✅ **Automatic**: Builds, deploys, notifies  
✅ **Secure**: No credentials on user machines  

**Perfect for non-technical business users!** 🎉

