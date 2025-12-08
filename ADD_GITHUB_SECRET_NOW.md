# 🔐 Add GitHub Organization Secret (Final Step)

**⏱️ Time: 2 minutes**

---

## ✅ What I've Done (Security Hardened)

- ✅ Created service account with **least privilege** (no Owner/Editor)
- ✅ Secured key file (permissions: 600)
- ✅ Added key to .gitignore
- ✅ Removed old keys
- ✅ Audit trail enabled

**All security best practices applied** ✅

---

## 🎯 What You Need to Do (Manual - Requires Your Admin Access)

### Step 1: Open GitHub Organization Settings

Replace `nelc` with your org name:

```
https://github.com/organizations/nelc/settings/secrets/actions
```

**Or navigate**:
1. Go to your org on GitHub
2. Click **Settings**
3. Left sidebar → **Secrets and variables** → **Actions**

### Step 2: Add Organization Secret

1. Click **"New organization secret"**

2. Fill in:
   - **Name**: `GCP_SA_KEY`
   
   - **Secret**: Copy **ENTIRE CONTENTS** from:
     ```
     ~/Documents/Cursor/cursor-app-factory/github-actions-key.json
     ```
     (Use `cat` or open in text editor)
   
   - **Repository access**: 
     - ✅ **Recommended**: "Selected repositories"
       - Only add repos you control
       - Add more as needed
     - ⚠️ "All repositories" (simpler but less secure)

3. Click **"Add secret"**

---

## 🧪 Step 3: Test It Works

Use your `cursor-k8s-test` app:

```bash
cd /Users/aleid/Documents/Cursor/cursor-k8s-test

# Create GitHub repo
gh repo create nelc/cursor-k8s-test --private

# Push code (triggers auto-deploy)
git init
git add .
git commit -m "Test deployment"
git remote add origin https://github.com/nelc/cursor-k8s-test.git
git push -u origin main
```

**Wait 10 minutes**, check Actions tab for success!

---

## 🔒 Security Notes

### ✅ What's Secure:

- Service account has **minimal permissions only**
- Key is **not in git** (added to .gitignore)
- Key file has **600 permissions** (only you can read)
- **Private repos** enforced in workflow
- No hardcoded credentials anywhere

### ⚠️ Important:

- **Don't** share the key file via email/Slack
- **Don't** commit it to git (already in .gitignore)
- **Do** rotate key every 90 days (calendar reminder)
- **Do** use "Selected repositories" if possible

---

## 📋 After Setup - Share With Business Users

Once organization secret is added, share:

**`BUSINESS_USER_DEPLOY.md`**

They'll be able to deploy with just:
```bash
# Add workflow file
curl -o .github/workflows/deploy-to-gke.yaml \
  https://raw.githubusercontent.com/nelc/cursor-app-factory/main/.github/workflows/deploy-to-gke.yaml

# Push code
git push
```

No secrets to configure! ✨

---

## 🎯 Summary

**What I can do**: ✅ Done
- Service account created & secured
- Permissions locked down
- Key file protected
- Documentation ready

**What you must do**: ⏳ Pending
- Add `GCP_SA_KEY` to GitHub (requires admin access)
- Test deployment
- Share docs with business users

**Estimated time**: 2 minutes

---

**Once you add the GitHub secret, deployment automation is complete!** 🚀

