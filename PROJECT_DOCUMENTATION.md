# Full Stack ChatGPT - Project Documentation

## Project Overview

**Full Stack ChatGPT** is a cloud-based AI-powered chat application that demonstrates core cloud concepts including scalability, availability, and service integration. It allows users to interact with OpenAI's GPT API through a modern web interface, manage credits/subscriptions, and store conversation history.

### Key Features

- **AI Chat Interface**: Real-time conversations with OpenAI's GPT models
- **User Authentication**: Secure login/registration with JWT tokens
- **Credit System**: Usage tracking with Stripe payment integration
- **Message History**: Persistent storage of conversations
- **File Upload**: Image uploads via ImageKit CDN
- **Responsive Design**: Tailwind CSS for modern UI
- **Cloud-Ready**: Containerized and deployable on AWS

## Technology Stack

### Frontend
- **React 19** - UI framework
- **Vite** - Build tool and dev server
- **Tailwind CSS** - Utility-first CSS framework
- **React Router** - Client-side routing
- **Axios** - HTTP client
- **React Markdown** - Markdown rendering
- **Prism.js** - Code syntax highlighting
- **React Hot Toast** - Toast notifications

### Backend
- **Node.js 18** - Runtime environment
- **Express.js** - REST API framework
- **MongoDB** - NoSQL database
- **Mongoose** - MongoDB ORM
- **OpenAI SDK** - GPT API integration
- **JWT** - Authentication tokens
- **bcryptjs** - Password hashing
- **Stripe SDK** - Payment processing
- **ImageKit SDK** - Image CDN and optimization
- **Svix** - Webhook management

### DevOps & Cloud
- **Docker** - Containerization
- **Docker Compose** - Multi-container orchestration
- **Nginx** - Reverse proxy & static file serving
- **AWS ECS/Fargate** - Container orchestration
- **AWS ALB** - Load balancing
- **AWS ECR** - Container registry
- **AWS Secrets Manager** - Secrets management
- **Amazon RDS/DocumentDB** - Managed database
- **Amazon S3** - File storage (optional)
- **CloudWatch** - Logging and monitoring

## Project Structure

```
FullStack_Chatgpt/
├── client/                          # React frontend
│   ├── src/
│   │   ├── components/             # React components
│   │   │   ├── Chatbox.jsx        # Main chat interface
│   │   │   ├── Message.jsx        # Message display
│   │   │   └── Sidebar.jsx        # Navigation sidebar
│   │   ├── pages/                 # Page components
│   │   ├── context/               # React Context for state
│   │   ├── assets/                # Static assets
│   │   └── App.jsx                # Main app component
│   ├── Dockerfile                 # Frontend container image
│   ├── nginx.conf                 # Nginx reverse proxy config
│   ├── package.json               # Node dependencies
│   └── vite.config.js             # Vite build config
│
├── server/                         # Express backend
│   ├── configs/                    # Configuration files
│   │   ├── db.js                  # MongoDB connection
│   │   ├── openai.js              # OpenAI setup
│   │   └── imageKit.js            # ImageKit setup
│   ├── controllers/                # Route handlers
│   │   ├── userController.js      # User operations
│   │   ├── chatController.js      # Chat operations
│   │   ├── messageController.js   # Message operations
│   │   ├── creditController.js    # Credit/billing
│   │   └── webhooks.js            # Webhook handlers
│   ├── middlewares/                # Express middlewares
│   │   └── auth.js                # JWT authentication
│   ├── models/                     # Mongoose schemas
│   │   ├── User.js                # User model
│   │   ├── Chat.js                # Chat session model
│   │   ├── Message.js             # Message model
│   │   └── Transaction.js         # Transaction model
│   ├── routes/                     # API routes
│   │   ├── userRoutes.js          # User endpoints
│   │   ├── chatRoutes.js          # Chat endpoints
│   │   ├── messageRoutes.js       # Message endpoints
│   │   └── creditRoutes.js        # Credit endpoints
│   ├── Dockerfile                 # Backend container image
│   ├── server.js                  # Express app entry
│   ├── package.json               # Node dependencies
│   └── .env                       # Environment variables
│
├── docker-compose.yml             # Multi-container orchestration
├── .env.docker                    # Docker environment template
├── .dockerignore                  # Docker ignore rules
├── DOCKER_README.md               # Docker setup guide
├── AWS_DEPLOYMENT.md              # AWS deployment guide
└── README.md                       # Main project documentation
```

