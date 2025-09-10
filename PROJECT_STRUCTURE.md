# Cấu trúc Dự án Security Incident Response Dashboard

## 📁 Tổng quan cấu trúc

```
security1/
├── 📄 README.md                    # Tài liệu chính
├── 📄 PROJECT_STRUCTURE.md         # File này
├── 📄 docker-compose.yml           # Docker orchestration
├── 📄 setup.sh                     # Script setup tự động
├── 📁 backend/                     # Node.js API Server
├── 📁 frontend/                    # React.js Dashboard
├── 📁 elk-stack/                   # ELK Stack configuration
├── 📁 scripts/                     # Utility scripts
└── 📁 docs/                        # Documentation
```

## 🔧 Backend (Node.js + Express)

```
backend/
├── 📄 package.json                 # Dependencies
├── 📄 Dockerfile                   # Container config
├── 📄 server.js                    # Entry point
├── 📁 models/                      # MongoDB schemas
│   ├── 📄 User.js                  # User model
│   └── 📄 Incident.js              # Incident model
├── 📁 routes/                      # API routes
│   ├── 📄 auth.js                  # Authentication
│   ├── 📄 incidents.js             # Incident management
│   ├── 📄 alerts.js                # Alert handling
│   ├── 📄 dashboard.js             # Dashboard data
│   └── 📄 elasticsearch.js         # ES integration
├── 📁 middleware/                  # Express middleware
│   ├── 📄 auth.js                  # JWT authentication
│   └── 📄 errorHandler.js          # Error handling
├── 📁 utils/                       # Utility functions
│   └── 📄 logger.js                # Winston logger
├── 📁 config/                      # Configuration files
│   ├── 📄 email.js                 # SMTP config
│   ├── 📄 slack.js                 # Slack integration
│   └── 📄 telegram.js              # Telegram bot
└── 📁 logs/                        # Application logs
```

## 🎨 Frontend (React.js)

```
frontend/
├── 📄 package.json                 # Dependencies
├── 📄 Dockerfile                   # Container config
├── 📄 nginx.conf                   # Nginx config
├── 📁 src/                         # Source code
│   ├── 📄 App.js                   # Main component
│   ├── 📄 index.js                 # Entry point
│   ├── 📁 components/              # Reusable components
│   │   ├── 📄 Layout.js            # Main layout
│   │   ├── 📄 Sidebar.js           # Navigation
│   │   ├── 📄 Header.js            # Top header
│   │   ├── 📄 Dashboard.js         # Dashboard view
│   │   ├── 📄 IncidentList.js      # Incident table
│   │   ├── 📄 AlertPanel.js        # Alert display
│   │   └── 📄 Charts/              # Chart components
│   ├── 📁 pages/                   # Page components
│   │   ├── 📄 Login.js             # Login page
│   │   ├── 📄 Dashboard.js         # Main dashboard
│   │   ├── 📄 Incidents.js         # Incident management
│   │   ├── 📄 Alerts.js            # Alert management
│   │   ├── 📄 Users.js             # User management
│   │   └── 📄 Settings.js          # System settings
│   ├── 📁 contexts/                # React contexts
│   │   ├── 📄 AuthContext.js       # Authentication state
│   │   └── 📄 SocketContext.js     # WebSocket connection
│   ├── 📁 hooks/                   # Custom hooks
│   ├── 📁 utils/                   # Utility functions
│   ├── 📁 services/                # API services
│   └── 📁 styles/                  # CSS/SCSS files
└── 📁 public/                      # Static assets
```

## 🐘 ELK Stack Configuration

```
elk-stack/
├── 📁 logstash/                    # Log processing
│   ├── 📁 config/
│   │   └── 📄 logstash.yml         # Logstash config
│   └── 📁 pipeline/
│       └── 📄 logstash.conf        # Processing pipeline
├── 📁 filebeat/                    # Log collection
│   └── 📄 filebeat.yml             # Filebeat config
├── 📁 auditbeat/                   # System audit
│   └── 📄 auditbeat.yml            # Auditbeat config
├── 📁 packetbeat/                  # Network monitoring
│   └── 📄 packetbeat.yml           # Packetbeat config
└── 📁 elastalert/                  # Alerting system
    ├── 📄 config.yaml              # ElastAlert config
    └── 📁 rules/                   # Alert rules
        ├── 📄 failed_login.yaml    # Failed login detection
        ├── 📄 suspicious_activity.yaml
        └── 📄 malware_detection.yaml
```

## 📜 Scripts & Utilities

```
scripts/
├── 📄 init-mongo.js                # MongoDB initialization
├── 📄 generate-test-data.js        # Test data generator
├── 📄 backup-database.sh           # Database backup
├── 📄 restore-database.sh          # Database restore
└── 📄 health-check.sh              # System health check
```

## 📚 Documentation

```
docs/
├── 📄 QUICK_START.md               # Hướng dẫn khởi động nhanh
├── 📄 API_REFERENCE.md             # API documentation
├── 📄 DEPLOYMENT.md                # Deployment guide
├── 📄 SECURITY.md                  # Security guidelines
├── 📄 TROUBLESHOOTING.md           # Troubleshooting guide
└── 📄 CONTRIBUTING.md              # Contribution guidelines
```

## 🐳 Docker Services

### Core Services
- **elasticsearch**: Search engine (port 9200)
- **logstash**: Log processing (port 5044, 5000)
- **kibana**: Data visualization (port 5601)
- **mongodb**: Database (port 27017)

### Application Services
- **backend**: Node.js API server (port 5000)
- **frontend**: React.js dashboard (port 3000)

### Monitoring Services
- **filebeat**: Log collection
- **auditbeat**: System audit
- **packetbeat**: Network monitoring
- **elastalert**: Alerting system

## 🔐 Security Features

### Authentication & Authorization
- JWT-based authentication
- Role-based access control (Admin, Analyst, Viewer)
- Password hashing với bcrypt
- Session management

### Data Protection
- Input validation và sanitization
- SQL injection prevention
- XSS protection
- CSRF protection
- Rate limiting

### Network Security
- HTTPS/TLS encryption
- Firewall configuration
- Network segmentation
- Intrusion detection

## 📊 Monitoring & Alerting

### Log Collection
- System logs (syslog, auth.log)
- Application logs
- Container logs
- Network traffic

### Threat Detection
- Failed login attempts
- Suspicious network activity
- File integrity monitoring
- Process monitoring

### Alert Channels
- Email notifications
- Slack integration
- Telegram bot
- Webhook endpoints

## 🚀 Deployment Options

### Development
```bash
# Local development
npm install
npm run dev
```

### Docker
```bash
# Containerized deployment
./setup.sh setup
```

### Production
- Kubernetes deployment
- Load balancer configuration
- SSL/TLS certificates
- Database clustering
- Backup strategies

## 🔄 CI/CD Pipeline

### Development Workflow
1. Code development
2. Unit testing
3. Integration testing
4. Security scanning
5. Docker build
6. Deployment

### Tools Integration
- Git version control
- GitHub Actions
- Docker registry
- Security scanners
- Monitoring tools

## 📈 Performance Optimization

### Backend Optimization
- Database indexing
- Query optimization
- Caching strategies
- Load balancing

### Frontend Optimization
- Code splitting
- Lazy loading
- Image optimization
- CDN integration

### Infrastructure Optimization
- Resource allocation
- Auto-scaling
- Monitoring metrics
- Performance tuning

---

**Lưu ý**: Cấu trúc này có thể thay đổi theo yêu cầu phát triển và mở rộng hệ thống.
