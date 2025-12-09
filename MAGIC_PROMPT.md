# Magic Deployment Prompt for Business Users

Copy and paste this prompt when building any application:

---

## THE MAGIC PROMPT

```
Create a production-ready docker-compose.yml that runs this application end-to-end so a non-technical user can run docker-compose up -d and have a fully working application in under 2 minutes, with data persisting across restarts. Use a single Dockerfile only (reuse the existing one if present) and do not create any additional Dockerfile variants. If this application needs its own database, define one DB service with fixed credentials inside docker-compose.yml. The application itself must implement two mandatory features: (1) the first registered user becomes the admin if the users table is empty, and (2) all system configuration must be managed through an in-app database-backed Settings Page UI using a Settings table, with no environment variables used for configuration except the database connection. These features are required and must be created if missing.

Additional requirements:
- Application MUST listen on port 8080
- Server MUST bind to 0.0.0.0 (not localhost or 127.0.0.1)
- Database MUST auto-initialize schema on first run
- Health check endpoint at /health that returns {"status":"healthy"}
- All secrets and configuration in database Settings table
- Docker container MUST use process.env.PORT with fallback to 8080
- For Node.js apps: MUST generate package-lock.json by running 'npm install' after creating package.json
- Application MUST parse DATABASE_URL for database connection (e.g., postgresql://user:pass@host:port/db)
- MUST create .dockerignore file that excludes: node_modules, .git, .env, *.log
```

---

## How to Use This Prompt

### Step 1: Start Your Project
```
You: "Build me a [describe your app]"
[generates initial code]
```

### Step 2: Make It Production-Ready
```
You: [Paste the Magic Prompt above]
[creates Dockerfile, docker-compose.yml, adds admin logic, adds settings page]
```

### Step 2.5: Ensure Dependencies Are Locked (Node.js only)
```
You: "Run npm install to generate package-lock.json"
[generates package-lock.json]
```

### Step 3: Test Locally
```bash
docker-compose up -d
```

Wait 1-2 minutes, then open http://localhost:8080

### Step 4: Deploy to Production
```bash
make deploy
```

Done! Your app is in production.

---

## What This Prompt Does

### ✅ Ensures Production Readiness
- Correct port (8080)
- Correct binding (0.0.0.0)
- Health checks
- Data persistence
- Fast startup

### ✅ Eliminates Setup Issues
- No manual database setup needed
- First user automatically becomes admin
- All settings managed via UI
- No environment variable configuration

### ✅ Makes Testing Easy
- One command to start (`docker-compose up -d`)
- Works identically in dev and prod
- Data persists across restarts
- Clean shutdown

### ✅ Enables One-Command Deployment
- docker-compose.yml auto-converts to Kubernetes manifests
- Same configuration works everywhere
- No manual k8s YAML writing

---

## Example: What Cursor Will Generate

### docker-compose.yml
```yaml
version: '3.9'

services:
  app:
    build: .
    ports:
      - "8080:8080"
    environment:
      - DATABASE_URL=postgresql://appuser:apppass@db:5432/appdb
      - NODE_ENV=production
    depends_on:
      db:
        condition: service_healthy
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "wget", "--no-verbose", "--tries=1", "--spider", "http://localhost:8080/health"]
      interval: 10s
      timeout: 5s
      retries: 3

  db:
    image: postgres:16-alpine
    environment:
      - POSTGRES_DB=appdb
      - POSTGRES_USER=appuser
      - POSTGRES_PASSWORD=apppass
    volumes:
      - postgres_data:/var/lib/postgresql/data
    restart: unless-stopped
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U appuser"]
      interval: 5s
      timeout: 5s
      retries: 5

volumes:
  postgres_data:
```

### Automatic Admin User Logic
```javascript
// On first registration, if no users exist:
async function register(email, password) {
  const userCount = await db.query('SELECT COUNT(*) FROM users');
  const isFirstUser = userCount.rows[0].count === '0';
  
  const user = await db.query(
    'INSERT INTO users (email, password, role) VALUES ($1, $2, $3) RETURNING *',
    [email, hashedPassword, isFirstUser ? 'admin' : 'user']
  );
  
  return user.rows[0];
}
```

### Automatic Settings Page
```javascript
// Settings stored in database, editable via UI
// No environment variables needed for app config

GET  /admin/settings     → View/edit settings page
POST /admin/settings     → Update settings

Settings table:
- smtp_host
- smtp_port
- company_name
- logo_url
- etc.
```

### Database Connection (CRITICAL!)
```javascript
// ✅ CORRECT: Your app MUST use DATABASE_URL environment variable
const { Pool } = require('pg');

const pool = new Pool({
  connectionString: process.env.DATABASE_URL
});

// ❌ WRONG: Do NOT use individual env vars
// This will FAIL in production:
const pool = new Pool({
  host: process.env.DB_HOST || 'localhost',     // ❌ NO
  port: process.env.DB_PORT || 5432,            // ❌ NO
  database: process.env.DB_NAME,                // ❌ NO
  user: process.env.DB_USER,                    // ❌ NO
  password: process.env.DB_PASSWORD             // ❌ NO
});
```

