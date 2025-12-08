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

## Step 4: Add GCP Secret (One-Time)

**Get the secret from platform team:**
```
"Can I get the GCP_SA_KEY for deployments?"
```

**Add it to your repository:**
```bash
# Platform team will give you a file or the key content
# Save it as gcp-key.json in your app folder

# Then run:
cat gcp-key.json | gh secret set GCP_SA_KEY --repo nelc/MY-APP-NAME
```

**Or if they give you the key as text:**
```bash
echo 'PASTE_KEY_CONTENT_HERE' | gh secret set GCP_SA_KEY --repo nelc/MY-APP-NAME
```

**Trigger deployment:**
```bash
git commit --allow-empty -m "Trigger deployment"
git push origin main
```

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

