# Security Incident Response Dashboard

Nền tảng giám sát – phát hiện – cảnh báo – phản ứng sự cố bảo mật thời gian gần thực dựa trên ELK Stack (Elasticsearch, Logstash, Kibana) và Dashboard UI (React/Node/MongoDB).

## 1) Thành phần & cổng dịch vụ
- Elasticsearch: 9200
- Kibana: 5601
- Logstash: 5044/5000 (input), 9600 (API)
- Backend API: 5001 (publish ra host; container chạy 5000)
- Frontend Dashboard: 3000
- MongoDB: 27017

Các thành phần được điều phối bằng Docker Compose trong `docker-compose.yml`.

## 2) Yêu cầu
- Ubuntu 20.04+ (host/VM)
- Docker 24+, Docker Compose v2
- Dung lượng trống tối thiểu 5GB

## 3) Khởi chạy nhanh
```bash
git clone <repository-url>
cd security1
docker compose up -d
```
Chờ ~1–2 phút cho healthchecks ổn định, sau đó truy cập:
- Frontend: http://localhost:3000
- Kibana: http://localhost:5601
- Elasticsearch: http://localhost:9200
- Backend API (host): http://localhost:5001

Kiểm tra nhanh:
```bash
curl -s http://localhost:5001/health | jq .
docker compose ps
```

## 4) Luồng hoạt động
1. Beats thu thập log → Logstash chuẩn hóa/làm giàu → Elasticsearch.
2. Kibana phục vụ điều tra/ trực quan.
3. ElastAlert2 khớp rule (port scan, ssh bruteforce, sudo, network surge) → gọi webhook `POST /api/alerts/webhook`.
4. Backend tạo Incident (MongoDB), phát realtime (Socket.IO) và gửi Telegram (nếu cấu hình).
5. Frontend hiển thị Dashboard/Incidents.

## 5) Cấu hình cảnh báo Telegram
Biến môi trường được đặt trong `docker-compose.yml` của service `backend`:
- `TELEGRAM_BOT_TOKEN`
- `TELEGRAM_CHAT_ID`

Chỉ cần giữ nguyên (hoặc thay bằng của bạn), khi rule khớp → ElastAlert gọi webhook → Backend gửi Telegram tự động.

## 6) Demo nhanh (3 ảnh báo cáo)
Tạo lưu lượng từ máy tấn công (ví dụ Windows 192.168.1.15) tới VM/host 192.168.1.8:

1) Port scan để kích hoạt rule (đủ ≥20 cổng trong 2 phút)
```powershell
nmap -Pn -sT -p 1-200 -T4 192.168.1.8
```
2) Kibana Discover xác nhận log (Chọn Last 5–15 minutes)
- KQL: `event.dataset: flow AND source.ip: 192.168.1.15`

3) Quan sát Incident + Telegram
- Incidents: http://192.168.1.8:3000/incidents
- Telegram: nhận tin “Port scan detected …”.

SQLi demo (tùy chọn):
```bash
curl "http://192.168.1.8:3000/?q=' OR '1'='1" -I
```
Kibana filter: `event.dataset: http AND source.ip: 192.168.1.15`.

## 7) Bộ rule ElastAlert2 tích hợp
Các rule nằm tại `elk-stack/elastalert/rules/` và đã được nối webhook:
- `port_scan.yaml`: cardinality theo `event.dataset: flow` (≥20 cổng/2 phút)
- `ssh_bruteforce.yaml`: 10 lần thất bại/5 phút (source.ip)
- `failed_login.yaml`: failed logins ≥3/2 phút
- `sudo_escalation.yaml`: sudo session/error bất thường
- `network_stress.yaml`: spike traffic

Sau khi chỉnh rule, chạy:
```bash
docker compose restart elastalert
```

## 8) Troubleshooting nhanh
- Nmap không thấy host: dùng `-Pn` hoặc đảm bảo VM ở Bridged/Port-Forwarding đúng.
- Không thấy log nmap trong Kibana: chọn index `packetbeat*`, filter `event.dataset: flow`, time range 5–15 phút, kiểm `source.ip` đúng.
- Không thấy Telegram: kiểm tra biến `TELEGRAM_BOT_TOKEN/CHAT_ID`, log backend và `docker logs elastalert`.
- Frontend không gọi đúng API: backend publish ra host cổng 5001; nếu cần, chỉnh `REACT_APP_API_URL` → `http://localhost:5001`.

## 9) Cấu trúc thư mục
```
security1/
├── backend/                 # Node.js API server (Express, JWT, Socket.IO)
├── frontend/                # React dashboard
├── elk-stack/               # Elasticsearch/Logstash/Kibana/Beats/ElastAlert configs
├── docker-compose.yml       # Orchestration
├── scripts/                 # Demo scripts
└── docs/                    # Tài liệu bổ sung
```

## 10) Lưu ý bảo mật
- Repo demo bật CORS `*` và CSP mở để thuận tiện test; siết lại allowlist khi production.
- Bảo vệ webhook `/api/alerts/webhook` bằng token header hoặc allowlist mạng nội bộ khi triển khai thật.
- Chuyển sang HTTPS/WSS end-to-end cho môi trường sản xuất.

## 11) Giấy phép & hỗ trợ
- License: MIT
- Issues/Support: tạo issue trong repo

---
Tip: Giữ cùng khung thời gian trong Kibana/Frontend (15–30 phút) để ảnh demo nhất quán.
