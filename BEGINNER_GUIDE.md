# 🚀 Build & Deploy from Cursor to GCP

**Simple workflow for business users who know Cursor**

---

## The 3-Step Process

```
1. Tell Cursor AI what to build → It generates everything
2. Test locally → docker-compose up -d
3. Deploy to cloud → make deploy
```

**Total time: 15 minutes**

---

## Step 1: Generate Your App with Cursor AI

### Open Cursor AI Chat (Cmd+L)

**Important: Order matters!**

1. **First** - Write what you want to build:
```
Build a task management app where users can:
- Create tasks with title, description, and due date
- Mark tasks as complete
- Delete tasks
- Filter by status (all/active/completed)

Use a modern design with blue accents.
```

2. **Second** - Copy the **entire contents** of `MAGIC_PROMPT.md` and paste it below your description

3. Press Enter

Cursor generates everything (1-2 min):
- All code files
- `Dockerfile`
- `docker-compose.yaml`
- Database schema
- First-user-as-admin logic
- Settings UI

---

## Step 2: Test Locally

In Cursor's terminal:

```bash
docker-compose up -d
```

Open browser: **http://localhost:8080**

**Important**: 
- Click **"Register"** first! The first user you create automatically becomes the admin.
- Look for a **Settings** page (usually in the nav menu or admin panel) - every app should have one for configuration.

Test all features. If something needs fixing, tell Cursor AI and it'll fix it.

**If Cursor skipped the Settings page**, tell it:
```
Add a Settings page accessible to admin users only. 
Store all configuration in a database Settings table (key-value pairs).
Add a Settings link in the navigation menu.
```

---

## Step 3: Deploy to GCP (Push to GitHub)

### First Time: Set Up GitHub Repo

```bash
# In your app directory
git init
git add .
git commit -m "Initial commit"

# Create repo on GitHub, then:
git remote add origin https://github.com/YOUR-ORG/YOUR-APP.git
git push -u origin main
```

### Every Update: Just Push

```bash
git add .
git commit -m "Updated feature"
git push
```

**That's it!** GitHub Actions automatically:
1. ✅ Builds your Docker image
2. ✅ Pushes to GCP
3. ✅ Deploys to Kubernetes
4. ✅ Comments with your live URL

Wait ~10 minutes, then check the **Actions** tab on GitHub for your URL!

**Example**: `🚀 Your app is live at: http://34.166.241.13`

---

## Make Updates

### Change something:
Tell Cursor AI: "Make the buttons green" or "Add priority field to tasks"

### Test the change:
```bash
docker-compose down
docker-compose up -d
```

### Deploy the update:
```bash
git add .
git commit -m "Made buttons green"
git push
```

**Done!** GitHub Actions auto-deploys in ~10 minutes.

---

## Essential Commands

```bash
# Local testing
docker-compose up -d              # Start app locally
docker-compose down               # Stop app
docker-compose logs               # View logs

# Deployment
make deploy                       # Deploy to GCP
kubectl get pods                  # Check if running
kubectl logs <pod-name>           # View cloud logs
kubectl get services              # Get your URL
```

---

## Example Prompts

### Customer Feedback System
```
Build a customer feedback app:
- Customers submit: name, email, rating (1-5 stars), comments
- Admin dashboard shows all feedback in a table
- Can filter by rating
- Mark feedback as "reviewed"
Use company colors: #0066cc and white
```

### Inventory Tracker
```
Build inventory management:
- Add/edit products: name, SKU, quantity, location
- Low stock alerts when quantity < 10
- Search by name or SKU
- Export to CSV
Clean, data-focused design
```

### Meeting Room Booking
```
Build room booking system:
- 4 rooms: Conference A, Conference B, Small 1, Small 2
- Calendar view showing availability
- Book time slots (30 min increments)
- Users see their bookings
- Auto-cancel if no-show after 15 min
```

---

## Troubleshooting

| Problem | Solution |
|---------|----------|
| `docker: command not found` | Install Docker Desktop from docker.com |
| `localhost:8080 doesn't load` | Run `docker-compose logs` to see errors |
| "Invalid credentials" on login | Click **Register** first! First user = admin |
| No Settings page | Ask Cursor: "Add an admin Settings page with database-backed configuration" |
| `make: command not found` | Run `bash scripts/deploy-to-gke.sh` instead |
| Deployment fails | Check `kubectl get pods` and `kubectl logs <pod>` |
| Want to reset database | Run `docker-compose down -v` then `docker-compose up -d` |

---

## Tips for Better Results

### ✅ Good Prompt
```
Build invoice generator where:
- Create invoices with line items (description, qty, price)
- Auto-calculate totals and tax (15%)
- Generate PDF
- Save all invoices to database
- Search by client name or invoice number
Professional design, company logo at top
```

### ❌ Vague Prompt
```
Make an invoice app
```

**Be specific!** List exact features, describe the UX, mention design preferences.

---

## That's It!

```
1. MAGIC_PROMPT.md + your description → Cursor generates code
2. docker-compose up -d → Test locally
3. make deploy → Live in 10 minutes
```

**You're ready to build!** 🚀
