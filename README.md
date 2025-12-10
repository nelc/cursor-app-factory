# Cursor App Factory

**Deploy production-ready applications from Cursor to Google Cloud Platform (GKE) in 3 steps.**

## 🚀 For Business Users

Start here: **[START_HERE.md](START_HERE.md)**

### The 3-Step Workflow:

1. **Describe your app** in Cursor AI
2. **Paste the magic prompt** from [MAGIC_PROMPT.md](MAGIC_PROMPT.md)
3. **Push to GitHub** → Automatic deployment!

**That's it!** Your app is live at `https://your-app.futurex.sa` in 5-10 minutes. ✨

### What You Get Automatically:

- ✅ **Trusted SSL certificates** (Cloudflare)
- ✅ **CDN & DDoS protection** (Cloudflare)
- ✅ **Kubernetes orchestration** (GKE Autopilot)
- ✅ **Automatic scaling** (serverless infrastructure)
- ✅ **Database persistence** (PostgreSQL StatefulSet)
- ✅ **Health checks** and monitoring
- ✅ **Zero configuration** required

---

## 🔧 For Platform Team

Technical documentation:
- **[PLATFORM_TEAM_GUIDE.md](PLATFORM_TEAM_GUIDE.md)** - Operations & maintenance
- **[K8S_DEPLOYMENT_GUIDE.md](K8S_DEPLOYMENT_GUIDE.md)** - Kubernetes deployment details
- **[SETUP_COMPLETE.md](SETUP_COMPLETE.md)** - Complete platform overview

---

## 📦 Repository Structure

```
cursor-app-factory/
├── START_HERE.md              # Entry point for all users
├── SIMPLE.md                  # Quick 3-step guide
├── MAGIC_PROMPT.md            # The one prompt for everything
│
├── templates/                 # Production-ready templates
│   ├── deploy-to-gke.yaml     # GitHub Actions workflow
│   ├── Dockerfile             # Docker build template
│   ├── docker-compose.yaml    # Local development
│   └── .dockerignore          # Build optimization
│
├── K8S_DEPLOYMENT_GUIDE.md    # Technical guide
├── PLATFORM_TEAM_GUIDE.md     # Operations guide
├── SETUP_COMPLETE.md          # Platform architecture
├── LESSONS_LEARNED.md         # Lessons learned
└── README.md                  # This file
```

---

## 🏗️ Infrastructure

- **GKE Cluster**: Dammam (me-central2), Autopilot, Shared VPC
- **SSL/HTTPS**: Cloudflare Origin Certificate + nginx sidecar
- **Registry**: Artifact Registry (me-central2)
- **Authentication**: Workload Identity Federation (no keys needed!)
- **Network**: Shared VPC (nelc-vpc)
- **CI/CD**: GitHub Actions

---

## ⚡ Quick Links

**Business Users:**
- [Start Here](START_HERE.md)
- [3-Step Guide](SIMPLE.md)
- [Magic Prompt](MAGIC_PROMPT.md)

**Platform Team:**
- [Operations Guide](PLATFORM_TEAM_GUIDE.md)
- [Kubernetes Guide](K8S_DEPLOYMENT_GUIDE.md)
- [Platform Setup](SETUP_COMPLETE.md)

---

## 💡 Key Features

- ✅ **No keys or secrets** - Automatic authentication via Workload Identity Federation
- ✅ **No GCP knowledge** required for business users
- ✅ **3-step deployment** - Describe, prompt, push
- ✅ **Production-ready** - Health checks, scaling, SSL all automatic
- ✅ **Each app isolated** - Own namespace, database, URL
- ✅ **Zero platform team** involvement needed for deployments

---

## 📈 Status

**Last Updated**: December 10, 2025  
**Status**: ✅ Production Ready  
**Authentication**: ✅ Workload Identity Federation (keyless)  
**SSL**: ✅ Cloudflare Origin Certificates  
**Deployments**: ✅ Fully automated via GitHub Actions

---

**Questions?** See [START_HERE.md](START_HERE.md) or contact the platform team.
