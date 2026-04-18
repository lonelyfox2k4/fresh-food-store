<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đặt hàng thành công – Fresh Food Store</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <style>
        .success-icon { animation: popIn .5s cubic-bezier(.37,1.78,.58,1) both; }
        @keyframes popIn {
            from { transform: scale(0); opacity: 0; }
            to   { transform: scale(1); opacity: 1; }
        }
    </style>
</head>
<body class="bg-light">
<jsp:include page="components/header.jsp"/>

<div class="container my-5">
    <div class="row justify-content-center">
        <div class="col-lg-6">
            <div class="card border-0 shadow text-center p-5">
                <%-- Success icon --%>
                <div class="success-icon mb-4">
                    <div class="rounded-circle bg-success d-inline-flex align-items-center justify-content-center"
                         style="width:90px;height:90px;">
                        <i class="fas fa-check fa-3x text-white"></i>
                    </div>
                </div>

                <h2 class="fw-bold text-success mb-2">Đặt hàng thành công!</h2>
                <p class="text-muted mb-4">
                    Cảm ơn bạn đã tin tưởng Fresh Food Store.<br>
                    Đơn hàng của bạn đang được xử lý.
                </p>

                <%-- Order code --%>
                <div class="bg-light rounded-3 p-3 mb-4">
                    <p class="text-muted small mb-1">Mã đơn hàng</p>
                    <h4 class="fw-bold text-brand mb-0">${order.orderCode}</h4>
                </div>

                <%-- Info cards --%>
                <div class="row g-3 mb-4">
                    <div class="col-6">
                        <div class="bg-light rounded-3 p-3">
                            <i class="fas fa-map-marker-alt text-brand mb-1 d-block"></i>
                            <p class="text-muted small mb-1">Giao tới</p>
                            <strong class="small">${order.recipientNameSnapshot}</strong>
                        </div>
                    </div>
                    <div class="col-6">
                        <div class="bg-light rounded-3 p-3">
                            <i class="fas fa-money-bill-wave text-success mb-1 d-block"></i>
                            <p class="text-muted small mb-1">Thanh toán</p>
                            <strong class="small">COD – Tiền mặt</strong>
                        </div>
                    </div>
                    <div class="col-6">
                        <div class="bg-light rounded-3 p-3">
                            <i class="fas fa-shipping-fast text-brand mb-1 d-block"></i>
                            <p class="text-muted small mb-1">Dự kiến giao</p>
                            <strong class="small">Trong ngày hôm nay</strong>
                        </div>
                    </div>
                    <div class="col-6">
                        <div class="bg-light rounded-3 p-3">
                            <i class="fas fa-coins text-warning mb-1 d-block"></i>
                            <p class="text-muted small mb-1">Tổng tiền COD</p>
                            <strong class="small text-brand">
                                <fmt:formatNumber value="${order.totalAmount}" pattern="###,###"/> ₫
                            </strong>
                        </div>
                    </div>
                </div>

                <div class="d-flex gap-3 justify-content-center">
                    <a href="${pageContext.request.contextPath}/orders/detail?id=${order.orderId}"
                       class="btn btn-brand fw-bold px-4">
                        <i class="fas fa-list-alt me-2"></i>Xem đơn hàng
                    </a>
                    <a href="${pageContext.request.contextPath}/products"
                       class="btn btn-outline-secondary fw-bold px-4">
                        <i class="fas fa-shopping-bag me-2"></i>Mua tiếp
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="components/footer.jsp"/>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
