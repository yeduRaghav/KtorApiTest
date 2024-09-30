#!/bin/bash

# Check if required environment variables are set
if [ -z "$PROJECT_ID" ] || [ -z "$REGION" ] || [ -z "$IMAGE_NAME" ] || [ -z "$SERVICE_NAME" ] || [ -z "$ENVIRONMENT" ]; then
    echo "Error: Missing required environment variables."
    echo "Please set PROJECT_ID, REGION, IMAGE_NAME, SERVICE_NAME, and ENVIRONMENT."
    exit 1
fi

# Use environment variables, with defaults for non-sensitive information
PROJECT_ID=${PROJECT_ID}
REGION=${REGION}
IMAGE_NAME=${IMAGE_NAME:-"ktor-api"}
SERVICE_NAME=${SERVICE_NAME}
ENVIRONMENT=${ENVIRONMENT}

# Build the Docker image
docker build -t gcr.io/"$PROJECT_ID"/"$IMAGE_NAME":"$ENVIRONMENT" .

# Push the image to Google Container Registry
docker push gcr.io/"$PROJECT_ID"/"$IMAGE_NAME":"$ENVIRONMENT"

# Deploy to Cloud Run
gcloud run deploy "$SERVICE_NAME" \
  --image gcr.io/"$PROJECT_ID"/"$IMAGE_NAME":"$ENVIRONMENT" \
  --platform managed \
  --region "$REGION" \
  --set-env-vars "CONFIG_FILE=/app/application-$ENVIRONMENT.conf,ENVIRONMENT=$ENVIRONMENT" \
  --set-secrets "DATABASE_URL=projects/$PROJECT_ID/secrets/$ENVIRONMENT-db-url:latest,DATABASE_USER=projects/$PROJECT_ID/secrets/$ENVIRONMENT-db-user:latest,DATABASE_PASSWORD=projects/$PROJECT_ID/secrets/$ENVIRONMENT-db-password:latest,JWT_SECRET=projects/$PROJECT_ID/secrets/$ENVIRONMENT-jwt-secret:latest" \
  --allow-unauthenticated