# Kubernetes Deployment Guide

This guide explains how business users can develop apps with docker-compose and deploy to GKE (Google Kubernetes Engine).

## Why This Approach Works

### ✅ Eliminates 350+ Failure Points

**The Problem Before:**
- Users had to manually configure Cloud Run, Cloud SQL, VPC, IAM
- Database setup was manual and error-prone
- Environment variables scattered everywhere
- No consistency between dev and prod

**The Solution Now:**
- Docker Compose for local development (works identically everywhere)
- Everything containerized (no environment differences)
- First user automatically becomes admin
- All config in database Settings table
- One command to deploy to Kubernetes

### 🎯 The Magic Prompt

Business users use this prompt:

```
Create a production-ready docker-compose.yml that runs this application end-to-end so a non-technical user can run docker-compose up -d and have a fully working application in under 2 minutes, with data persisting across restarts. Use a single Dockerfile only (reuse the existing one if present) and do not create any additional Dockerfile variants. If this application needs its own database, define one DB service with fixed credentials inside docker-compose.yml. The application itself must implement two mandatory features: (1) the first registered user becomes the admin if the users table is empty, and (2) all system configuration must be managed through an in-app database-backed Settings Page UI using a Settings table, with no environment variables used for configuration except the database connection. These features are required and must be created if missing.

Additional requirements:
- Application MUST listen on port 8080
- Server MUST bind to 0.0.0.0 (not localhost or 127.0.0.1)
- Database MUST auto-initialize schema on first run
- Health check endpoint at /health that returns {"status":"healthy"}
- All secrets and configuration in database Settings table
- Docker container MUST use process.env.PORT with fallback to 8080
```

This ensures Cursor generates deployment-ready code.

---

## Complete Workflow

### Step 1: Develop in Cursor

```
User: "Build me an employee management system with departments, roles, and attendance tracking"

Cursor: [generates application code]

User: [Pastes the Magic Prompt]

Cursor: 
✓ Created Dockerfile
✓ Created docker-compose.yml with PostgreSQL
✓ Configured port 8080 and 0.0.0.0 binding
✓ Added health check at /health
✓ Added first-user-is-admin logic
✓ Added Settings page for configuration
✓ Added database auto-initialization
```

### Step 2: Test Locally

```bash
# Start everything
docker-compose up -d

# Wait for startup (usually < 1 minute)
sleep 30

# Check health
curl http://localhost:8080/health
# Output: {"status":"healthy"}

# Open in browser
open http://localhost:8080

# Register first user → automatically becomes admin
# Test all features
# Configure settings via admin UI
```

### Step 3: Deploy to GKE

```bash
# One command deployment
make deploy

# Or specify environment
make k8s-deploy ENV=prod
```

**What happens automatically:**

