# Security Incident Response Dashboard

Hệ thống giám sát, phát hiện và phản hồi sự cố bảo mật tự động dựa trên ELK Stack.

## 🎯 Mục tiêu

- Giám sát thời gian thực các hoạt động đáng ngờ
- Phân tích và phân loại mối đe dọa
- Cảnh báo tức thì qua email, Slack, Telegram
- Trực quan hóa dữ liệu an ninh
- Theo dõi phản ứng và lưu trữ sự kiện

## 🏗️ Kiến trúc hệ thống

```
Attacker → User Device → Log Collector → Logstash → Elasticsearch → Kibana → Dashboard UI
                                    ↓                    ↓
                            Threat Detection    →    Alerting System
```

## 🛠️ Công nghệ sử dụng

- **Frontend**: React.js, WebSocket
- **Backend**: Node.js + Express
- **Log Collection**: Filebeat, Auditbeat, Packetbeat
- **Processing**: Logstash
- **Storage & Search**: Elasticsearch
- **Visualization**: Kibana
- **Alerting**: ElastAlert
- **Database**: MongoDB
- **Infrastructure**: Docker, Ubuntu Server

## 🚀 Cài đặt và chạy

### Yêu cầu hệ thống
- Docker và Docker Compose
- Node.js 18+
- Ubuntu 20.04+

### Khởi chạy nhanh

1. Clone repository:
```bash
git clone <repository-url>
cd security1
```

2. Chạy toàn bộ hệ thống:
```bash
docker-compose up -d
```

3. Truy cập các dịch vụ:
- Dashboard: http://localhost:3000
- Kibana: http://localhost:5601
- Elasticsearch: http://localhost:9200
- API Backend: http://localhost:5000

## 📁 Cấu trúc dự án

```
security1/
├── backend/                 # Node.js API server
├── frontend/               # React.js Dashboard
├── elk-stack/             # ELK Stack configuration
├── docker-compose.yml     # Docker orchestration
├── scripts/               # Setup và utility scripts
└── docs/                  # Documentation
```

## 🔧 Cấu hình

### Biến môi trường
Tạo file `.env` từ `.env.example`:
```bash
cp .env.example .env
```

### Cấu hình cảnh báo
- Email: Cấu hình SMTP trong `backend/config/email.js`
- Slack: Thêm webhook URL trong `backend/config/slack.js`
- Telegram: Thêm bot token trong `backend/config/telegram.js`

## 📊 Tính năng chính

### 1. Giám sát thời gian thực
- Thu thập log từ nhiều nguồn
- Phân tích hành vi bất thường
- Phát hiện mối đe dọa tự động

### 2. Dashboard trực quan
- Biểu đồ thống kê sự cố
- Bản đồ phân bố địa lý
- Heatmap hoạt động
- Timeline sự kiện

### 3. Hệ thống cảnh báo
- Email thông báo
- Slack integration
- Telegram bot
- Webhook tùy chỉnh

### 4. Quản lý sự cố
- Phân loại mức độ nghiêm trọng
- Ghi nhận xử lý
- Báo cáo và kiểm toán

## 🤖 Machine Learning (Tính năng nâng cao)

- Phát hiện anomaly dựa trên hành vi
- Gợi ý xử lý tự động
- Học từ dữ liệu lịch sử

## 🔐 Bảo mật

- Xác thực đa yếu tố
- Phân quyền người dùng
- Mã hóa dữ liệu
- Audit logging

## 📈 Monitoring

- Health check các dịch vụ
- Performance metrics
- Resource utilization
- Error tracking

## 🤝 Đóng góp

1. Fork dự án
2. Tạo feature branch
3. Commit changes
4. Push to branch
5. Tạo Pull Request

## 📄 License

MIT License - xem file LICENSE để biết thêm chi tiết.

## 📞 Hỗ trợ

- Issues: GitHub Issues
- Email: support@security-dashboard.com
- Documentation: `/docs` folder

---

**Lưu ý**: Đây là dự án demo cho mục đích học tập và nghiên cứu. Không sử dụng trong môi trường production mà không có đánh giá bảo mật đầy đủ.
