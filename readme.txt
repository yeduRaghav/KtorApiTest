How to Deploy to cloud :
========================
1. Set the required environment variables before running the script in local machine.

Eg :
export PROJECT_ID="your-google-cloud-project-id"
export REGION="your-preferred-region"
export IMAGE_NAME="ktor-api"
export SERVICE_NAME="ktor-api-qa"
export ENVIRONMENT="qa"

2. Run the script.
./deploy.sh



Local Docker deploy command :
=============================
./gradlew clean build
docker build -t my-ktor-app .

docker run -p 8080:8080 \
  -e PORT=8080 \
  -e JWT_AUDIENCE=your_audience \
  -e JWT_REALM=your_realm \
  -e JWT_SECRET=your_secret \
  -e JWT_ISSUER=your_issuer \
  my-ktor-app