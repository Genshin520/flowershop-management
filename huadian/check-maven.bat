@echo off
chcp 65001 >nul
title Maven环境检测工具

echo ========================================
echo           Maven环境检测工具
echo ========================================
echo.

echo [信息] 正在检测Maven环境...
echo.

REM 检查Maven是否在PATH中
echo [步骤1] 检查Maven命令是否可用...
where mvn >nul 2>&1
if %errorlevel% neq 0 (
    echo [错误] 未找到Maven命令！
    echo [原因] Maven可能未安装或未添加到PATH环境变量
    echo.
    echo [解决方案]:
    echo 1. 下载Maven: https://maven.apache.org/download.cgi
    echo 2. 解压到英文路径，如: C:\apache-maven-3.8.6
    echo 3. 添加环境变量:
    echo    - MAVEN_HOME = C:\apache-maven-3.8.6
    echo    - PATH += %MAVEN_HOME%\bin
    echo.
    pause
    exit /b 1
) else (
    echo [成功] 找到Maven命令
)

REM 尝试运行Maven版本检查
echo.
echo [步骤2] 检查Maven版本...
mvn -version
if %errorlevel% neq 0 (
    echo [错误] Maven版本检查失败！
    echo [可能原因]:
    echo 1. Maven安装不完整
    echo 2. Java环境配置问题
    echo 3. Maven配置文件损坏
    echo.
    echo [建议] 重新安装Maven
    pause
    exit /b 1
) else (
    echo [成功] Maven版本检查通过
)

REM 检查Maven配置文件
echo.
echo [步骤3] 检查Maven配置文件...
if exist "%USERPROFILE%\.m2\settings.xml" (
    echo [信息] 找到用户级Maven配置文件
) else (
    echo [信息] 未找到用户级Maven配置文件（这是正常的）
)

if exist "%MAVEN_HOME%\conf\settings.xml" (
    echo [信息] 找到全局Maven配置文件
) else (
    echo [警告] 未找到全局Maven配置文件
)

REM 检查Maven本地仓库
echo.
echo [步骤4] 检查Maven本地仓库...
if exist "%USERPROFILE%\.m2\repository" (
    echo [信息] 找到Maven本地仓库
    dir "%USERPROFILE%\.m2\repository" | find "个文件"
) else (
    echo [信息] Maven本地仓库不存在（首次使用时会自动创建）
)

REM 测试Maven基本功能
echo.
echo [步骤5] 测试Maven基本功能...
echo [信息] 正在测试Maven依赖解析...
mvn help:effective-settings >nul 2>&1
if %errorlevel% neq 0 (
    echo [警告] Maven配置测试失败
    echo [建议] 检查网络连接和Maven配置
) else (
    echo [成功] Maven配置测试通过
)

echo.
echo ========================================
echo [总结] Maven环境检测完成
echo [状态] Maven环境正常
echo [建议] 可以正常使用Maven命令
echo ========================================
echo.
pause 