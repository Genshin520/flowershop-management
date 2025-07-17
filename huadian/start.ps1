# 设置控制台编码为UTF-8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "           花店管理系统启动器" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# 检查Java环境
Write-Host "[信息] 正在检查Java环境..." -ForegroundColor Green
try {
    $javaVersion = java -version 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "[成功] Java环境检查通过" -ForegroundColor Green
    } else {
        throw "Java not found"
    }
} catch {
    Write-Host "[错误] 未找到Java环境！" -ForegroundColor Red
    Write-Host "[提示] 请先安装Java 8或更高版本" -ForegroundColor Yellow
    Write-Host "[提示] 下载地址：https://www.oracle.com/java/technologies/downloads/" -ForegroundColor Yellow
    Write-Host ""
    Read-Host "按回车键退出"
    exit 1
}

Write-Host ""

# 检查Maven环境
Write-Host "[信息] 正在检查Maven环境..." -ForegroundColor Green
try {
    $mavenVersion = mvn -version 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "[成功] Maven环境检查通过" -ForegroundColor Green
    } else {
        throw "Maven not found"
    }
} catch {
    Write-Host "[错误] 未找到Maven环境！" -ForegroundColor Red
    Write-Host "[提示] 请先安装Maven 3.6或更高版本" -ForegroundColor Yellow
    Write-Host "[提示] 下载地址：https://maven.apache.org/download.cgi" -ForegroundColor Yellow
    Write-Host ""
    Read-Host "按回车键退出"
    exit 1
}

Write-Host ""
Write-Host "[信息] 开始编译和启动应用..." -ForegroundColor Green
Write-Host "[提示] 首次启动可能需要较长时间，请耐心等待..." -ForegroundColor Yellow
Write-Host ""

# 启动应用
try {
    mvn spring-boot:run
    if ($LASTEXITCODE -eq 0) {
        Write-Host ""
        Write-Host "========================================" -ForegroundColor Cyan
        Write-Host "[成功] 花店管理系统启动成功！" -ForegroundColor Green
        Write-Host "[地址] http://localhost:8080" -ForegroundColor Yellow
        Write-Host "[提示] 按回车键关闭此窗口" -ForegroundColor Yellow
        Write-Host "========================================" -ForegroundColor Cyan
    } else {
        throw "Application failed to start"
    }
} catch {
    Write-Host ""
    Write-Host "[错误] 应用启动失败！" -ForegroundColor Red
    Write-Host "[提示] 请检查：" -ForegroundColor Yellow
    Write-Host "[提示] 1. MySQL服务是否正常运行" -ForegroundColor Yellow
    Write-Host "[提示] 2. 数据库连接配置是否正确" -ForegroundColor Yellow
    Write-Host "[提示] 3. 端口8080是否被占用" -ForegroundColor Yellow
    Write-Host ""
}

Read-Host "按回车键退出" 