## Cloud Architecture

### Local Development
```
┌──────────────────────────────────────┐
│      docker-compose Services         │
├──────────────────────────────────────┤
│ ┌────────────────────────────────┐   │
│ │ Frontend (Nginx on port 80)    │   │
│ └────────────────┬───────────────┘   │
│                  │ API calls         │
│ ┌────────────────▼───────────────┐   │
│ │ Backend (Node.js on port 3000)│   │
│ └────────────────┬───────────────┘   │
│                  │ DB queries        │
│ ┌────────────────▼───────────────┐   │
│ │ MongoDB (port 27017)           │   │
│ └────────────────────────────────┘   │
└──────────────────────────────────────┘
```

### AWS Production
```
┌─────────────────────────────────────────────┐
│           AWS Region (us-east-1)            │
├─────────────────────────────────────────────┤
│  ┌──────────────────────────────────────┐   │
│  │   Application Load Balancer (ALB)    │   │
│  │   + Route 53 DNS + HTTPS/TLS         │   │
│  └──────────┬────────────────┬──────────┘   │
│             │                │               │
│    ┌────────▼──┐      ┌──────▼────┐        │
│    │ECS Fargate│      │ECS Fargate│        │
│    │Frontend   │      │Backend    │        │
│    │Service    │      │Service    │        │
│    └───────────┘      └─────┬─────┘        │
│                             │               │
│                    ┌────────▼───────┐      │
│                    │ Amazon RDS/    │      │
│                    │ MongoDB Atlas  │      │
│                    └────────────────┘      │
│                                            │
│  ┌────────────────────────────────────┐   │
│  │  AWS Services Integration:         │   │
│  │  • Secrets Manager (API Keys)      │   │
│  │  • CloudWatch (Logs/Monitoring)    │   │
│  │  • S3 (File Storage)               │   │
│  │  • IAM (Access Control)            │   │
│  └────────────────────────────────────┘   │
└─────────────────────────────────────────────┘
```

## AWS Services Used

### Compute
- **AWS ECS (Elastic Container Service)**: Runs containerized frontend and backend
- **AWS Fargate**: Serverless container execution (no server management)
- **Application Load Balancer**: Distributes traffic across services

### Storage & Database
- **Amazon RDS** or **MongoDB Atlas**: Managed database (MongoDB)
- **Amazon S3** (Optional): File uploads and storage
- **CloudWatch Logs**: Application logging and debugging

### Security & Secrets
- **AWS Secrets Manager**: Store API keys and sensitive data
- **AWS IAM**: Role-based access control
- **AWS Security Groups**: Network access control

### Optional Services
- **Amazon CloudFront**: CDN for faster content delivery
- **AWS Lambda**: Serverless processing for webhooks
- **Amazon SNS/SQS**: Message queues for async operations
- **Amazon CloudWatch**: Monitoring and alerting

## API Endpoints

### User Routes
- `POST /api/user/register` - Register new user
- `POST /api/user/login` - User login
- `GET /api/user/profile` - Get user profile
- `PUT /api/user/profile` - Update user profile
- `GET /api/user/me` - Get current user info

### Chat Routes
- `GET /api/chat` - List user's chats
- `POST /api/chat` - Create new chat
- `GET /api/chat/:id` - Get chat details
- `DELETE /api/chat/:id` - Delete chat
- `PUT /api/chat/:id` - Update chat title

