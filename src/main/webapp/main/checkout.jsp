<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thanh toán | Fresh Food Store</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body class="bg-light d-flex flex-column min-vh-100">
<jsp:include page="../components/header.jsp"/>

<main class="container py-5 flex-grow-1">
    <h2 class="mb-4">Thông tin thanh toán</h2>
    
    <%-- Hiển thị thông báo lỗi nếu có --%>
    <c:if test="${not empty sessionScope.checkoutError}">
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <i class="fa-solid fa-circle-exclamation me-2"></i>
            ${sessionScope.checkoutError}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
        <c:remove var="checkoutError" scope="session"/>
    </c:if>

    <div class="row g-4">
        <%-- Left Column: Form Info --%>
        <div class="col-lg-7">
            <form action="${pageContext.request.contextPath}/place-order" method="post" id="checkoutForm">
                <div class="bg-white p-4 rounded-3 shadow-sm mb-4">
                    <h5 class="fw-bold mb-4 border-bottom pb-2">
                        <i class="fa-solid fa-truck-fast me-2 text-primary"></i>Thông tin vận chuyển
                    </h5>
                    
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label small fw-bold">Họ và tên người nhận</label>
                            <input type="text" name="recipientName" class="form-control" 
                                   value="${sessionScope.user.fullName}" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label small fw-bold">Số điện thoại</label>
                            <input type="tel" name="recipientPhone" class="form-control" 
                                   value="${sessionScope.user.phone}" required>
                        </div>
                        <div class="col-12">
                            <label class="form-label small fw-bold">Địa chỉ nhận hàng</label>
                            <textarea name="shippingAddress" class="form-control" rows="3" 
                                      placeholder="Số nhà, tên đường, phường/xã, quận/huyện..." required></textarea>
                        </div>
                        <div class="col-12">
                            <label class="form-label small fw-bold">Ghi chú (tùy chọn)</label>
                            <textarea name="note" class="form-control" rows="2" 
                                      placeholder="Ví dụ: Giao giờ hành chính, gọi trước khi đến..."></textarea>
                        </div>
                    </div>
                </div>

                <div class="bg-white p-4 rounded-3 shadow-sm mb-4">
                    <h5 class="fw-bold mb-4 border-bottom pb-2">
                        <i class="fa-solid fa-credit-card me-2 text-primary"></i>Phương thức thanh toán
                    </h5>
                    
                    <div class="form-check p-3 border rounded-3 mb-3 bg-light">
                        <input class="form-check-input ms-0 me-3" type="radio" name="paymentMethod" id="paymentCOD" value="COD" checked>
                        <label class="form-check-label d-flex align-items-center" for="paymentCOD">
                            <i class="fa-solid fa-money-bill-wave me-3 text-success fs-4"></i>
                            <div>
                                <div class="fw-bold">Thanh toán khi nhận hàng (COD)</div>
                                <div class="small text-muted">Thanh toán trực tiếp bằng tiền mặt khi nhận được hàng.</div>
                            </div>
                        </label>
                    </div>

                    <div class="form-check p-3 border rounded-3 border-primary-subtle bg-primary-subtle bg-opacity-10">
                        <input class="form-check-input ms-0 me-3" type="radio" name="paymentMethod" id="paymentVNPAY" value="VNPAY">
                        <label class="form-check-label d-flex align-items-center" for="paymentVNPAY">
                            <img src="https://sandbox.vnpayment.vn/paymentv2/Images/design/logo_vnpay.png" alt="VNPAY" height="30" class="me-3">
                            <div>
                                <div class="fw-bold text-primary">Thanh toán Online qua VNPAY</div>
                                <div class="small text-muted">Hỗ trợ ATM, Thẻ quốc tế, QR Code ngân hàng.</div>
                            </div>
                        </label>
                    </div>
                    <%-- Note: Other methods can be added here --%>
                </div>
            </form>
        </div>

        <%-- Right Column: Summary --%>
        <div class="col-lg-5">
            <div class="bg-white p-4 rounded-3 shadow-sm mb-4">
                <h5 class="fw-bold mb-4 border-bottom pb-2">
                    <i class="fa-solid fa-receipt me-2 text-primary"></i>Đơn hàng của bạn
                </h5>

                <div class="cart-items-summary mb-4" style="max-height: 300px; overflow-y: auto;">
                    <c:forEach var="item" items="${cartItems}">
                        <div class="d-flex gap-3 mb-3 pb-3 border-bottom">
                            <img src="${not empty item.imageUrl ? item.imageUrl : 'https://via.placeholder.com/60x60?text=Food'}"
                                 alt="${item.productName}" width="60" height="60" class="rounded-2" style="object-fit: cover;">
                            <div class="flex-grow-1">
                                <div class="fw-semibold small">${item.productName}</div>
                                <div class="text-muted small">x ${item.quantity} | ${item.packWeightGram}g</div>
                            </div>
                            <div class="text-end fw-bold small">
                                <fmt:formatNumber value="${item.lineTotal}" pattern="###,###"/> ₫
                            </div>
                        </div>
                    </c:forEach>
                </div>

                <%-- Voucher Section --%>
                <div class="mb-4">
                    <form action="${pageContext.request.contextPath}/voucher/apply" method="post" class="input-group input-group-sm">
                        <input type="text" name="voucherCode" class="form-control" placeholder="Mã giảm giá" 
                               value="${appliedVoucher != null ? appliedVoucher.voucherCode : ''}">
                        <button class="btn btn-outline-primary" type="submit">Áp dụng</button>
                    </form>
                    <c:if test="${not empty sessionScope.voucherMsg}">
                        <div class="mt-2 small ${sessionScope.voucherMsg.startsWith('success') ? 'text-success' : 'text-danger'}">
                            ${sessionScope.voucherMsg.substring(sessionScope.voucherMsg.indexOf(':') + 1)}
                        </div>
                        <c:remove var="voucherMsg" scope="session"/>
                    </c:if>
                    <c:if test="${appliedVoucher != null}">
                         <div class="mt-2 text-success small">
                             <i class="fas fa-check-circle me-1"></i>Đã áp dụng mã: <strong>${appliedVoucher.voucherCode}</strong>
                         </div>
                    </c:if>
                </div>

                <div class="summary-details">
                    <div class="d-flex justify-content-between mb-2">
                        <span class="text-muted">Tạm tính</span>
                        <strong><fmt:formatNumber value="${subtotal}" pattern="###,###"/> ₫</strong>
                    </div>
                    <c:if test="${voucherDiscount > 0}">
                        <div class="d-flex justify-content-between mb-2 text-success">
                            <span>Giảm giá</span>
                            <strong>- <fmt:formatNumber value="${voucherDiscount}" pattern="###,###"/> ₫</strong>
                        </div>
                    </c:if>
                    <div class="d-flex justify-content-between mb-2">
                        <span class="text-muted">Phí vận chuyển</span>
                        <strong>
                            <c:choose>
                                <c:when test="${shippingFee == 0}"><span class="text-success">Miễn phí</span></c:when>
                                <c:otherwise><fmt:formatNumber value="${shippingFee}" pattern="###,###"/> ₫</c:otherwise>
                            </c:choose>
                        </strong>
                    </div>
                    <hr>
                    <div class="d-flex justify-content-between align-items-center">
                        <span class="fs-5 fw-bold">Tổng cộng</span>
                        <span class="fs-4 fw-bold text-brand"><fmt:formatNumber value="${total}" pattern="###,###"/> ₫</span>
                    </div>
                </div>

                <button type="submit" form="checkoutForm" class="btn btn-success w-100 py-3 mt-4 fw-bold shadow-sm">
                    <i class="fa-solid fa-bag-shopping me-2"></i>ĐẶT HÀNG NGAY
                </button>
            </div>
            
            <a href="${pageContext.request.contextPath}/cart" class="text-muted text-decoration-none small">
                <i class="fa-solid fa-arrow-left me-1"></i> Quay lại giỏ hàng
            </a>
        </div>
    </div>
</main>

<jsp:include page="../components/footer.jsp"/>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.getElementById('checkoutForm').addEventListener('submit', function() {
            const submitBtn = this.querySelector('button[type="submit"]');
            submitBtn.disabled = true;
            submitBtn.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span>ĐANG XỬ LÝ...';
        });
    </script>
</body>
</html>