**Why?**
- Docker Compose provides `DATABASE_URL=postgresql://user:pass@db:5432/dbname`
- Kubernetes deployment provides `DATABASE_URL`
- Individual env vars will connect to `localhost` and crash

---

## Troubleshooting

### If Cursor doesn't follow the prompt exactly:

1. **Regenerate the specific file:**
   ```
   You: "Please create docker-compose.yml following the production-ready requirements"
   ```

2. **Check specific requirement:**
   ```
   You: "Verify the app listens on port 8080 and binds to 0.0.0.0"
   You: "Add the first-user-is-admin logic to the registration endpoint"
   You: "Create a Settings table and admin UI for managing configuration"
   ```

3. **Validate before deploying:**
   ```bash
   # Test locally first
   docker-compose up -d
   
   # Check logs
   docker-compose logs -f app
   
   # Verify health
   curl http://localhost:8080/health
   ```

---

## Why This Works

### Solves Database Issues
- ✅ Database auto-created with docker-compose
- ✅ Schema auto-initialized on first run
- ✅ First user becomes admin automatically
- ✅ Credentials built into compose file
- ✅ Data persists in volume

### Solves Configuration Issues
- ✅ No manual env var setup
- ✅ Settings in database (editable via UI)
- ✅ Same config locally and in prod
- ✅ Non-technical users can change settings via UI

### Solves Deployment Issues
- ✅ Port always correct (8080)
- ✅ Binding always correct (0.0.0.0)
- ✅ Health checks built in
- ✅ Fast startup (< 2 minutes)
- ✅ Kubernetes-ready

### Solves User Experience Issues
- ✅ One command to start
- ✅ No setup wizard needed
- ✅ Works immediately
- ✅ Clear admin credentials (first registered user)

---

## Advanced: Customizing the Prompt

Add these to the magic prompt for specific needs:

### For Apps with File Uploads
```
Add a 'storage' service using MinIO for S3-compatible object storage.
Configure the app to use MinIO at http://storage:9000.
```

### For Apps with Background Jobs
```
Add a 'worker' service that shares the same codebase but runs background jobs.
Use a Redis service for job queues.
```

### For Apps with Real-Time Features
```
Add WebSocket support with sticky sessions.
Add a Redis service for pub/sub.
```

### For Multi-Tenant Apps
```
Implement tenant isolation at the database level using a tenant_id column.
Add tenant selection UI for admin users.
```

---

## Full Workflow Example

### 1. Create Your App
```
You: "Build me a project management tool with tasks, teams, and file uploads"

Cursor: [generates full application]
```

### 2. Make It Production-Ready
```
You: [Paste the Magic Prompt]

Cursor: 
✓ Created Dockerfile
✓ Created docker-compose.yml with app + database + storage
✓ Added first-user-is-admin logic
✓ Added Settings page for configuration
✓ Configured port 8080 and 0.0.0.0 binding
✓ Added health check endpoint
✓ Added database schema initialization
```

### 3. Test Locally
```bash
docker-compose up -d

# Wait for startup
sleep 30

# Open in browser
open http://localhost:8080

# Register first user → automatically admin
# Configure settings via UI
# Test all features
```

### 4. Deploy to Production
```bash
# Push to GitHub
git add .
git commit -m "Initial version"
git push

# Deploy to GKE
make deploy

# Output:
# ✓ Converted docker-compose to k8s manifests
# ✓ Created namespace
# ✓ Created secrets
# ✓ Deployed PostgreSQL StatefulSet
# ✓ Deployed application Deployment
# ✓ Created LoadBalancer Service
# ✓ App available at: http://35.123.456.789
```

### 5. Access Production
```
Open: http://your-app.yourcompany.com
Register first user → becomes admin
Configure settings via UI
Share URL with team
```

---

## Success Checklist

Before deploying, verify:

- [ ] `docker-compose up -d` starts app successfully
- [ ] Can access app at http://localhost:8080
- [ ] Can register first user
- [ ] First user has admin role
- [ ] Can access Settings page as admin
- [ ] Can change settings and see them take effect
- [ ] Data persists after `docker-compose down` and `docker-compose up -d`
- [ ] Health endpoint returns `{"status":"healthy"}`
- [ ] App logs look clean (no errors)

If all checked, you're ready to deploy to production!

---

## Need Help?

If Cursor doesn't generate something correctly:

1. **Be specific:**
   ```
   "The app is listening on port 3000, please change it to 8080"
   "The server binds to localhost, please change to 0.0.0.0"
   "Add first-user-is-admin logic to the registration function"
   ```

2. **Validate the files:**
   ```
   "Check docker-compose.yml has health checks for both services"
   "Verify Dockerfile exposes port 8080"
   "Show me the first-user-is-admin code"
   ```

3. **Test incrementally:**
   ```bash
   # Build image
   docker-compose build
   
   # Start just database
   docker-compose up db
   
   # Start everything
   docker-compose up
   ```

---

**Remember: The magic prompt ensures your app works locally AND in production with zero configuration changes!**