### Message Routes
- `GET /api/message/:chatId` - Get messages in chat
- `POST /api/message` - Send new message
- `DELETE /api/message/:id` - Delete message
- `PUT /api/message/:id` - Edit message

### Credit Routes
- `GET /api/credit` - Get user credits
- `POST /api/credit/purchase` - Purchase credits (Stripe)
- `GET /api/credit/plans` - Get available plans
- `POST /api/stripe/webhook` - Handle Stripe webhooks

## Database Models

### User Schema
```javascript
{
  username: String,
  email: String (unique),
  password: String (hashed),
  avatar: String (image URL),
  credits: Number,
  totalSpent: Number,
  createdAt: Date,
  updatedAt: Date
}
```

### Chat Schema
```javascript
{
  userId: ObjectId (ref: User),
  title: String,
  topic: String,
  createdAt: Date,
  updatedAt: Date
}
```

### Message Schema
```javascript
{
  chatId: ObjectId (ref: Chat),
  userId: ObjectId (ref: User),
  role: String (user/assistant),
  content: String,
  tokensUsed: Number,
  createdAt: Date
}
```

### Transaction Schema
```javascript
{
  userId: ObjectId (ref: User),
  amount: Number,
  credits: Number,
  type: String (purchase/refund),
  status: String (pending/completed/failed),
  stripeTransactionId: String,
  createdAt: Date
}
```

## Deployment Steps

### Prerequisites
- Docker & Docker Compose installed
- AWS Account with appropriate permissions
- API keys for: OpenAI, ImageKit, Stripe, Svix

### Local Development

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd FullStack_Chatgpt
   ```

2. **Create environment file**
   ```bash
   copy .env.docker .env
   # Edit .env with your API keys
   ```

3. **Start with Docker Compose**
   ```bash
   docker-compose up --build
   ```

4. **Access application**
   - Frontend: http://localhost
   - Backend: http://localhost:3000

### AWS Deployment (ECS Fargate - Recommended)

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
   # Login to ECR
   aws ecr get-login-password | docker login --username AWS --password-stdin <account-id>.dkr.ecr.us-east-1.amazonaws.com
   
   # Build and push
   docker build -t chatgpt-server ./server
   docker tag chatgpt-server:latest <account-id>.dkr.ecr.us-east-1.amazonaws.com/chatgpt-server:latest
   docker push <account-id>.dkr.ecr.us-east-1.amazonaws.com/chatgpt-server:latest
   ```

4. **Create ECS Cluster**
   ```bash
   aws ecs create-cluster --cluster-name chatgpt-cluster
   ```

5. **Register task definitions and create services**
   - See AWS_DEPLOYMENT.md for detailed steps

6. **Configure DNS and SSL**
   - Use Route 53 for domain management
   - Use AWS Certificate Manager for HTTPS

## Scalability Features

1. **Containerization**: Easy to scale horizontally with multiple container instances
2. **Load Balancing**: ALB distributes requests across services
3. **Auto-Scaling**: ECS can automatically scale based on CPU/memory metrics
4. **Database Scaling**: MongoDB Atlas provides automatic scaling
5. **CDN**: CloudFront for static asset caching and distribution
6. **Stateless Design**: Services don't rely on local storage

## High Availability

1. **Multi-AZ Deployment**: Services spread across availability zones
2. **Health Checks**: ECS monitors container health and restarts failed services
3. **Load Balancer**: ALB provides fault tolerance
4. **Managed Database**: RDS/MongoDB Atlas with automatic backups
5. **Read Replicas**: Database read replicas for redundancy
6. **Auto-Scaling**: Maintains desired service count

## Security Best Practices

