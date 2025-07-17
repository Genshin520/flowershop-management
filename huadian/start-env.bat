@echo off
chcp 65001 >nul
title 花店管理系统环境启动器

echo ========================================
echo           花店管理系统环境启动器
echo ========================================
echo.

echo [信息] 正在检测环境变量...
echo.

REM 显示当前PATH环境变量
echo [调试] 当前PATH环境变量:
echo %PATH%
echo.

REM 尝试查找Maven
echo [信息] 正在查找Maven...
where mvn
if %errorlevel% neq 0 (
    echo [警告] 在PATH中未找到Maven
    echo [信息] 尝试直接调用Maven...
) else (
    echo [成功] 在PATH中找到Maven
)

echo.
echo [信息] 正在启动应用...
echo [提示] 如果Maven命令失败，请手动在命令行中运行: mvn spring-boot:run
echo.

REM 尝试启动应用
call mvn spring-boot:run

if %errorlevel% neq 0 (
    echo.
    echo [错误] Maven命令执行失败！
    echo [建议] 请在命令行中手动执行以下命令:
    echo [命令] mvn spring-boot:run
    echo.
    echo [原因] 批处理文件可能无法正确继承环境变量
    echo [解决] 请打开命令提示符，导航到项目目录，然后运行mvn命令
    echo.
    pause
    exit /b 1
) else (
    echo.
    echo [成功] 应用启动成功！
    echo [地址] http://localhost:8080
)

echo.
pause 