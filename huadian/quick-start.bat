@echo off
chcp 65001 >nul
title 花店管理系统快速启动

echo ========================================
echo           花店管理系统快速启动
echo ========================================
echo.

echo [信息] 正在启动应用...
echo [提示] 首次启动可能需要较长时间，请耐心等待
echo [提示] 请确保MySQL服务正在运行
echo.

REM 尝试多种方式启动Maven
echo [启动] 正在启动Spring Boot应用...

REM 方法1: 直接尝试mvn命令
mvn spring-boot:run >nul 2>&1
if %errorlevel% equ 0 (
    goto success
)

REM 方法2: 尝试使用where命令找到mvn
where mvn >nul 2>&1
if %errorlevel% equ 0 (
    echo [信息] 找到Maven，重新尝试启动...
    mvn spring-boot:run
    goto check_result
)

REM 方法3: 尝试常见的Maven安装路径
echo [信息] 尝试查找Maven安装路径...
if exist "C:\apache-maven-3.8.6\bin\mvn.cmd" (
    echo [信息] 使用完整路径启动Maven...
    C:\apache-maven-3.8.6\bin\mvn.cmd spring-boot:run
    goto check_result
)

if exist "C:\apache-maven-3.8.5\bin\mvn.cmd" (
    echo [信息] 使用完整路径启动Maven...
    C:\apache-maven-3.8.5\bin\mvn.cmd spring-boot:run
    goto check_result
)

if exist "C:\apache-maven-3.8.4\bin\mvn.cmd" (
    echo [信息] 使用完整路径启动Maven...
    C:\apache-maven-3.8.4\bin\mvn.cmd spring-boot:run
    goto check_result
)

REM 方法4: 尝试从环境变量中获取
echo [信息] 尝试从环境变量启动...
call mvn spring-boot:run
goto check_result

:success
echo [成功] 应用启动成功！
goto end

:check_result
if %errorlevel% neq 0 (
    echo.
    echo [错误] 应用启动失败！
    echo.
    echo [常见问题排查]:
    echo [问题1] MySQL服务未启动
    echo [解决1] 启动MySQL服务
    echo.
    echo [问题2] 数据库连接配置错误
    echo [解决2] 检查 src/main/resources/application.yml 文件
    echo [解决2] 确认数据库名、用户名、密码正确
    echo.
    echo [问题3] 端口8080被占用
    echo [解决3] 关闭占用8080端口的程序
    echo [解决3] 或修改application.yml中的端口号
    echo.
    echo [问题4] Maven依赖下载失败
    echo [解决4] 检查网络连接
    echo [解决4] 尝试手动执行: mvn clean install
    echo.
    echo [手动启动命令]:
    echo mvn clean install
    echo mvn spring-boot:run
    echo.
    pause
    exit /b 1
) else (
    goto success
)

:end
echo.
echo [完成] 应用已停止运行
pause 