<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lịch sử đơn hàng – Fresh Food Store</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
<jsp:include page="components/header.jsp"/>

<div class="container my-5">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h1 class="h3 fw-bold mb-0">
            <i class="fas fa-clipboard-list me-2 text-brand"></i>Đơn hàng của tôi
        </h1>
        <a href="${pageContext.request.contextPath}/products" class="btn btn-outline-secondary btn-sm">
            <i class="fas fa-shopping-bag me-1"></i>Mua tiếp
        </a>
    </div>

    <%-- Flash messages --%>
    <c:if test="${not empty sessionScope.orderMsg}">
        <c:set var="oMsg" value="${sessionScope.orderMsg}"/>
        <c:set var="oType" value="${fn:startsWith(oMsg,'success') ? 'success' : 'danger'}"/>
        <div class="alert alert-${oType} alert-dismissible">
            <i class="fas fa-info-circle me-2"></i>
            ${fn:substringAfter(oMsg, ':')}
            <button class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <c:remove var="orderMsg" scope="session"/>
    </c:if>

    <c:choose>
        <c:when test="${empty orders}">
            <div class="text-center py-5">
                <i class="fas fa-box-open fa-5x text-muted mb-4"></i>
                <h4 class="text-muted">Bạn chưa có đơn hàng nào</h4>
                <a href="${pageContext.request.contextPath}/products" class="btn btn-brand mt-2 px-5">
                    Mua sắm ngay
                </a>
            </div>
        </c:when>
        <c:otherwise>
            <c:forEach var="order" items="${orders}">
                <div class="card border-0 shadow-sm mb-3">
                    <div class="card-body">
                        <div class="row align-items-center">
                            <%-- Order code & date --%>
                            <div class="col-md-3 mb-2 mb-md-0">
                                <p class="text-muted small mb-0">Mã đơn hàng</p>
                                <strong class="text-brand">${order.orderCode}</strong>
                                <p class="text-muted small mb-0 mt-1">
                                    <i class="far fa-calendar-alt me-1"></i>
                                    <%= ((org.example.model.order.Order)pageContext.getAttribute("order")).getPlacedAt().format(java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm")) %>
                                </p>
                            </div>

                            <%-- Recipient --%>
                            <div class="col-md-3 mb-2 mb-md-0">
                                <p class="text-muted small mb-0">Người nhận</p>
                                <strong>${order.recipientNameSnapshot}</strong><br>
                                <small class="text-muted">${order.recipientPhoneSnapshot}</small>
                            </div>

                            <%-- Total --%>
                            <div class="col-md-2 mb-2 mb-md-0">
                                <p class="text-muted small mb-0">Tổng tiền</p>
                                <strong class="text-brand">
                                    <fmt:formatNumber value="${order.totalAmount}" pattern="###,###"/> ₫
                                </strong>
                            </div>

                            <%-- Status --%>
                            <div class="col-md-2 mb-2 mb-md-0 text-center">
                                <span class="badge rounded-pill status-${order.orderStatus} py-2 px-3">
                                    <c:choose>
                                        <c:when test="${order.orderStatus == 1}">⏳ Chờ xác nhận</c:when>
                                        <c:when test="${order.orderStatus == 2}">✅ Đã xác nhận</c:when>
                                        <c:when test="${order.orderStatus == 3}">🔄 Đang chuẩn bị</c:when>
                                        <c:when test="${order.orderStatus == 4}">🚚 Đang giao hàng</c:when>
                                        <c:when test="${order.orderStatus == 5}">🎉 Đã giao thành công</c:when>
                                        <c:when test="${order.orderStatus == 6}">❌ Đã hủy</c:when>
                                        <c:otherwise>Không xác định</c:otherwise>
                                    </c:choose>
                                </span>
                            </div>

                            <%-- Actions --%>
                            <div class="col-md-2 text-md-end">
                                <a href="${pageContext.request.contextPath}/orders/detail?id=${order.orderId}"
                                   class="btn btn-outline-secondary btn-sm me-1">
                                    <i class="fas fa-eye me-1"></i>Chi tiết
                                </a>
                                <c:if test="${order.orderStatus == 1}">
                                    <form action="${pageContext.request.contextPath}/orders/cancel"
                                          method="post" class="d-inline"
                                          onsubmit="return confirm('Bạn có chắc muốn hủy đơn hàng này?')">
                                        <input type="hidden" name="orderId" value="${order.orderId}">
                                        <button type="submit" class="btn btn-outline-danger btn-sm">
                                            <i class="fas fa-times me-1"></i>Hủy
                                        </button>
                                    </form>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </c:otherwise>
    </c:choose>
</div>

<jsp:include page="components/footer.jsp"/>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
