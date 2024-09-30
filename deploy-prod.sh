#!/bin/bash

# Set variables
PROJECT_ID="your-google-cloud-project-id"
REGION="your-preferred-region"
IMAGE_NAME="ktor-api"
SERVICE_NAME="ktor-api-prod"

# Build the Docker image
docker build -t gcr.io/$PROJECT_ID/$IMAGE_NAME:prod .

# Push the image to Google Container Registry
docker push gcr.io/$PROJECT_ID/$IMAGE_NAME:prod

# Deploy to Cloud Run
gcloud run deploy $SERVICE_NAME \
  --image gcr.io/$PROJECT_ID/$IMAGE_NAME:prod \
  --platform managed \
  --region $REGION \
  --set-env-vars "CONFIG_FILE=/app/application-prod.conf,ENVIRONMENT=PROD" \
  --set-secrets "DATABASE_URL=projects/$PROJECT_ID/secrets/prod-db-url:latest,DATABASE_USER=projects/$PROJECT_ID/secrets/prod-db-user:latest,DATABASE_PASSWORD=projects/$PROJECT_ID/secrets/prod-db-password:latest,JWT_SECRET=projects/$PROJECT_ID/secrets/prod-jwt-secret:latest" \
  --allow-unauthenticated