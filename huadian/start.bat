@echo off
chcp 65001 >nul
title 花店管理系统启动器

echo ========================================
echo           花店管理系统启动器
echo ========================================
echo.

echo [信息] 正在检查Java环境...
java -version >nul 2>&1
if %errorlevel% neq 0 (
    echo [错误] 未找到Java环境！
    echo [提示] 请先安装Java 8或更高版本
    echo [提示] 下载地址: https://www.oracle.com/java/technologies/downloads/
    echo.
    pause
    exit /b 1
) else (
    echo [成功] Java环境检查通过
)

echo.
echo [信息] 正在检查Maven环境...
echo [提示] 如果Maven未安装，请先安装Maven
echo [提示] 下载地址: https://maven.apache.org/download.cgi
echo.

REM 尝试运行Maven命令，但捕获错误
mvn -version >nul 2>&1
set maven_status=%errorlevel%

if %maven_status% neq 0 (
    echo [警告] Maven环境检查失败！
    echo [提示] 可能的原因:
    echo [提示] 1. Maven未安装
    echo [提示] 2. Maven未添加到PATH环境变量
    echo [提示] 3. Maven安装路径包含中文或特殊字符
    echo.
    echo [选择] 是否继续尝试启动应用? (Y/N)
    set /p choice=
    if /i "%choice%"=="Y" (
        echo [信息] 继续启动应用...
        goto start_app
    ) else (
        echo [信息] 请先安装Maven后再启动
        pause
        exit /b 1
    )
) else (
    echo [成功] Maven环境检查通过
    goto start_app
)

:start_app
echo.
echo [信息] 开始编译和启动应用...
echo [提示] 首次启动可能需要较长时间，请耐心等待...
echo [提示] 如果出现错误，请检查数据库连接配置
echo.

REM 尝试启动应用
mvn spring-boot:run

if %errorlevel% neq 0 (
    echo.
    echo [错误] 应用启动失败！
    echo [提示] 请检查:
    echo [提示] 1. MySQL服务是否正常运行
    echo [提示] 2. 数据库连接配置是否正确 (application.yml)
    echo [提示] 3. 端口8080是否被占用
    echo [提示] 4. Maven依赖是否下载完成
    echo.
    echo [建议] 可以尝试以下命令手动启动:
    echo [建议] mvn clean install
    echo [建议] mvn spring-boot:run
    echo.
    pause
    exit /b 1
) else (
    echo.
    echo ========================================
    echo [成功] 花店管理系统启动成功！
    echo [地址] http://localhost:8080
    echo [提示] 按任意键关闭此窗口
    echo ========================================
    pause
) 