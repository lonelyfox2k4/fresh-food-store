<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thanh toán – Fresh Food Store</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
<jsp:include page="components/header.jsp"/>

<div class="container my-5">
    <h1 class="h3 fw-bold mb-4"><i class="fas fa-lock me-2 text-brand"></i>Thanh toán</h1>

    <%-- Error alert --%>
    <c:if test="${not empty sessionScope.checkoutError}">
        <div class="alert alert-danger alert-dismissible">
            <i class="fas fa-exclamation-circle me-2"></i>${sessionScope.checkoutError}
            <button class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <c:remove var="checkoutError" scope="session"/>
    </c:if>

    <%-- Voucher flash --%>
    <c:if test="${not empty sessionScope.voucherMsg}">
        <c:set var="vMsg" value="${sessionScope.voucherMsg}"/>
        <c:set var="vType" value="${fn:startsWith(vMsg,'success') ? 'success' : fn:startsWith(vMsg,'error') ? 'danger' : 'info'}"/>
        <div class="alert alert-${vType} alert-dismissible">
            <i class="fas fa-tag me-2"></i>${fn:substringAfter(vMsg, ':')}
            <button class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <c:remove var="voucherMsg" scope="session"/>
    </c:if>

    <form action="${pageContext.request.contextPath}/place-order" method="post" id="checkoutForm">
        <div class="row g-4">

            <%-- ══ LEFT: Shipping info ════════════════════════════════════ --%>
            <div class="col-lg-7">

                <%-- Shipping details --%>
                <div class="checkout-card mb-4">
                    <h5 class="fw-bold mb-3"><i class="fas fa-map-marker-alt me-2 text-brand"></i>Thông tin giao hàng</h5>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Họ và tên người nhận <span class="text-danger">*</span></label>
                        <input type="text" name="recipientName" class="form-control"
                               value="${sessionScope.user.fullName}" required
                               placeholder="Nhập họ và tên...">
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Số điện thoại <span class="text-danger">*</span></label>
                        <input type="tel" name="recipientPhone" class="form-control"
                               value="${sessionScope.user.phone}" required
                               placeholder="Nhập số điện thoại...">
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Địa chỉ giao hàng <span class="text-danger">*</span></label>
                        <textarea name="shippingAddress" class="form-control" rows="3" required
                                  placeholder="Số nhà, đường, phường/xã, quận/huyện, tỉnh/thành phố..."></textarea>
                    </div>
                    <div class="mb-0">
                        <label class="form-label fw-semibold">Ghi chú cho tài xế</label>
                        <input type="text" name="note" class="form-control"
                               placeholder="VD: gọi trước 15 phút, để hàng ở bảo vệ...">
                    </div>
                </div>

                <%-- Voucher --%>
                <div class="checkout-card mb-4">
                    <h5 class="fw-bold mb-3"><i class="fas fa-ticket-alt me-2 text-brand"></i>Mã giảm giá</h5>
                    <form action="${pageContext.request.contextPath}/voucher/apply" method="post"
                          class="d-flex gap-2">
                        <input type="text" name="voucherCode" class="form-control"
                               value="${appliedVoucher != null ? appliedVoucher.voucherCode : ''}"
                               placeholder="Nhập mã voucher...">
                        <button type="submit" class="btn btn-outline-brand fw-bold"
                                style="white-space:nowrap;border-color:#E3000F;color:#E3000F;">
                            <i class="fas fa-tag me-1"></i>Áp dụng
                        </button>
                        </form>
                    <c:if test="${appliedVoucher != null}">
                        <form action="${pageContext.request.contextPath}/voucher/apply" method="post" class="d-inline mt-1">
                            <input type="hidden" name="voucherCode" value="">
                            <button type="submit" class="btn btn-sm btn-outline-secondary" title="Xóa voucher">
                                <i class="fas fa-times me-1"></i>Xóa mã
                            </button>
                        </form>
                    </c:if>
                    <c:if test="${appliedVoucher != null}">
                        <div class="mt-2 text-success small fw-semibold">
                            <i class="fas fa-check-circle me-1"></i>
                            Đang áp dụng: <strong>${appliedVoucher.voucherCode}</strong>
                            – ${appliedVoucher.voucherName}
                        </div>
                    </c:if>
                </div>

                <%-- Payment method --%>
                <div class="checkout-card">
                    <h5 class="fw-bold mb-3"><i class="fas fa-wallet me-2 text-brand"></i>Phương thức thanh toán</h5>
                    <div class="form-check border rounded-3 p-3 d-flex align-items-center gap-3 bg-light">
                        <input class="form-check-input" type="radio" name="paymentMethod"
                               id="pmCOD" value="COD" checked>
                        <label class="form-check-label d-flex align-items-center gap-2" for="pmCOD">
                            <i class="fas fa-money-bill-wave fs-4 text-success"></i>
                            <div>
                                <strong>Thanh toán khi nhận hàng (COD)</strong><br>
                                <small class="text-muted">Kiểm tra hàng trước khi trả tiền</small>
                            </div>
                        </label>
                    </div>
                </div>

            </div>

            <%-- ══ RIGHT: Order summary ════════════════════════════════════ --%>
            <div class="col-lg-5">
                <div class="checkout-card sticky-top" style="top:20px;">
                    <h5 class="fw-bold mb-3"><i class="fas fa-receipt me-2"></i>Đơn hàng của bạn</h5>

                    <%-- Item list --%>
                    <div class="mb-3" style="max-height:280px;overflow-y:auto;">
                        <c:forEach var="item" items="${cartItems}">
                            <div class="d-flex justify-content-between align-items-center py-2 border-bottom">
                                <div class="d-flex align-items-center gap-2 overflow-hidden">
                                    <img src="${not empty item.imageUrl ? item.imageUrl : 'https://via.placeholder.com/48/fdf2f2/E3000F?text=F'}"
                                         style="width:48px;height:48px;object-fit:cover;border-radius:6px;"
                                         alt="${item.productName}">
                                    <div class="overflow-hidden">
                                        <div class="text-truncate fw-semibold small" style="max-width:160px;">
                                            ${item.productName}
                                        </div>
                                        <small class="text-muted">${item.packWeightGram}g × ${item.quantity}</small>
                                    </div>
                                </div>
                                <strong class="text-brand small ms-2">
                                    <fmt:formatNumber value="${item.lineTotal}" pattern="###,###"/>₫
                                </strong>
                            </div>
                        </c:forEach>
                    </div>

                    <%-- Totals --%>
                    <div class="d-flex justify-content-between mb-2">
                        <span class="text-muted">Tạm tính</span>
                        <strong><fmt:formatNumber value="${subtotal}" pattern="###,###"/> ₫</strong>
                    </div>
                    <c:if test="${voucherDiscount > 0}">
                        <div class="d-flex justify-content-between mb-2 text-success">
                            <span><i class="fas fa-tag me-1"></i>Giảm giá voucher</span>
                            <strong>- <fmt:formatNumber value="${voucherDiscount}" pattern="###,###"/> ₫</strong>
                        </div>
                    </c:if>
                    <div class="d-flex justify-content-between mb-2">
                        <span class="text-muted">Phí giao hàng</span>
                        <c:choose>
                            <c:when test="${shippingFee == 0}">
                                <strong class="text-success">Miễn phí</strong>
                            </c:when>
                            <c:otherwise>
                                <strong><fmt:formatNumber value="${shippingFee}" pattern="###,###"/> ₫</strong>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <hr>
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <span class="fw-bold fs-5">Tổng cộng</span>
                        <span class="fw-bold fs-4 text-brand">
                            <fmt:formatNumber value="${total}" pattern="###,###"/> ₫
                        </span>
                    </div>

                    <button type="submit" class="btn btn-brand fw-bold w-100 py-2 fs-5">
                        <i class="fas fa-check-circle me-2"></i>Đặt hàng ngay
                    </button>
                    <p class="text-muted text-center small mt-2 mb-0">
                        <i class="fas fa-shield-alt me-1"></i>
                        Thông tin được bảo mật tuyệt đối
                    </p>
                </div>
            </div>

        </div>
    </form>
</div>

<jsp:include page="components/footer.jsp"/>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<%-- JSTL fn not imported above; using simple alert for voucher message --%>
<script>
// Parse voucher message (format "success:..." or "error:..." or "info:...")
// Already handled server-side via session - nothing extra needed.
</script>
</body>
</html>
