# 🚀 Deployment Prompt for Cursor AI

> **For Business Users**: Copy this entire prompt and paste it into Cursor AI to deploy your app to GCP.

---

## Copy-Paste This Prompt into Cursor:

```
I have a working application that I've built and tested locally with docker-compose. 
Now I need to deploy it to GCP (Google Cloud Platform) in the nelc organization.

Please help me with these steps:

1. Create the .github/workflows directory if it doesn't exist

2. Download the pre-configured deployment workflow file:
   curl -o .github/workflows/deploy-to-gke.yaml \
     https://raw.githubusercontent.com/nelc/cursor-app-factory/main/templates/deploy-to-gke.yaml

3. Initialize git if not already done, and show me what files will be committed

4. Guide me to create a GitHub repository in the nelc organization with this command format:
   gh repo create nelc/MY-APP-NAME --private
   (Help me choose a good app name based on what my app does)

5. Add the remote and push to GitHub:
   git remote add origin https://github.com/nelc/MY-APP-NAME.git
   git push -u origin main

After pushing, tell me:
- Where to watch the deployment progress (GitHub Actions URL)
- That the first run will fail and I need to contact platform team
- How to contact platform team for deployment enablement
- How to re-run the workflow after platform team enables it
- How long successful deployment will take (~10 minutes)
- How to get my app's public URL when deployment finishes

IMPORTANT REMINDERS:
- Do NOT modify the downloaded workflow file
- Do NOT create a custom workflow file
- The workflow file must be used exactly as downloaded

After pushing to GitHub:
- The workflow will initially FAIL (this is expected)
- Contact the platform team: "Please enable deployment for [REPO-NAME]"
- Platform team will run one command (takes 5 seconds)
- Then re-run the workflow from GitHub Actions
- Deployment will succeed!

Please execute these steps one by one and confirm each step before moving to the next.
```

---

## Alternative: Ultra-Short Version

If the business user just wants the commands without explanation:

```
I need to deploy my app to GCP. My app is already built and tested locally.

Run these commands for me:

mkdir -p .github/workflows
curl -o .github/workflows/deploy-to-gke.yaml \
  https://raw.githubusercontent.com/nelc/cursor-app-factory/main/templates/deploy-to-gke.yaml

git init
git add .
git commit -m "Deploy my app"

gh repo create nelc/[suggest-a-name-based-on-my-app] --private
git remote add origin https://github.com/nelc/[repo-name].git
git push -u origin main

Then tell me where to watch the deployment and how to get my app URL.
```

---

## What Cursor AI Will Do

When you paste this prompt, Cursor AI will:

1. ✅ Create the `.github/workflows/` directory
2. ✅ Download the deployment workflow (pre-configured, zero config needed)
3. ✅ Show you what files will be committed
4. ✅ Help you pick a good repository name
5. ✅ Create the GitHub repo in the `nelc` organization
6. ✅ Push your code to GitHub
7. ✅ Tell you where to watch deployment progress
8. ✅ Explain how to get your app's URL

---

## After Deployment

**First-time setup (one-time per app):**

1. **Watch for initial failure:**
   ```
   https://github.com/nelc/YOUR-APP-NAME/actions
   ```
   The first workflow run will FAIL - this is expected!

2. **Contact Platform Team:**
   - Message: "Please enable deployment for nelc/YOUR-APP-NAME"
   - Platform team runs: `./scripts/setup-app-secret.sh YOUR-APP-NAME`
   - Takes 5 seconds

3. **Re-run the workflow:**
   - Go to the failed workflow run
   - Click "Re-run all jobs" button
   - Now it will succeed!

**Get Your App URL:**
- After ~10 minutes, the workflow will complete
- GitHub will post a comment on your commit with the public URL
- Or check: `kubectl get service YOUR-APP-NAME` (if you have kubectl access)

**Your app will be live at:** `http://[LOADBALANCER-IP]`

**Future deployments:**
- Just push code → automatic deployment!
- No need to contact platform team again

---

## Troubleshooting

If Cursor AI asks you to add secrets:
- ❌ **STOP!** You shouldn't need to add any secrets
- ✅ The workflow file might be wrong - make sure you downloaded it from the correct URL
- ✅ Re-download: `https://raw.githubusercontent.com/nelc/cursor-app-factory/main/templates/deploy-to-gke.yaml`

If deployment fails:
1. Check GitHub Actions for error details
2. Common issues:
   - No `/health` endpoint → App must have a health check
   - Not running on port 8080 → App must listen on port 8080
   - Missing Dockerfile or docker-compose.yaml → Use MAGIC_PROMPT to rebuild

---

## Need Help?

- **Building apps**: See `MAGIC_PROMPT.md` in cursor-app-factory repo
- **Step-by-step guide**: See `BEGINNER_GUIDE.md`
- **Deployment only**: See `BUSINESS_USER_DEPLOY.md`

---

## Example Conversation with Cursor

**You:**
```
I have a working task manager app tested locally. Deploy it to GCP using the prompt above.
```

**Cursor AI will:**
```
I'll help you deploy to GCP. Let me:

1. Create .github/workflows directory...
2. Download the deployment workflow...
3. Check your files...
4. Your app appears to be a task manager. I suggest the repo name: nelc/task-manager-pro
5. Creating GitHub repo...
6. Pushing to GitHub...

✅ Done! Your app is deploying.

Watch progress: https://github.com/nelc/task-manager-pro/actions

Deployment takes ~10 minutes. The URL will be posted as a comment on your latest commit.
```

---

## Summary

**Just copy the prompt above and paste it into Cursor AI. That's it!** 🚀

No GCP credentials needed. No secrets to configure. Just deploy!

