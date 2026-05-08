# AWS Deployment Guide for Full Stack ChatGPT

This guide covers deploying your Full Stack ChatGPT application to AWS using various services.

## Architecture Overview

```
┌─────────────────────────────────────────────────────────────┐
│                       AWS Region                             │
├─────────────────────────────────────────────────────────────┤
│  ┌──────────────────────────────────────────────────────┐   │
│  │         Application Load Balancer (ALB)              │   │
│  │  - HTTPS/TLS Termination                            │   │
│  │  - Route to frontend and backend                    │   │
│  └──────────────┬─────────────────────────────────────┘   │
│                 │                                            │
│    ┌────────────┴────────────┐                              │
│    │                         │                              │
│  ┌─▼────────┐         ┌─────▼─────┐                        │
│  │  ECS     │         │   ECS     │                        │
│  │ Frontend │         │ Backend   │                        │
│  │Fargate   │         │ Fargate   │                        │
│  └──────────┘         └─────┬─────┘                        │
│                              │                              │
│                    ┌─────────▼────────┐                    │
│                    │  Amazon RDS      │                    │
│                    │  MongoDB Atlas   │                    │
│                    │  or DocumentDB   │                    │
│                    └──────────────────┘                    │
│                                                              │
│  ┌───────────────────────────────────────────────────────┐ │
│  │        AWS Services Integration                       │ │
│  │ • Amazon S3 (File uploads via ImageKit)              │ │
│  │ • AWS Secrets Manager (API Keys)                    │ │
│  │ • CloudWatch (Logs & Monitoring)                    │ │
│  │ • AWS IAM (Access Control)                          │ │
│  └───────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
```

## Deployment Options

### Option 1: AWS ECS Fargate (Recommended for Beginners)

**Advantages:**
- No servers to manage
- Auto-scaling capabilities
- Pay only for what you use
- Integrated monitoring

**Steps:**

1. **Create AWS Account & Set Up AWS CLI**

```bash
# Install AWS CLI
# Windows: https://awscli.amazonaws.com/AWSCLIV2.msi
# Mac: brew install awscli
# Linux: apt-get install awscli

# Configure credentials
aws configure
# Enter: AWS Access Key ID
# Enter: AWS Secret Access Key
# Enter: Default region (e.g., us-east-1)
```

2. **Create ECR Repositories**

```bash
# Create repository for frontend
aws ecr create-repository \
  --repository-name chatgpt-client \
  --region us-east-1

# Create repository for backend
aws ecr create-repository \
  --repository-name chatgpt-server \
  --region us-east-1

# Get login token and login to ECR
aws ecr get-login-password --region us-east-1 | \
  docker login --username AWS --password-stdin YOUR_ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com
```

3. **Build and Push Docker Images**

```bash
# Set variables
$ACCOUNT_ID = "YOUR_ACCOUNT_ID"
$REGION = "us-east-1"

# Build and push server image
docker build -t chatgpt-server:latest ./server
docker tag chatgpt-server:latest $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/chatgpt-server:latest
docker push $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/chatgpt-server:latest

# Build and push client image
docker build -t chatgpt-client:latest ./client
docker tag chatgpt-client:latest $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/chatgpt-client:latest
docker push $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/chatgpt-client:latest
```

4. **Create ECS Cluster**

```bash
# Create cluster
aws ecs create-cluster \
  --cluster-name chatgpt-cluster \
  --region us-east-1
```

5. **Create Task Definitions**

Create `task-definition-server.json`:

