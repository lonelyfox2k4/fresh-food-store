<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đặt hàng thành công | Fresh Food Store</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <style>
        .success-checkmark {
            width: 100px; height: 100px; margin: 0 auto;
            background: #d4edda; border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            animation: bounceIn 0.6s cubic-bezier(0.68, -0.55, 0.265, 1.55);
        }
        @keyframes bounceIn {
            0% { transform: scale(0); opacity: 0; }
            60% { transform: scale(1.1); opacity: 1; }
            100% { transform: scale(1); opacity: 1; }
        }
    </style>
</head>
<body class="bg-light d-flex flex-column min-vh-100">
<jsp:include page="../components/header.jsp"/>

<main class="container py-5 flex-grow-1">
    <div class="row justify-content-center">
        <div class="col-lg-6">
            <div class="bg-white p-5 rounded-4 shadow-sm text-center">
                <div class="success-checkmark mb-4">
                    <i class="fa-solid fa-check fa-4x text-success"></i>
                </div>

                <h2 class="fw-bold text-success mb-2">Đặt hàng thành công!</h2>
                <p class="text-muted mb-4">
                    Cảm ơn bạn đã tin tưởng <strong>Fresh Food Store</strong>.<br>
                    Chúng tôi đang chuẩn bị hàng và sẽ giao tới bạn sớm nhất.
                </p>

                <div class="bg-light rounded-3 p-4 mb-4 text-start">
                    <div class="row g-3">
                        <div class="col-6 border-end">
                            <small class="text-muted d-block">Mã đơn hàng</small>
                            <span class="fw-bold text-brand h5 mb-0">${order.orderCode}</span>
                        </div>
                        <div class="col-6 ps-4">
                            <small class="text-muted d-block">Tổng tiền (COD)</small>
                            <span class="fw-bold text-dark h5 mb-0"><fmt:formatNumber value="${order.totalAmount}" pattern="###,###"/> ₫</span>
                        </div>
                        <div class="col-12 mt-3 pt-3 border-top">
                            <div class="d-flex align-items-center gap-2 small">
                                <i class="fa-solid fa-location-dot text-brand"></i>
                                <span class="text-muted">Giao tới:</span>
                                <span class="fw-semibold">${order.recipientNameSnapshot}</span>
                            </div>
                            <div class="ms-4 small text-muted">${order.shippingAddressSnapshot}</div>
                        </div>
                    </div>
                </div>

                <div class="d-grid gap-3 d-sm-flex justify-content-center">
                    <a href="${pageContext.request.contextPath}/orders/detail?id=${order.orderId}" 
                       class="btn btn-brand fw-bold px-4">
                        <i class="fa-solid fa-list-check me-2"></i>Xem đơn hàng
                    </a>
                    <a href="${pageContext.request.contextPath}/home" 
                       class="btn btn-outline-secondary fw-bold px-4">
                        <i class="fa-solid fa-house me-2"></i>Về trang chủ
                    </a>
                </div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="../components/footer.jsp"/>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
