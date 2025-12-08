# 🚀 Simple: Build and Deploy

## 1. Build

Copy `MAGIC_PROMPT.md` → Paste in Cursor → Done

## 2. Test

```bash
docker-compose up -d
```

Open http://localhost:8080

## 3. Deploy

Copy `DEPLOY_PROMPT.md` → Paste in Cursor

**First time only:**
- Cursor says: "Need GCP_SA_KEY from platform team"
- You message platform team: "Can I get the GCP_SA_KEY?"
- They send you a file or key
- You give it to Cursor
- Cursor adds it to GitHub for you
- Cursor deploys!

**That's it!** ✅

---

## Future Updates

```bash
git push
```

Auto-deploys! 🎉

---

## Summary

**3 steps:**
1. One prompt → Build
2. Test locally
3. One prompt → Deploy

**First time**: Platform team gives you one key  
**Every time after**: Just push code