1. **API Keys in Secrets Manager**: Never hardcoded in images
2. **HTTPS/TLS**: All communication encrypted
3. **JWT Tokens**: Secure authentication
4. **Password Hashing**: bcryptjs for secure password storage
5. **CORS Configuration**: Restricted origins
6. **Rate Limiting**: Prevent abuse (implement in future)
7. **Input Validation**: Sanitize all user inputs
8. **Security Groups**: Restrict network access

## Monitoring & Logging

1. **CloudWatch Logs**: Automatic log collection
2. **Application Logging**: Built-in via Node.js
3. **Health Checks**: ECS monitors service health
4. **CloudWatch Metrics**: Track performance metrics
5. **Alarms**: Auto-notification for failures

## Performance Optimization

1. **Image Compression**: Nginx gzip compression
2. **Caching**: Static assets cached with 1-year expiry
3. **Code Splitting**: React code splitting with Vite
4. **Database Indexing**: MongoDB indexes on frequently queried fields
5. **Connection Pooling**: Mongoose connection management
6. **CDN**: CloudFront for global content distribution

## Error Handling & Validation

1. **Input Validation**: Server-side validation for all requests
2. **Error Responses**: Standardized error response format
3. **Logging**: Error logging to CloudWatch
4. **Graceful Degradation**: User-friendly error messages
5. **Retry Logic**: Automatic retries for failed operations
6. **Transaction Rollback**: Database transaction management

## CI/CD Pipeline (Optional)

Implement GitHub Actions for automated deployment:

```yaml
# .github/workflows/deploy.yml
- Build and test code
- Build Docker images
- Push to ECR
- Update ECS service
- Notify team of deployment
```

## Testing

### Frontend Testing
- Unit tests with Vitest
- Component testing with React Testing Library
- E2E tests with Cypress

### Backend Testing
- Unit tests with Jest
- API endpoint testing with Supertest
- Database tests with test database

### Integration Testing
- Full stack testing with Docker Compose
- API testing with Postman

## Cost Optimization

- Use Fargate Spot instances for cost savings
- Reserved instances for predictable workloads
- S3 lifecycle policies for old data
- CloudFront caching to reduce data transfer
- Database auto-scaling to match demand

## Future Enhancements

1. **WebSocket Support**: Real-time chat updates
2. **Voice Input/Output**: Audio transcription and synthesis
3. **Multi-model Support**: Support for different AI models
4. **Advanced Analytics**: Usage analytics dashboard
5. **Team Collaboration**: Shared chats and permissions
6. **API Rate Limiting**: Prevent abuse
7. **Advanced Logging**: Distributed tracing with X-Ray
8. **Machine Learning**: Custom model training

## Troubleshooting

### Application Issues
- Check logs: `docker-compose logs -f service-name`
- Verify environment variables in `.env`
- Test database connectivity
- Review application code for errors

### Deployment Issues
- Verify Docker images are properly built
- Check AWS credentials and permissions
- Verify security groups allow traffic
- Review CloudWatch logs for service failures

### Performance Issues
- Monitor CloudWatch metrics
- Check database query performance
- Analyze slow endpoints
- Profile application code

## Team Contributions

Document team member contributions:

| Member | Responsibility | Hours |
|--------|-----------------|-------|
| | Frontend Development | |
| | Backend API Development | |
| | Database Design | |
| | Cloud Deployment | |
| | Documentation | |
| | Testing | |

## References

- [Docker Documentation](https://docs.docker.com/)
- [AWS ECS Documentation](https://docs.aws.amazon.com/ecs/)
- [MongoDB Documentation](https://docs.mongodb.com/)
- [Express.js Documentation](https://expressjs.com/)
- [React Documentation](https://react.dev/)
- [Nginx Documentation](https://nginx.org/en/docs/)

## Conclusion

The Full Stack ChatGPT application successfully demonstrates modern cloud development practices including:
- Containerization with Docker
- Multi-tier architecture
- Cloud service integration
- Scalability and high availability
- Security best practices
- Monitoring and logging

The application is production-ready and can be easily deployed to AWS for enterprise use.
