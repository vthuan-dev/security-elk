# 🎯 DEMO SECURITY INCIDENT RESPONSE DASHBOARD

## 🚀 Khởi động nhanh

```bash
# Khởi động hệ thống
docker compose up -d

# Chạy demo
./demo_runner.sh
```

## 📱 Truy cập hệ thống

- **Dashboard**: http://192.168.1.8:3000
- **Kibana**: http://192.168.1.8:5601
- **Backend API**: http://192.168.1.8:5001

**Đăng nhập**: admin@security.local / admin123

## 🎬 Kịch bản Demo

### 1. Từ Ubuntu VM
```bash
./demo_runner.sh
# Chọn option 5 để chạy tất cả attacks
```

### 2. Từ Windows Host
```powershell
# Copy file attack_from_windows.ps1 và chạy:
.\attack_from_windows.ps1 -TargetIP 192.168.1.8
```

## 📊 Screenshots cần chụp

1. **Dashboard Overview** - Statistics và charts
2. **Incidents List** - Danh sách sự cố
3. **Real-time Alerts** - Panel cảnh báo
4. **Kibana Discover** - Security events
5. **Network Traffic** - Packetbeat data
6. **Failed Logins** - Brute force detection

## 🔧 Scripts có sẵn

- `simulate_bruteforce.sh` - Brute force attacks
- `simulate_portscan.sh` - Port scanning  
- `simulate_network_stress.sh` - Network stress
- `create_security_events.sh` - Generate incidents
- `attack_from_windows.ps1` - Windows attack script

## 📝 Tài liệu

- `DEMO_GUIDE.md` - Hướng dẫn demo chi tiết
- `PROJECT_STRUCTURE.md` - Cấu trúc dự án
- `WORKFLOW_ANALYSIS.md` - Phân tích workflow

---

**Lưu ý**: Đây là hệ thống demo, không sử dụng trong production!
