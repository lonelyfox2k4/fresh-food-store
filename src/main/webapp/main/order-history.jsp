<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đơn hàng của tôi | Fresh Food Store</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body class="bg-light d-flex flex-column min-vh-100">
<jsp:include page="../components/header.jsp"/>

<main class="container py-5 flex-grow-1">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="mb-0">Đơn hàng của tôi</h2>
        <a href="${pageContext.request.contextPath}/home" class="btn btn-outline-secondary btn-sm">
            <i class="fa-solid fa-cart-shopping me-1"></i> Tiếp tục mua sắm
        </a>
    </div>

    <%-- Flash messages --%>
    <c:if test="${not empty sessionScope.orderMsg}">
        <c:set var="oMsg" value="${sessionScope.orderMsg}"/>
        <c:set var="oType" value="${fn:startsWith(oMsg,'success') ? 'success' : 'danger'}"/>
        <div class="alert alert-${oType} alert-dismissible mb-4 shadow-sm border-0">
            <i class="fas fa-info-circle me-2"></i>
            ${fn:substringAfter(oMsg, ':')}
            <button class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <c:remove var="orderMsg" scope="session"/>
    </c:if>

    <c:choose>
        <c:when test="${empty orders}">
            <div class="text-center py-5 bg-white rounded-3 shadow-sm">
                <i class="fa-solid fa-box-open fa-4x text-muted mb-3"></i>
                <h4 class="text-muted">Bạn chưa có đơn hàng nào.</h4>
                <p class="text-muted">Hãy bắt đầu mua sắm những thực phẩm tươi ngon nhất!</p>
                <a href="${pageContext.request.contextPath}/home" class="btn btn-brand fw-bold px-4">Mua sắm ngay</a>
            </div>
        </c:when>
        <c:otherwise>
            <div class="table-responsive bg-white rounded-3 shadow-sm">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light">
                        <tr>
                            <th class="ps-4 py-3">Mã đơn hàng</th>
                            <th>Ngày đặt</th>
                            <th>Người nhận</th>
                            <th class="text-center">Trạng thái</th>
                            <th class="text-end">Tổng tiền</th>
                            <th class="text-end pe-4">Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="order" items="${orders}">
                            <tr>
                                <td class="ps-4 clickable-row" data-href="${pageContext.request.contextPath}/orders/detail?id=${order.orderId}" style="cursor: pointer;">
                                    <a href="${pageContext.request.contextPath}/orders/detail?id=${order.orderId}" class="fw-bold text-brand text-decoration-none">
                                        ${order.orderCode}
                                    </a>
                                </td>
                                <td class="small clickable-row" data-href="${pageContext.request.contextPath}/orders/detail?id=${order.orderId}" style="cursor: pointer;">
                                    <i class="far fa-calendar-alt me-1 text-muted"></i>
                                    <%= ((org.example.model.order.Order)pageContext.getAttribute("order")).getPlacedAt() != null ? ((org.example.model.order.Order)pageContext.getAttribute("order")).getPlacedAt().format(java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy")) : "N/A" %>
                                </td>
                                <td class="small clickable-row" data-href="${pageContext.request.contextPath}/orders/detail?id=${order.orderId}" style="cursor: pointer;">
                                    <div class="fw-semibold">${order.recipientNameSnapshot}</div>
                                    <div class="text-muted">${order.recipientPhoneSnapshot}</div>
                                </td>
                                <td class="text-center clickable-row" data-href="${pageContext.request.contextPath}/orders/detail?id=${order.orderId}" style="cursor: pointer;">
                                    <span class="badge rounded-pill py-2 px-3 status-${order.orderStatus}">
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
                                </td>
                                <td class="text-end fw-bold clickable-row" data-href="${pageContext.request.contextPath}/orders/detail?id=${order.orderId}" style="cursor: pointer;">
                                    <fmt:formatNumber value="${order.totalAmount}" pattern="###,###"/> ₫
                                </td>
                                <td class="text-end pe-4">
                                    <div class="dropdown">
                                        <button class="btn btn-light btn-sm rounded-circle" type="button" data-bs-toggle="dropdown">
                                            <i class="fa-solid fa-ellipsis-vertical"></i>
                                        </button>
                                        <ul class="dropdown-menu dropdown-menu-end shadow-sm border-0">
                                            <li>
                                                <a class="dropdown-item" href="${pageContext.request.contextPath}/orders/detail?id=${order.orderId}">
                                                    <i class="fa-solid fa-circle-info me-2 text-primary"></i>Chi tiết
                                                </a>
                                            </li>
                                            <c:if test="${order.orderStatus == 1}">
                                                <li><hr class="dropdown-divider"></li>
                                                <li>
                                                    <form action="${pageContext.request.contextPath}/orders/cancel" method="post" 
                                                          onsubmit="return confirm('Bạn có chắc muốn hủy đơn hàng này?')">
                                                        <input type="hidden" name="orderId" value="${order.orderId}">
                                                        <button type="submit" class="dropdown-item text-danger">
                                                            <i class="fa-solid fa-rectangle-xmark me-2"></i>Hủy đơn
                                                        </button>
                                                    </form>
                                                </li>
                                            </c:if>
                                        </ul>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </c:otherwise>
    </c:choose>
</main>

<jsp:include page="../components/footer.jsp"/>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.addEventListener("DOMContentLoaded", function() {
        const rows = document.querySelectorAll(".clickable-row");
        rows.forEach(row => {
            row.addEventListener("click", function() {
                window.location.href = this.dataset.href;
            });
        });
    });
</script>
</body>
</html>
