// 全局变量
let flowers = [];
let orders = [];
let flowerRowCount = 1;

// 页面加载完成后初始化
document.addEventListener('DOMContentLoaded', function() {
    loadFlowers();
    loadOrders();
    loadDashboard();
});

// 显示花卉管理页面
function showFlowers() {
    hideAllSections();
    document.getElementById('flowersSection').style.display = 'block';
    loadFlowers();
}

// 显示订单管理页面
function showOrders() {
    hideAllSections();
    document.getElementById('ordersSection').style.display = 'block';
    loadOrders();
}

// 显示数据统计页面
function showDashboard() {
    hideAllSections();
    document.getElementById('dashboardSection').style.display = 'block';
    loadDashboard();
}

// 隐藏所有区域
function hideAllSections() {
    document.getElementById('flowersSection').style.display = 'none';
    document.getElementById('ordersSection').style.display = 'none';
    document.getElementById('dashboardSection').style.display = 'none';
    document.querySelector('.hero-section').style.display = 'none';
}

// 加载花卉数据
async function loadFlowers() {
    try {
        const response = await fetch('/api/flowers');
        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }
        const data = await response.json();
        // 确保data是数组
        flowers = Array.isArray(data) ? data : [];
        displayFlowers(flowers);
    } catch (error) {
        console.error('加载花卉数据失败:', error);
        showAlert('加载花卉数据失败', 'danger');
        // 确保flowers是空数组
        flowers = [];
        displayFlowers(flowers);
    }
}

// 显示花卉列表
function displayFlowers(flowersToShow) {
    const container = document.getElementById('flowersContainer');
    if (!container) {
        console.error('找不到flowersContainer元素');
        return;
    }
    
    container.innerHTML = '';

    // 确保flowersToShow是数组
    if (!Array.isArray(flowersToShow)) {
        console.error('flowersToShow不是数组:', flowersToShow);
        flowersToShow = [];
    }

    if (flowersToShow.length === 0) {
        container.innerHTML = '<div class="col-12 text-center text-muted"><p>暂无花卉数据</p></div>';
        return;
    }

    flowersToShow.forEach(flower => {
        const card = document.createElement('div');
        card.className = 'col-md-4 mb-4';
        card.innerHTML = `
            <div class="card h-100">
                <img src="${flower.imageUrl || 'https://via.placeholder.com/300x200?text=花卉图片'}" 
                     class="card-img-top flower-image" alt="${flower.name}">
                <div class="card-body">
                    <h5 class="card-title">${flower.name || '未命名花卉'}</h5>
                    <p class="card-text">${flower.description || '暂无描述'}</p>
                    <p class="price">¥${flower.price || '0.00'}</p>
                    <p class="stock">库存: ${flower.stock || 0}</p>
                    <p class="text-muted">分类: ${flower.category || '未分类'}</p>
                </div>
                <div class="card-footer">
                    <div class="btn-group w-100" role="group">
                        <button class="btn btn-outline-primary" onclick="editFlower(${flower.id})">
                            <i class="fas fa-edit"></i> 编辑
                        </button>
                        <button class="btn btn-outline-danger" onclick="deleteFlower(${flower.id})">
                            <i class="fas fa-trash"></i> 删除
                        </button>
                    </div>
                </div>
            </div>
        `;
        container.appendChild(card);
    });
}

// 搜索花卉
async function searchFlowers() {
    const searchTerm = document.getElementById('searchInput').value.trim();
    if (searchTerm === '') {
        displayFlowers(flowers);
        return;
    }

    try {
        const response = await fetch(`/api/flowers/search?name=${encodeURIComponent(searchTerm)}`);
        const searchResults = await response.json();
        displayFlowers(searchResults);
    } catch (error) {
        console.error('搜索花卉失败:', error);
        showAlert('搜索花卉失败', 'danger');
    }
}

// 显示添加花卉模态框
function showAddFlowerModal() {
    document.getElementById('addFlowerForm').reset();
    const modal = new bootstrap.Modal(document.getElementById('addFlowerModal'));
    modal.show();
}

