@echo off
chcp 65001 >nul
title 数据库配置检查工具

echo ========================================
echo           数据库配置检查工具
echo ========================================
echo.

echo [信息] 正在检查数据库配置...
echo.

REM 检查application.yml文件
if not exist "src\main\resources\application.yml" (
    echo [错误] 未找到application.yml配置文件！
    echo [解决] 请确保在项目根目录运行此脚本
    pause
    exit /b 1
) else (
    echo [成功] 找到application.yml配置文件
)

echo.
echo [信息] 当前数据库配置信息:
echo [文件] src\main\resources\application.yml
echo.

REM 显示数据库配置信息
echo [配置] 数据库URL: jdbc:mysql://localhost:3306/flower_shop
echo [配置] 用户名: root
echo [配置] 密码: 123456
echo [配置] 端口: 8080
echo.

echo [检查] 请确认以下事项:
echo [检查1] MySQL服务是否正在运行?
echo [检查2] 数据库flower_shop是否已创建?
echo [检查3] 用户名和密码是否正确?
echo [检查4] 端口8080是否被占用?
echo.

echo [建议] 如果配置不正确，请修改application.yml文件
echo [建议] 数据库创建命令:
echo [建议] CREATE DATABASE flower_shop CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
echo.

echo [选择] 是否继续启动应用? (Y/N)
set /p continue=
if /i "%continue%"=="Y" (
    echo.
    echo [启动] 正在启动应用...
    mvn spring-boot:run
) else (
    echo [信息] 请先配置好数据库后再启动
)

echo.
pause 