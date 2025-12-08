# 🚀 Deploy Your App (NELC Business Users)

**Simple 3-step deployment - No secrets needed!**

---

## Prerequisites

- ✅ You built an app with Cursor (used MAGIC_PROMPT)
- ✅ You tested it locally: `docker-compose up -d`
- ✅ You have access to NELC GitHub org
- ✅ You have `gh` CLI authenticated

---

## Step 1: Add Deployment File (10 seconds)

In your app folder, run:

```bash
mkdir -p .github/workflows
curl -o .github/workflows/deploy-to-gke.yaml \
  https://raw.githubusercontent.com/nelc/cursor-app-factory/main/.github/workflows/deploy-to-gke.yaml
```

*(Replace `nelc` with your actual org name)*

---

## Step 2: Push to GitHub (1 minute)

```bash
# Create repo in NELC org
gh repo create nelc/YOUR-APP-NAME --private

# Push your code
git init
git add .
git commit -m "Deploy to production"
git remote add origin https://github.com/nelc/YOUR-APP-NAME.git
git push -u origin main
```

Replace `YOUR-APP-NAME` with your app name (e.g., `task-manager`, `inventory-app`)

---

## Step 3: Get Your URL (10 minutes)

1. Go to your repo: `https://github.com/nelc/YOUR-APP-NAME`
2. Click the **"Actions"** tab
3. Watch the deployment progress
4. When it shows ✅ **green checkmark**, click on your latest commit
5. You'll see a comment: **"🚀 Your app is live at: http://XX.XX.XX.XX"**

**Open that URL - your app is live on GCP!** 🎉

---

## 🔄 Making Updates

```bash
# Make changes in Cursor
# Test locally: docker-compose up -d

# Deploy update
git add .
git commit -m "Added new feature"
git push
```

**That's it!** Auto-deploys in 10 minutes.

---

## 🔍 Checking Your App Status

### View logs:
```bash
gh run list --repo nelc/YOUR-APP-NAME
gh run view --repo nelc/YOUR-APP-NAME
```

### Get your URL anytime:
```bash
kubectl get service YOUR-APP-NAME
```

(Or check the commit comment on GitHub)

---

## 📊 Example Full Workflow

```bash
# 1. Build app in Cursor with MAGIC_PROMPT
# 2. Test locally
cd ~/my-awesome-app
docker-compose up -d
# Visit http://localhost:8080 - it works!

# 3. Add deployment
mkdir -p .github/workflows
curl -o .github/workflows/deploy-to-gke.yaml \
  https://raw.githubusercontent.com/nelc/cursor-app-factory/main/.github/workflows/deploy-to-gke.yaml

# 4. Deploy
gh repo create nelc/awesome-app --private
git init
git add .
git commit -m "Initial deployment"
git remote add origin https://github.com/nelc/awesome-app.git
git push -u origin main

# 5. Wait 10 minutes, get URL from GitHub Actions tab
# 6. Share URL with team!
```

---

## ❓ FAQ

### Do I need to add any secrets?

**No!** The organization admin already set up `GCP_SA_KEY` for all repos. Just push code.

### What if deployment fails?

Check the **Actions** tab on GitHub for error details. Common issues:
- Docker build failed → Fix your Dockerfile
- Health check failed → Make sure app runs on port 8080
- Permission error → Contact platform team

### Can I deploy to staging first?

Push to a `staging` branch:
```bash
git checkout -b staging
git push origin staging
```

(Platform team needs to configure this first)

### How do I delete my app?

```bash
kubectl delete deployment YOUR-APP-NAME
kubectl delete service YOUR-APP-NAME
kubectl delete statefulset YOUR-APP-NAME-db
```

Or ask platform team to remove it.

---

## 🆘 Need Help?

Contact platform team with:
- **Repo URL**: https://github.com/nelc/YOUR-APP-NAME
- **Actions tab screenshot** (if deployment failed)
- **What you expected vs what happened**

---

## 🎯 Summary

```
1. Add workflow file (curl command)
2. Push to GitHub (gh repo create + git push)
3. Get URL from Actions tab
```

**Total time: 2 minutes of work + 10 minutes waiting for deployment**

**No secrets, no GCP credentials, no kubectl needed!** ✨

