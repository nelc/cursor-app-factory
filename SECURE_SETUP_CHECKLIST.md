# 🔒 Security Best Practices - Setup Checklist

**For Platform Team - Complete Security Review**

---

## ✅ What's Already Secure

### 1. Service Account Permissions (Least Privilege)
```bash
✅ roles/container.developer     # Deploy to GKE only
✅ roles/artifactregistry.writer # Push images only  
✅ roles/storage.admin           # Manage volumes only

❌ NO roles/owner
❌ NO roles/editor
❌ NO broad permissions
```

**Verified**: Service account has minimal necessary permissions.

### 2. Key File Security
```bash
✅ Permissions: 600 (owner read/write only)
✅ Added to .gitignore
✅ Not committed to git
✅ Stored in secure location
```

### 3. GitHub Workflow Security
```bash
✅ Uses secrets (not hardcoded credentials)
✅ Private repos enforced
✅ No credentials in logs
✅ Service account, not personal credentials
```

---

## 📋 Manual Setup Required (You Must Do This)

### Step 1: Add Organization Secret on GitHub

**Why manual?** 
- Requires organization admin privileges
- Cannot be automated (GitHub security policy)
- Should be done by authorized person

**Instructions**:

1. **Go to**: `https://github.com/organizations/YOURORG/settings/secrets/actions`
   (Replace `YOURORG` with your actual organization name)

2. **Authenticate**: May require 2FA/SSO

3. **Click**: "New organization secret"

4. **Fill in**:
   - **Name**: `GCP_SA_KEY`
   - **Secret**: Copy from:
     ```
     ~/Documents/Cursor/cursor-app-factory/github-actions-key.json
     ```
   - **Repository access**: 
     - ✅ **Recommended**: "Selected repositories"
     - ⚠️ "All repositories" (only if you trust all repos)

5. **Save**: Click "Add secret"

---

## 🔐 Additional Security Recommendations

### 1. Enable Repository Restrictions

**Only allow deployments from**:
- ✅ Private repositories
- ✅ Repositories you control
- ✅ Specific team access only

**Implementation**:
```
Organization Settings → Actions → General
→ Set "Actions permissions" to selected repositories
```

### 2. Enable Branch Protection

For each app repository:
```
Settings → Branches → Add rule
→ Require pull request reviews
→ Require status checks (CI must pass)
→ Do not allow bypassing
```

### 3. Enable Audit Logging

Track all deployments:
```
Organization Settings → Audit log
→ Enable logging
→ Set retention: 90+ days
```

### 4. Set Up Alerts

**Monitor for**:
- New service account keys created
- Permission changes
- Failed deployments
- Unusual activity

### 5. Key Rotation Schedule

**Best Practice**: Rotate every 90 days

**Set calendar reminder**:
```
Every 90 days:
1. Create new service account key
2. Update GitHub organization secret
3. Delete old key
4. Verify deployments still work
```

---

## 🚫 Security DON'Ts

### Never Do These:

❌ **Don't** commit `github-actions-key.json` to git  
❌ **Don't** share key via email/Slack  
❌ **Don't** use personal GCP credentials  
❌ **Don't** grant Owner/Editor roles  
❌ **Don't** use public repositories for sensitive apps  
❌ **Don't** disable branch protection  
❌ **Don't** skip key rotation  
❌ **Don't** reuse keys across different purposes  

---

## 📊 Security Monitoring

### Regular Checks (Monthly)

**1. Service Account Permissions Audit**
```bash
gcloud projects get-iam-policy app-sandbox-factory \
  --flatten="bindings[].members" \
  --filter="bindings.members:github-actions@app-sandbox-factory.iam.gserviceaccount.com"
```

**Expected**: Only container.developer, artifactregistry.writer, storage.admin

**2. Active Keys Audit**
```bash
gcloud iam service-accounts keys list \
  --iam-account=github-actions@app-sandbox-factory.iam.gserviceaccount.com
```

**Expected**: Only 1 user-managed key

**3. GitHub Secret Access Audit**
```
Go to: Organization → Settings → Secrets → GCP_SA_KEY
Check: Which repositories have access
```

**Expected**: Only approved repositories

**4. Deployment Activity Review**
```
Go to: Organization → Insights → Actions
Review: All workflow runs in past 30 days
```

