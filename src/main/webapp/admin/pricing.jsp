<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Giá & Hạn dùng | FoodStore Admin</title>
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <!-- Bootstrap 5 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    
    <style>
        :root {
            --primary: #4f46e5;
            --primary-light: #818cf8;
            --bg-glass: rgba(255, 255, 255, 0.9);
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

        /* Navbar & Header */
        .glass-nav {
            background: rgba(15, 23, 42, 0.9);
            backdrop-filter: blur(12px);
            border-bottom: 1px solid rgba(255,255,255,0.1);
        }

        .header-section {
            background: linear-gradient(135deg, var(--slate-900) 0%, var(--slate-800) 100%);
            color: white;
            padding: 4rem 0 6rem 0;
            margin-bottom: -4rem;
        }

        /* Card & Table logic */
        .main-card {
            background: white;
            border: none;
            border-radius: 1.25rem;
            box-shadow: 0 10px 25px -5px rgba(0,0,0,0.05), 0 8px 10px -6px rgba(0,0,0,0.05);
            overflow: hidden;
        }

        .table thead th {
            background-color: var(--slate-50);
            border-bottom: 2px solid var(--slate-100);
            text-transform: uppercase;
            font-size: 0.7rem;
            font-weight: 700;
            color: var(--secondary-color);
            letter-spacing: 0.05em;
            padding: 1.25rem 1.5rem;
        }

        .table tbody td {
            padding: 1.25rem 1.5rem;
            border-bottom: 1px solid var(--slate-100);
            vertical-align: middle;
        }

        .table-hover tbody tr:hover {
            background-color: #fcfcfd;
            transition: background 0.2s;
        }

        /* Typography & Components */
        .product-title {
            font-weight: 600;
            font-size: 1rem;
            color: var(--slate-900);
            display: block;
        }

        .supplier-tag {
            background: var(--slate-100);
            color: var(--slate-700);
            font-size: 0.75rem;
            padding: 0.25rem 0.6rem;
            border-radius: 0.5rem;
            font-weight: 500;
        }

        .price-base {
            font-size: 0.85rem;
            color: var(--slate-400);
            text-decoration: line-through;
        }

        .price-final {
            font-size: 1.15rem;
            font-weight: 700;
            color: var(--slate-900);
        }

        .discount-badge {
            background: linear-gradient(135deg, #fb7185 0%, #e11d48 100%);
            color: white;
            padding: 0.35rem 0.75rem;
            border-radius: 9999px;
            font-size: 0.75rem;
            font-weight: 700;
            box-shadow: 0 4px 6px -1px rgba(225, 29, 72, 0.2);
        }

        .date-box {
            display: inline-flex;
            align-items: center;
            font-size: 0.85rem;
            font-weight: 500;
        }

        .date-urgent {
            color: #e11d48;
            background: #fff1f2;
            padding: 0.25rem 0.5rem;
            border-radius: 0.4rem;
        }

        .stats-sidebar {
            background: white;
            border-radius: 1rem;
            padding: 1.5rem;
            box-shadow: 0 4px 6px -1px rgba(0,0,0,0.05);
        }
    </style>
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark glass-nav sticky-top">
        <div class="container">
            <a class="navbar-brand d-flex align-items-center" href="../home">
                <i class="bi bi-shield-check text-primary me-2 fs-3"></i>
                <span class="fw-bold tracking-tight">FOODSTORE <span class="text-primary-light">ADMIN</span></span>
            </a>
            <div class="navbar-nav ms-auto">
                <a class="nav-link px-3" href="products">Hàng hóa</a>
                <a class="nav-link px-3" href="categories">Phân phối</a>
                <a class="nav-link px-3" href="suppliers">Đối tác</a>
                <a class="nav-link px-3 active" href="inventory-pricing">Giá & Hạn dùng</a>
            </div>
        </div>
    </nav>

    <header class="header-section">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-md-8">
                    <h1 class="display-6 fw-bold mb-2">Quản lý Giá & Hạn sử dụng</h1>
                    <p class="text-white-50 lead fs-6 mb-0">Hệ thống AI tự động điều chỉnh giá bán dựa trên quy tắc độ tươi và ngày hết hạn.</p>
                </div>
                <div class="col-md-4 text-md-end mt-4 mt-md-0">
                    <a href="policies" class="btn btn-outline-light btn-sm rounded-pill px-4">
                        <i class="bi bi-gear-fill me-2"></i>Cấu hình quy tắc
                    </a>
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
                            <th>Sản phẩm & Đối tác</th>
                            <th>Hạn sử dụng</th>
                            <th>Tình trạng</th>
                            <th>Chính sách áp dụng</th>
                            <th>Tồn kho</th>
                            <th class="text-end">Định giá AI</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="item" items="${pricingList}">
                            <tr>
                                <td>
                                    <span class="product-title">${item.productName}</span>
                                    <span class="supplier-tag"><i class="bi bi-patch-check-fill text-primary me-1"></i>${item.supplierName}</span>
                                </td>
                                <td>
                                    <div class="date-box ${item.daysRemaining <= 7 ? 'date-urgent' : 'text-slate-700'}">
                                        <i class="bi bi-calendar-event me-2"></i> ${item.expiryDate}
                                    </div>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${item.daysRemaining < 0}">
                                            <span class="badge bg-danger rounded-pill px-3">Hết hạn</span>
                                        </c:when>
                                        <c:when test="${item.daysRemaining == 0}">
                                            <span class="badge bg-warning text-dark rounded-pill px-3">Hết hạn hôm nay</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-dark small fw-bold">Còn ${item.daysRemaining} ngày</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty item.policyName}">
                                            <div class="small fw-semibold text-primary">
                                                <i class="bi bi-shield-lock-fill me-1"></i>${item.policyName}
                                            </div>
                                            <small class="text-muted italic">Logic ngày còn lại</small>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-muted small">Mặc định (Giá niêm yết)</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <span class="fw-bold fs-5">${item.quantity}</span>
                                    <small class="text-muted">đv</small>
                                </td>
                                <td class="text-end">
                                    <c:choose>
                                        <c:when test="${item.discountPercent < 100}">
                                            <div class="price-base"><fmt:formatNumber value="${item.basePrice}" pattern="#,###"/>đ</div>
                                            <div class="price-final d-flex align-items-center justify-content-end">
                                                <fmt:formatNumber value="${item.currentPrice}" pattern="#,###"/>đ
                                                <span class="discount-badge ms-2">-${100 - item.discountPercent}%</span>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="price-final"><fmt:formatNumber value="${item.currentPrice}" pattern="#,###"/>đ</div>
                                            <div class="text-success small fw-medium">Giá niêm yết</div>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
        
        <div class="mt-4 row g-4">
            <div class="col-md-6">
                <div class="stats-sidebar">
                    <h6 class="fw-bold text-uppercase small text-muted mb-3">Thông tin vận hành</h6>
                    <div class="d-flex align-items-center mb-2">
                        <i class="bi bi-circle-fill text-success me-2" style="font-size: 8px;"></i>
                        <span class="small font-medium">Server phân tích giá: <strong>Hoạt động</strong></span>
                    </div>
                    <div class="d-flex align-items-center">
                        <i class="bi bi-circle-fill text-primary me-2" style="font-size: 8px;"></i>
                        <span class="small font-medium">Bản ghi cuối: <strong>Vừa xong</strong></span>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
