# Full Stack ChatGPT - AI-Powered Chat Application

A modern, cloud-ready full-stack application that integrates OpenAI's GPT models with a scalable backend and responsive frontend. Designed for AWS deployment with containerization, authentication, credit management, and comprehensive monitoring.

![React](https://img.shields.io/badge/React-19.2-blue?logo=react)
![Node.js](https://img.shields.io/badge/Node.js-18-green?logo=node.js)
![MongoDB](https://img.shields.io/badge/MongoDB-9.1-green?logo=mongodb)
![Docker](https://img.shields.io/badge/Docker-ready-blue?logo=docker)
![AWS](https://img.shields.io/badge/AWS-ECS%20%2F%20Fargate-orange?logo=amazon-aws)
![License](https://img.shields.io/badge/License-ISC-blue)

## 📋 Features

- ✅ **AI Chat Interface** - Real-time conversations with OpenAI's GPT models
- ✅ **User Authentication** - Secure JWT-based login/registration
- ✅ **Credit System** - Usage tracking with Stripe payment integration
- ✅ **Message History** - Persistent storage of all conversations
- ✅ **File Upload** - Image uploads via ImageKit CDN
- ✅ **Responsive Design** - Modern UI with Tailwind CSS
- ✅ **Docker Ready** - Fully containerized for local and cloud deployment
- ✅ **Cloud Native** - Designed for AWS ECS/Fargate deployment
- ✅ **Scalable** - Multi-container orchestration with load balancing
- ✅ **Monitored** - Integrated CloudWatch logging and health checks

## 🚀 Quick Start (Local Development)

### Prerequisites
- **Docker**: [Install Docker Desktop](https://www.docker.com/products/docker-desktop)
- **API Keys**: OpenAI, ImageKit, Stripe (see `.env.docker`)

### Option 1: Using Quick Start Script (Recommended)

**Windows:**
```bash
.\start-docker.ps1
```

**Mac/Linux:**
```bash
chmod +x start-docker.sh
./start-docker.sh
```

**Batch Script (Windows CMD):**
```bash
start-docker.bat
```

### Option 2: Manual Setup

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd FullStack_Chatgpt
   ```

2. **Create environment file**
   ```bash
   copy .env.docker .env
   ```

3. **Edit `.env` with your API keys**
   ```
   OPENAI_API_KEY=sk-...
   IMAGEKIT_PUBLIC_KEY=...
   IMAGEKIT_PRIVATE_KEY=...
   IMAGEKIT_URL_ENDPOINT=...
   STRIPE_API_KEY=sk_live_...
   STRIPE_WEBHOOK_SECRET=whsec_...
   SVIX_WEBHOOK_SECRET=whsec_...
   JWT_SECRET=your_secret_key
   ```

4. **Start with Docker Compose**
   ```bash
   docker-compose up --build
   ```

5. **Access the application**
   - **Frontend**: http://localhost
   - **Backend API**: http://localhost:3000
   - **MongoDB**: localhost:27017

### Stopping the Application

```bash
# Stop all services
docker-compose down

# Stop and remove all data (volumes)
docker-compose down -v

# View logs
docker-compose logs -f service-name  # server, client, mongodb
```

## 📁 Project Structure

```
FullStack_Chatgpt/
├── client/                  # React Frontend (Vite)
│   ├── src/
│   │   ├── components/     # React components
│   │   ├── pages/          # Page components
│   │   ├── context/        # React Context
│   │   └── assets/         # Static assets
│   ├── Dockerfile
│   ├── nginx.conf          # Reverse proxy config
│   └── package.json
│
├── server/                  # Express Backend
│   ├── configs/            # Configuration (DB, OpenAI, ImageKit)
│   ├── controllers/        # Route handlers
│   ├── middlewares/        # Auth, logging, etc.
│   ├── models/             # Mongoose schemas
│   ├── routes/             # API routes
│   ├── Dockerfile
│   └── server.js           # Entry point
│
├── docker-compose.yml      # Multi-container orchestration
├── .env.docker             # Environment template
├── DOCKER_README.md        # Docker guide
├── AWS_DEPLOYMENT.md       # AWS deployment guide
└── PROJECT_DOCUMENTATION.md # Detailed documentation
```

## 🏗️ Architecture

### Local Development
Containerized services running locally:
- **Frontend** (Nginx) - Port 80
- **Backend** (Node.js) - Port 3000
- **Database** (MongoDB) - Port 27017

### AWS Production
Scalable cloud deployment:
- **Application Load Balancer** - Traffic distribution
- **ECS Fargate** - Frontend & Backend services
- **MongoDB Atlas / RDS** - Managed database
- **CloudWatch** - Logging & monitoring
- **Secrets Manager** - API key management

## 📚 Documentation

| Document | Purpose |
|----------|---------|
| [DOCKER_README.md](./DOCKER_README.md) | Local Docker setup and commands |
| [AWS_DEPLOYMENT.md](./AWS_DEPLOYMENT.md) | AWS deployment guide (ECS, EC2, Beanstalk) |
| [PROJECT_DOCUMENTATION.md](./PROJECT_DOCUMENTATION.md) | Complete project documentation & architecture |

## 🔧 Available Commands

### Docker Commands

```bash
# Build and start services
docker-compose up --build

# Run in background
docker-compose up --build -d

# View logs
docker-compose logs -f

# Logs for specific service
docker-compose logs -f server
docker-compose logs -f client
docker-compose logs -f mongodb

# Stop services
docker-compose down

# Stop and remove volumes
docker-compose down -v

# Execute command in container
docker-compose exec server npm list
docker-compose exec mongodb mongosh -u admin -p password123
```

### Service Status

```bash
# View all running containers and their status
docker-compose ps

# View detailed service information
docker-compose ps --all
```

## 🌐 API Endpoints

### User Routes
- `POST /api/user/register` - Register new user
- `POST /api/user/login` - User login
- `GET /api/user/profile` - Get profile
- `PUT /api/user/profile` - Update profile

### Chat Routes
- `GET /api/chat` - List all chats
- `POST /api/chat` - Create new chat
- `GET /api/chat/:id` - Get chat
- `DELETE /api/chat/:id` - Delete chat

### Message Routes
- `GET /api/message/:chatId` - Get messages
- `POST /api/message` - Send message
- `DELETE /api/message/:id` - Delete message

### Credit Routes
- `GET /api/credit` - Get user credits
- `POST /api/credit/purchase` - Purchase credits

For complete API documentation, see [PROJECT_DOCUMENTATION.md](./PROJECT_DOCUMENTATION.md)

## 🔑 Environment Variables

Create a `.env` file with these required variables:

```env
# OpenAI API
OPENAI_API_KEY=your_openai_api_key

# ImageKit (File Uploads)
IMAGEKIT_PUBLIC_KEY=your_imagekit_public_key
IMAGEKIT_PRIVATE_KEY=your_imagekit_private_key
IMAGEKIT_URL_ENDPOINT=your_imagekit_url_endpoint

# Stripe (Payments)
STRIPE_API_KEY=your_stripe_api_key
STRIPE_WEBHOOK_SECRET=your_stripe_webhook_secret

# Svix (Webhooks)
SVIX_WEBHOOK_SECRET=your_svix_webhook_secret

# JWT
JWT_SECRET=your_jwt_secret_key

# Optional: Database (MongoDB Atlas)
MONGODB_URI=mongodb+srv://username:password@cluster.mongodb.net/chatgpt
```

## 📊 Technology Stack

### Frontend
- React 19 - UI framework
- Vite - Build tool
- Tailwind CSS - Styling
- React Router - Routing
- Axios - HTTP client
- React Markdown - Markdown support
- Prism.js - Code highlighting

### Backend
- Node.js 18 - Runtime
- Express.js - Web framework
- MongoDB - Database
- Mongoose - MongoDB ORM
- OpenAI SDK - GPT integration
- Stripe SDK - Payment processing
- JWT - Authentication
- bcryptjs - Password hashing

### DevOps
- Docker - Containerization
- Docker Compose - Orchestration
- Nginx - Reverse proxy
- AWS ECS - Container service
- AWS Fargate - Serverless compute
- CloudWatch - Monitoring

## 🚀 Deployment to AWS

### Quick Deployment (ECS Fargate)

1. **Setup AWS CLI**
   ```bash
   aws configure
   ```

2. **Create ECR repositories**
   ```bash
   aws ecr create-repository --repository-name chatgpt-server
   aws ecr create-repository --repository-name chatgpt-client
   ```

3. **Build and push images**
   ```bash
   # Push to ECR (see AWS_DEPLOYMENT.md for detailed steps)
   ```

4. **Deploy to ECS**
   ```bash
   # Create cluster and deploy (see AWS_DEPLOYMENT.md)
   ```

For detailed AWS deployment steps, see [AWS_DEPLOYMENT.md](./AWS_DEPLOYMENT.md)

## 📈 Scalability

The application is designed for scalability:
- **Horizontal Scaling**: Add more container instances
- **Auto-Scaling**: ECS scales based on CPU/memory
- **Load Balancing**: ALB distributes traffic
- **Caching**: Static assets cached with 1-year expiry
- **Database Scaling**: MongoDB Atlas auto-scaling
- **CDN**: CloudFront for global distribution

## 🔐 Security Features

- ✅ JWT-based authentication
- ✅ Password hashing with bcryptjs
- ✅ CORS protection
- ✅ Environment variables in Secrets Manager
- ✅ HTTPS/TLS support
- ✅ Input validation and sanitization
- ✅ Secure HTTP headers
- ✅ Rate limiting (implement in future)

## ⚠️ Troubleshooting

### Port Already in Use

```bash
# Change ports in docker-compose.yml
# Example: map 8080 to 80
# ports:
#   - "8080:80"
```

### Container Won't Start

```bash
# Check logs
docker-compose logs service-name

# Rebuild without cache
docker-compose up --build --no-cache
```

### Database Connection Issues

```bash
# Check MongoDB is running and healthy
docker-compose ps

# View MongoDB logs
docker-compose logs mongodb

# Connect directly to MongoDB
docker-compose exec mongodb mongosh -u admin -p password123
```

### API Not Responding

```bash
# Check backend logs
docker-compose logs server

# Test API endpoint
curl http://localhost:3000/

# Verify environment variables
docker-compose exec server env | grep OPENAI
```

### Frontend Not Loading

```bash
# Check frontend logs
docker-compose logs client

# Verify nginx config
docker-compose exec client nginx -t
```

## 📝 Project Report Template

For your Cloud Development Final Project, include:

1. **Project Overview**
   - Problem statement
   - Solution description
   - Key features

2. **Technical Architecture**
   - System design
   - Components and services
   - Data flow

3. **Cloud Services Used**
   - AWS services (ECS, RDS, etc.)
   - Integration details
   - Scaling strategy

4. **Implementation**
   - Tech stack
   - Code structure
   - API documentation

5. **Deployment**
   - Local (Docker)
   - AWS (ECS/Fargate)
   - Monitoring & logging

6. **Results & Testing**
   - Performance metrics
   - Test results
   - Deployment verification

7. **Lessons Learned**
   - Challenges faced
   - Solutions implemented
   - Future improvements

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Create a feature branch
2. Make your changes
3. Test locally with Docker
4. Submit a pull request

## 📄 License

ISC

## 👥 Team Members

| Name | Role | Contribution |
|------|------|--------------|
| | Frontend | |
| | Backend | |
| | DevOps | |
| | Testing | |
| | Documentation | |

## 📞 Support

For issues, questions, or suggestions:
1. Check the documentation files
2. Review logs with `docker-compose logs`
3. Verify environment variables in `.env`
4. Check AWS CloudWatch for deployment issues

## 🎯 Next Steps

1. ✅ Setup local development environment
2. ✅ Configure API keys in `.env`
3. ✅ Run `docker-compose up --build`
4. ✅ Test the application
5. ✅ Deploy to AWS (see AWS_DEPLOYMENT.md)
6. ✅ Monitor with CloudWatch
7. ✅ Submit project report

## 📚 Additional Resources

- [Docker Documentation](https://docs.docker.com/)
- [AWS ECS Documentation](https://docs.aws.amazon.com/ecs/)
- [Express.js Guide](https://expressjs.com/)
- [React Documentation](https://react.dev/)
- [MongoDB Documentation](https://docs.mongodb.com/)
- [Nginx Documentation](https://nginx.org/)

---

**Status**: Production Ready ✅

**Last Updated**: 2024

**Docker Compose Version**: 3.9

**Compatibility**: Windows, macOS, Linux
