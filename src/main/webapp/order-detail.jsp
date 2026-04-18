<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết đơn hàng ${order.orderCode} – Fresh Food Store</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
<jsp:include page="components/header.jsp"/>

<div class="container my-5">
    <%-- Breadcrumb --%>
    <nav aria-label="breadcrumb" class="mb-4">
        <ol class="breadcrumb">
            <li class="breadcrumb-item">
                <a href="${pageContext.request.contextPath}/orders" class="text-brand">Đơn hàng của tôi</a>
            </li>
            <li class="breadcrumb-item active">${order.orderCode}</li>
        </ol>
    </nav>

    <div class="row g-4">

        <%-- ══ LEFT: Order info ════════════════════════════════════════════ --%>
        <div class="col-lg-8">

            <%-- Order header --%>
            <div class="checkout-card mb-4">
                <div class="d-flex justify-content-between align-items-start">
                    <div>
                        <h2 class="h5 fw-bold mb-1">Đơn hàng <span class="text-brand">${order.orderCode}</span></h2>
                        <p class="text-muted small mb-0">
                            <i class="far fa-clock me-1"></i>
                            Đặt lúc: <%= ((org.example.model.order.Order)request.getAttribute("order")).getPlacedAt().format(java.time.format.DateTimeFormatter.ofPattern("HH:mm - dd/MM/yyyy")) %>
                        </p>
                    </div>
                    <span class="badge rounded-pill status-${order.orderStatus} py-2 px-3 fs-6">
                        <c:choose>
                            <c:when test="${order.orderStatus == 1}">⏳ Chờ xác nhận</c:when>
                            <c:when test="${order.orderStatus == 2}">✅ Đã xác nhận</c:when>
                            <c:when test="${order.orderStatus == 3}">🔄 Đang chuẩn bị</c:when>
                            <c:when test="${order.orderStatus == 4}">🚚 Đang giao hàng</c:when>
                            <c:when test="${order.orderStatus == 5}">🎉 Đã giao thành công</c:when>
                            <c:when test="${order.orderStatus == 6}">❌ Đã hủy</c:when>
                        </c:choose>
                    </span>
                </div>

                <c:if test="${order.orderStatus == 6 && not empty order.cancelledReason}">
                    <div class="alert alert-danger mt-3 py-2 mb-0">
                        <i class="fas fa-info-circle me-1"></i>Lý do hủy: ${order.cancelledReason}
                    </div>
                </c:if>
            </div>

            <%-- Items table --%>
            <div class="checkout-card mb-4">
                <h6 class="fw-bold mb-3"><i class="fas fa-box me-2 text-brand"></i>Sản phẩm trong đơn</h6>
                <div class="table-responsive">
                    <table class="table align-middle">
                        <thead class="table-light">
                            <tr>
                                <th>Sản phẩm</th>
                                <th class="text-center">Đơn giá</th>
                                <th class="text-center">SL</th>
                                <th class="text-end">Thành tiền</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="item" items="${orderItems}">
                                <tr>
                                    <td>
                                        <div class="d-flex align-items-center gap-3">
                                            <img src="${not empty item.imageUrlSnapshot ? item.imageUrlSnapshot : 'https://via.placeholder.com/60/fdf2f2/E3000F?text=FFS'}"
                                                 style="width:56px;height:56px;object-fit:cover;border-radius:8px;"
                                                 alt="${item.productNameSnapshot}">
                                            <div>
                                                <strong class="d-block">${item.productNameSnapshot}</strong>
                                                <small class="text-muted">
                                                    <i class="fas fa-weight-hanging me-1"></i>Khay ${item.packWeightGramSnapshot}g
                                                </small>
                                                <c:if test="${item.lineDiscountSnapshot > 0}">
                                                    <br><span class="badge bg-success-subtle text-success small">
                                                        Tiết kiệm <fmt:formatNumber value="${item.lineDiscountSnapshot}" pattern="###,###"/>₫
                                                    </span>
                                                </c:if>
                                            </div>
                                        </div>
                                    </td>
                                    <td class="text-center">
                                        <fmt:formatNumber value="${item.computedPackBasePriceSnapshot}" pattern="###,###"/>₫
                                    </td>
                                    <td class="text-center fw-bold">${item.orderedQuantity}</td>
                                    <td class="text-end fw-bold text-brand">
                                        <fmt:formatNumber value="${item.lineTotalSnapshot}" pattern="###,###"/>₫
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>

            <%-- Cancel button (only PENDING) --%>
            <c:if test="${order.orderStatus == 1}">
                <form action="${pageContext.request.contextPath}/orders/cancel" method="post"
                      onsubmit="return confirm('Hủy đơn hàng này sẽ giải phóng toàn bộ hàng đã đặt giữ. Xác nhận hủy?')">
                    <input type="hidden" name="orderId" value="${order.orderId}">
                    <button type="submit" class="btn btn-outline-danger fw-bold">
                        <i class="fas fa-times-circle me-2"></i>Hủy đơn hàng
                    </button>
                </form>
            </c:if>
        </div>

        <%-- ══ RIGHT: Summary ══════════════════════════════════════════════ --%>
        <div class="col-lg-4">

            <%-- Shipping info --%>
            <div class="checkout-card mb-4">
                <h6 class="fw-bold mb-3"><i class="fas fa-map-marker-alt me-2 text-brand"></i>Thông tin giao hàng</h6>
                <p class="mb-1"><strong>${order.recipientNameSnapshot}</strong></p>
                <p class="text-muted small mb-1">
                    <i class="fas fa-phone me-1"></i>${order.recipientPhoneSnapshot}
                </p>
                <p class="text-muted small mb-0">
                    <i class="fas fa-home me-1"></i>${order.shippingAddressSnapshot}
                </p>
                <c:if test="${not empty order.note}">
                    <hr class="my-2">
                    <p class="text-muted small mb-0"><i class="fas fa-sticky-note me-1"></i>${order.note}</p>
                </c:if>
            </div>

            <%-- Financial summary --%>
            <div class="checkout-card">
                <h6 class="fw-bold mb-3"><i class="fas fa-receipt me-2"></i>Chi tiết thanh toán</h6>

                <div class="d-flex justify-content-between mb-2">
                    <span class="text-muted">Tạm tính</span>
                    <strong><fmt:formatNumber value="${order.subtotalAmount}" pattern="###,###"/> ₫</strong>
                </div>
                <c:if test="${order.discountAmount > 0}">
                    <div class="d-flex justify-content-between mb-2 text-success">
                        <span><i class="fas fa-tags me-1"></i>Giảm giá</span>
                        <strong>- <fmt:formatNumber value="${order.discountAmount}" pattern="###,###"/> ₫</strong>
                    </div>
                </c:if>
                <div class="d-flex justify-content-between mb-2">
                    <span class="text-muted">Phí giao hàng</span>
                    <c:choose>
                        <c:when test="${order.shippingFee == 0}">
                            <strong class="text-success">Miễn phí</strong>
                        </c:when>
                        <c:otherwise>
                            <strong><fmt:formatNumber value="${order.shippingFee}" pattern="###,###"/> ₫</strong>
                        </c:otherwise>
                    </c:choose>
                </div>

                <hr>
                <div class="d-flex justify-content-between align-items-center">
                    <span class="fw-bold">Tổng cộng</span>
                    <span class="fw-bold fs-4 text-brand">
                        <fmt:formatNumber value="${order.totalAmount}" pattern="###,###"/> ₫
                    </span>
                </div>

                <div class="mt-3 p-2 bg-light rounded-2 d-flex align-items-center gap-2">
                    <i class="fas fa-money-bill-wave text-success"></i>
                    <span class="small">Thanh toán: <strong>Tiền mặt khi nhận hàng (COD)</strong></span>
                </div>
            </div>
        </div>

    </div>
</div>

<jsp:include page="components/footer.jsp"/>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
