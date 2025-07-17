Write-Host "========================================" -ForegroundColor Green
Write-Host "花店管理系统 - 数据库设置" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""

Write-Host "正在检查MySQL连接..." -ForegroundColor Yellow
Write-Host ""

try {
    # 尝试连接到MySQL并创建数据库
    $createDbCommand = "CREATE DATABASE IF NOT EXISTS flower_shop CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
    mysql -u root -p -e $createDbCommand 2>$null
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ 数据库创建成功！" -ForegroundColor Green
        Write-Host ""
        Write-Host "正在初始化数据库表结构..." -ForegroundColor Yellow
        
        # 执行初始化SQL脚本
        mysql -u root -p flower_shop < "src\main\resources\db\init.sql" 2>$null
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✓ 数据库表结构初始化成功！" -ForegroundColor Green
            Write-Host ""
            Write-Host "========================================" -ForegroundColor Green
            Write-Host "数据库设置完成！" -ForegroundColor Green
            Write-Host "========================================" -ForegroundColor Green
            Write-Host ""
            Write-Host "现在可以启动应用程序了：" -ForegroundColor Cyan
            Write-Host "mvn spring-boot:run" -ForegroundColor White
            Write-Host ""
        } else {
            Write-Host "✗ 数据库表结构初始化失败！" -ForegroundColor Red
            Write-Host ""
            Write-Host "请手动执行以下SQL命令：" -ForegroundColor Yellow
            Write-Host "mysql -u root -p flower_shop < src\main\resources\db\init.sql" -ForegroundColor White
            Write-Host ""
        }
    } else {
        throw "数据库创建失败"
    }
} catch {
    Write-Host "✗ 数据库创建失败！" -ForegroundColor Red
    Write-Host ""
    Write-Host "可能的原因：" -ForegroundColor Yellow
    Write-Host "1. MySQL服务未启动" -ForegroundColor White
    Write-Host "2. 用户名或密码错误" -ForegroundColor White
    Write-Host "3. MySQL未安装" -ForegroundColor White
    Write-Host ""
    Write-Host "请手动执行以下SQL命令：" -ForegroundColor Yellow
    Write-Host "CREATE DATABASE IF NOT EXISTS flower_shop CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;" -ForegroundColor White
    Write-Host ""
    Write-Host "然后执行：" -ForegroundColor Yellow
    Write-Host "mysql -u root -p flower_shop < src\main\resources\db\init.sql" -ForegroundColor White
    Write-Host ""
}

Read-Host "按任意键继续..." 