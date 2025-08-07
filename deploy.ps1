# PowerShell Deployment script for Major System Backend
# Usage: .\deploy.ps1 [environment]
# Environment: dev, prod, or ghcr (default: dev)

param(
    [string]$Environment = "dev"
)

Write-Host "🚀 Deploying Major System Backend..." -ForegroundColor Cyan
Write-Host "Environment: $Environment" -ForegroundColor Yellow

# Stop any running instances to avoid conflicts
docker-compose -f docker-compose.dev.yml down --remove-orphans 2>$null
docker-compose -f docker-compose.yml down --remove-orphans 2>$null
docker-compose -f docker-compose.prod.yml down --remove-orphans 2>$null

switch ($Environment.ToLower()) {
    "dev" {
        Write-Host "Building for development..." -ForegroundColor Green
        docker-compose -f docker-compose.dev.yml up --build -d
        if ($LASTEXITCODE -eq 0) {
            Write-Host "Development deployment complete!" -ForegroundColor Green
            Write-Host "Access at: http://localhost:5001" -ForegroundColor Blue
        }
    }
    "prod" {
        Write-Host "Building for production (local build)..." -ForegroundColor Green
        docker-compose -f docker-compose.yml up --build -d
        if ($LASTEXITCODE -eq 0) {
            Write-Host "Production deployment complete!" -ForegroundColor Green
            Write-Host "Access at: http://localhost:5000" -ForegroundColor Blue
        }
    }
    "ghcr" {
        Write-Host "Deploying from GitHub Container Registry..." -ForegroundColor Green
        docker pull ghcr.io/theupsider/majorsystem-backend:latest
        if ($LASTEXITCODE -eq 0) {
            docker-compose -f docker-compose.prod.yml up -d
            if ($LASTEXITCODE -eq 0) {
                Write-Host "GitHub Container Registry deployment complete!" -ForegroundColor Green
                Write-Host "Access at: http://localhost:5000" -ForegroundColor Blue
            }
        } else {
            Write-Host "Failed to pull image from GHCR. Make sure you are logged in." -ForegroundColor Red
        }
    }
    default {
        Write-Host "Invalid environment. Use 'dev', 'prod', or 'ghcr'" -ForegroundColor Red
        exit 1
    }
}

if ($LASTEXITCODE -ne 0) {
    Write-Host "Deployment failed!" -ForegroundColor Red
    exit 1
}

Write-Host ""
docker ps --filter 'name=majorsystem-backend'