// 添加花卉
async function addFlower() {
    const flowerData = {
        name: document.getElementById('flowerName').value,
        description: document.getElementById('flowerDescription').value,
        price: parseFloat(document.getElementById('flowerPrice').value),
        stock: parseInt(document.getElementById('flowerStock').value),
        category: document.getElementById('flowerCategory').value,
        imageUrl: document.getElementById('flowerImageUrl').value
    };

    try {
        const response = await fetch('/api/flowers', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(flowerData)
        });

        if (response.ok) {
            const newFlower = await response.json();
            flowers.push(newFlower);
            displayFlowers(flowers);
            bootstrap.Modal.getInstance(document.getElementById('addFlowerModal')).hide();
            showAlert('花卉添加成功', 'success');
        } else {
            showAlert('添加花卉失败', 'danger');
        }
    } catch (error) {
        console.error('添加花卉失败:', error);
        showAlert('添加花卉失败', 'danger');
    }
}

// 编辑花卉
function editFlower(id) {
    const flower = flowers.find(f => f.id === id);
    if (flower) {
        document.getElementById('flowerName').value = flower.name;
        document.getElementById('flowerDescription').value = flower.description || '';
        document.getElementById('flowerPrice').value = flower.price;
        document.getElementById('flowerStock').value = flower.stock;
        document.getElementById('flowerCategory').value = flower.category || '';
        document.getElementById('flowerImageUrl').value = flower.imageUrl || '';
        
        // 修改模态框标题和按钮
        document.querySelector('#addFlowerModal .modal-title').textContent = '编辑花卉';
        document.querySelector('#addFlowerModal .btn-primary').textContent = '更新';
        document.querySelector('#addFlowerModal .btn-primary').onclick = () => updateFlower(id);
        
        const modal = new bootstrap.Modal(document.getElementById('addFlowerModal'));
        modal.show();
    }
}

// 更新花卉
async function updateFlower(id) {
    const flowerData = {
        name: document.getElementById('flowerName').value,
        description: document.getElementById('flowerDescription').value,
        price: parseFloat(document.getElementById('flowerPrice').value),
        stock: parseInt(document.getElementById('flowerStock').value),
        category: document.getElementById('flowerCategory').value,
        imageUrl: document.getElementById('flowerImageUrl').value
    };

    try {
        const response = await fetch(`/api/flowers/${id}`, {
            method: 'PUT',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(flowerData)
        });

        if (response.ok) {
            const updatedFlower = await response.json();
            const index = flowers.findIndex(f => f.id === id);
            if (index !== -1) {
                flowers[index] = updatedFlower;
                displayFlowers(flowers);
            }
            bootstrap.Modal.getInstance(document.getElementById('addFlowerModal')).hide();
            showAlert('花卉更新成功', 'success');
            
            // 重置模态框
            document.querySelector('#addFlowerModal .modal-title').textContent = '添加花卉';
            document.querySelector('#addFlowerModal .btn-primary').textContent = '添加';
            document.querySelector('#addFlowerModal .btn-primary').onclick = addFlower;
        } else {
            showAlert('更新花卉失败', 'danger');
        }
    } catch (error) {
        console.error('更新花卉失败:', error);
        showAlert('更新花卉失败', 'danger');
    }
}

// 删除花卉
async function deleteFlower(id) {
    if (confirm('确定要删除这个花卉吗？')) {
        try {
            const response = await fetch(`/api/flowers/${id}`, {
                method: 'DELETE'
            });

            if (response.ok) {
                flowers = flowers.filter(f => f.id !== id);
                displayFlowers(flowers);
                showAlert('花卉删除成功', 'success');
            } else {
                showAlert('删除花卉失败', 'danger');
            }
        } catch (error) {
            console.error('删除花卉失败:', error);
            showAlert('删除花卉失败', 'danger');
        }
    }
}

// 加载订单数据
async function loadOrders() {
    try {
        const response = await fetch('/api/orders');
        if (!response.ok) {
            throw new Error(`HTTP error! status: ${response.status}`);
        }
        const data = await response.json();
        // 确保data是数组
        orders = Array.isArray(data) ? data : [];
        displayOrders(orders);
    } catch (error) {
        console.error('加载订单数据失败:', error);
        showAlert('加载订单数据失败', 'danger');
        // 确保orders是空数组
        orders = [];
        displayOrders(orders);
    }
}

