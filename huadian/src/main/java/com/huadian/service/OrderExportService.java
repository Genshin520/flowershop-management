package com.huadian.service;

import com.huadian.entity.Order;
import com.huadian.entity.OrderItem;
import com.huadian.repository.OrderRepository;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.time.format.DateTimeFormatter;
import java.util.List;

@Service
public class OrderExportService {
    
    @Autowired
    private OrderRepository orderRepository;
    
    private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
    
    /**
     * 导出订单为Excel格式
     */
    public byte[] exportOrdersToExcel(List<Order> orders) throws IOException {
        try (Workbook workbook = new XSSFWorkbook()) {
            Sheet sheet = workbook.createSheet("订单列表");
            
            // 创建标题行样式
            CellStyle headerStyle = createHeaderStyle(workbook);
            
            // 创建标题行
            Row headerRow = sheet.createRow(0);
            String[] headers = {"订单ID", "订单号", "客户姓名", "联系电话", "地址", "总金额", "状态", "创建时间", "更新时间"};
            
            for (int i = 0; i < headers.length; i++) {
                Cell cell = headerRow.createCell(i);
                cell.setCellValue(headers[i]);
                cell.setCellStyle(headerStyle);
            }
            
            // 填充数据
            int rowNum = 1;
            for (Order order : orders) {
                Row row = sheet.createRow(rowNum++);
                row.createCell(0).setCellValue(order.getId());
                row.createCell(1).setCellValue(order.getOrderNumber());
                row.createCell(2).setCellValue(order.getCustomerName());
                row.createCell(3).setCellValue(order.getCustomerPhone() != null ? order.getCustomerPhone() : "");
                row.createCell(4).setCellValue(order.getCustomerAddress() != null ? order.getCustomerAddress() : "");
                row.createCell(5).setCellValue(order.getTotalAmount().doubleValue());
                row.createCell(6).setCellValue(order.getStatus().getDescription());
                row.createCell(7).setCellValue(order.getCreatedTime() != null ? order.getCreatedTime().format(DATE_FORMATTER) : "");
                row.createCell(8).setCellValue(order.getUpdatedTime() != null ? order.getUpdatedTime().format(DATE_FORMATTER) : "");
            }
            
            // 自动调整列宽
            for (int i = 0; i < headers.length; i++) {
                sheet.autoSizeColumn(i);
            }
            
            // 输出到字节数组
            ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
            workbook.write(outputStream);
            return outputStream.toByteArray();
        }
    }
    
    /**
     * 导出单个订单详情为Excel
     */
    public byte[] exportOrderDetailToExcel(Order order) throws IOException {
        try (Workbook workbook = new XSSFWorkbook()) {
            Sheet sheet = workbook.createSheet("订单详情");
            
            CellStyle headerStyle = createHeaderStyle(workbook);
            CellStyle titleStyle = createTitleStyle(workbook);
            
            int rowNum = 0;
            
            // 订单基本信息
            Row titleRow = sheet.createRow(rowNum++);
            Cell titleCell = titleRow.createCell(0);
            titleCell.setCellValue("订单基本信息");
            titleCell.setCellStyle(titleStyle);
            
            rowNum = createOrderInfoRows(sheet, order, rowNum);
            rowNum++; // 空行
            
            // 订单项信息
            Row itemsTitleRow = sheet.createRow(rowNum++);
            Cell itemsTitleCell = itemsTitleRow.createCell(0);
            itemsTitleCell.setCellValue("订单项详情");
            itemsTitleCell.setCellStyle(titleStyle);
            
            // 订单项表头
            Row itemsHeaderRow = sheet.createRow(rowNum++);
            String[] itemHeaders = {"商品ID", "商品名称", "数量", "单价", "小计"};
            for (int i = 0; i < itemHeaders.length; i++) {
                Cell cell = itemsHeaderRow.createCell(i);
                cell.setCellValue(itemHeaders[i]);
                cell.setCellStyle(headerStyle);
            }
            
            // 订单项数据
            if (order.getOrderItems() != null) {
                for (OrderItem item : order.getOrderItems()) {
                    Row row = sheet.createRow(rowNum++);
                    row.createCell(0).setCellValue(item.getFlower() != null ? item.getFlower().getId() : 0L);
                    row.createCell(1).setCellValue(item.getFlower() != null ? item.getFlower().getName() : "花卉商品");
                    row.createCell(2).setCellValue(item.getQuantity());
                    row.createCell(3).setCellValue(item.getUnitPrice().doubleValue());
                    row.createCell(4).setCellValue(item.getTotalPrice().doubleValue());
                }
            }
            
            // 自动调整列宽
            for (int i = 0; i < 10; i++) {
                sheet.autoSizeColumn(i);
            }
            
            ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
            workbook.write(outputStream);
            return outputStream.toByteArray();
        }
    }
    
    private int createOrderInfoRows(Sheet sheet, Order order, int startRow) {
        String[][] orderInfo = {
            {"订单ID", order.getId().toString()},
            {"订单号", order.getOrderNumber()},
            {"客户姓名", order.getCustomerName()},
            {"联系电话", order.getCustomerPhone() != null ? order.getCustomerPhone() : ""},
            {"客户地址", order.getCustomerAddress() != null ? order.getCustomerAddress() : ""},
            {"总金额", "¥" + order.getTotalAmount().toString()},
            {"订单状态", order.getStatus().getDescription()},
            {"创建时间", order.getCreatedTime() != null ? order.getCreatedTime().format(DATE_FORMATTER) : ""},
            {"更新时间", order.getUpdatedTime() != null ? order.getUpdatedTime().format(DATE_FORMATTER) : ""}
        };
        
        for (String[] info : orderInfo) {
            Row row = sheet.createRow(startRow++);
            row.createCell(0).setCellValue(info[0]);
            row.createCell(1).setCellValue(info[1]);
        }
        
        return startRow;
    }
    
    private CellStyle createHeaderStyle(Workbook workbook) {
        CellStyle style = workbook.createCellStyle();
        Font font = workbook.createFont();
        font.setBold(true);
        font.setColor(IndexedColors.WHITE.getIndex());
        style.setFont(font);
        style.setFillForegroundColor(IndexedColors.BLUE.getIndex());
        style.setFillPattern(FillPatternType.SOLID_FOREGROUND);
        style.setBorderBottom(BorderStyle.THIN);
        style.setBorderTop(BorderStyle.THIN);
        style.setBorderRight(BorderStyle.THIN);
        style.setBorderLeft(BorderStyle.THIN);
        return style;
    }
    
    private CellStyle createTitleStyle(Workbook workbook) {
        CellStyle style = workbook.createCellStyle();
        Font font = workbook.createFont();
        font.setBold(true);
        font.setFontHeightInPoints((short) 14);
        style.setFont(font);
        return style;
    }
} 