Docker deploy command :

docker build -t my-ktor-app .

docker run -p 8080:8080 -e PORT=8080 -e JWT_AUDIENCE=your_audience -e JWT_REALM=your_realm -e JWT_SECRET=your_secret -e JWT_ISSUER=your_issuer my-ktor-app