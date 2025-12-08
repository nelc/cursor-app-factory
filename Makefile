.PHONY: help dev stop build test deploy clean logs status

# Load environment variables (optional)
-include .env
export

# Default values
ENV ?= dev
NAMESPACE ?= $(shell grep SERVICE_NAME .env 2>/dev/null | cut -d'=' -f2 || echo "myapp")-$(ENV)
DOMAIN ?=

help: ## Show this help message
	@echo '╔══════════════════════════════════════════════════════════════╗'
	@echo '║          Cursor App Factory - Docker Compose → K8s          ║'
	@echo '╚══════════════════════════════════════════════════════════════╝'
	@echo ''
	@echo 'Usage: make [target]'
	@echo ''
	@echo 'Local Development:'
	@grep -E '^(dev|stop|clean|build|test|logs):.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'
	@echo ''
	@echo 'Kubernetes Deployment:'
	@grep -E '^(deploy|convert|status|k8s-logs|k8s-delete):.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'
	@echo ''
	@echo 'Examples:'
	@echo '  make dev              # Start local development'
	@echo '  make deploy           # Deploy to dev environment'
	@echo '  make deploy ENV=prod  # Deploy to production'
	@echo '  make status           # Check deployment status'
	@echo ''

setup: ## Initial setup - copy env file
	@if [ ! -f .env ]; then \
		cp env.example .env; \
		echo "✅ Created .env file"; \
		echo "📝 Please update GCP_PROJECT_ID and other values in .env"; \
	else \
		echo "✅ .env file already exists"; \
	fi
	@echo ""
	@echo "Next steps:"
	@echo "  1. Update .env with your GCP project details"
	@echo "  2. Run 'make dev' to test locally"
	@echo "  3. Run 'make deploy' to deploy to GKE"

# Local Development Targets
dev: ## Start development environment with Docker Compose
	@echo "🚀 Starting local development environment..."
	@docker compose up --build

stop: ## Stop all running containers
	@echo "🛑 Stopping containers..."
	@docker compose down

clean: ## Stop containers and remove volumes (deletes data!)
	@echo "🧹 Cleaning up containers and volumes..."
	@docker compose down -v

build: ## Build Docker image locally
	@echo "🔨 Building Docker image..."
	@docker compose build

test: ## Run tests
	@echo "🧪 Running tests..."
	@docker compose run --rm app npm test

logs: ## View application logs
	@docker compose logs -f app

# Kubernetes Deployment Targets
convert: ## Convert docker-compose.yml to Kubernetes manifests
	@echo "🔄 Converting docker-compose.yml to Kubernetes manifests..."
	@./scripts/compose-to-k8s.sh $(NAMESPACE) $(DOMAIN)

deploy: ## Deploy to GKE (ENV=dev|prod, optional: DOMAIN=example.com)
	@echo "🚀 Deploying to Kubernetes ($(ENV))..."
	@./scripts/deploy-to-gke.sh $(ENV)

status: ## Check deployment status in Kubernetes
	@echo "📊 Checking deployment status in namespace: $(NAMESPACE)"
	@kubectl get all -n $(NAMESPACE) 2>/dev/null || echo "Namespace $(NAMESPACE) not found. Have you deployed yet?"

k8s-logs: ## View application logs in Kubernetes
	@echo "📝 Viewing logs for namespace: $(NAMESPACE)"
	@kubectl logs -f -l app=app -n $(NAMESPACE)

k8s-delete: ## Delete all resources from Kubernetes namespace
	@echo "⚠️  This will delete ALL resources in namespace: $(NAMESPACE)"
	@read -p "Are you sure? (yes/no): " confirm && [ "$$confirm" = "yes" ] && kubectl delete namespace $(NAMESPACE) || echo "Cancelled"

