x<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Quản lý Sản phẩm | FoodStore Admin</title>
                <!-- Google Fonts -->
                <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap"
                    rel="stylesheet">
                <!-- Bootstrap 5 -->
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
                <!-- Bootstrap Icons -->
                <link rel="stylesheet"
                    href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">

                <style>
                    :root {
                        --primary: #4f46e5;
                        --primary-light: #818cf8;
                        --slate-50: #f8fafc;
                        --slate-100: #f1f5f9;
                        --slate-200: #e2e8f0;
                        --slate-700: #334155;
                        --slate-800: #1e293b;
                        --slate-900: #0f172a;
                    }

                    body {
                        font-family: 'Inter', sans-serif;
                        background-color: #f3f4f6;
                        color: var(--slate-800);
                        min-height: 100vh;
                    }

                    .glass-nav {
                        background: rgba(15, 23, 42, 0.9);
                        backdrop-filter: blur(12px);
                        border-bottom: 1px solid rgba(255, 255, 255, 0.1);
                    }

                    .header-section {
                        background: linear-gradient(135deg, var(--slate-900) 0%, var(--slate-800) 100%);
                        color: white;
                        padding: 4rem 0 6rem 0;
                        margin-bottom: -4rem;
                    }

                    .main-card {
                        background: white;
                        border: none;
                        border-radius: 1.25rem;
                        box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.05), 0 8px 10px -6px rgba(0, 0, 0, 0.05);
                        overflow: hidden;
                    }

                    .product-img {
                        width: 48px;
                        height: 48px;
                        object-fit: cover;
                        border-radius: 0.75rem;
                        border: 2px solid var(--slate-100);
                    }

                    .table thead th {
                        background-color: var(--slate-50);
                        border-bottom: 2px solid var(--slate-100);
                        text-transform: uppercase;
                        font-size: 0.7rem;
                        font-weight: 700;
                        color: var(--slate-500);
                        letter-spacing: 0.05em;
                        padding: 1.25rem 1.5rem;
                    }

                    .table tbody td {
                        padding: 1.25rem 1.5rem;
                        border-bottom: 1px solid var(--slate-100);
                        vertical-align: middle;
                    }

                    .status-badge {
                        padding: 0.35rem 0.75rem;
                        border-radius: 9999px;
                        font-size: 0.75rem;
                        font-weight: 600;
                    }

                    .status-active {
                        background: #dcfce7;
                        color: #166534;
                    }

                    .status-inactive {
                        background: #f1f5f9;
                        color: #475569;
                    }

                    .action-btn {
                        width: 32px;
                        height: 32px;
                        display: inline-flex;
                        align-items: center;
                        justify-content: center;
                        border-radius: 0.5rem;
                        transition: all 0.2s;
                        border: 1px solid var(--slate-200);
                        background: white;
                        color: var(--slate-600);
                    }

                    .action-btn:hover {
                        border-color: var(--primary);
                        color: var(--primary);
                        background: #eef2ff;
                    }

                    .action-btn.delete:hover {
                        border-color: #ef4444;
                        color: #ef4444;
                        background: #fef2f2;
                    }
                </style>
            </head>

            <body>
                <nav class="navbar navbar-expand-lg navbar-dark glass-nav sticky-top">
                    <div class="container">
                        <a class="navbar-brand d-flex align-items-center" href="../home">
                            <i class="bi bi-shield-check text-primary me-2 fs-3"></i>
                            <span class="fw-bold tracking-tight">Fresh <span class="text-primary-light">Fresh
                                    Food</span></span>
                        </a>
                        <div class="navbar-nav ms-auto">
                            <a class="nav-link px-3 active" href="products">Hàng hóa</a>
                            <a class="nav-link px-3" href="categories">Phân phối</a>
                            <a class="nav-link px-3" href="suppliers">Đối tác</a>
                            <a class="nav-link px-3" href="inventory-pricing">Giá & Hạn dùng</a>
                        </div>
                    </div>
                </nav>

                <header class="header-section">
                    <div class="container">
                        <div class="row align-items-center">
                            <div class="col-md-8">
                                <h1 class="display-6 fw-bold mb-2">Danh mục Sản phẩm</h1>
                                <p class="text-white-50 lead fs-6 mb-0">Quản lý kho hàng, thông tin sản phẩm và trạng
                                    thái kinh doanh.</p>
                            </div>
                            <div class="col-md-4 text-md-end mt-4 mt-md-0">
                                <c:if test="${sessionScope.user.roleId != 1}">
                                    <a href="products?action=new"
                                        class="btn btn-primary rounded-pill px-4 py-2 fw-semibold shadow-lg">
                                        <i class="bi bi-plus-lg me-2"></i>Thêm sản phẩm mới
                                    </a>
                                </c:if>
                            </div>
                        </div>

                        <!-- Thanh tìm kiếm & Bộ lọc -->
                        <div class="row mt-5">
                            <div class="col-12">
                                <div class="glass-card p-3 rounded-4 shadow-sm" style="background: rgba(255,255,255,0.1); backdrop-filter: blur(10px); border: 1px solid rgba(255,255,255,0.1);">
                                    <form class="row g-3">
                                        <div class="col-md-4">
                                            <div class="input-group">
                                                <span class="input-group-text bg-white border-0"><i class="bi bi-search text-muted"></i></span>
                                                <input type="text" id="searchInput" class="form-control border-0" placeholder="Tìm tên sản phẩm...">
                                            </div>
                                        </div>
                                        <div class="col-md-3">
                                            <select id="supplierFilter" class="form-select border-0">
                                                <option value="">-- Tất cả Đối tác --</option>
                                                <c:forEach var="p" items="${products}">
                                                    <c:if test="${not empty p.supplierName}">
                                                        <option value="${p.supplierName}">${p.supplierName}</option>
                                                    </c:if>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="col-md-3">
                                            <select id="statusFilter" class="form-select border-0">
                                                <option value="">-- Tất cả trạng thái --</option>
                                                <option value="Đang bán">Đang bán</option>
                                                <option value="Tạm dừng">Tạm dừng</option>
                                                <option value="Chưa nhập kho">Chưa nhập kho</option>
                                            </select>
                                        </div>
                                        <div class="col-md-2">
                                            <button type="button" onclick="resetFilters()" class="btn btn-outline-light w-100 rounded-pill">Xóa lọc</button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                </header>

                <main class="container mb-5">
                    <div class="main-card">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle">
                                <thead>
                                    <tr>
                                        <th>Ảnh</th>
                                        <th>Thông tin sản phẩm</th>
                                        <th>Đối tác (Mã ID)</th>
                                        <th>Giá niêm yết</th>
                                        <th>Ngày nhập & Hạn dùng</th>
                                        <th>Trạng thái</th>
                                        <c:if test="${sessionScope.user.roleId != 1}">
                                            <th class="text-end">Thao tác</th>
                                        </c:if>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="p" items="${products}">
                                        <tr>
                                            <td>
                                                <img src="${p.imageUrl}" class="product-img"
                                                    onerror="this.src='https://placehold.co/48x48/f1f5f9/475569?text=Food'">
                                            </td>
                                            <td>
                                                <div class="fw-bold text-dark">${p.productName}</div>
                                                <div class="badge bg-light text-primary border border-primary-subtle rounded-pill px-2" style="font-size: 0.65rem;">CAT-${p.categoryId}</div>
                                                <c:if test="${not empty p.expiryPricingPolicyId}">
                                                    <div class="badge bg-info-subtle text-info border border-info-subtle rounded-pill px-2" style="font-size: 0.65rem;">Policy #${p.expiryPricingPolicyId}</div>
                                                </c:if>
                                            </td>
                                            <td>
                                                <div class="fw-bold text-secondary small">${not empty p.supplierName ? p.supplierName : 'Chưa có đối tác'}</div>
                                                <small class="text-muted" style="font-size: 0.75rem;">Mã ID: #${p.productId}</small>
                                            </td>
                                            <td>
                                                <div class="fw-bold text-slate-900 fs-5">
                                                    <fmt:formatNumber value="${p.currentPrice}" pattern="#,###" />đ
                                                </div>
                                                <c:if test="${p.discountPercent < 100}">
                                                    <div class="small text-muted text-decoration-line-through">
                                                        <fmt:formatNumber value="${p.basePriceAmount}" pattern="#,###" />đ
                                                    </div>
                                                    <span class="badge bg-danger pe-none" style="font-size: 0.65rem;">
                                                        GIẢM ${100 - p.discountPercent.intValue()}%
                                                    </span>
                                                </c:if>
                                                <div class="text-muted small">${p.priceBaseWeightGram}g</div>
                                            </td>
                                            <td>
                                                <div class="small">
                                                    <span class="text-muted text-primary">Nhập lúc:</span> 
                                                    <span class="fw-medium">${not empty p.createdDate ? p.createdDate : '--'}</span>
                                                </div>
                                                <c:choose>
                                                    <c:when test="${not empty p.expiryDate}">
                                                        <div class="small">
                                                            <span class="text-muted">Hết hạn:</span> ${p.expiryDate}
                                                        </div>
                                                        <div class="small fw-bold mt-1">
                                                            <c:choose>
                                                                <c:when test="${p.daysRemaining < 0}">
                                                                    <span class="text-danger"><i class="bi bi-exclamation-triangle-fill"></i> Hết hạn</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="${p.daysRemaining <= 3 ? 'text-danger fw-bold' : 'text-warning'}">
                                                                        <i class="bi bi-hourglass-split"></i> Còn ${p.daysRemaining} ngày
                                                                    </span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </div>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <div class="small text-muted italic mt-1">
                                                            <i class="bi bi-info-circle"></i> Chưa nhập kho
                                                        </div>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${p.status}">
                                                        <span class="status-badge status-active"><i
                                                                class="bi bi-check-circle-fill me-1"></i>Đang bán</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="status-badge status-inactive"><i
                                                                class="bi bi-dash-circle me-1"></i>Tạm dừng</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <c:if test="${sessionScope.user.roleId != 1}">
                                                <td class="text-end">
                                                    <a href="products?action=edit&id=${p.productId}"
                                                        class="action-btn me-1" title="Chỉnh sửa">
                                                        <i class="bi bi-pencil-square"></i>
                                                    </a>
                                               
                                                </td>
                                            </c:if>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </main>

                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                <script>
                    const searchInput = document.getElementById('searchInput');
                    const supplierFilter = document.getElementById('supplierFilter');
                    const statusFilter = document.getElementById('statusFilter');
                    const tableRows = document.querySelectorAll('tbody tr');

                    function filterTable() {
                        const searchTerm = searchInput.value.toLowerCase();
                        const supplierTerm = supplierFilter.value;
                        const statusTerm = statusFilter.value;

                        tableRows.forEach(row => {
                            const name = row.querySelector('td:nth-child(2) div:first-child').textContent.toLowerCase();
                            const supplier = row.querySelector('td:nth-child(3) div').textContent;
                            const status = row.querySelector('td:nth-child(6)').textContent.trim();
                            const stockInfo = row.querySelector('td:nth-child(5)').textContent;

                            let show = name.includes(searchTerm);
                            if (supplierTerm && !supplier.includes(supplierTerm)) show = false;
                            
                            if (statusTerm) {
                                if (statusTerm === 'Chưa nhập kho') {
                                    if (!stockInfo.includes('Chưa nhập kho')) show = false;
                                } else if (!status.includes(statusTerm)) {
                                    show = false;
                                }
                            }

                            row.style.display = show ? '' : 'none';
                        });
                    }

                    function resetFilters() {
                        searchInput.value = '';
                        supplierFilter.value = '';
                        statusFilter.value = '';
                        filterTable();
                    }

                    searchInput.addEventListener('input', filterTable);
                    supplierFilter.addEventListener('change', filterTable);
                    statusFilter.addEventListener('change', filterTable);
                </script>
            </body>

            </html>