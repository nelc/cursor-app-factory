# Cursor App Factory

**Deploy production-ready Node.js applications from Cursor to Google Cloud Platform (GKE) with automatic SSL/HTTPS.**

## For Business Users

Start here: **[START_HERE.md](START_HERE.md)**

Quick workflow:
1. **[MAGIC_PROMPT.md](MAGIC_PROMPT.md)** - Build your app in Cursor
2. Test locally: `docker-compose up -d`
3. **[DEPLOY_PROMPT.md](DEPLOY_PROMPT.md)** - Deploy to production
4. Get your app at: `https://your-app.futurex.sa` ✨

All apps automatically get:
- ✅ Trusted SSL certificates
- ✅ Cloudflare CDN & DDoS protection
- ✅ Kubernetes orchestration
- ✅ Automatic scaling
- ✅ Database persistence

## For Platform Team

Technical documentation:
- **[K8S_DEPLOYMENT_GUIDE.md](K8S_DEPLOYMENT_GUIDE.md)** - Kubernetes deployment details
- **[PLATFORM_TEAM_GUIDE.md](PLATFORM_TEAM_GUIDE.md)** - Operations & maintenance
- **[SSL_SETUP_COMPLETE.md](SSL_SETUP_COMPLETE.md)** - SSL/HTTPS configuration

## Repository Structure

```
cursor-app-factory/
├── START_HERE.md              # Entry point for all users
├── SIMPLE.md                  # Quick 3-step guide
├── MAGIC_PROMPT.md            # Prompt for building apps
├── DEPLOY_PROMPT.md           # Prompt for deploying apps
├── GET_GCP_KEY.md             # How to get GCP credentials
│
├── templates/                 # Application templates
│   ├── Dockerfile             # Docker build template
│   ├── docker-compose.yaml    # Local development
│   └── deploy-to-gke.yaml     # GitHub Actions workflow
│
├── K8S_DEPLOYMENT_GUIDE.md    # Technical guide
├── PLATFORM_TEAM_GUIDE.md     # Operations guide
├── PLATFORM_TEAM_SHARE_KEY.md # Key distribution
├── SSL_SETUP_COMPLETE.md      # SSL setup details
│
├── schema.sql                 # Database template
├── env.example                # Environment variables
└── README.md                  # This file
```

## Infrastructure

- **GKE Cluster**: Dammam (me-central2), Autopilot, Shared VPC
- **SSL/HTTPS**: Cloudflare Origin Certificate + nginx sidecar
- **Registry**: Artifact Registry (me-central2)
- **Network**: Shared VPC (nelc-vpc)
- **CI/CD**: GitHub Actions

## Quick Links

**Business Users:**
- [Start Here](START_HERE.md)
- [Simple Guide](SIMPLE.md)
- [Build App](MAGIC_PROMPT.md)
- [Deploy App](DEPLOY_PROMPT.md)

**Platform Team:**
- [Kubernetes Guide](K8S_DEPLOYMENT_GUIDE.md)
- [Operations Guide](PLATFORM_TEAM_GUIDE.md)
- [SSL Setup](SSL_SETUP_COMPLETE.md)

## Support

For issues or questions, contact the platform team.

---

**Last Updated**: December 9, 2025  
**Status**: ✅ Production Ready
