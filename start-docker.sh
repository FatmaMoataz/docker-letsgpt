#!/bin/bash

# Full Stack ChatGPT - Quick Start Script for Mac/Linux

echo ""
echo "============================================"
echo "Full Stack ChatGPT - Docker Setup"
echo "============================================"
echo ""

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "ERROR: Docker is not installed or not in PATH"
    echo "Please install Docker Desktop from https://www.docker.com/products/docker-desktop"
    exit 1
fi

echo "Docker is installed: "
docker --version

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null; then
    echo "WARNING: Docker Compose might not be properly installed"
    echo "Trying with 'docker compose' command..."
fi

echo ""
echo "Checking environment..."
if [ ! -f ".env" ]; then
    echo ""
    echo "Creating .env file from template..."
    cp .env.docker .env
    echo ""
    echo "IMPORTANT: Edit .env file and add your API keys:"
    echo "  - OPENAI_API_KEY"
    echo "  - IMAGEKIT_PUBLIC_KEY"
    echo "  - IMAGEKIT_PRIVATE_KEY"
    echo "  - IMAGEKIT_URL_ENDPOINT"
    echo "  - STRIPE_API_KEY"
    echo "  - STRIPE_WEBHOOK_SECRET"
    echo "  - SVIX_WEBHOOK_SECRET"
    echo ""
    echo "Opening .env file for editing..."
    
    # Try to open with default editor
    if command -v nano &> /dev/null; then
        nano .env
    elif command -v vi &> /dev/null; then
        vi .env
    else
        echo "Please edit .env manually"
    fi
fi

echo ""
echo "============================================"
echo "Starting Docker containers..."
echo "============================================"
echo ""

# Start containers
docker-compose up --build

echo ""
echo "============================================"
echo "Done!"
echo "============================================"
echo ""
echo "Access your application at:"
echo "  Frontend: http://localhost"
echo "  Backend:  http://localhost:3000"
echo ""
