-- 创建数据库
CREATE DATABASE IF NOT EXISTS flower_shop CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- 使用数据库
USE flower_shop;

-- 创建花卉表
CREATE TABLE IF NOT EXISTS flowers (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    stock INT NOT NULL,
    image_url VARCHAR(200),
    category VARCHAR(50),
    category_id BIGINT,
    created_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 创建分类表
CREATE TABLE IF NOT EXISTS category (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
    description VARCHAR(200)
);

-- 修改flowers表，增加category_id外键（如已存在则跳过）
ALTER TABLE flowers ADD CONSTRAINT fk_flowers_category FOREIGN KEY (category_id) REFERENCES category(id);

-- 创建订单表
CREATE TABLE IF NOT EXISTS orders (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    order_number VARCHAR(50) NOT NULL UNIQUE,
    customer_name VARCHAR(100) NOT NULL,
    customer_address TEXT,
    customer_phone VARCHAR(20),
    total_amount DECIMAL(10,2) NOT NULL,
    status ENUM('PENDING', 'CONFIRMED', 'SHIPPED', 'DELIVERED', 'CANCELLED') DEFAULT 'PENDING',
    created_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_time DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 创建订单项表
CREATE TABLE IF NOT EXISTS order_items (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    order_id BIGINT NOT NULL,
    flower_id BIGINT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    total_price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    FOREIGN KEY (flower_id) REFERENCES flowers(id) ON DELETE CASCADE
);

-- 插入示例花卉数据
INSERT INTO flowers (name, description, price, stock, category, image_url) VALUES
('红玫瑰', '经典红玫瑰，象征热情与爱情', 15.99, 100, '玫瑰', 'https://images.unsplash.com/photo-1549465220-1a8b9238cd48?w=300&h=200&fit=crop'),
('白百合', '纯洁的白百合，适合各种场合', 12.50, 80, '百合', 'https://images.unsplash.com/photo-1589244159943-460088ed5c1b?w=300&h=200&fit=crop'),
('向日葵', '阳光般的向日葵，给人温暖感觉', 8.99, 120, '向日葵', 'https://images.unsplash.com/photo-1470509037663-253afd7f0f51?w=300&h=200&fit=crop'),
('粉玫瑰', '温柔的粉玫瑰，表达浪漫情感', 18.50, 90, '玫瑰', 'https://images.unsplash.com/photo-1549465220-1a8b9238cd48?w=300&h=200&fit=crop'),
('康乃馨', '母亲节首选，表达感恩之情', 10.99, 150, '康乃馨', 'https://images.unsplash.com/photo-1589244159943-460088ed5c1b?w=300&h=200&fit=crop'),
('郁金香', '优雅的郁金香，春季花卉代表', 14.99, 70, '郁金香', 'https://images.unsplash.com/photo-1470509037663-253afd7f0f51?w=300&h=200&fit=crop'),
('紫罗兰', '神秘的紫罗兰，独特的花香', 16.50, 60, '紫罗兰', 'https://images.unsplash.com/photo-1549465220-1a8b9238cd48?w=300&h=200&fit=crop'),
('满天星', '小巧的满天星，完美的配花', 6.99, 200, '满天星', 'https://images.unsplash.com/photo-1589244159943-460088ed5c1b?w=300&h=200&fit=crop');

-- 创建索引
CREATE INDEX idx_flowers_category ON flowers(category);
CREATE INDEX idx_flowers_name ON flowers(name);
CREATE INDEX idx_orders_status ON orders(status);
CREATE INDEX idx_orders_customer_name ON orders(customer_name);
CREATE INDEX idx_orders_created_time ON orders(created_time);

-- 用户表
CREATE TABLE IF NOT EXISTS users (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(100) NOT NULL,
    role VARCHAR(20) NOT NULL DEFAULT 'USER',
    created_time DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- 初始管理员账户（密码为admin123的BCrypt加密值）
INSERT INTO users (username, password, role) VALUES (
    'root',
    'tzz040911',
    'ADMIN'
) ON DUPLICATE KEY UPDATE username=username; 