#!/bin/bash

# Set variables
PROJECT_ID="your-google-cloud-project-id"
REGION="your-preferred-region"
IMAGE_NAME="ktor-api"
SERVICE_NAME="ktor-api-qa"

# Build the Docker image
docker build -t gcr.io/$PROJECT_ID/$IMAGE_NAME:qa .

# Push the image to Google Container Registry
docker push gcr.io/$PROJECT_ID/$IMAGE_NAME:qa

# Deploy to Cloud Run
gcloud run deploy $SERVICE_NAME \
  --image gcr.io/$PROJECT_ID/$IMAGE_NAME:qa \
  --platform managed \
  --region $REGION \
  --set-env-vars "CONFIG_FILE=/app/application-qa.conf,ENVIRONMENT=QA" \
  --set-secrets "DATABASE_URL=projects/$PROJECT_ID/secrets/qa-db-url:latest,DATABASE_USER=projects/$PROJECT_ID/secrets/qa-db-user:latest,DATABASE_PASSWORD=projects/$PROJECT_ID/secrets/qa-db-password:latest,JWT_SECRET=projects/$PROJECT_ID/secrets/qa-jwt-secret:latest" \
  --allow-unauthenticated