// 显示订单列表
function displayOrders(ordersToShow) {
    const tbody = document.getElementById('ordersTableBody');
    if (!tbody) {
        console.error('找不到ordersTableBody元素');
        return;
    }
    
    tbody.innerHTML = '';

    // 确保ordersToShow是数组
    if (!Array.isArray(ordersToShow)) {
        console.error('ordersToShow不是数组:', ordersToShow);
        ordersToShow = [];
    }

    if (ordersToShow.length === 0) {
        tbody.innerHTML = '<tr><td colspan="7" class="text-center text-muted">暂无订单数据</td></tr>';
        return;
    }

    ordersToShow.forEach(order => {
        const row = document.createElement('tr');
        row.innerHTML = `
            <td>${order.orderNumber || '-'}</td>
            <td>${order.customerName || '-'}</td>
            <td>${order.customerPhone || '-'}</td>
            <td>¥${order.totalAmount || '0.00'}</td>
            <td><span class="badge bg-${getStatusBadgeColor(order.status)}">${getStatusText(order.status)}</span></td>
            <td>${formatDateTime(order.createdTime)}</td>
            <td>
                <div class="btn-group btn-group-sm" role="group">
                    <button class="btn btn-outline-primary" onclick="viewOrder(${order.id})">
                        <i class="fas fa-eye"></i>
                    </button>
                    <button class="btn btn-outline-success" onclick="updateOrderStatus(${order.id})">
                        <i class="fas fa-edit"></i>
                    </button>
                    <button class="btn btn-outline-danger" onclick="deleteOrder(${order.id})">
                        <i class="fas fa-trash"></i>
                    </button>
                </div>
            </td>
        `;
        tbody.appendChild(row);
    });
}

// 获取状态徽章颜色
function getStatusBadgeColor(status) {
    if (!status) {
        return 'secondary';
    }
    
    switch (status.toUpperCase()) {
        case 'PENDING': return 'warning';
        case 'CONFIRMED': return 'info';
        case 'SHIPPED': return 'primary';
        case 'DELIVERED': return 'success';
        case 'CANCELLED': return 'danger';
        default: return 'secondary';
    }
}

// 获取状态文本
function getStatusText(status) {
    if (!status) {
        return '未知状态';
    }
    
    switch (status.toUpperCase()) {
        case 'PENDING': return '待处理';
        case 'CONFIRMED': return '已确认';
        case 'SHIPPED': return '已发货';
        case 'DELIVERED': return '已送达';
        case 'CANCELLED': return '已取消';
        default: return status;
    }
}

// 格式化日期时间
function formatDateTime(dateTimeString) {
    if (!dateTimeString) {
        return '-';
    }
    
    try {
        const date = new Date(dateTimeString);
        if (isNaN(date.getTime())) {
            return '-';
        }
        return date.toLocaleString('zh-CN');
    } catch (error) {
        console.error('日期格式化失败:', error);
        return '-';
    }
}

// 显示创建订单模态框
function showCreateOrderModal() {
    document.getElementById('createOrderForm').reset();
    loadFlowerOptions();
    const modal = new bootstrap.Modal(document.getElementById('createOrderModal'));
    modal.show();
}

// 加载花卉选项
async function loadFlowerOptions() {
    try {
        const response = await fetch('/api/flowers/available');
        const availableFlowers = await response.json();
        
        const selects = document.querySelectorAll('select[id^="orderFlower"]');
        selects.forEach(select => {
            select.innerHTML = '<option value="">选择花卉</option>';
            availableFlowers.forEach(flower => {
                const option = document.createElement('option');
                option.value = flower.id;
                option.textContent = `${flower.name} - ¥${flower.price} (库存: ${flower.stock})`;
                select.appendChild(option);
            });
        });
    } catch (error) {
        console.error('加载花卉选项失败:', error);
    }
}

// 添加花卉行
function addFlowerRow() {
    flowerRowCount++;
    const container = document.getElementById('orderFlowersContainer');
    const newRow = document.createElement('div');
    newRow.className = 'row mb-2';
    newRow.innerHTML = `
        <div class="col-md-6">
            <select class="form-select" id="orderFlower${flowerRowCount}">
                <option value="">选择花卉</option>
            </select>
        </div>
        <div class="col-md-4">
            <input type="number" class="form-control" id="orderQuantity${flowerRowCount}" placeholder="数量" min="1">
        </div>
        <div class="col-md-2">
            <button type="button" class="btn btn-outline-danger" onclick="removeFlowerRow(this)">
                <i class="fas fa-trash"></i>
            </button>
        </div>
    `;
    container.appendChild(newRow);
    
    // 为新行加载花卉选项
    const newSelect = document.getElementById(`orderFlower${flowerRowCount}`);
    loadFlowerOptions();
}

// 移除花卉行
function removeFlowerRow(button) {
    button.closest('.row').remove();
}

