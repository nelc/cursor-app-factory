# 🔧 Platform Team Guide: Enabling App Deployments

## Overview

Due to GitHub Free plan limitations, **organization secrets are NOT automatically available** to repositories. The platform team must run a simple command to enable deployment for each new app.

---

## ⚠️ Why This Is Needed

**Issue**: GitHub Free plan doesn't support automatic org-level secrets  
**Impact**: Business users cannot deploy until you enable their repo  
**Solution**: One command to set up each new app (takes 5 seconds)

---

## 🚀 Quick Setup (For Each New App)

When a business user pushes their app to GitHub, run:

```bash
cd cursor-app-factory
./scripts/setup-app-secret.sh APP-REPO-NAME
```

**Example:**
```bash
./scripts/setup-app-secret.sh taskmanager-app
```

**Output:**
```
╔══════════════════════════════════════════════════════════════╗
║         Setup GCP Secret for New App                         ║
╚══════════════════════════════════════════════════════════════╝

Checking if repository exists...
✓ Repository found: nelc/taskmanager-app

Adding GCP_SA_KEY secret to repository...
✓ Secret added successfully!

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

SUCCESS! The app is ready to deploy.

Next steps:
  1. Tell the business user their app is configured
  2. They can now push code and it will auto-deploy
  3. Watch deployment: https://github.com/nelc/taskmanager-app/actions
```

---

## 📋 Workflow for Business Users

### Business User Does:
1. Builds app in Cursor (using `MAGIC_PROMPT.md`)
2. Tests locally: `docker-compose up -d`
3. Uses `DEPLOY_PROMPT.md` with Cursor AI to push to GitHub
4. **Waits for platform team to enable deployment**

### Platform Team Does:
1. Gets notification: "New app: nelc/APP-NAME created"
2. Runs: `./scripts/setup-app-secret.sh APP-NAME`
3. Notifies business user: "Your app is ready to deploy!"

### Result:
4. Business user pushes code → Auto-deploys! 🚀

---

## 🔄 Alternative: Automated Approach

If you get too many requests, create a GitHub Action in this repo to auto-enable new repos:

```yaml
# .github/workflows/auto-enable-repos.yaml
name: Auto-Enable New Repos

on:
  repository_dispatch:
    types: [new_app]

jobs:
  setup:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Add secret to new repo
        run: |
          cat github-actions-key.json | \
            gh secret set GCP_SA_KEY --repo nelc/${{ github.event.client_payload.repo_name }}
        env:
          GH_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

Then business users just need to trigger:
```bash
gh api /repos/nelc/cursor-app-factory/dispatches \
  -f event_type=new_app \
  -f client_payload[repo_name]=APP-NAME
```

---

## 🛠️ Troubleshooting

### Error: "Repository not found"
- Business user hasn't pushed to GitHub yet
- Check repository name spelling
- Ensure it's in the `nelc` organization

### Error: "Permission denied"
- You need admin access to the repository
- Or you need `admin:org` scope: `gh auth refresh -s admin:org`

### Script not found
- Make sure you're in the `cursor-app-factory` directory
- Check: `ls scripts/setup-app-secret.sh`

---

## 📊 Monitoring

### Check which repos have the secret:
```bash
# List all repos
gh repo list nelc --limit 100

# Check if a specific repo has the secret
gh secret list --repo nelc/APP-NAME | grep GCP_SA_KEY
```

### Bulk setup (if needed):
```bash
# Add secret to multiple repos at once
for repo in app1 app2 app3; do
  ./scripts/setup-app-secret.sh $repo
done
```

---

## 🔐 Security Notes

- The `github-actions-key.json` file contains sensitive credentials
- It's in `.gitignore` and will never be committed
- Only platform team members should have access
- The secret is encrypted in GitHub's vault
- Each repo gets the same service account (least privilege)

---

## 📈 Future Improvement

Consider upgrading to **GitHub Team** ($4/user/month) which supports:
- ✅ True organization-level secrets (automatic)
- ✅ No manual setup per repo
- ✅ Better security features
- ✅ Easier management

**Cost**: ~$300/month for 75 users  
**Benefit**: Zero-touch deployment for business users

---

## ❓ Questions?

- **Why not use Workload Identity Federation?**  
  More complex setup, harder for business users to understand

- **Can we automate this completely?**  
  Yes, with GitHub webhooks or repository templates, but adds complexity

- **How long does setup take?**  
  5 seconds per app with the script

---

## 📝 Summary

**One-time per app:**
```bash
./scripts/setup-app-secret.sh APP-NAME
```

**That's it!** Business users can then deploy automatically.


