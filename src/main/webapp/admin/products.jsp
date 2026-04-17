<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Sản phẩm | FoodStore Admin</title>
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
            border-bottom: 1px solid rgba(255,255,255,0.1);
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
            box-shadow: 0 10px 25px -5px rgba(0,0,0,0.05), 0 8px 10px -6px rgba(0,0,0,0.05);
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
                <span class="fw-bold tracking-tight">FOODSTORE <span class="text-primary-light">ADMIN</span></span>
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
                    <p class="text-white-50 lead fs-6 mb-0">Quản lý kho hàng, thông tin sản phẩm và trạng thái kinh doanh của cửa hàng.</p>
                </div>
                <div class="col-md-4 text-md-end mt-4 mt-md-0">
                    <c:if test="${sessionScope.user.roleId != 1}">
                        <a href="products?action=new" class="btn btn-primary rounded-pill px-4 py-2 fw-semibold shadow-lg">
                            <i class="bi bi-plus-lg me-2"></i>Thêm sản phẩm mới
                        </a>
                    </c:if>
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
                            <th>Phân loại</th>
                            <th>Đối tác</th>
                            <th>Giá niêm yết</th>
                            <th>Chính sách giá</th>
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
                                    <img src="${p.imageUrl}" class="product-img" onerror="this.src='https://placehold.co/48x48/f1f5f9/475569?text=Food'">
                                </td>
                                <td>
                                    <div class="fw-bold text-dark">${p.productName}</div>
                                    <small class="text-muted">SKU: ${p.productId}00${p.categoryId}</small>
                                </td>
                                <td>
                                    <span class="badge bg-light text-primary border border-primary-subtle rounded-pill px-3">${p.categoryName}</span>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty p.supplierName}">
                                            <span class="text-dark small fw-medium"><i class="bi bi-shop me-1"></i>${p.supplierName}</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-muted small italic">Chưa xác định</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <div class="fw-bold text-slate-900"><fmt:formatNumber value="${p.basePriceAmount}" pattern="#,###"/>đ</div>
                                    <small class="text-muted">${p.priceBaseWeightGram}g</small>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty p.policyName}">
                                            <span class="badge bg-info-subtle text-info border border-info-subtle rounded-pill px-3">
                                                <i class="bi bi-lightning-charge-fill me-1"></i>${p.policyName}
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-muted small">Mặc định</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${p.status}">
                                            <span class="status-badge status-active"><i class="bi bi-check-circle-fill me-1"></i>Đang bán</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="status-badge status-inactive"><i class="bi bi-dash-circle me-1"></i>Tạm dừng</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <c:if test="${sessionScope.user.roleId != 1}">
                                    <td class="text-end">
                                        <a href="products?action=edit&id=${p.productId}" class="action-btn me-1" title="Chỉnh sửa">
                                            <i class="bi bi-pencil-square"></i>
                                        </a>
                                        <a href="products?action=delete&id=${p.productId}" class="action-btn delete" title="Ẩn sản phẩm" onclick="return confirm('Xác nhận ngừng kinh doanh sản phẩm này?')">
                                            <i class="bi bi-eye-slash"></i>
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
</body>
</html>
