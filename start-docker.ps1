# PowerShell Quick Start Script for Full Stack ChatGPT

Write-Host ""
Write-Host "============================================"
Write-Host "Full Stack ChatGPT - Docker Setup" -ForegroundColor Cyan
Write-Host "============================================"
Write-Host ""

# Check if Docker is installed
try {
    $dockerVersion = docker --version 2>$null
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ Docker is installed: $dockerVersion" -ForegroundColor Green
    }
}
catch {
    Write-Host "✗ ERROR: Docker is not installed or not in PATH" -ForegroundColor Red
    Write-Host "Please install Docker Desktop from https://www.docker.com/products/docker-desktop"
    Read-Host "Press Enter to exit"
    exit 1
}

# Check if Docker Compose is installed
try {
    $composeVersion = docker-compose --version 2>$null
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ Docker Compose is installed: $composeVersion" -ForegroundColor Green
    }
}
catch {
    Write-Host "⚠ WARNING: Docker Compose might need to be installed" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Checking environment..."

# Create .env if it doesn't exist
if (-not (Test-Path ".env")) {
    Write-Host "Creating .env file from template..." -ForegroundColor Yellow
    Copy-Item ".env.docker" ".env"
    Write-Host ""
    Write-Host "IMPORTANT: Edit .env file and add your API keys:" -ForegroundColor Yellow
    Write-Host "  - OPENAI_API_KEY"
    Write-Host "  - IMAGEKIT_PUBLIC_KEY"
    Write-Host "  - IMAGEKIT_PRIVATE_KEY"
    Write-Host "  - IMAGEKIT_URL_ENDPOINT"
    Write-Host "  - STRIPE_API_KEY"
    Write-Host "  - STRIPE_WEBHOOK_SECRET"
    Write-Host "  - SVIX_WEBHOOK_SECRET"
    Write-Host ""
    Write-Host "Opening .env file for editing..." -ForegroundColor Cyan
    Invoke-Item .env
    
    Write-Host "Press Enter after you've saved the .env file..." -ForegroundColor Yellow
    Read-Host | Out-Null
}

Write-Host ""
Write-Host "============================================"
Write-Host "Starting Docker containers..." -ForegroundColor Cyan
Write-Host "============================================"
Write-Host ""

# Start containers
docker-compose up --build

Write-Host ""
Write-Host "============================================"
Write-Host "Done!" -ForegroundColor Green
Write-Host "============================================"
Write-Host ""
Write-Host "Access your application at:" -ForegroundColor Cyan
Write-Host "  Frontend: http://localhost"
Write-Host "  Backend:  http://localhost:3000"
Write-Host ""
Write-Host "Press Enter to exit..." -ForegroundColor Yellow
Read-Host | Out-Null
