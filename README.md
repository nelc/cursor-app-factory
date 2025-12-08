# Application Factory for GKE

Template for deploying applications from Cursor to Google Kubernetes Engine (GKE).

---

## 🎯 For Business Teams

**→ Read: `BUSINESS_USER_DEPLOY.md`** (3-step deployment - no secrets!)

### TL;DR:

1. Describe your app + paste `MAGIC_PROMPT.md` → Cursor generates code
2. `docker-compose up -d` → test locally
3. `git push` → **auto-deploys to GCP!** ✨

**See `PROMPT_TEMPLATE.md` for copy-paste examples**

---

## 🔧 For Platform Team

**→ Read: `ORG_SECRET_SETUP.md`** (One-time organization secret setup)

Set up `GCP_SA_KEY` as org-level secret → Business users never touch secrets!

---

## 🛠️ For Platform Teams

**Managing the infrastructure?**

- **Deployment Guide** → `K8S_DEPLOYMENT_GUIDE.md`
- **Current Status** → `STATUS_NOW.md`

---

## ✅ Infrastructure

```yaml
Cluster: app-factory-prod
Region: me-central2 (Dammam)
Type: Autopilot (Google-managed)
Network: nelc-vpc (Shared VPC)
Status: RUNNING
```

---

## 📁 Repository Structure

```
cursor-app-factory/
├── START_HERE.md              # 👈 Start here
├── MAGIC_PROMPT.md            # Copy this to Cursor
├── K8S_DEPLOYMENT_GUIDE.md    # Full deployment guide
├── STATUS_NOW.md              # Current infrastructure status
├── Dockerfile                 # Docker template
├── docker-compose.yaml        # Local dev template
├── schema.sql                 # Database template
├── Makefile                   # Simple commands
└── scripts/                   # Deployment automation
```

---

## 🚀 Quick Commands

```bash
# Fix kubectl access (first time only)
bash FIX_KUBECTL.sh

# Deploy an app
make deploy

# Check deployments
kubectl get all

# View logs
kubectl logs <pod-name>
```

---

## 🔗 Quick Links

- **GCP Console**: https://console.cloud.google.com/kubernetes/list?project=app-sandbox-factory
- **Artifact Registry**: https://console.cloud.google.com/artifacts?project=app-sandbox-factory

---

## 📖 Documentation

| File | Purpose |
|------|---------|
| `START_HERE.md` | Main entry point for all users |
| `MAGIC_PROMPT.md` | The magic prompt for Cursor AI |
| `K8S_DEPLOYMENT_GUIDE.md` | Complete deployment guide |
| `STATUS_NOW.md` | Current infrastructure status |
| `SETUP_COMPLETE_NEXT_STEPS.md` | Detailed next steps |

---

## 💡 How It Works

1. Business team uses Cursor AI with `MAGIC_PROMPT.md`
2. Cursor generates production-ready code
3. Test locally: `docker-compose up -d`
4. Deploy to GKE: `make deploy`
5. App runs in Kubernetes cluster in Dammam

---

## ✅ What's Included

✅ **Autopilot GKE cluster** in Dammam  
✅ **Private networking** with nelc-vpc  
✅ **One-command deployment** (`make deploy`)  
✅ **Database-backed configuration** (no env vars)  
✅ **First-user-as-admin** (auto-initialization)  
✅ **Data persistence** (PostgreSQL volumes)  
✅ **Health checks** (required)  
✅ **Production-ready** templates  

---

## 🎊 Ready to Go!

**First Time Setup:**
```bash
bash FIX_KUBECTL.sh
```

**Then:**
1. Read `START_HERE.md`
2. Follow the workflow
3. Deploy apps!

---

**Questions?** Check `SETUP_COMPLETE_NEXT_STEPS.md` for detailed guidance.
