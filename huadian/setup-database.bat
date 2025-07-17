@echo off
chcp 65001 >nul
echo ========================================
echo 花店管理系统 - 数据库设置
echo ========================================
echo.

echo 正在检查MySQL连接...
echo.

REM 尝试连接到MySQL并创建数据库
mysql -u root -p -e "CREATE DATABASE IF NOT EXISTS flower_shop CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;" 2>nul

if %errorlevel% equ 0 (
    echo ✓ 数据库创建成功！
    echo.
    echo 正在初始化数据库表结构...
    
    REM 执行初始化SQL脚本
    mysql -u root -p flower_shop < src\main\resources\db\init.sql 2>nul
    
    if %errorlevel% equ 0 (
        echo ✓ 数据库表结构初始化成功！
        echo.
        echo ========================================
        echo 数据库设置完成！
        echo ========================================
        echo.
        echo 现在可以启动应用程序了：
        echo mvn spring-boot:run
        echo.
    ) else (
        echo ✗ 数据库表结构初始化失败！
        echo.
        echo 请手动执行以下SQL命令：
        echo mysql -u root -p flower_shop ^< src\main\resources\db\init.sql
        echo.
    )
) else (
    echo ✗ 数据库创建失败！
    echo.
    echo 可能的原因：
    echo 1. MySQL服务未启动
    echo 2. 用户名或密码错误
    echo 3. MySQL未安装
    echo.
    echo 请手动执行以下SQL命令：
    echo CREATE DATABASE IF NOT EXISTS flower_shop CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
    echo.
    echo 然后执行：
    echo mysql -u root -p flower_shop ^< src\main\resources\db\init.sql
    echo.
)

pause 