<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đơn hàng ${order.orderCode} | Fresh Food Store</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body class="bg-light d-flex flex-column min-vh-100">
<jsp:include page="../components/header.jsp"/>

<main class="container py-5 flex-grow-1">
    <%-- Breadcrumb --%>
    <nav aria-label="breadcrumb" class="mb-4">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/orders" class="text-brand text-decoration-none">Đơn hàng của tôi</a></li>
            <li class="breadcrumb-item active">${order.orderCode}</li>
        </ol>
    </nav>

    <div class="row g-4">
        <%-- Left: Order basics & Items --%>
        <div class="col-lg-8">
            <div class="bg-white p-4 rounded-3 shadow-sm mb-4">
                <div class="d-flex justify-content-between align-items-center flex-wrap gap-2 mb-3">
                    <h4 class="fw-bold mb-0">Đơn hàng <span class="text-brand">${order.orderCode}</span></h4>
                    <span class="badge rounded-pill py-2 px-3 status-${order.orderStatus} fs-6">
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
                <div class="text-muted small">
                    <i class="far fa-clock me-1"></i>
                    Đặt lúc: <%= ((org.example.model.order.Order)request.getAttribute("order")).getPlacedAt() != null ? ((org.example.model.order.Order)request.getAttribute("order")).getPlacedAt().format(java.time.format.DateTimeFormatter.ofPattern("HH:mm - dd/MM/yyyy")) : "N/A" %>
                </div>
                <c:if test="${order.orderStatus == 6 && not empty order.cancelledReason}">
                    <div class="alert alert-danger mt-3 py-2 mb-0 small border-0">
                        <i class="fas fa-info-circle me-1"></i>Lý do hủy: ${order.cancelledReason}
                    </div>
                </c:if>
            </div>

            <div class="bg-white rounded-3 shadow-sm overflow-hidden mb-4">
                <div class="p-3 bg-light border-bottom fw-bold">
                    <i class="fa-solid fa-box-open me-2 text-primary"></i>Sản phẩm đã đặt
                </div>
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead class="bg-light small text-muted">
                            <tr>
                                <th class="ps-4">Sản phẩm</th>
                                <th class="text-center">Đơn giá</th>
                                <th class="text-center">SL</th>
                                <th class="text-end pe-4">Thành tiền</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="item" items="${orderItems}">
                                <tr>
                                    <td class="ps-4">
                                        <div class="d-flex align-items-center gap-3">
                                            <img src="${not empty item.imageUrlSnapshot ? item.imageUrlSnapshot : 'https://via.placeholder.com/60x60?text=Food'}"
                                                 alt="${item.productNameSnapshot}" width="50" height="50" class="rounded-2" style="object-fit: cover;">
                                            <div>
                                                <div class="fw-semibold small">${item.productNameSnapshot}</div>
                                                <div class="text-muted extra-small">${item.packWeightGramSnapshot}g</div>
                                            </div>
                                        </div>
                                    </td>
                                    <td class="text-center small">
                                        <fmt:formatNumber value="${item.computedPackBasePriceSnapshot}" pattern="###,###"/> ₫
                                    </td>
                                    <td class="text-center small fw-bold">${item.orderedQuantity}</td>
                                    <td class="text-end pe-4 fw-bold text-brand small">
                                        <fmt:formatNumber value="${item.lineTotalSnapshot}" pattern="###,###"/> ₫
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>

            <c:if test="${order.orderStatus == 1}">
                <form action="${pageContext.request.contextPath}/orders/cancel" method="post" 
                      onsubmit="return confirm('Hủy đơn hàng này? Thao tác không thể hoàn tác.')">
                    <input type="hidden" name="orderId" value="${order.orderId}">
                    <button type="submit" class="btn btn-outline-danger btn-sm fw-bold">
                        <i class="fa-solid fa-rectangle-xmark me-1"></i> Hủy đơn hàng này
                    </button>
                </form>
            </c:if>
        </div>

        <%-- Right: Summary & Recipient --%>
        <div class="col-lg-4">
            <div class="bg-white p-4 rounded-3 shadow-sm mb-4">
                <h6 class="fw-bold mb-3 border-bottom pb-2">
                    <i class="fa-solid fa-location-dot me-2 text-primary"></i>Thông tin giao hàng
                </h6>
                <div class="mb-1 fw-bold">${order.recipientNameSnapshot}</div>
                <div class="text-muted small mb-3">
                    <i class="fas fa-phone me-1"></i>${order.recipientPhoneSnapshot}
                </div>
                <div class="bg-light p-3 rounded-3 small text-muted">
                    <i class="fas fa-map-marker-alt me-1"></i>${order.shippingAddressSnapshot}
                </div>
                <c:if test="${not empty order.note}">
                   <div class="mt-3 small">
                       <span class="text-muted">Ghi chú:</span> <em>${order.note}</em>
                   </div>
                </c:if>
            </div>

            <div class="bg-white p-4 rounded-3 shadow-sm border-top border-4 border-brand">
                <h6 class="fw-bold mb-4 border-bottom pb-2">
                    <i class="fa-solid fa-receipt me-2 text-primary"></i>Chi tiết thanh toán
                </h6>
                
                <div class="d-flex justify-content-between mb-2 small">
                    <span class="text-muted">Tạm tính</span>
                    <strong class="text-dark"><fmt:formatNumber value="${order.subtotalAmount}" pattern="###,###"/> ₫</strong>
                </div>
                <c:if test="${order.discountAmount > 0}">
                    <div class="d-flex justify-content-between mb-2 text-success small">
                        <span>Giảm giá</span>
                        <strong>- <fmt:formatNumber value="${order.discountAmount}" pattern="###,###"/> ₫</strong>
                    </div>
                </c:if>
                <div class="d-flex justify-content-between mb-2 small">
                    <span class="text-muted">Phí giao hàng</span>
                    <strong>
                        <c:choose>
                            <c:when test="${order.shippingFee == 0}"><span class="text-success">Miễn phí</span></c:when>
                            <c:otherwise><fmt:formatNumber value="${order.shippingFee}" pattern="###,###"/> ₫</c:otherwise>
                        </c:choose>
                    </strong>
                </div>
                <hr>
                <div class="d-flex justify-content-between align-items-center">
                    <span class="fw-bold">Tổng thanh toán</span>
                    <span class="fs-4 fw-bold text-brand"><fmt:formatNumber value="${order.totalAmount}" pattern="###,###"/> ₫</span>
                </div>
                <div class="mt-3 p-2 bg-light rounded-2 small d-flex align-items-center gap-2">
                    <i class="fa-solid fa-credit-card text-primary"></i>
                    <span>Thanh toán: <strong>
                        <c:choose>
                            <c:when test="${order.paymentStatus == 1}">VNPAY (Thanh toán Online)</c:when>
                            <c:otherwise>COD (Tiền mặt)</c:otherwise>
                        </c:choose>
                    </strong></span>
                </div>
                <div class="mt-2 p-2 rounded-2 small d-flex align-items-center gap-2 ${order.paymentStatus == 1 || order.paymentStatus == 2 || order.paymentStatus == 3 ? 'bg-success bg-opacity-10 text-success' : 'bg-warning bg-opacity-10 text-warning'}">
                    <i class="fa-solid ${order.paymentStatus == 1 || order.paymentStatus == 2 || order.paymentStatus == 3 ? 'fa-check-circle' : 'fa-clock'}"></i>
                    <span>Trạng thái: <strong>
                        <c:choose>
                            <c:when test="${order.paymentStatus == 1 || order.paymentStatus == 2 || order.paymentStatus == 3}">Đã thanh toán</c:when>
                            <c:otherwise>Chờ thanh toán</c:otherwise>
                        </c:choose>
                    </strong></span>
                </div>
            </div>
        </div>
    </div>
</main>

<jsp:include page="../components/footer.jsp"/>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
