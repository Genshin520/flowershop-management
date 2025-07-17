package com.huadian.service;

import com.huadian.entity.Order;
import com.huadian.entity.OrderItem;
import com.huadian.entity.Flower;
import com.huadian.repository.OrderRepository;
import com.huadian.repository.FlowerRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.math.BigDecimal;
import java.util.ArrayList;

@Service
public class OrderService {
    
    @Autowired
    private OrderRepository orderRepository;
    
    @Autowired
    private FlowerRepository flowerRepository;
    
    public List<Order> getAllOrders() {
        try {
            return orderRepository.findAll();
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }
    
    public Optional<Order> getOrderById(Long id) {
        return orderRepository.findById(id);
    }
    
    public Optional<Order> getOrderByOrderNumber(String orderNumber) {
        return orderRepository.findByOrderNumber(orderNumber);
    }
    
    public Order createOrder(Order order) {
        // 生成订单号
        if (order.getOrderNumber() == null || order.getOrderNumber().trim().isEmpty()) {
            order.setOrderNumber(generateOrderNumber());
        }
        
        // 设置默认状态
        if (order.getStatus() == null) {
            order.setStatus(Order.OrderStatus.PENDING);
        }
        
        // 设置创建时间
        if (order.getCreatedTime() == null) {
            order.setCreatedTime(LocalDateTime.now());
        }
        
        // 自动计算金额
        BigDecimal totalAmount = BigDecimal.ZERO;
        if (order.getOrderItems() != null) {
            for (OrderItem item : order.getOrderItems()) {
                if (item.getFlower() == null || item.getFlower().getId() == null) {
                    throw new RuntimeException("订单项缺少花卉ID");
                }
                Flower flower = flowerRepository.findById(item.getFlower().getId())
                        .orElseThrow(() -> new RuntimeException("找不到花卉ID: " + item.getFlower().getId()));
                item.setFlower(flower);
                item.setUnitPrice(flower.getPrice());
                item.setTotalPrice(flower.getPrice().multiply(BigDecimal.valueOf(item.getQuantity())));
                item.setOrder(order); // 维护双向关系
                totalAmount = totalAmount.add(item.getTotalPrice());
            }
        }
        order.setTotalAmount(totalAmount);
        return orderRepository.save(order);
    }
    
    public Order updateOrderStatus(Long id, Order.OrderStatus status) {
        Optional<Order> optionalOrder = orderRepository.findById(id);
        if (optionalOrder.isPresent()) {
            Order order = optionalOrder.get();
            order.setStatus(status);
            order.setUpdatedTime(LocalDateTime.now());
            return orderRepository.save(order);
        }
        throw new RuntimeException("订单不存在: " + id);
    }
    
    public List<Order> getOrdersByStatus(Order.OrderStatus status) {
        return orderRepository.findByStatus(status);
    }
    
    public List<Order> searchOrdersByCustomerName(String customerName) {
        return orderRepository.findByCustomerNameContainingIgnoreCase(customerName);
    }
    
    public List<Order> getOrdersByDateRange(LocalDateTime startDate, LocalDateTime endDate) {
        return orderRepository.findByDateRange(startDate, endDate);
    }
    
    public void deleteOrder(Long id) {
        orderRepository.deleteById(id);
    }
    
    private String generateOrderNumber() {
        // 生成格式: ORD + 时间戳 + 随机数
        String timestamp = String.valueOf(System.currentTimeMillis());
        String random = UUID.randomUUID().toString().substring(0, 8);
        return "ORD" + timestamp.substring(timestamp.length() - 8) + random;
    }
} 