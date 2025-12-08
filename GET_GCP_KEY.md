# 🔑 Getting the GCP Deployment Key

## For Business Users

To deploy your app to GCP, you need the `GCP_SA_KEY` secret.

---

## How to Get It

**Contact the platform team and request:**

```
"Hi, I need the GCP_SA_KEY to deploy my app to GKE. 
Can you send me the key file or share the secure location?"
```

---

## What You'll Receive

The platform team will give you **ONE** of these:

### Option 1: File
- A file named `github-actions-key.json`
- Save it in your app directory (it's in `.gitignore`, won't be committed)

### Option 2: Text Content
- The JSON key content as text
- You'll paste it when adding the secret

### Option 3: Secure Link
- A link to download from secure storage
- Download and save as `gcp-key.json`

---

## How to Use It

### If you have the file:

```bash
# From your app directory
cat gcp-key.json | gh secret set GCP_SA_KEY --repo nelc/YOUR-APP-NAME
```

### If you have the text content:

```bash
echo 'PASTE_KEY_CONTENT_HERE' | gh secret set GCP_SA_KEY --repo nelc/YOUR-APP-NAME
```

### Verify it was added:

```bash
gh secret list --repo nelc/YOUR-APP-NAME
```

You should see:
```
GCP_SA_KEY  Updated YYYY-MM-DD
```

---

## Trigger Deployment

After adding the secret:

```bash
git commit --allow-empty -m "Trigger deployment"
git push origin main
```

Watch: `https://github.com/nelc/YOUR-APP-NAME/actions`

---

## Security Notes

**IMPORTANT:**
- ⚠️ **Never commit the key file to git**
- ⚠️ **Never share the key publicly**
- ⚠️ **Don't paste it in Slack/email**
- ✅ Add it as a GitHub secret (encrypted)
- ✅ Delete the key file after adding it to GitHub

**The key file is already in `.gitignore` so it won't be committed accidentally.**

---

## Troubleshooting

### "gh: command not found"
Install GitHub CLI:
```bash
# macOS
brew install gh

# Then authenticate
gh auth login
```

### "Permission denied"
Make sure you have access to the repository:
```bash
gh repo view nelc/YOUR-APP-NAME
```

### Key not working
- Make sure you pasted the entire content
- Check for extra spaces or line breaks
- Contact platform team for a fresh copy

---

## One-Time Setup

**You only need to do this ONCE per app.**

After adding the secret:
- All future deployments are automatic
- Just push code → auto-deploy!
- No need to add the secret again

---

## Questions?

- Can't get the key? → Contact platform team
- Key not working? → Re-add it and try again
- Need help? → Check BUSINESS_USER_SIMPLE.md