```json
{
  "family": "chatgpt-server",
  "networkMode": "awsvpc",
  "requiresCompatibilities": ["FARGATE"],
  "cpu": "256",
  "memory": "512",
  "containerDefinitions": [
    {
      "name": "chatgpt-server",
      "image": "YOUR_ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com/chatgpt-server:latest",
      "portMappings": [
        {
          "containerPort": 3000,
          "hostPort": 3000,
          "protocol": "tcp"
        }
      ],
      "environment": [
        {
          "name": "NODE_ENV",
          "value": "production"
        },
        {
          "name": "PORT",
          "value": "3000"
        }
      ],
      "secrets": [
        {
          "name": "OPENAI_API_KEY",
          "valueFrom": "arn:aws:secretsmanager:us-east-1:YOUR_ACCOUNT_ID:secret:chatgpt/openai-api-key"
        },
        {
          "name": "MONGODB_URI",
          "valueFrom": "arn:aws:secretsmanager:us-east-1:YOUR_ACCOUNT_ID:secret:chatgpt/mongodb-uri"
        },
        {
          "name": "JWT_SECRET",
          "valueFrom": "arn:aws:secretsmanager:us-east-1:YOUR_ACCOUNT_ID:secret:chatgpt/jwt-secret"
        }
      ],
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "/ecs/chatgpt-server",
          "awslogs-region": "us-east-1",
          "awslogs-stream-prefix": "ecs"
        }
      }
    }
  ],
  "executionRoleArn": "arn:aws:iam::YOUR_ACCOUNT_ID:role/ecsTaskExecutionRole"
}
```

Register the task definition:

```bash
aws ecs register-task-definition \
  --cli-input-json file://task-definition-server.json \
  --region us-east-1
```

6. **Create VPC and Load Balancer**

```bash
# Create Application Load Balancer
aws elbv2 create-load-balancer \
  --name chatgpt-alb \
  --subnets subnet-xxxxx subnet-yyyyy \
  --security-groups sg-xxxxx \
  --scheme internet-facing \
  --type application \
  --region us-east-1
```

7. **Create ECS Service**

```bash
aws ecs create-service \
  --cluster chatgpt-cluster \
  --service-name chatgpt-server-service \
  --task-definition chatgpt-server:1 \
  --desired-count 2 \
  --launch-type FARGATE \
  --network-configuration "awsvpcConfiguration={subnets=[subnet-xxxxx,subnet-yyyyy],securityGroups=[sg-xxxxx],assignPublicIp=ENABLED}" \
  --load-balancers targetGroupArn=arn:aws:elasticloadbalancing:...,containerName=chatgpt-server,containerPort=3000 \
  --region us-east-1
```

### Option 2: AWS Elastic Beanstalk (Easiest)

**Advantages:**
- Simplest deployment option
- Built-in monitoring and logging
- Auto-scaling
- Free tier eligible

**Steps:**

1. **Install EB CLI**

```bash
pip install awsebcli
```

2. **Initialize Elastic Beanstalk**

```bash
# In project root
eb init -p docker chatgpt-app --region us-east-1
```

3. **Create Environment and Deploy**

```bash
# Create environment
eb create chatgpt-production

# Deploy
eb deploy

# Open in browser
eb open
```

4. **Monitor**

```bash
# View logs
eb logs

# View health
eb health

# SSH into instance
eb ssh
```

### Option 3: AWS EC2 (Manual but Full Control)

**Advantages:**
- Full control
- Cost-effective for long-term
- Learning experience

**Steps:**

1. **Launch EC2 Instance**
   - AMI: Amazon Linux 2
   - Instance type: t3.small or t3.medium
   - Security group: Allow ports 80, 443, 3000

2. **Connect and Install Docker**

```bash
# SSH into instance
ssh -i your-key.pem ec2-user@your-instance-ip

# Install Docker
sudo amazon-linux-extras install docker -y
sudo systemctl start docker
sudo usermod -aG docker ec2-user

# Install Docker Compose
sudo curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

3. **Clone Repository and Deploy**

```bash
git clone your-repo-url
cd FullStack_Chatgpt

# Create .env with production values
nano .env

# Start containers
docker-compose up -d
```

4. **Setup Nginx Reverse Proxy** (Optional but Recommended)

```bash
sudo amazon-linux-extras install nginx -y
sudo systemctl start nginx
# Configure nginx to proxy to docker-compose services
```

## Database Setup

### Option 1: MongoDB Atlas (Cloud - Recommended)

```bash
# 1. Create account at https://www.mongodb.com/cloud/atlas
# 2. Create a cluster
# 3. Get connection string
# 4. Update .env:
MONGODB_URI=mongodb+srv://username:password@cluster.mongodb.net/chatgpt?retryWrites=true&w=majority
```

### Option 2: Amazon DocumentDB

```bash
# 1. Create cluster via AWS Console
# 2. Configure security groups
# 3. Get connection string
# 4. Update task definition/docker-compose
```

### Option 3: Keep Docker MongoDB (Development Only)

In docker-compose.yml, MongoDB runs locally. For production, use managed services.

## Secrets Management

Store sensitive data in AWS Secrets Manager:

```bash
# Create secret for OpenAI API key
aws secretsmanager create-secret \
  --name chatgpt/openai-api-key \
  --secret-string "your-api-key" \
  --region us-east-1

