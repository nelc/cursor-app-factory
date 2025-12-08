# 🚀 Cursor App Factory - Start Here

> Deploy apps from Cursor to GCP in 3 steps

---

## 👨‍💼 For Business Users

**Want to deploy an app? Read this:**

### [📖 SIMPLE.md](SIMPLE.md) ← Start Here!

**3 steps:**
1. Copy MAGIC_PROMPT.md → Build app
2. Test: `docker-compose up -d`
3. Copy DEPLOY_PROMPT.md → Deploy

**That's it!** 🎉

### The Two Prompts You Need:

1. **[MAGIC_PROMPT.md](MAGIC_PROMPT.md)** - Build your app
2. **[DEPLOY_PROMPT.md](DEPLOY_PROMPT.md)** - Deploy to GCP

### Need the GCP Key?

- **[GET_GCP_KEY.md](GET_GCP_KEY.md)** - How to get it from platform team

---

## 🔧 For Platform Team

**Managing deployments? Read this:**

### Main Guide:
- **[PLATFORM_TEAM_GUIDE.md](PLATFORM_TEAM_GUIDE.md)** - Operations guide

### Key Tasks:

**Share GCP Key with Business Users:**
- **[PLATFORM_TEAM_SHARE_KEY.md](PLATFORM_TEAM_SHARE_KEY.md)**

**Enable New App (Optional):**
```bash
./scripts/setup-app-secret.sh APP-NAME
```

*Note: Business users can add the secret themselves. This script is optional.*

---

## 📚 Reference Documentation

### Overview:
- **[SETUP_COMPLETE.md](SETUP_COMPLETE.md)** - Complete platform overview

### Technical Details:
- **[K8S_DEPLOYMENT_GUIDE.md](K8S_DEPLOYMENT_GUIDE.md)** - GKE deployment details
- **[LESSONS_LEARNED.md](LESSONS_LEARNED.md)** - What we learned building this

---

## 📦 Repository Structure

```
cursor-app-factory/
├── SIMPLE.md                      ← Business users start here
├── MAGIC_PROMPT.md                ← Prompt 1: Build app
├── DEPLOY_PROMPT.md               ← Prompt 2: Deploy app
├── GET_GCP_KEY.md                 ← How to get the key
│
├── PLATFORM_TEAM_GUIDE.md         ← Platform team operations
├── PLATFORM_TEAM_SHARE_KEY.md     ← How to share keys
│
├── templates/
│   ├── deploy-to-gke.yaml         ← GitHub Actions workflow
│   ├── Dockerfile                 ← Example Dockerfile
│   └── docker-compose.yaml        ← Example docker-compose
│
├── scripts/
│   └── setup-app-secret.sh        ← Optional: Enable apps
│
├── SETUP_COMPLETE.md              ← Complete overview
├── K8S_DEPLOYMENT_GUIDE.md        ← Technical details
├── LESSONS_LEARNED.md             ← Lessons learned
└── README.md                      ← About this repo
```

---

## ⚡ Quick Links

### I want to...

| Goal | Document |
|------|----------|
| **Deploy my first app** | [SIMPLE.md](SIMPLE.md) |
| **Build an app** | [MAGIC_PROMPT.md](MAGIC_PROMPT.md) |
| **Deploy an app** | [DEPLOY_PROMPT.md](DEPLOY_PROMPT.md) |
| **Get the GCP key** | [GET_GCP_KEY.md](GET_GCP_KEY.md) |
| **Share keys with users** | [PLATFORM_TEAM_SHARE_KEY.md](PLATFORM_TEAM_SHARE_KEY.md) |
| **Understand the platform** | [SETUP_COMPLETE.md](SETUP_COMPLETE.md) |
| **See technical details** | [K8S_DEPLOYMENT_GUIDE.md](K8S_DEPLOYMENT_GUIDE.md) |

---

## 🎯 The Simple Workflow

```
Business User:
  1. Copy MAGIC_PROMPT → Build app in Cursor
  2. Test locally: docker-compose up -d
  3. Copy DEPLOY_PROMPT → Deploy with Cursor
  4. Request GCP_SA_KEY from platform team
  5. Cursor adds it to GitHub
  6. Get URL → Live! ✨

Platform Team:
  1. Share github-actions-key.json with users
  2. Done! (optional: use setup-app-secret.sh)
```

---

## 💡 Key Benefits

- ✅ **3-step deployment** for business users
- ✅ **No GCP knowledge** required
- ✅ **Automatic CI/CD** via GitHub Actions
- ✅ **Production-ready** apps in ~20 minutes
- ✅ **Each app gets its own URL**
- ✅ **Minimal platform team involvement**

---

## 🚀 Get Started

**Business User?** → Read [SIMPLE.md](SIMPLE.md)

**Platform Team?** → Read [PLATFORM_TEAM_GUIDE.md](PLATFORM_TEAM_GUIDE.md)

**Want full details?** → Read [SETUP_COMPLETE.md](SETUP_COMPLETE.md)

---

**That's it!** Everything you need is in this repo. 🎉
