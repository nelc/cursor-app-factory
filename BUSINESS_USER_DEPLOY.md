# 🚀 Deploy Your App to GCP (3 Steps)

> **For Business Users**: Zero configuration needed! Just follow these 3 steps.

---

## Prerequisites

- ✅ App built with Cursor (using `MAGIC_PROMPT.md`)
- ✅ Tested locally with `docker-compose up -d`
- ✅ GitHub CLI authenticated (`gh auth login`)

---

## Step 1: Add Deployment Workflow

**⚠️ IMPORTANT: Copy the template EXACTLY - DO NOT create your own!**

```bash
# In your app directory
mkdir -p .github/workflows

# Copy the pre-configured workflow (DO NOT MODIFY)
curl -o .github/workflows/deploy-to-gke.yaml \
  https://raw.githubusercontent.com/nelc/cursor-app-factory/main/templates/deploy-to-gke.yaml
```

**✅ What this does:**
- Downloads a pre-configured workflow
- Already has ALL GCP settings (project, region, cluster)
- Already uses org-level credentials (no secrets to add!)

**❌ DO NOT:**
- Create your own workflow file
- Ask Cursor AI to generate a workflow
- Modify the downloaded workflow
- Add any GitHub secrets (already configured at org level!)

---

## Step 2: Push to GitHub

```bash
# Initialize git (if not already done)
git init
git add .
git commit -m "Deploy my app"

# Create GitHub repo in nelc organization (MUST be private)
gh repo create nelc/my-app-name --private

# Add remote and push
git remote add origin https://github.com/nelc/my-app-name.git
git push -u origin main
```

**Replace `my-app-name` with your actual app name** (lowercase, no spaces).

---

## Step 3: Wait for Deployment

1. **Go to your repo on GitHub**:
   ```
   https://github.com/nelc/my-app-name
   ```

2. **Click "Actions" tab**

3. **Watch the deployment** (takes ~10 minutes)

4. **Get your app URL**:
   - When deployment completes, GitHub Actions will post a comment on your commit
   - The comment will contain your app's public URL
   - Example: `http://34.123.45.67`

---

## ✅ You're Done!

Your app is now live on GCP in Dammam! 🎉

### What Just Happened?

The workflow automatically:
- ✅ Built your Docker image
- ✅ Pushed to Google Artifact Registry
- ✅ Deployed to GKE (Kubernetes)
- ✅ Created database with persistent storage
- ✅ Exposed app on public LoadBalancer IP
- ✅ Set up health checks

### No Configuration Needed Because:

- ✅ GCP credentials: Org-level secret (already configured)
- ✅ Project ID: Pre-configured (`app-sandbox-factory`)
- ✅ Region: Pre-configured (Dammam `me-central2`)
- ✅ Cluster: Pre-configured (`app-factory-prod`)

---

## 🔄 Update Your App

To deploy changes:

```bash
git add .
git commit -m "Update my app"
git push origin main
```

It will auto-deploy again! Same process, new version.

---

## 🆘 Troubleshooting

### Deployment Failed?

1. **Check Actions tab** for error details
2. **Common issues**:
   - App doesn't have `/health` endpoint → Add it
   - App doesn't run on port 8080 → Fix it
   - Dockerfile missing → Use MAGIC_PROMPT again
   - docker-compose.yaml missing → Use MAGIC_PROMPT again

### Need Help?

- Review: `MAGIC_PROMPT.md` (requirements for deployable apps)
- Check: `BEGINNER_GUIDE.md` (detailed walkthrough)
- Ask: Platform team

---

## 📖 Summary

```bash
# 1. Add workflow (copy template exactly)
curl -o .github/workflows/deploy-to-gke.yaml \
  https://raw.githubusercontent.com/nelc/cursor-app-factory/main/templates/deploy-to-gke.yaml

# 2. Push to GitHub
gh repo create nelc/my-app --private
git push origin main

# 3. Wait 10 min → Get URL from Actions tab
```

**That's it! No secrets, no GCP config, just push and deploy!** ✨