**Look for**: Unusual patterns, failures, unauthorized repos

---

## 🔄 Key Rotation Procedure (Every 90 Days)

### Step 1: Create New Key
```bash
export GCP_PROJECT_ID="app-sandbox-factory"
export SA_EMAIL="github-actions@${GCP_PROJECT_ID}.iam.gserviceaccount.com"

gcloud iam service-accounts keys create github-actions-key-new.json \
  --iam-account=$SA_EMAIL \
  --project=$GCP_PROJECT_ID
```

### Step 2: Update GitHub Secret
1. Go to organization secrets
2. Click `GCP_SA_KEY`
3. Click "Update secret"
4. Paste new key contents
5. Save

### Step 3: Test Deployment
Push a small change to a test repo and verify deployment works.

### Step 4: Delete Old Key
```bash
# List keys
gcloud iam service-accounts keys list --iam-account=$SA_EMAIL

# Delete old key (use KEY_ID from list)
gcloud iam service-accounts keys delete OLD_KEY_ID --iam-account=$SA_EMAIL
```

### Step 5: Delete Old Key File
```bash
rm ~/Documents/Cursor/cursor-app-factory/github-actions-key.json
mv ~/Documents/Cursor/cursor-app-factory/github-actions-key-new.json \
   ~/Documents/Cursor/cursor-app-factory/github-actions-key.json
chmod 600 ~/Documents/Cursor/cursor-app-factory/github-actions-key.json
```

---

## 🚨 Incident Response

### If Key is Compromised:

**Immediate Actions (within 1 hour)**:

1. **Disable the key**:
   ```bash
   gcloud iam service-accounts keys delete KEY_ID \
     --iam-account=github-actions@app-sandbox-factory.iam.gserviceaccount.com
   ```

2. **Remove from GitHub**:
   - Delete organization secret `GCP_SA_KEY`
   - This stops all deployments immediately

3. **Review recent activity**:
   ```bash
   gcloud logging read "protoPayload.authenticationInfo.principalEmail=github-actions@app-sandbox-factory.iam.gserviceaccount.com" \
     --limit 100 \
     --format json
   ```

4. **Create new key** (follow rotation procedure above)

5. **Notify team**: Inform all users deployments are paused

### If Unauthorized Deployment Detected:

1. **Identify the source**:
   - Check GitHub Actions logs
   - Check which repo triggered it
   - Check commit author

2. **Revoke repository access**:
   - Go to organization secret settings
   - Remove compromised repo from access list

3. **Delete unauthorized resources**:
   ```bash
   kubectl delete deployment UNAUTHORIZED_APP
   kubectl delete service UNAUTHORIZED_APP
   ```

4. **Review and tighten access controls**

---

## ✅ Security Compliance Checklist

**Before enabling for business users, verify**:

- [ ] Service account has least privilege permissions
- [ ] Organization secret configured with restricted access
- [ ] Key file not in git
- [ ] Key file has 600 permissions
- [ ] Branch protection enabled on app repos
- [ ] Only private repositories allowed
- [ ] Audit logging enabled
- [ ] 90-day key rotation calendar reminder set
- [ ] Incident response procedure documented
- [ ] Business users trained on security basics

---

## 📖 For Business Users - Security Guidelines

Share this with them:

### Do's:
✅ Keep your repositories private  
✅ Use strong GitHub passwords + 2FA  
✅ Review code before pushing  
✅ Only deploy from main/master branch  
✅ Report suspicious activity immediately  

### Don'ts:
❌ Share your GitHub credentials  
❌ Clone repos to public machines  
❌ Commit secrets to code  
❌ Bypass branch protection  
❌ Deploy untested code  

---

## 🎯 Summary

**Current Security Posture**: ✅ **Strong**

- Least privilege access
- Secure credential storage
- Auditable deployments
- Automated security (GitHub Actions)
- No hardcoded credentials

**Action Required**: 
1. Add organization secret on GitHub (manual)
2. Set 90-day rotation reminder
3. Train business users

**Next Review**: 90 days from now (key rotation)

---

**Security Contact**: Platform Team  
**Last Updated**: December 8, 2025  
**Next Key Rotation**: March 8, 2026

