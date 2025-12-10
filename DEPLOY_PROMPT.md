# 🚀 Deployment Prompt

> **This prompt is now integrated into [MAGIC_PROMPT.md](MAGIC_PROMPT.md)**

---

## For New Apps

If you're building a new app, use the **single consolidated prompt** in:

**[MAGIC_PROMPT.md](MAGIC_PROMPT.md)**

This one prompt handles:
- ✅ App structure
- ✅ Docker setup
- ✅ Database configuration
- ✅ **Deployment workflow** (downloads automatically)
- ✅ Health checks
- ✅ Everything else

Then just push to GitHub and it deploys automatically!

---

## For Existing Apps (Already Built)

If you already have an app and just want to add deployment:

### Step 1: Download Deployment Workflow

```bash
mkdir -p .github/workflows
curl -o .github/workflows/deploy-to-gke.yaml \
  https://raw.githubusercontent.com/nelc/cursor-app-factory/main/templates/deploy-to-gke.yaml
```

### Step 2: Ensure Compatibility

Tell Cursor:
```
Review the deployment workflow in .github/workflows/deploy-to-gke.yaml and my application.
Make minimal compatibility fixes if needed:
- Ensure app listens on port 8080
- Ensure app binds to 0.0.0.0
- Ensure /health endpoint exists and returns {"status":"healthy"}
- Ensure app uses DATABASE_URL environment variable for database connection
- Ensure .dockerignore exists with: node_modules, .git, .env, *.log
```

### Step 3: Create GitHub Repo (if needed)

```bash
# Check if repo exists
if ! gh repo view nelc/MY-APP-NAME >/dev/null 2>&1; then
  gh repo create nelc/MY-APP-NAME --private
  echo "Repository created"
else
  echo "Repository already exists"
fi
```

### Step 4: Push to Deploy

```bash
git add .
git commit -m "Add deployment workflow"
git remote add origin https://github.com/nelc/MY-APP-NAME.git
git push -u origin main
```

**Done!** GitHub Actions deploys automatically.

---

## Recommended: Use the New Workflow

For the best experience, start fresh with **[MAGIC_PROMPT.md](MAGIC_PROMPT.md)** - it's simpler and handles everything in one go!
