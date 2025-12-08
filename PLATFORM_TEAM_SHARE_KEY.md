# 🔑 Platform Team: Sharing the GCP Key

## Overview

Business users need the `GCP_SA_KEY` to deploy their apps. This guide explains how to securely share it.

---

## The Key Location

The key file is:
```
/Users/aleid/Documents/Cursor/cursor-app-factory/github-actions-key.json
```

**NEVER commit this to git!** It's in `.gitignore`.

---

## Sharing Options (Choose ONE)

### Option 1: Secure File Share (RECOMMENDED)

**Use a secure file-sharing service:**

1. **Upload to secure storage:**
   - Google Drive (set to "Anyone with link can view")
   - Internal file server
   - Password-protected zip file

2. **Share the link:**
   ```
   "Download the GCP key from: [SECURE_LINK]
   Save it as gcp-key.json in your app folder.
   
   Then run:
   cat gcp-key.json | gh secret set GCP_SA_KEY --repo nelc/YOUR-APP
   
   Delete the file after adding it to GitHub."
   ```

3. **Revoke access** after they download it

---

### Option 2: Direct File Transfer

**For in-person or secure channels:**

1. Copy the file to a USB drive or secure network share
2. Business user saves it as `gcp-key.json`
3. They run:
   ```bash
   cat gcp-key.json | gh secret set GCP_SA_KEY --repo nelc/THEIR-APP
   ```
4. They delete the local file

---

### Option 3: Automated Script (Best for Scale)

**Create a script that business users can run:**

```bash
#!/bin/bash
# get-gcp-key.sh

# This script should be placed on a secure internal server
# Business users run: curl https://internal.server/get-gcp-key.sh | bash

REPO_NAME="$1"

if [ -z "$REPO_NAME" ]; then
  echo "Usage: $0 YOUR-APP-NAME"
  exit 1
fi

# Fetch key from secure location (replace with your method)
curl -s https://internal.server/secure/github-actions-key.json | \
  gh secret set GCP_SA_KEY --repo nelc/$REPO_NAME

echo "✅ Secret added to nelc/$REPO_NAME"
echo "You can now deploy!"
```

Business users run:
```bash
curl https://internal.server/get-gcp-key.sh | bash -s MY-APP
```

---

### Option 4: Manual Copy-Paste (Least Secure)

**Only use in secure environment (e.g., in-person):**

1. Open the key file
2. Copy the entire content
3. Tell business user:
   ```bash
   echo 'PASTE_KEY_HERE' | gh secret set GCP_SA_KEY --repo nelc/THEIR-APP
   ```
4. They paste when prompted

**⚠️ Never share via email or public Slack channels!**

---

## What to Tell Business Users

**Message template:**

```
Hi [NAME],

To deploy your app to GKE, you need to add the GCP_SA_KEY secret.

[Choose ONE method below:]

METHOD 1 - File Download:
1. Download the key: [SECURE_LINK]
2. Save as gcp-key.json in your app folder
3. Run: cat gcp-key.json | gh secret set GCP_SA_KEY --repo nelc/YOUR-APP
4. Delete the file
5. Deploy: git push origin main

METHOD 2 - Automated:
1. Run: curl https://internal.server/get-key.sh | bash -s YOUR-APP
2. Deploy: git push origin main

This is a one-time setup. Future deployments will be automatic.

Questions? Check GET_GCP_KEY.md in cursor-app-factory.
```

---

## Security Best Practices

### DO:
- ✅ Use secure file-sharing with access controls
- ✅ Expire/revoke access after download
- ✅ Use encrypted channels (HTTPS, secure file shares)
- ✅ Log who requested the key and when
- ✅ Remind users to delete local copies
- ✅ Rotate the key periodically

### DON'T:
- ❌ Email the key
- ❌ Post in public Slack channels
- ❌ Commit to git
- ❌ Share in unencrypted channels
- ❌ Leave it in shared folders indefinitely

---

## Key Rotation

If the key is compromised:

1. **Create new service account key:**
   ```bash
   gcloud iam service-accounts keys create new-key.json \
     --iam-account=github-actions-deployer@app-sandbox-factory.iam.gserviceaccount.com
   ```

2. **Update all repositories:**
   ```bash
   # Use the bulk update script
   for repo in $(gh repo list nelc --json name -q '.[].name'); do
     cat new-key.json | gh secret set GCP_SA_KEY --repo nelc/$repo
   done
   ```

3. **Delete old key:**
   ```bash
   gcloud iam service-accounts keys delete OLD_KEY_ID \
     --iam-account=github-actions-deployer@app-sandbox-factory.iam.gserviceaccount.com
   ```

4. **Notify business users:**
   ```
   "The GCP key was rotated. Your existing deployments will continue 
   to work. No action needed unless you're setting up a new app."
   ```

---

## Monitoring

**Track key usage:**

```bash
# Check who has the secret configured
for repo in $(gh repo list nelc --json name -q '.[].name'); do
  if gh secret list --repo nelc/$repo 2>/dev/null | grep -q GCP_SA_KEY; then
    echo "✓ nelc/$repo"
  fi
done
```

**Audit failed deployments:**
```bash
# Check for auth errors
gh run list --repo nelc/APP-NAME --limit 10 --json conclusion,name
```

---

## Alternative: No Key Sharing (Workload Identity)

If sharing keys is too complex, consider **Workload Identity Federation**:
- No keys to share
- GitHub OIDC tokens authenticate directly to GCP
- More secure
- More complex setup

See: https://github.com/google-github-actions/auth#workload-identity-federation

---

## Summary

**Recommended approach:**
1. Upload key to secure shared drive
2. Share link with business user
3. They download, use, and delete
4. Revoke access to link

**This is one-time per app.** Future deployments are automatic.

**Questions?** Update this guide as you learn what works best for your organization.

