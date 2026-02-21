#!/usr/bin/env bash
set -euo pipefail

# CAMU Landing Page deployment script
# Deploys to Cloud Run in the letscamu GCP project.
#
# Usage:
#   ./deploy.sh

PROJECT_ID="${GCP_PROJECT_ID:-letscamu}"
REGION="${GCP_REGION:-us-central1}"
SERVICE_NAME="camu-landing"

echo "=== Deploying CAMU Landing Page ==="
echo "Project: $PROJECT_ID"
echo "Region:  $REGION"
echo "Service: $SERVICE_NAME"
echo ""

gcloud run deploy "$SERVICE_NAME" \
  --project "$PROJECT_ID" \
  --region "$REGION" \
  --source . \
  --allow-unauthenticated \
  --port 8080

echo ""
echo "=== Deployed ==="
gcloud run services describe "$SERVICE_NAME" \
  --project "$PROJECT_ID" \
  --region "$REGION" \
  --format "value(status.url)"
