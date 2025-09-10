#!/bin/bash

# Security Incident Response Dashboard Setup Script
# Tác giả: Security Team
# Phiên bản: 1.0

set -e

# Colors cho output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function để in thông báo
print_message() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_header() {
    echo -e "${BLUE}================================${NC}"
    echo -e "${BLUE}  Security Incident Response${NC}"
    echo -e "${BLUE}  Dashboard Setup Script${NC}"
    echo -e "${BLUE}================================${NC}"
}

# Function kiểm tra dependencies
check_dependencies() {
    print_message "Kiểm tra dependencies..."
    
    # Kiểm tra Docker
    if ! command -v docker &> /dev/null; then
        print_error "Docker không được cài đặt. Vui lòng cài đặt Docker trước."
        exit 1
    fi
    
    # Kiểm tra Docker Compose
    if ! command -v docker-compose &> /dev/null; then
        print_error "Docker Compose không được cài đặt. Vui lòng cài đặt Docker Compose trước."
        exit 1
    fi
    
    # Kiểm tra Node.js (cho development)
    if ! command -v node &> /dev/null; then
        print_warning "Node.js không được cài đặt. Chỉ có thể chạy trong Docker."
    fi
    
    print_message "Tất cả dependencies đã sẵn sàng!"
}

# Function tạo file .env
create_env_file() {
    if [ ! -f .env ]; then
        print_message "Tạo file .env..."
        cat > .env << EOF
# Security Incident Response Dashboard Environment Variables

# Application
NODE_ENV=production
PORT=5000
FRONTEND_URL=http://localhost:3000

# MongoDB
MONGODB_URI=mongodb://admin:password123@mongodb:27017/security_incidents?authSource=admin

# JWT
JWT_SECRET=your-super-secret-jwt-key-change-in-production
JWT_EXPIRE=30d

# Elasticsearch
ELASTICSEARCH_URL=http://elasticsearch:9200

# Email Configuration (SMTP)
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=your-email@gmail.com
SMTP_PASS=your-app-password
SMTP_FROM=noreply@security.local

# Slack Configuration
SLACK_WEBHOOK_URL=your-slack-webhook-url
SLACK_CHANNEL=#security-alerts

# Telegram Configuration
TELEGRAM_BOT_TOKEN=your-telegram-bot-token
TELEGRAM_CHAT_ID=your-chat-id

# Logging
LOG_LEVEL=info

# Security
RATE_LIMIT_WINDOW_MS=900000
RATE_LIMIT_MAX_REQUESTS=100
EOF
        print_message "File .env đã được tạo!"
    else
        print_message "File .env đã tồn tại."
    fi
}

# Function tạo thư mục logs
create_logs_directory() {
    print_message "Tạo thư mục logs..."
    mkdir -p backend/logs
    mkdir -p logs
    print_message "Thư mục logs đã được tạo!"
}

# Function build và start containers
start_containers() {
    print_message "Khởi chạy containers..."
    
    # Pull images
    print_message "Đang tải Docker images..."
    docker-compose pull
    
    # Build images
    print_message "Đang build images..."
    docker-compose build
    
    # Start services
    print_message "Đang khởi động services..."
    docker-compose up -d
    
    print_message "Containers đã được khởi động!"
}

# Function kiểm tra health của services
check_services_health() {
    print_message "Kiểm tra health của services..."
    
    # Đợi services khởi động
    sleep 30
    
    # Kiểm tra Elasticsearch
    if curl -s http://localhost:9200 > /dev/null; then
        print_message "✓ Elasticsearch đang chạy"
    else
        print_warning "✗ Elasticsearch chưa sẵn sàng"
    fi
    
    # Kiểm tra MongoDB
    if docker-compose exec -T mongodb mongosh --eval "db.runCommand('ping')" > /dev/null 2>&1; then
        print_message "✓ MongoDB đang chạy"
    else
        print_warning "✗ MongoDB chưa sẵn sàng"
    fi
    
    # Kiểm tra Backend API
    if curl -s http://localhost:5000/health > /dev/null; then
        print_message "✓ Backend API đang chạy"
    else
        print_warning "✗ Backend API chưa sẵn sàng"
    fi
    
    # Kiểm tra Frontend
    if curl -s http://localhost:3000 > /dev/null; then
        print_message "✓ Frontend đang chạy"
    else
        print_warning "✗ Frontend chưa sẵn sàng"
    fi
    
    # Kiểm tra Kibana
    if curl -s http://localhost:5601 > /dev/null; then
        print_message "✓ Kibana đang chạy"
    else
        print_warning "✗ Kibana chưa sẵn sàng"
    fi
}

# Function hiển thị thông tin truy cập
show_access_info() {
    echo -e "${BLUE}================================${NC}"
    echo -e "${BLUE}  Access Information${NC}"
    echo -e "${BLUE}================================${NC}"
    echo -e "${GREEN}Frontend Dashboard:${NC} http://localhost:3000"
    echo -e "${GREEN}Backend API:${NC} http://localhost:5000"
    echo -e "${GREEN}Kibana:${NC} http://localhost:5601"
    echo -e "${GREEN}Elasticsearch:${NC} http://localhost:9200"
    echo -e "${GREEN}MongoDB:${NC} localhost:27017"
    echo ""
    echo -e "${YELLOW}Default Users:${NC}"
    echo -e "Admin: admin@security.local / admin123"
    echo -e "Analyst: analyst@security.local / analyst123"
    echo -e "Viewer: viewer@security.local / viewer123"
    echo ""
    echo -e "${YELLOW}Useful Commands:${NC}"
    echo -e "View logs: docker-compose logs -f"
    echo -e "Stop services: docker-compose down"
    echo -e "Restart services: docker-compose restart"
    echo -e "Update services: docker-compose pull && docker-compose up -d"
}

# Function cleanup
cleanup() {
    print_message "Dọn dẹp tài nguyên..."
    docker-compose down -v
    docker system prune -f
    print_message "Cleanup hoàn tất!"
}

# Function help
show_help() {
    echo "Usage: $0 [OPTION]"
    echo ""
    echo "Options:"
    echo "  setup     Setup và khởi động toàn bộ hệ thống"
    echo "  start     Khởi động services"
    echo "  stop      Dừng services"
    echo "  restart   Khởi động lại services"
    echo "  status    Kiểm tra trạng thái services"
    echo "  logs      Xem logs"
    echo "  cleanup   Dọn dẹp tài nguyên"
    echo "  help      Hiển thị help"
    echo ""
    echo "Examples:"
    echo "  $0 setup    # Setup và khởi động lần đầu"
    echo "  $0 start    # Khởi động services"
    echo "  $0 logs     # Xem logs real-time"
}

# Main script
main() {
    case "${1:-setup}" in
        "setup")
            print_header
            check_dependencies
            create_env_file
            create_logs_directory
            start_containers
            check_services_health
            show_access_info
            ;;
        "start")
            print_message "Khởi động services..."
            docker-compose up -d
            ;;
        "stop")
            print_message "Dừng services..."
            docker-compose down
            ;;
        "restart")
            print_message "Khởi động lại services..."
            docker-compose restart
            ;;
        "status")
            print_message "Trạng thái services..."
            docker-compose ps
            ;;
        "logs")
            print_message "Xem logs..."
            docker-compose logs -f
            ;;
        "cleanup")
            cleanup
            ;;
        "help"|"-h"|"--help")
            show_help
            ;;
        *)
            print_error "Option không hợp lệ: $1"
            show_help
            exit 1
            ;;
    esac
}

# Chạy main function
main "$@"
