<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Giá & Hạn dùng | Fresh Food</title>
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    
    <jsp:include page="../components/admin-style.jsp" />
    <style>
        .product-title { font-weight: 600; font-size: 1rem; color: var(--slate-900); display: block; }
        .supplier-tag { background: var(--slate-100); color: var(--slate-700); font-size: 0.75rem; padding: 0.25rem 0.6rem; border-radius: 0.5rem; font-weight: 500; }
        .price-base { font-size: 0.85rem; color: var(--slate-400); text-decoration: line-through; }
        .price-final { font-size: 1.15rem; font-weight: 700; color: var(--slate-900); }
        .discount-badge { background: linear-gradient(135deg, #fb7185 0%, #e11d48 100%); color: white; padding: 0.35rem 0.75rem; border-radius: 9999px; font-size: 0.75rem; font-weight: 700; }
        .date-box { display: inline-flex; align-items: center; font-size: 0.85rem; font-weight: 500; }
        .date-urgent { color: #e11d48; background: #fff1f2; padding: 0.25rem 0.5rem; border-radius: 0.4rem; }
        .stats-sidebar { background: #fff; border-radius: 16px; padding: 1.5rem; border: 1px solid #e2e8f0; margin-bottom: 2rem; }
    </style>
</head>
<body>
    <jsp:include page="../components/admin-nav.jsp">
        <jsp:param name="active" value="inventory-pricing" />
    </jsp:include>

    <div class="page-header mt-n2">
        <div class="container d-flex justify-content-between align-items-center">
            <div>
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb mb-1">
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/manager/products">Quản lý</a></li>
                        <li class="breadcrumb-item active">Bảng giá phân tích</li>
                    </ol>
                </nav>
                <h2 class="fw-800 mb-0">Hệ thống phân tích Giá</h2>
            </div>
            <c:if test="${sessionScope.user.roleId != 1}">
                <a href="policies" class="btn btn-outline-brand rounded-pill px-4 shadow-sm">
                    <i class="fas fa-cog me-2"></i>Cấu hình luật phân tích
                </a>
            </c:if>
        </div>
    </div>

    <main class="container mb-5">
        <div class="user-table-card">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead>
                        <tr>
                            <th>Sản phẩm & Đối tác</th>
                            <th>Hạn sử dụng</th>
                            <th>Tình trạng</th>
                            <th>Chính sách áp dụng</th>
                            <th>Tồn kho</th>
                            <th class="text-end pe-4">Định giá AI</th>
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
                                        <i class="fas fa-calendar-alt me-2"></i> ${item.expiryDate}
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
                                                <i class="fas fa-shield-alt me-1"></i>${item.policyName}
                                            </div>
                                            <small class="text-muted fst-italic">Logic ngày còn lại</small>
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
                                <td class="text-end pe-4">
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
                        <i class="fas fa-circle text-success me-2" style="font-size: 10px;"></i>
                        <span class="small font-medium">Server phân tích giá: <strong>Hoạt động</strong></span>
                    </div>
                    <div class="d-flex align-items-center">
                        <i class="fas fa-circle text-primary me-2" style="font-size: 10px;"></i>
                        <span class="small font-medium">Bản ghi cuối: <strong>Vừa xong</strong></span>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
