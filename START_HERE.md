# 🚀 START HERE

## Welcome to Cursor App Factory!

> **Build apps in Cursor. Deploy to production in 5 minutes.**

---

## 📖 Documentation

**→ [BEGINNER_GUIDE.md](BEGINNER_GUIDE.md)** - Complete 3-step workflow (start here!)  
**→ This file** - Detailed reference

---

## ⚡ What Is This?

A simple workflow for **non-technical business teams** to:
1. Build apps in Cursor
2. Test locally with `docker-compose up -d`
3. Deploy to production Kubernetes with `make deploy`

**No complex setup. No technical knowledge required.**

---

## 🎯 Quick Decision Tree

### **Are you a business user building an app?**
👉 Go to **[GET_STARTED.md](GET_STARTED.md)**

### **Are you on the platform team?**
👉 Go to **[SUMMARY.md](SUMMARY.md)** first, then **[GET_STARTED.md](GET_STARTED.md)**

### **Are you an executive/stakeholder?**
👉 Read **[SUMMARY.md](SUMMARY.md)** for the business case

### **Just want to see all docs?**
👉 Check **[INDEX.md](INDEX.md)** for the full list

---

## 🌟 The Magic Prompt

The **most important file** in this repo is **[MAGIC_PROMPT.md](MAGIC_PROMPT.md)**.

When building apps in Cursor, you paste this prompt to ensure your app:
- ✅ Works locally with `docker-compose up -d`
- ✅ Deploys to production with `make deploy`
- ✅ First user automatically becomes admin
- ✅ All configuration via database UI (no env vars!)
- ✅ Scales automatically in production

**Without this prompt, your app won't deploy correctly.** With it, everything just works.

---

## 📚 Documentation Overview

| If You Want To... | Read This |
|-------------------|-----------|
| Get started in 5 minutes | **[GET_STARTED.md](GET_STARTED.md)** |
| Get the magic prompt | **[MAGIC_PROMPT.md](MAGIC_PROMPT.md)** ⭐ |
| Understand the approach | **[SUMMARY.md](SUMMARY.md)** |
| See all documentation | **[INDEX.md](INDEX.md)** |
| Deep dive into deployment | **[K8S_DEPLOYMENT_GUIDE.md](K8S_DEPLOYMENT_GUIDE.md)** |

---

## ⚡ Super Quick Start

```bash
# 1. Clone this repo
git clone <repo-url>
cd cursor-app-factory

# 2. Configure
cp env.example .env
# Edit .env with your GCP_PROJECT_ID

# 3. In Cursor, build your app and paste the Magic Prompt
# (Get it from MAGIC_PROMPT.md)

# 4. Test locally
docker-compose up -d
open http://localhost:8080

# 5. Deploy to production
make deploy
```

**Done!** You'll have a production URL in ~5 minutes.

---

## 💡 Why This Works

### Before (350+ Failure Points)
- ❌ Manual Cloud SQL setup
- ❌ Complex environment variables
- ❌ Manual admin user creation
- ❌ Different config for dev/prod
- ❌ Required understanding GCP

### Now (Simple & Reliable)
- ✅ Database in docker-compose
- ✅ All config in database UI
- ✅ First user = admin (automatic)
- ✅ Same setup everywhere
- ✅ Zero GCP knowledge needed

---

## 🎯 Critical Success Factor

**Everyone MUST use the Magic Prompt from [MAGIC_PROMPT.md](MAGIC_PROMPT.md).**

This is non-negotiable. Without it, Cursor generates code that:
- Uses wrong ports
- Binds to localhost (health checks fail)
- Requires manual admin setup
- Has environment variable chaos

**With the prompt**, everything works first time.

---

## 📞 Need Help?

- **Business Users**: Start with [GET_STARTED.md](GET_STARTED.md)
- **Platform Team**: Start with [SUMMARY.md](SUMMARY.md)
- **Everyone**: Use [INDEX.md](INDEX.md) to find the right doc

---

## 🚀 Next Step

👉 **Go to [GET_STARTED.md](GET_STARTED.md) and follow the 5-minute guide!**

---

**Ready? Let's build something! 🎉**
