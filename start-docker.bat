@echo off
REM Full Stack ChatGPT - Quick Start Script for Windows

echo.
echo ============================================
echo Full Stack ChatGPT - Docker Setup
echo ============================================
echo.

REM Check if Docker is installed
docker --version >nul 2>&1
if errorlevel 1 (
    echo ERROR: Docker is not installed or not in PATH
    echo Please install Docker Desktop from https://www.docker.com/products/docker-desktop
    pause
    exit /b 1
)

echo Docker is installed: 
docker --version

REM Check if Docker Compose is installed
docker-compose --version >nul 2>&1
if errorlevel 1 (
    echo WARNING: Docker Compose might not be properly installed
    echo Trying with 'docker compose' command...
)

echo.
echo Checking environment...
if not exist ".env" (
    echo.
    echo Creating .env file from template...
    copy .env.docker .env
    echo.
    echo IMPORTANT: Edit .env file and add your API keys:
    echo   - OPENAI_API_KEY
    echo   - IMAGEKIT_PUBLIC_KEY
    echo   - IMAGEKIT_PRIVATE_KEY
    echo   - IMAGEKIT_URL_ENDPOINT
    echo   - STRIPE_API_KEY
    echo   - STRIPE_WEBHOOK_SECRET
    echo   - SVIX_WEBHOOK_SECRET
    echo.
    echo Opening .env file for editing...
    notepad .env
)

echo.
echo ============================================
echo Starting Docker containers...
echo ============================================
echo.

REM Start containers
docker-compose up --build

echo.
echo ============================================
echo Done!
echo ============================================
echo.
echo Access your application at:
echo   Frontend: http://localhost
echo   Backend:  http://localhost:3000
echo.
pause
