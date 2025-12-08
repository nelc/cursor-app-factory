# 🚀 Deploy Your App (Super Simple)

> For business users who want the shortest possible guide.

---

## Step 1: Build Your App

Copy the **MAGIC_PROMPT.md** and paste it into Cursor AI along with your app description.

---

## Step 2: Test Locally

```bash
docker-compose up -d
```

Open http://localhost:8080 and verify it works.

---

## Step 3: Deploy

Copy the **DEPLOY_PROMPT.md** and paste it into Cursor AI.

It will:
- Create `.github/workflows/` folder
- Download the deployment file
- Push your code to GitHub

---

## Step 4: Enable Deployment (One-Time)

After pushing, the deployment will **fail the first time**. This is normal!

**Contact platform team:**
```
"Please enable deployment for nelc/MY-APP-NAME"
```

**They run one command (5 seconds):**
```bash
./scripts/setup-app-secret.sh MY-APP-NAME
```

**Then you re-run the workflow:**
- Go to: `https://github.com/nelc/MY-APP-NAME/actions`
- Click on the failed run
- Click "Re-run all jobs"

**Done!** ✅

---

## Step 5: Get Your URL

After ~10 minutes, GitHub will post a comment on your commit with your app's URL.

**Example:** `http://34.123.45.67`

---

## Future Updates

Just push code:
```bash
git add .
git commit -m "Update my app"
git push origin main
```

**Auto-deploys!** No need to contact platform team again.

---

## That's It!

**Summary:**
1. Copy MAGIC_PROMPT → Build app
2. Test: `docker-compose up -d`
3. Copy DEPLOY_PROMPT → Push to GitHub
4. Contact platform team (one-time, 5 seconds)
5. Re-run workflow → Get URL!

Future: Just push → auto-deploy! 🎉

