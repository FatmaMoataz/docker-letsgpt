# Docker Setup Guide for Full Stack ChatGPT

This guide explains how to run the Full Stack ChatGPT application using Docker and Docker Compose.

## Prerequisites

- **Docker**: [Install Docker Desktop](https://www.docker.com/products/docker-desktop)
- **Docker Compose**: Usually comes with Docker Desktop
- Environment variables with API keys (OpenAI, ImageKit, Stripe, etc.)

## Quick Start

### 1. Setup Environment Variables

Create a `.env` file in the root directory with your API keys:

```bash
OPENAI_API_KEY=your_openai_api_key_here
IMAGEKIT_PUBLIC_KEY=your_imagekit_public_key
IMAGEKIT_PRIVATE_KEY=your_imagekit_private_key
IMAGEKIT_URL_ENDPOINT=your_imagekit_url_endpoint
STRIPE_API_KEY=your_stripe_api_key
STRIPE_WEBHOOK_SECRET=your_stripe_webhook_secret
SVIX_WEBHOOK_SECRET=your_svix_webhook_secret
JWT_SECRET=your_jwt_secret_key_change_this_to_something_secure
```

Or copy from the template:
```bash
copy .env.docker .env
# Then edit .env with your actual values
```

### 2. Build and Run with Docker Compose

```bash
# Build images and start containers
docker-compose up --build

# Run in background (detached mode)
docker-compose up --build -d
```

### 3. Access the Application

- **Frontend**: http://localhost
- **Backend API**: http://localhost:3000
- **MongoDB**: localhost:27017

### Stop the Application

```bash
# Stop all containers
docker-compose down

# Stop and remove all data
docker-compose down -v
```

## Service Details

### Services Running:

1. **MongoDB (mongodb)**: Database service
   - Port: 27017 (internal)
   - Username: admin
   - Password: password123
   - Database: chatgpt

2. **Backend Server (server)**: Express.js API
   - Port: 3000
   - Build: Multi-stage Node.js Alpine image
   - Health check enabled

3. **Frontend Client (client)**: React Vite + Nginx
   - Port: 80
   - Build: Multi-stage Nginx Alpine image
   - Proxies API requests to backend
   - Serves static assets with caching

## Useful Docker Commands

### View Logs

```bash
# All services
docker-compose logs

# Specific service
docker-compose logs server
docker-compose logs client
docker-compose logs mongodb

# Follow logs in real-time
docker-compose logs -f server
```

### Execute Commands Inside Container

```bash
# Access server container shell
docker-compose exec server sh

# Access MongoDB CLI
docker-compose exec mongodb mongosh -u admin -p password123 --authenticationDatabase admin
```

### Rebuild Images

```bash
# Rebuild without using cache
docker-compose up --build --no-cache
```

### Remove Everything

```bash
# Remove containers, networks, volumes
docker-compose down -v

# Remove images too
docker-compose down -v --rmi all
```

## Troubleshooting

### Port Already in Use

If you get "port 80 is already in use" or similar error:

```bash
# Change ports in docker-compose.yml
# For example, map 8080 to 80:
# ports:
#   - "8080:80"
```

### MongoDB Connection Issues

Check if MongoDB is healthy:
```bash
docker-compose logs mongodb
docker-compose ps  # Check status of services
```

### Application Crashes

View logs:
```bash
docker-compose logs server
docker-compose logs client
```

### Clear Everything and Start Fresh

```bash
docker-compose down -v --rmi all
docker-compose up --build
```

## Environment Variables Reference

| Variable | Purpose | Example |
|----------|---------|---------|
| OPENAI_API_KEY | OpenAI API access | sk-... |
| IMAGEKIT_PUBLIC_KEY | ImageKit file upload | public_key_xxx |
| IMAGEKIT_PRIVATE_KEY | ImageKit authentication | private_key_xxx |
| IMAGEKIT_URL_ENDPOINT | ImageKit endpoint | https://ik.imagekit.io/xxx |
| STRIPE_API_KEY | Stripe payment processing | sk_live_... |
| STRIPE_WEBHOOK_SECRET | Stripe webhook validation | whsec_... |
| SVIX_WEBHOOK_SECRET | Svix webhook secret | whsec_... |
| JWT_SECRET | JWT token signing | any_random_secure_string |

## Deployment Considerations

### For AWS Deployment:

1. **Amazon ECR**: Push Docker images to Elastic Container Registry
2. **Amazon ECS**: Deploy using Fargate or EC2
3. **Amazon RDS**: Use for MongoDB instead of container
4. **AWS Secrets Manager**: Store sensitive environment variables
5. **Application Load Balancer**: For load balancing

### Example Dockerfile Build for Registry:

```bash
# Build for ECR
docker build -t chatgpt-server:latest ./server
docker tag chatgpt-server:latest YOUR_ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com/chatgpt-server:latest
docker push YOUR_ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com/chatgpt-server:latest
```

## Performance Optimization

The Docker images are optimized for:
- **Alpine Linux**: Smaller image size (~100MB for Node, ~50MB for Nginx)
- **Multi-stage builds**: Reduces final image size by excluding build dependencies
- **Health checks**: Ensures services are running properly
- **Restart policies**: Automatically restarts failed containers

## Next Steps

1. Update all API keys in `.env`
2. Run `docker-compose up --build`
3. Test the application at http://localhost
4. Monitor logs with `docker-compose logs -f`
5. Deploy to AWS (see Deployment Considerations)

## Support

For issues or questions, check the logs and ensure all environment variables are correctly set.
