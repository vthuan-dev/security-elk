# 🎯 Hướng dẫn Demo Security Incident Response Dashboard

## 📋 Chuẩn bị Demo

### 1. Truy cập các dịch vụ
- **Dashboard Frontend**: http://localhost:3000
- **Kibana**: http://localhost:5601  
- **Elasticsearch**: http://localhost:9200
- **Backend API**: http://localhost:5001

### 2. Tài khoản đăng nhập
- **Email**: admin@security.local
- **Password**: admin123

---

## 🎬 Kịch bản Demo từng bước

### **Bước 1: Giới thiệu Dashboard** ⏱️ 2-3 phút

1. **Mở Dashboard**: http://localhost:3000
2. **Đăng nhập** với tài khoản admin
3. **Giới thiệu các thành phần**:
   - Statistics cards (Tổng số incidents, Open incidents, Critical severity)
   - Charts (Pie chart severity, Bar chart status, Line chart trends)
   - Real-time alerts panel
   - Geographic map (nếu có dữ liệu GeoIP)

### **Bước 2: Tạo sự cố thủ công** ⏱️ 1-2 phút

1. **Vào trang Incidents**: Click "Incidents" trong sidebar
2. **Tạo incident mới**: Click "Create New Incident"
3. **Điền thông tin**:
   - Title: "Demo Security Incident"
   - Description: "Tấn công brute force phát hiện từ IP 192.168.1.100"
   - Severity: High
   - Category: network_intrusion
   - Source IP: 192.168.1.100
4. **Lưu** và quan sát real-time update

### **Bước 3: Mô phỏng tấn công Brute Force** ⏱️ 2-3 phút

**Từ Windows Host** (PowerShell hoặc Command Prompt):
```bash
# Mở PowerShell và chạy:
for ($i=1; $i -le 10; $i++) {
    Invoke-RestMethod -Uri "http://192.168.1.8:5001/api/auth/login" -Method POST -ContentType "application/json" -Body '{"email":"admin@security.local","password":"wrongpassword"}'
    Start-Sleep -Seconds 1
}
```

**Hoặc từ Ubuntu VM**:
```bash
cd /home/user/project/security1
chmod +x scripts/simulate_bruteforce.sh
./scripts/simulate_bruteforce.sh
```

**Quan sát**:
- Dashboard sẽ hiển thị alerts real-time
- Kibana sẽ ghi nhận failed login attempts
- ElastAlert có thể trigger nếu đủ số lần thử

### **Bước 4: Mô phỏng Port Scanning** ⏱️ 2-3 phút

**Từ Windows Host**:
```bash
# Sử dụng nmap (nếu có) hoặc PowerShell:
for ($port=1; $port -le 100; $port++) {
    try {
        $tcpClient = New-Object System.Net.Sockets.TcpClient
        $tcpClient.Connect("192.168.1.8", $port)
        Write-Host "Port $port is open"
        $tcpClient.Close()
    } catch {
        # Port closed
    }
    Start-Sleep -Milliseconds 50
}
```

**Hoặc từ Ubuntu VM**:
```bash
chmod +x scripts/simulate_portscan.sh
./scripts/simulate_portscan.sh
```

**Quan sát**:
- Packetbeat sẽ ghi nhận network traffic
- Kibana Network tab sẽ hiển thị connections
- Có thể trigger port scan detection rules

### **Bước 5: Mô phỏng Network Stress** ⏱️ 2-3 phút

**Từ Ubuntu VM**:
```bash
chmod +x scripts/simulate_network_stress.sh
./scripts/simulate_network_stress.sh
```

**Quan sát**:
- Packetbeat metrics tăng đột biến
- Network stress detection có thể trigger
- Dashboard hiển thị traffic spikes

### **Bước 6: Tạo nhiều sự cố tự động** ⏱️ 1-2 phút

```bash
chmod +x scripts/create_security_events.sh
./scripts/create_security_events.sh
```

**Quan sát**:
- Dashboard được populate với nhiều incidents
- Charts và statistics được cập nhật
- Real-time notifications

### **Bước 7: Demo Kibana** ⏱️ 3-4 phút

1. **Mở Kibana**: http://localhost:5601
2. **Tạo Index Pattern**:
   - Vào Stack Management > Index Patterns
   - Tạo pattern cho `filebeat-*`, `packetbeat-*`, `auditbeat-*`
3. **Xem Discover**:
   - Chọn index pattern
   - Filter theo thời gian (last 1 hour)
   - Xem các events được ghi nhận
4. **Tạo Dashboard**:
   - Vào Dashboard > Create new dashboard
   - Add visualization cho security events
   - Tạo charts cho failed logins, network traffic

### **Bước 8: Demo Alerting** ⏱️ 2-3 phút

1. **Kiểm tra ElastAlert**:
   ```bash
   docker compose logs elastalert
   ```
2. **Xem alert rules**:
   ```bash
   ls -la elk-stack/elastalert/rules/
   cat elk-stack/elastalert/rules/failed_login.yaml
   ```
3. **Trigger alerts** bằng cách chạy lại brute force script

---

## 🎯 Điểm nhấn cho Demo

### **Tính năng nổi bật**:
1. **Real-time monitoring**: WebSocket updates
2. **Multi-source data collection**: System logs, network, files
3. **Automated threat detection**: ElastAlert rules
4. **Visual analytics**: Charts, maps, timelines
5. **Incident management**: Full lifecycle tracking

### **Screenshots cần chụp**:
1. **Dashboard overview** với statistics
2. **Incidents list** với filters
3. **Real-time alerts** panel
4. **Kibana Discover** với security events
5. **Network traffic** visualization
6. **Failed login attempts** timeline

### **Scripts tấn công có sẵn**:
- `simulate_bruteforce.sh` - Brute force attacks
- `simulate_portscan.sh` - Port scanning
- `simulate_network_stress.sh` - Network stress
- `create_security_events.sh` - Generate incidents

---

## 🔧 Troubleshooting

### **Nếu services không start**:
```bash
docker compose down
docker compose up -d
```

### **Nếu không có data trong Kibana**:
```bash
# Kiểm tra logs
docker compose logs filebeat
docker compose logs logstash
docker compose logs elasticsearch
```

### **Nếu dashboard không load**:
```bash
# Kiểm tra backend
curl http://localhost:5001/health
curl http://localhost:5001/api/dashboard/stats
```

---

## 📝 Ghi chú Demo

- **Thời gian tổng**: 15-20 phút
- **Chuẩn bị**: 5 phút (start services, check health)
- **Demo chính**: 15 phút
- **Q&A**: 5-10 phút

**Lưu ý**: Đây là hệ thống demo, không sử dụng trong production!
