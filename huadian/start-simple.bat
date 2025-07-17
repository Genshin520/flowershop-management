@echo off
echo Starting Flower Shop Management System...
echo.

echo Checking Java...
java -version >nul 2>&1
if %errorlevel% neq 0 (
    echo Error: Java not found!
    echo Please install Java 8 or higher
    pause
    exit /b 1
)

echo Checking Maven...
mvn -version >nul 2>&1
if %errorlevel% neq 0 (
    echo Error: Maven not found!
    echo Please install Maven 3.6 or higher
    pause
    exit /b 1
)

echo Starting application...
echo Please wait, this may take a few minutes...
echo.

REM 使用call命令确保正确调用Maven
call mvn spring-boot:run

echo.
echo Application started successfully!
echo Please visit: http://localhost:8080
pause 