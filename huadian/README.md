# 花店管理系统

一个基于Spring Boot和MySQL的花店管理系统，提供花卉管理、订单管理等功能。

## 技术栈

- **后端**: Spring Boot 2.7.14
- **数据库**: MySQL 8.0+
- **前端**: HTML + JavaScript
- **构建工具**: Maven 3.6+
- **Java版本**: 17+

## 系统要求

- Java 17 或更高版本
- MySQL 8.0 或更高版本
- Maven 3.6 或更高版本

## 快速开始

### 1. 环境准备

确保已安装以下软件：
- Java 17+
- MySQL 8.0+
- Maven 3.6+

### 2. 数据库设置

#### 方法一：使用脚本（推荐）

**Windows CMD:**
```bash
setup-database.bat
```

**Windows PowerShell:**
```powershell
.\setup-database.ps1
```

#### 方法二：手动设置

1. 连接到MySQL：
```bash
mysql -u root -p
```

2. 创建数据库：
```sql
CREATE DATABASE IF NOT EXISTS flower_shop CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

3. 初始化数据库结构：
```bash
mysql -u root -p flower_shop < src/main/resources/db/init.sql
```

### 3. 启动应用

#### 方法一：使用Maven命令
```bash
mvn spring-boot:run
```

#### 方法二：使用启动脚本

**Windows CMD:**
```bash
start.bat
```

**Windows PowerShell:**
```powershell
.\start.ps1
```

### 4. 访问系统

应用启动后，在浏览器中访问：
```
http://localhost:8080
```

## 功能特性

### 花卉管理
- 查看花卉列表
- 添加新花卉
- 编辑花卉信息
- 删除花卉
- 库存管理

### 订单管理
- 创建新订单
- 查看订单列表
- 更新订单状态
- 订单详情查看

### 系统功能
- 响应式Web界面
- RESTful API
- 数据持久化
- 实时库存更新

## 项目结构

```
huadian/
├── src/
│   ├── main/
│   │   ├── java/com/huadian/
│   │   │   ├── config/          # 配置类
│   │   │   ├── controller/      # 控制器
│   │   │   ├── entity/          # 实体类
│   │   │   ├── repository/      # 数据访问层
│   │   │   ├── service/         # 业务逻辑层
│   │   │   └── FlowerShopApplication.java
│   │   └── resources/
│   │       ├── application.yml  # 应用配置
│   │       ├── db/              # 数据库脚本
│   │       └── static/          # 静态资源
├── pom.xml                      # Maven配置
├── README.md                    # 项目说明
└── 启动说明.md                  # 启动说明
```

## API接口

### 花卉管理
- `GET /api/flowers` - 获取花卉列表
- `GET /api/flowers/{id}` - 获取单个花卉
- `POST /api/flowers` - 创建新花卉
- `PUT /api/flowers/{id}` - 更新花卉信息
- `DELETE /api/flowers/{id}` - 删除花卉

### 订单管理
- `GET /api/orders` - 获取订单列表
- `GET /api/orders/{id}` - 获取单个订单
- `POST /api/orders` - 创建新订单
- `PUT /api/orders/{id}` - 更新订单状态

## 配置说明

### 数据库配置
在 `src/main/resources/application.yml` 中配置数据库连接：

```yaml
spring:
  datasource:
    url: jdbc:mysql://localhost:3306/flower_shop?useSSL=false&serverTimezone=UTC
    username: root
    password: your_password
```

### 应用配置
- 端口：8080
- 字符编码：UTF-8
- 时区：UTC

## 常见问题

### 1. 编译错误
如果遇到编译错误，请确保：
- Java版本为17或更高
- Maven版本为3.6或更高
- 所有依赖都已正确下载

### 2. 数据库连接失败
如果数据库连接失败，请检查：
- MySQL服务是否启动
- 数据库用户名和密码是否正确
- 数据库是否已创建

### 3. 端口占用
如果8080端口被占用，可以在 `application.yml` 中修改端口：
```yaml
server:
  port: 8081
```

## 开发说明

### 添加新功能
1. 在 `entity` 包中创建实体类
2. 在 `repository` 包中创建数据访问接口
3. 在 `service` 包中实现业务逻辑
4. 在 `controller` 包中创建API接口
5. 在前端页面中添加相应的UI组件

### 数据库迁移
如需修改数据库结构，请：
1. 更新实体类注解
2. 修改 `init.sql` 脚本
3. 重新执行数据库初始化

## 许可证

本项目采用 MIT 许可证。

## 联系方式

如有问题或建议，请提交 Issue 或联系开发团队。 