// 创建订单
async function createOrder() {
    const orderItems = [];
    const rows = document.querySelectorAll('#orderFlowersContainer .row');
    
    for (let i = 0; i < rows.length; i++) {
        const flowerId = document.getElementById(`orderFlower${i + 1}`)?.value;
        const quantity = document.getElementById(`orderQuantity${i + 1}`)?.value;
        
        if (flowerId && quantity) {
            const flower = flowers.find(f => f.id == flowerId);
            if (flower) {
                orderItems.push({
                    flower: { id: parseInt(flowerId) },
                    quantity: parseInt(quantity)
                });
            }
        }
    }
    
    if (orderItems.length === 0) {
        showAlert('请至少选择一种花卉', 'warning');
        return;
    }
    
    const orderData = {
        customerName: document.getElementById('customerName').value,
        customerPhone: document.getElementById('customerPhone').value,
        customerAddress: document.getElementById('customerAddress').value,
        orderItems: orderItems
    };
    
    try {
        const response = await fetch('/api/orders', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(orderData)
        });
        
        if (response.ok) {
            const newOrder = await response.json();
            orders.unshift(newOrder);
            displayOrders(orders);
            bootstrap.Modal.getInstance(document.getElementById('createOrderModal')).hide();
            showAlert('订单创建成功', 'success');
            loadFlowers(); // 重新加载花卉以更新库存
        } else {
            showAlert('创建订单失败', 'danger');
        }
    } catch (error) {
        console.error('创建订单失败:', error);
        showAlert('创建订单失败', 'danger');
    }
}

// 更新订单状态
async function updateOrderStatus(orderId) {
    const status = prompt('请输入新状态 (PENDING/CONFIRMED/SHIPPED/DELIVERED/CANCELLED):');
    if (!status) return;
    
    try {
        const response = await fetch(`/api/orders/${orderId}/status?status=${status}`, {
            method: 'PUT'
        });
        
        if (response.ok) {
            const updatedOrder = await response.json();
            const index = orders.findIndex(o => o.id === orderId);
            if (index !== -1) {
                orders[index] = updatedOrder;
                displayOrders(orders);
            }
            showAlert('订单状态更新成功', 'success');
        } else {
            showAlert('更新订单状态失败', 'danger');
        }
    } catch (error) {
        console.error('更新订单状态失败:', error);
        showAlert('更新订单状态失败', 'danger');
    }
}

// 删除订单
async function deleteOrder(orderId) {
    if (confirm('确定要删除这个订单吗？')) {
        try {
            const response = await fetch(`/api/orders/${orderId}`, {
                method: 'DELETE'
            });
            
            if (response.ok) {
                orders = orders.filter(o => o.id !== orderId);
                displayOrders(orders);
                showAlert('订单删除成功', 'success');
            } else {
                showAlert('删除订单失败', 'danger');
            }
        } catch (error) {
            console.error('删除订单失败:', error);
            showAlert('删除订单失败', 'danger');
        }
    }
}

// 加载仪表板数据
async function loadDashboard() {
    try {
        // 加载统计数据
        document.getElementById('totalFlowers').textContent = flowers.length;
        document.getElementById('totalOrders').textContent = orders.length;
        
        // 计算今日销售额
        const today = new Date();
        const todayOrders = orders.filter(order => {
            const orderDate = new Date(order.createdTime);
            return orderDate.toDateString() === today.toDateString();
        });
        
        const todaySales = todayOrders.reduce((sum, order) => sum + parseFloat(order.totalAmount), 0);
        document.getElementById('todaySales').textContent = `¥${todaySales.toFixed(2)}`;
        
        // 计算库存预警
        const lowStockFlowers = flowers.filter(flower => flower.stock < 10);
        document.getElementById('lowStock').textContent = lowStockFlowers.length;
        
    } catch (error) {
        console.error('加载仪表板数据失败:', error);
    }
}

// 显示提示信息
function showAlert(message, type) {
    const alertDiv = document.createElement('div');
    alertDiv.className = `alert alert-${type} alert-dismissible fade show position-fixed`;
    alertDiv.style.cssText = 'top: 20px; right: 20px; z-index: 9999; min-width: 300px;';
    alertDiv.innerHTML = `
        ${message}
        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
    `;
    
    document.body.appendChild(alertDiv);
    
    // 3秒后自动消失
    setTimeout(() => {
        if (alertDiv.parentNode) {
            alertDiv.remove();
        }
    }, 3000);
} 