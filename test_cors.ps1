# Test script để kiểm tra CORS từ Windows
# Copy và paste vào PowerShell

Write-Host "🔍 Testing CORS Configuration..." -ForegroundColor Cyan
Write-Host "================================================================" -ForegroundColor Yellow

# Test 1: Health Check
Write-Host "`n1️⃣ Testing Health Check..." -ForegroundColor Green
try {
    $health = Invoke-RestMethod -Uri "http://192.168.1.8:5001/health" -Method GET
    Write-Host "✅ Health Check: $($health.status)" -ForegroundColor Green
} catch {
    Write-Host "❌ Health Check Failed: $($_.Exception.Message)" -ForegroundColor Red
}

# Test 2: CORS Preflight
Write-Host "`n2️⃣ Testing CORS Preflight..." -ForegroundColor Green
try {
    $headers = @{
        'Origin' = 'http://192.168.1.15'
        'Access-Control-Request-Method' = 'POST'
        'Access-Control-Request-Headers' = 'Content-Type'
    }
    $response = Invoke-WebRequest -Uri "http://192.168.1.8:5001/api/auth/login" -Method OPTIONS -Headers $headers
    Write-Host "✅ CORS Preflight: Status $($response.StatusCode)" -ForegroundColor Green
    Write-Host "   Access-Control-Allow-Origin: $($response.Headers['Access-Control-Allow-Origin'])" -ForegroundColor Yellow
} catch {
    Write-Host "❌ CORS Preflight Failed: $($_.Exception.Message)" -ForegroundColor Red
}

# Test 3: Login API
Write-Host "`n3️⃣ Testing Login API..." -ForegroundColor Green
try {
    $body = @{
        email = "admin@security.local"
        password = "admin123"
    } | ConvertTo-Json
    
    $loginResponse = Invoke-RestMethod -Uri "http://192.168.1.8:5001/api/auth/login" -Method POST -ContentType "application/json" -Body $body
    Write-Host "✅ Login Success: $($loginResponse.user.email)" -ForegroundColor Green
    $token = $loginResponse.token
} catch {
    Write-Host "❌ Login Failed: $($_.Exception.Message)" -ForegroundColor Red
}

# Test 4: Dashboard Stats
Write-Host "`n4️⃣ Testing Dashboard Stats..." -ForegroundColor Green
if ($token) {
    try {
        $headers = @{
            'Authorization' = "Bearer $token"
            'Content-Type' = 'application/json'
        }
        $stats = Invoke-RestMethod -Uri "http://192.168.1.8:5001/api/dashboard/stats" -Method GET -Headers $headers
        Write-Host "✅ Dashboard Stats: $($stats.totalIncidents) incidents" -ForegroundColor Green
    } catch {
        Write-Host "❌ Dashboard Stats Failed: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Test 5: Frontend Access
Write-Host "`n5️⃣ Testing Frontend Access..." -ForegroundColor Green
try {
    $frontendResponse = Invoke-WebRequest -Uri "http://192.168.1.8:3000" -Method GET -TimeoutSec 10
    Write-Host "✅ Frontend Access: Status $($frontendResponse.StatusCode)" -ForegroundColor Green
} catch {
    Write-Host "❌ Frontend Access Failed: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "`n================================================================" -ForegroundColor Yellow
Write-Host "🎯 CORS Test Complete!" -ForegroundColor Cyan
Write-Host "📱 Dashboard: http://192.168.1.8:3000" -ForegroundColor White
Write-Host "🔧 API: http://192.168.1.8:5001" -ForegroundColor White
Write-Host "📊 Kibana: http://192.168.1.8:5601" -ForegroundColor White
