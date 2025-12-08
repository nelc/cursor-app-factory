#!/bin/bash
#
# Setup GCP Secret for New App
#
# This script adds the GCP_SA_KEY secret to a new app repository.
# 
# IMPORTANT: Organization secrets don't work on GitHub Free plan,
# so we must add the secret to each repository individually.
#
# Usage:
#   ./scripts/setup-app-secret.sh REPO_NAME
#
# Example:
#   ./scripts/setup-app-secret.sh my-task-app
#

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
ORG="nelc"
KEY_FILE="$(dirname "$0")/../github-actions-key.json"

# Check arguments
if [ $# -eq 0 ]; then
    echo -e "${RED}Error: Repository name required${NC}"
    echo ""
    echo "Usage: $0 REPO_NAME"
    echo ""
    echo "Example:"
    echo "  $0 my-task-app"
    echo ""
    exit 1
fi

REPO_NAME="$1"
FULL_REPO="$ORG/$REPO_NAME"

echo "╔══════════════════════════════════════════════════════════════╗"
echo "║         Setup GCP Secret for New App                         ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""

# Check if key file exists
if [ ! -f "$KEY_FILE" ]; then
    echo -e "${RED}Error: Key file not found: $KEY_FILE${NC}"
    echo ""
    echo "Please ensure github-actions-key.json exists in the repository root."
    exit 1
fi

# Check if repo exists
echo "Checking if repository exists..."
if ! gh repo view "$FULL_REPO" &>/dev/null; then
    echo -e "${RED}Error: Repository '$FULL_REPO' not found${NC}"
    echo ""
    echo "Make sure the business user has created the repository first."
    exit 1
fi

echo -e "${GREEN}✓${NC} Repository found: $FULL_REPO"
echo ""

# Add the secret
echo "Adding GCP_SA_KEY secret to repository..."
if cat "$KEY_FILE" | gh secret set GCP_SA_KEY --repo "$FULL_REPO"; then
    echo -e "${GREEN}✓${NC} Secret added successfully!"
    echo ""
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""
    echo -e "${GREEN}SUCCESS!${NC} The app is ready to deploy."
    echo ""
    echo "Next steps:"
    echo "  1. Tell the business user their app is configured"
    echo "  2. They can now push code and it will auto-deploy"
    echo "  3. Watch deployment: https://github.com/$FULL_REPO/actions"
    echo ""
else
    echo -e "${RED}✗${NC} Failed to add secret"
    echo ""
    echo "Make sure you have admin access to the repository."
    exit 1
fi

