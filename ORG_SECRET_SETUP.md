# 🔐 Organization-Level Secret Setup (One-Time)

**This eliminates the need for business users to add secrets to each repo!**

---

## ✅ Benefits

After this setup:
- ✅ Business users never touch secrets
- ✅ Works automatically for all repos in your org
- ✅ Centralized secret management
- ✅ Update once, applies everywhere

---

## 🔧 Setup Steps (5 Minutes)

### Step 1: Go to Organization Settings

**Replace `nelc` with your actual org name:**

```
https://github.com/organizations/nelc/settings/secrets/actions
```

Or navigate:
1. Go to https://github.com/nelc
2. Click **Settings** (top menu)
3. Left sidebar → **Secrets and variables** → **Actions**

---

### Step 2: Create Organization Secret

1. Click **"New organization secret"**

2. Fill in:
   - **Name**: `GCP_SA_KEY`
   - **Secret**: Copy the **entire contents** of:
     ```
     ~/Documents/Cursor/cursor-app-factory/github-actions-key.json
     ```
   - **Repository access**: Choose one:
     - **All repositories** (recommended for simplicity)
     - **Selected repositories** (if you want control)

3. Click **"Add secret"**

---

### Step 3: Test It Works

Create a test repo and push code with the workflow file - it should work without adding any secrets!

---

## 📝 For Business Users (New Instructions)

With org-level secret, business users now:

### Deploy Your App (3 Steps!)

**Step 1: Add workflow file**
```bash
mkdir -p .github/workflows
curl -o .github/workflows/deploy-to-gke.yaml \
  https://raw.githubusercontent.com/nelc/cursor-app-factory/main/templates/deploy-to-gke.yaml
```

**Step 2: Push to GitHub**
```bash
gh repo create nelc/my-app --private
git init
git add .
git commit -m "Deploy my app"
git remote add origin https://github.com/nelc/my-app.git
git push -u origin main
```

**Step 3: Wait for deployment**
- Check Actions tab
- Get URL from commit comment

**No secrets to add! It just works!** 🎉

---

## 🔒 Security Considerations

### Who Can Access?

**Organization secrets are available to**:
- All repos in the org (if you chose "All repositories")
- Selected repos only (if you chose "Selected repositories")

### Repository Types

- ✅ Works with **private repos** (recommended)
- ⚠️  Works with **public repos** (but secrets stay hidden)

**Recommendation**: Use private repos for business apps

### Permissions Required

**To set organization secret, you need**:
- Organization owner OR
- Organization admin with "Manage organization secrets" permission

---

## 🔄 Secret Rotation (Every 90 Days)

When rotating the service account key:

**Step 1: Create new key**
```bash
export GCP_PROJECT_ID="app-sandbox-factory"
export SA_EMAIL="github-actions@${GCP_PROJECT_ID}.iam.gserviceaccount.com"

# Create new key
gcloud iam service-accounts keys create github-actions-key-new.json \
  --iam-account=$SA_EMAIL \
  --project=$GCP_PROJECT_ID
```

**Step 2: Update organization secret**
1. Go to org secrets page
2. Click on `GCP_SA_KEY`
3. Click "Update secret"
4. Paste new key contents
5. Save

**Step 3: Delete old key**
```bash
# List keys
gcloud iam service-accounts keys list --iam-account=$SA_EMAIL

# Delete old key (use the KEY_ID from list command)
gcloud iam service-accounts keys delete OLD_KEY_ID --iam-account=$SA_EMAIL
```

**All repos automatically use the new key!** No need to update each repo.

---

## 📊 Monitoring Secret Usage

**See which repos are using the secret:**

1. Go to organization secrets page
2. Click on `GCP_SA_KEY`
3. View "Repository access" section

**See deployment runs:**
- Each repo's Actions tab shows deployment history
- Organization Insights → Actions shows all workflow runs

---

## 🆘 Troubleshooting

### "Secret not found" Error

**Cause**: Repo doesn't have access to org secret

**Fix**:
1. Go to org secrets page
2. Click `GCP_SA_KEY`
3. Update "Repository access"
4. Add the repo

### "Permission denied" Error

**Cause**: Service account lacks permissions

**Fix**: Check service account has these roles:
```bash
gcloud projects get-iam-policy app-sandbox-factory \
  --flatten="bindings[].members" \
  --filter="bindings.members:github-actions@app-sandbox-factory.iam.gserviceaccount.com"
```

Should show:
- `roles/container.developer`
- `roles/artifactregistry.writer`
- `roles/storage.admin`

---

## 📖 Updated Business User Documentation

Update your internal docs to:

### ❌ OLD Way (Per-Repo Secrets)
```
1. Add workflow file
2. Create repo
3. Add GCP_SA_KEY secret ← Remove this step!
4. Push code
```

### ✅ NEW Way (Org Secret)
```
1. Add workflow file
2. Push code
```

**That's it!** Much simpler!

---

## 🎯 Summary

✅ **One-time setup**: Add org secret  
✅ **Business users**: Never touch secrets  
✅ **Deployment**: Just `git push`  
✅ **Maintenance**: Update one place, affects all repos  
✅ **Security**: Centralized, auditable, rotatable  

**This is the right way to do it!** 🚀

