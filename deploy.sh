#!/bin/bash

# Deployment script for Major System Backend
# Run this script on your server to deploy the latest version

set -e

echo "🚀 Deploying Major System Backend..."

# Pull the latest image
echo "📦 Pulling latest Docker image..."
docker pull ghcr.io/theupsider/majorsystem-backend:latest

# Stop existing container if running
echo "🛑 Stopping existing container..."
docker-compose down || true

# Create data directory for database persistence
echo "📁 Creating data directory..."
mkdir -p ./data

# Start the new container
echo "🏃 Starting new container..."
docker-compose up -d

# Wait for container to be healthy
echo "⏳ Waiting for container to be healthy..."
timeout=60
while ! docker exec majorsystem-backend curl -f http://localhost:5000/health >/dev/null 2>&1; do
    sleep 2
    timeout=$((timeout-2))
    if [ $timeout -le 0 ]; then
        echo "❌ Container failed to become healthy within 60 seconds"
        docker-compose logs
        exit 1
    fi
done

echo "✅ Deployment successful!"
echo "🌐 API is now running at http://localhost:5000"
echo "🔍 Check health: curl http://localhost:5000/health"
