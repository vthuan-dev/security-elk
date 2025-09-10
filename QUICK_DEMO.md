# 🎯 HƯỚNG DẪN DEMO NHANH

## 📱 Truy cập hệ thống
- **Dashboard**: http://192.168.1.8:3000
- **Kibana**: http://192.168.1.8:5601
- **Đăng nhập**: admin@security.local / admin123

## 🎬 Demo từ Ubuntu VM
```bash
cd /home/user/project/security1
./demo_runner.sh
# Chọn option 5 để chạy tất cả attacks
```

## 🎬 Demo từ Windows Host

### Cách 1: Copy-paste từng đoạn vào PowerShell

**Brute Force Attack:**
```powershell
for ($i = 1; $i -le 10; $i++) {
    $body = @{email="admin@security.local"; password="wrongpassword"} | ConvertTo-Json
    try { Invoke-RestMethod -Uri "http://192.168.1.8:5001/api/auth/login" -Method POST -ContentType "application/json" -Body $body -TimeoutSec 5 } catch {}
    Start-Sleep -Seconds 1
}
```

**Port Scanning:**
```powershell
$ports = @(22, 80, 443, 3000, 5001, 9200, 27017)
foreach ($port in $ports) {
    try {
        $tcpClient = New-Object System.Net.Sockets.TcpClient
        $tcpClient.Connect("192.168.1.8", $port)
        Write-Host "Port $port mở" -ForegroundColor Green
        $tcpClient.Close()
    } catch {}
    Start-Sleep -Milliseconds 500
}
```

**HTTP Flood:**
```powershell
for ($i = 1; $i -le 10; $i++) {
    try { Invoke-WebRequest -Uri "http://192.168.1.8:3000/" -TimeoutSec 2 -UseBasicParsing | Out-Null } catch {}
    try { Invoke-WebRequest -Uri "http://192.168.1.8:5001/health" -TimeoutSec 2 -UseBasicParsing | Out-Null } catch {}
    Start-Sleep -Milliseconds 200
}
```

### Cách 2: Chạy file PowerShell
```powershell
# Copy file windows_attack_commands.ps1 và chạy:
.\windows_attack_commands.ps1
```

## 📊 Screenshots cần chụp
1. Dashboard overview với statistics
2. Incidents list với filters  
3. Real-time alerts panel
4. Kibana Discover với security events
5. Network traffic visualization
6. Failed login attempts timeline

## 🔧 Kiểm tra hệ thống
```bash
# Kiểm tra services
docker compose ps

# Kiểm tra logs
docker compose logs backend
docker compose logs filebeat
```

---
**Lưu ý**: Đây là hệ thống demo, không sử dụng trong production!