# Create secret for MongoDB URI
aws secretsmanager create-secret \
  --name chatgpt/mongodb-uri \
  --secret-string "mongodb+srv://..." \
  --region us-east-1

# Create secret for JWT
aws secretsmanager create-secret \
  --name chatgpt/jwt-secret \
  --secret-string "your-jwt-secret" \
  --region us-east-1
```

## Monitoring with CloudWatch

```bash
# View logs in real-time
aws logs tail /ecs/chatgpt-server --follow --region us-east-1

# View metrics
aws cloudwatch list-metrics \
  --namespace AWS/ECS \
  --region us-east-1
```

## Cost Estimation (Monthly)

| Service | Free Tier | Pay as You Go | Est. Cost |
|---------|-----------|---------------|-----------|
| ECS Fargate | 20 vCPU-hours/month | $0.04840/vCPU-hour | $10-30 |
| Application LB | 750 hours | $0.0225/hour | $10-15 |
| CloudWatch Logs | 5GB free | $0.50/GB | $0-5 |
| Data Transfer | 100GB free | $0.09/GB | $0-5 |
| MongoDB Atlas | Free tier (512MB) | $0.0008/hour | $0-10 |
| **Total Estimate** | | | **$20-60** |

## Troubleshooting

### Service won't start

```bash
# Check logs
aws ecs describe-tasks --cluster chatgpt-cluster \
  --tasks <task-arn> \
  --region us-east-1

# View logs
aws logs get-log-events \
  --log-group-name /ecs/chatgpt-server \
  --log-stream-name <stream-name> \
  --region us-east-1
```

### Health check failures

- Verify security group allows traffic
- Check application is listening on correct port
- Review container logs

### High costs

- Reduce task resources
- Use auto-scaling with lower minimums
- Use free tier services where possible

## CI/CD with GitHub Actions

Create `.github/workflows/deploy.yml`:

```yaml
name: Deploy to AWS

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      
      - name: Build and push Docker images
        env:
          AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
          AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
        run: |
          aws ecr get-login-password --region us-east-1 | \
            docker login --username AWS --password-stdin ${{ secrets.AWS_ACCOUNT_ID }}.dkr.ecr.us-east-1.amazonaws.com
          docker build -t chatgpt-server ./server
          docker tag chatgpt-server:latest ${{ secrets.AWS_ACCOUNT_ID }}.dkr.ecr.us-east-1.amazonaws.com/chatgpt-server:latest
          docker push ${{ secrets.AWS_ACCOUNT_ID }}.dkr.ecr.us-east-1.amazonaws.com/chatgpt-server:latest
      
      - name: Update ECS service
        env:
          AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
          AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
        run: |
          aws ecs update-service --cluster chatgpt-cluster \
            --service chatgpt-server-service \
            --force-new-deployment \
            --region us-east-1
```

## Production Checklist

- [ ] All environment variables configured in AWS Secrets Manager
- [ ] Database backup strategy in place
- [ ] Auto-scaling policies configured
- [ ] CloudWatch alarms set up
- [ ] HTTPS/SSL certificates installed
- [ ] Logging and monitoring enabled
- [ ] Security groups properly configured
- [ ] IAM roles with least privilege
- [ ] Load balancer health checks passing
- [ ] Domain name configured and DNS pointing to ALB

## Next Steps

1. Choose deployment option (Fargate recommended for beginners)
2. Set up AWS account and CLI
3. Push Docker images to ECR
4. Configure secrets in AWS Secrets Manager
5. Deploy using chosen option
6. Test application at public URL
7. Monitor CloudWatch logs

For more information, visit [AWS Documentation](https://docs.aws.amazon.com/)
