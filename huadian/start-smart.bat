@echo off
chcp 65001 >nul
title 花店管理系统智能启动器

echo ========================================
echo           花店管理系统智能启动器
echo ========================================
echo.

REM 检查Java环境
echo [步骤1] 检查Java环境...
java -version >nul 2>&1
if %errorlevel% neq 0 (
    echo [错误] Java环境检查失败！
    echo [原因] 可能未安装Java或环境变量配置错误
    echo [解决] 请安装Java 8或更高版本
    echo [下载] https://www.oracle.com/java/technologies/downloads/
    echo.
    pause
    exit /b 1
) else (
    echo [成功] Java环境检查通过
)

echo.
echo [步骤2] 检查Maven环境...
echo [提示] 正在检测Maven，请稍候...

REM 使用更智能的方式检查Maven
mvn -version >nul 2>&1
set maven_test=%errorlevel%

if %maven_test% neq 0 (
    echo [警告] Maven版本检查失败！
    echo [可能原因]：
    echo [原因1] Maven未安装
    echo [原因2] Maven未添加到PATH环境变量
    echo [原因3] Maven安装路径有问题
    echo.
    echo [解决方案]：
    echo [方案1] 下载安装Maven：https://maven.apache.org/download.cgi
    echo [方案2] 检查环境变量PATH是否包含Maven的bin目录
    echo [方案3] 重新安装Maven到英文路径
    echo.
    echo [选择] 是否跳过Maven检查继续启动？(Y/N)
    set /p skip_maven=
    if /i not "%skip_maven%"=="Y" (
        echo [信息] 请先安装Maven后再启动
        pause
        exit /b 1
    )
) else (
    echo [成功] Maven环境检查通过
    echo [信息] Maven已正确安装并配置
)

echo.
echo [步骤3] 检查项目环境...
echo [信息] 正在检查项目依赖...

REM 检查pom.xml文件是否存在
if not exist "pom.xml" (
    echo [错误] 未找到pom.xml文件！
    echo [原因] 可能不在正确的项目目录中
    echo [解决] 请确保在项目根目录运行此脚本
    echo.
    pause
    exit /b 1
) else (
    echo [成功] 找到项目配置文件
)

echo.
echo [步骤4] 启动应用...
echo [提示] 首次启动可能需要较长时间
echo [提示] 请确保MySQL服务正在运行
echo [提示] 请确保数据库配置正确
echo.

REM 尝试启动应用
echo [信息] 正在启动Spring Boot应用...
echo [提示] 如果首次启动，Maven会下载依赖，请耐心等待...
echo.

mvn spring-boot:run

REM 检查启动结果
if %errorlevel% neq 0 (
    echo.
    echo [错误] 应用启动失败！
    echo.
    echo [常见问题排查]：
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
    echo [解决4] 尝试手动执行：mvn clean install
    echo.
    echo [手动启动命令]：
    echo mvn clean install
    echo mvn spring-boot:run
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