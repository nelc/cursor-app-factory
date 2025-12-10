# Magic Deployment Prompt for Business Users

## 🚀 THE 3-STEP WORKFLOW

### Step 1: Describe Your App
Open Cursor AI and say:
```
Build me a [describe your app]
```

Example: "Build me a task manager with user authentication"

---

### Step 2: Make It Production-Ready

After Cursor generates your app, copy and paste this **EXACT** prompt:

```
Create a production-ready docker-compose.yml that runs this application end-to-end so a non-technical user can run docker-compose up -d and have a fully working system in under 2 minutes, with data persisting across restarts. Use exactly one Dockerfile (reuse the existing one if present) and do not create any additional variants. If the application requires a database, use PostgreSQL, define a single DB service with fixed credentials inside docker-compose.yml, ensure the schema auto-initializes on first run, and make the application connect via DATABASE_URL only. The app must listen on port 8080, bind to 0.0.0.0, expose a /health endpoint returning {"status":"healthy"}, use process.env.PORT with fallback to 8080, and must not crash if env vars like JWT_SECRET or NODE_ENV are missing (provide safe defaults or move them into the database-backed Settings Page UI). The first registered user becomes the admin when the users table is empty, and all system configuration and secrets must be stored and managed through this in-app Settings Page UI rather than environment variables (except for DB connection). Include a proper .dockerignore to optimize the build context. For deployment, ensure a .github/workflows directory exists, download the preconfigured workflow using curl -o .github/workflows/deploy-to-gke.yaml https://raw.githubusercontent.com/nelc/cursor-app-factory/main/templates/deploy-to-gke.yaml, then review this workflow and the application together and make only minimal, non-breaking compatibility fixes (e.g. aligning ports, health path, DATABASE_URL usage, or adding missing envs) without changing GCP project/region/cluster or the overall workflow structure. All required features must be implemented if missing.
```

Cursor will:
- ✅ Create `Dockerfile`
- ✅ Create `docker-compose.yml` with app + PostgreSQL
- ✅ Create `.dockerignore`
- ✅ Download deployment workflow to `.github/workflows/deploy-to-gke.yaml`
- ✅ Add `/health` endpoint
- ✅ Implement first-user-is-admin logic
- ✅ Create Settings Page UI for configuration

---

### Step 3: Push to GitHub

```bash
git init
git add .
git commit -m "Initial commit"
git remote add origin https://github.com/nelc/YOUR-APP-NAME.git
git push -u origin main
```

**Done!** GitHub Actions will automatically deploy your app to GKE with SSL.

---

## 📋 What Gets Created

### Files You'll See:
```
your-app/
├── .github/
│   └── workflows/
│       └── deploy-to-gke.yaml    # Auto-deployment workflow
├── .dockerignore                 # Optimizes Docker builds
├── Dockerfile                     # Production-ready container
├── docker-compose.yml             # Local development setup
└── [your app files]
```

### Automatic Features:
- ✅ **Port 8080** - Standard for GKE
- ✅ **Health checks** - `/health` endpoint
- ✅ **PostgreSQL** - Auto-initialized database
- ✅ **First user = admin** - No manual role assignment
- ✅ **Settings UI** - Database-backed configuration
- ✅ **SSL/HTTPS** - Automatic via Cloudflare
- ✅ **Automatic deployment** - Push to GitHub = deployed to production

---

## 🧪 Optional: Test Locally First

```bash
# Start the app
docker-compose up -d

# Wait 30 seconds
sleep 30

# Check if it's working
curl http://localhost:8080/health
# Should return: {"status":"healthy"}

# Open in browser
open http://localhost:8080
```

---

## 🎯 After Deployment

1. **Wait 5-10 minutes** for GitHub Actions to complete
2. **Check deployment status**: `https://github.com/nelc/YOUR-APP-NAME/actions`
3. **Get your app URL** from the Actions logs (look for LoadBalancer IP)
4. **Add to Cloudflare**:
   - Point DNS to the LoadBalancer IP
   - Enable "Proxied" (orange cloud)
   - SSL/TLS mode: "Full (strict)"
5. **Access your app**: `https://your-app.futurex.sa`

---

## ❓ Troubleshooting

### Deployment Failed?
Check: `https://github.com/nelc/YOUR-APP-NAME/actions`

Common issues:
- **"npm ci requires package-lock.json"**: Ask Cursor to run `npm install` first
- **Missing .dockerignore**: Ask Cursor to create it
- **App crashes**: Check the `/health` endpoint works locally

### App Not Loading?
1. Verify LoadBalancer IP: `kubectl get svc YOUR-APP-NAME -n YOUR-APP-NAME`
2. Check Cloudflare DNS is pointing to the correct IP
3. Ensure SSL mode is "Full (strict)" in Cloudflare

---

**That's it! Your app is now in production with automatic HTTPS.** 🚀