1. ✅ Converts docker-compose.yml to Kubernetes manifests
2. ✅ Creates GKE cluster (if doesn't exist)
3. ✅ Builds Docker image
4. ✅ Pushes to Google Container Registry
5. ✅ Deploys to Kubernetes
6. ✅ Creates LoadBalancer Service
7. ✅ Returns public URL

**Output:**
```
✅ Deployment complete!
🌐 Service URL: http://35.123.456.789:8080

Test with: curl http://35.123.456.789:8080/health

Useful commands:
  View pods:     kubectl get pods -n myapp-dev
  View logs:     kubectl logs -f -l app=app -n myapp-dev
  View services: kubectl get svc -n myapp-dev
```

---

## What Gets Deployed to Kubernetes

### From docker-compose.yml:
```yaml
services:
  app:     → Kubernetes Deployment (2 replicas)
  db:      → Kubernetes StatefulSet (PostgreSQL)
```

### Generated Kubernetes Resources:

1. **Namespace** - Isolated environment for your app
2. **Secrets** - Database credentials, API keys
3. **ConfigMaps** - Non-sensitive configuration
4. **Deployment** - Your application containers
5. **StatefulSet** - PostgreSQL database
6. **PersistentVolumeClaims** - Data storage
7. **Services** - LoadBalancer for external access
8. **Ingress** (optional) - Custom domain with HTTPS

### Architecture in Kubernetes:

```
                 ┌─────────────────────────────┐
                 │   LoadBalancer Service       │
                 │   External IP: 35.x.x.x     │
                 └─────────────────────────────┘
                              ↓
        ┌────────────────────────────────────────┐
        │         App Deployment                  │
        │  ┌─────────┐  ┌─────────┐  ┌─────────┐│
        │  │  Pod 1  │  │  Pod 2  │  │  Pod 3  ││
        │  │  App    │  │  App    │  │  App    ││
        │  └─────────┘  └─────────┘  └─────────┘│
        └────────────────────────────────────────┘
                              ↓
                 ┌─────────────────────────────┐
                 │    Database Service          │
                 └─────────────────────────────┘
                              ↓
        ┌────────────────────────────────────────┐
        │      PostgreSQL StatefulSet             │
        │  ┌─────────────────┐                   │
        │  │  Database Pod   │                   │
        │  │  + Persistent   │                   │
        │  │    Volume       │                   │
        │  └─────────────────┘                   │
        └────────────────────────────────────────┘
```

---

## Key Features

### 1. Automatic Database Management

**docker-compose.yml includes:**
```yaml
db:
  image: postgres:16-alpine
  environment:
    - POSTGRES_DB=appdb
    - POSTGRES_USER=appuser
    - POSTGRES_PASSWORD=apppass123
  volumes:
    - ./schema.sql:/docker-entrypoint-initdb.d/01-schema.sql
```

**Kubernetes converts to:**
- StatefulSet for PostgreSQL
- PersistentVolume for data storage
- Secret for database credentials
- Automatic schema initialization

### 2. First User = Admin

**Application code includes:**
```javascript
async function register(email, password) {
  const userCount = await db.query('SELECT COUNT(*) FROM users');
  const isFirstUser = userCount.rows[0].count === '0';
  
  const role = isFirstUser ? 'admin' : 'user';
  
  // Create user with appropriate role
  await db.query(
    'INSERT INTO users (email, password, role) VALUES ($1, $2, $3)',
    [email, hashedPassword, role]
  );
}
```

**This means:**
- No manual admin user creation needed
- First person to register gets admin access
- Simple onboarding process

### 3. Settings in Database

**Application includes Settings table:**
```sql
CREATE TABLE settings (
  key VARCHAR(255) PRIMARY KEY,
  value TEXT,
  description TEXT,
  updated_at TIMESTAMP DEFAULT NOW()
);
```

**Admin UI for managing settings:**
```
Settings Page:
┌────────────────────────────────────────┐
│ Application Settings                    │
├────────────────────────────────────────┤
│ Company Name:     [_______________]    │
│ Company Logo URL: [_______________]    │
│ SMTP Host:        [_______________]    │
│ SMTP Port:        [_______________]    │
│ Max Upload Size:  [_______________]    │
│                                         │
│ [Save Settings]                         │
└────────────────────────────────────────┘
```

**No environment variables needed** - everything configurable via UI!

### 4. Production-Ready Health Checks

**Application code:**
```javascript
app.get('/health', async (req, res) => {
  try {
    // Check database connection
    await db.query('SELECT 1');
    
    res.json({ 
      status: 'healthy',
      database: 'connected',
      uptime: process.uptime()
    });
  } catch (err) {
    res.status(503).json({ 
      status: 'unhealthy',
      error: 'Database connection failed'
    });
  }
});
```

**Kubernetes uses this for:**
- Liveness probes (restart if unhealthy)
- Readiness probes (only send traffic when ready)
- Load balancer health checks

---

## How It Solves the 350+ Problems

### ✅ Database Issues (50+ problems) → SOLVED

**Before:**
- Manual Cloud SQL creation
- Manual schema migration
- Manual user creation
- Connection string confusion
- Permission issues

**Now:**
- PostgreSQL included in docker-compose
- Schema auto-runs on first start
- First user auto-becomes admin
- Connection string in one place
- Works identically locally and in k8s

### ✅ Port & Binding Issues (35+ problems) → SOLVED

**Before:**
- Random ports (3000, 5000, 3001)
- Binding to localhost
- Health checks failing

**Now:**
- Magic prompt enforces port 8080
- Magic prompt enforces 0.0.0.0 binding
- Health check at /health required
- Validated before deployment

### ✅ Configuration Issues (40+ problems) → SOLVED

**Before:**
- Environment variables everywhere
- Secrets in git
- Different config for dev/prod
- Manual Secret Manager setup

**Now:**
- All config in database Settings table
- Editable via admin UI
- Same config approach everywhere
- No secrets in git (only in docker-compose)

### ✅ Deployment Issues (25+ problems) → SOLVED

**Before:**
- Complex Cloud Run setup
- VPC connector confusion
- Service account permissions
- Build phase vs runtime confusion

**Now:**
- docker-compose → k8s (automatic)
- All networking handled by k8s
- Service accounts auto-created
- Everything containerized (no build phase issues)

### ✅ Setup Issues (20+ problems) → SOLVED

**Before:**
- Install Docker, gcloud, GitHub CLI
- Multiple authentication steps
- Manual project setup
- Permission requests

**Now:**
- Only Docker Desktop needed
- One-time gcloud auth
- Automated project setup
- Script handles permissions

---

## Commands Reference

### Local Development

```bash
# Start application
docker-compose up -d

# View logs
docker-compose logs -f app

# Stop application
docker-compose down

# Reset everything (including data)
docker-compose down -v

# Rebuild after code changes
docker-compose up -d --build

# Access database
docker-compose exec db psql -U appuser -d appdb
```

### Kubernetes Deployment

```bash
# Deploy to development
make k8s-deploy ENV=dev

# Deploy to production
make k8s-deploy ENV=prod

# Just convert docker-compose to k8s manifests
make k8s-convert

# View deployment status
make k8s-status

# View logs
make k8s-logs

# Delete everything
make k8s-delete
```

### Manual Kubernetes Commands

```bash
# Get all resources
kubectl get all -n myapp-dev

# View pods
kubectl get pods -n myapp-dev

# View logs for app
kubectl logs -f -l app=app -n myapp-dev

# View logs for database
kubectl logs -f -l app=db -n myapp-dev

# Describe service (to get external IP)
kubectl describe svc app -n myapp-dev

# Scale app
kubectl scale deployment/app --replicas=5 -n myapp-dev

# Rollback deployment
kubectl rollout undo deployment/app -n myapp-dev

# View rollout history
kubectl rollout history deployment/app -n myapp-dev

# Access pod shell
kubectl exec -it <pod-name> -n myapp-dev -- sh

# Port forward to local machine
kubectl port-forward svc/app 8080:8080 -n myapp-dev
```

---

## Advanced Features

### Custom Domain with HTTPS

1. **Get external IP:**
```bash
kubectl get svc app -n myapp-prod
```

2. **Add DNS A record:**
```
myapp.yourcompany.com → 35.x.x.x
```

3. **Install cert-manager (once per cluster):**
```bash
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.13.0/cert-manager.yaml
```

4. **Deploy with domain:**
```bash
make k8s-deploy ENV=prod DOMAIN=myapp.yourcompany.com
```

This creates Ingress with automatic Let's Encrypt SSL!

### Scaling

**Horizontal scaling (more pods):**
```bash
kubectl scale deployment/app --replicas=10 -n myapp-prod
```

**Auto-scaling based on CPU:**
```bash
kubectl autoscale deployment/app \
  --min=2 --max=10 \
  --cpu-percent=70 \
  -n myapp-prod
```

### Database Backups

**Manual backup:**
```bash
# Get database pod name
DB_POD=$(kubectl get pod -l app=db -n myapp-prod -o jsonpath='{.items[0].metadata.name}')

# Create backup
kubectl exec $DB_POD -n myapp-prod -- \
  pg_dump -U appuser appdb > backup-$(date +%Y%m%d).sql
```

**Automated backups with CronJob:**
```yaml
apiVersion: batch/v1
kind: CronJob
metadata:
  name: db-backup
spec:
  schedule: "0 2 * * *"  # 2 AM daily
  jobTemplate:
    spec:
      template:
        spec:
          containers:
          - name: backup
            image: postgres:16-alpine
            command: ["/bin/sh", "-c"]
            args:
            - pg_dump -h db -U appuser appdb | gzip > /backup/$(date +%Y%m%d).sql.gz
            volumeMounts:
            - name: backup
              mountPath: /backup
          volumes:
          - name: backup
            persistentVolumeClaim:
              claimName: db-backups
          restartPolicy: OnFailure
```

### Monitoring

**Built-in Kubernetes monitoring:**
```bash
# Resource usage
kubectl top pods -n myapp-prod
kubectl top nodes

# Events
kubectl get events -n myapp-prod --sort-by='.lastTimestamp'
```

**Google Cloud Monitoring:**
```bash
# Enable monitoring
gcloud container clusters update <cluster-name> \
  --enable-cloud-monitoring \
  --zone <zone>
```

View metrics in: https://console.cloud.google.com/monitoring

---

## Troubleshooting

### Pod won't start

```bash
# Check pod status
kubectl get pods -n myapp-dev

# Describe pod for events
kubectl describe pod <pod-name> -n myapp-dev

# Check logs
kubectl logs <pod-name> -n myapp-dev

# Check previous container logs (if crashed)
kubectl logs <pod-name> -n myapp-dev --previous
```

### Can't access application

```bash
# Check service has external IP
kubectl get svc app -n myapp-dev

# If pending, check load balancer quota
gcloud compute addresses list

# Test from within cluster
kubectl run test --rm -it --image=busybox -n myapp-dev -- sh
wget -O- http://app:8080/health
```

### Database connection issues

```bash
# Check database pod is running
kubectl get pod -l app=db -n myapp-dev

# Check database logs
kubectl logs -l app=db -n myapp-dev

# Connect to database
kubectl exec -it <db-pod-name> -n myapp-dev -- psql -U appuser -d appdb

# Test connection from app pod
kubectl exec -it <app-pod-name> -n myapp-dev -- sh
apk add postgresql-client
psql $DATABASE_URL
```

### Slow performance

```bash
# Check resource usage
kubectl top pods -n myapp-prod

# Increase resources in deployment
kubectl edit deployment app -n myapp-prod
# Increase CPU and memory limits

# Scale horizontally
kubectl scale deployment/app --replicas=5 -n myapp-prod
```

---

## Cost Optimization

### Development Environment

```yaml
# Smaller nodes
--machine-type=e2-small

# Fewer replicas
replicas: 1

# Smaller database
resources:
  requests:
    memory: "128Mi"
```

### Production Environment

```yaml
# Appropriate node sizing
--machine-type=e2-medium

# Auto-scaling
--enable-autoscaling
--min-nodes=2
--max-nodes=10

# Preemptible nodes for non-critical workloads
--preemptible
```

### Delete unused environments

```bash
# Delete dev environment when not in use
kubectl delete namespace myapp-dev

# Delete entire cluster
gcloud container clusters delete <cluster-name> --zone <zone>
```

---

## Next Steps

1. **Try it locally:**
   ```bash
   docker-compose up -d
   open http://localhost:8080
   ```

2. **Deploy to GKE:**
   ```bash
   make k8s-deploy ENV=dev
   ```

3. **Access your app:**
   - Register first user (becomes admin)
   - Configure settings via admin UI
   - Test all features

4. **Share with team:**
   - Give them the external URL
   - They can register and start using it
   - Admin can manage users and settings

**That's it! Your app is production-ready and running in Kubernetes.**

