<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<html>
<head>
    <title>Chi tiết Đơn hàng | Shipper</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <meta name="viewport" content="width=device-width, initial-scale=1">
</head>
<body class="bg-light">

<nav class="navbar navbar-dark bg-primary mb-3 shadow-sm py-2">
    <div class="container">
        <a class="navbar-brand fw-bold small" href="${pageContext.request.contextPath}/shipper/orders">
            <i class="bi bi-chevron-left me-1"></i> Quay lại danh sách
        </a>
    </div>
</nav>

<div class="container pb-5">
    <div class="card border-0 shadow-sm mb-3">
        <div class="card-body">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h5 class="fw-bold mb-0 text-primary">Đơn hàng #${order.orderCode}</h5>
                <c:choose>
                    <c:when test="${order.orderStatus == 1}"><span class="badge bg-primary">Chờ lấy hàng</span></c:when>
                    <c:when test="${order.orderStatus == 2}"><span class="badge bg-info text-dark">Đang giao hàng</span></c:when>
                    <c:when test="${order.orderStatus == 3}"><span class="badge bg-success">Đã giao thành công</span></c:when>
                    <c:when test="${order.orderStatus == 4}"><span class="badge bg-danger">Giao thất bại / Đã hủy</span></c:when>
                </c:choose>
            </div>
            
            <div class="mb-4">
                <p class="mb-1 text-muted small"><i class="bi bi-person"></i> Người nhận:</p>
                <p class="fw-bold mb-3">${order.recipientNameSnapshot} - ${order.recipientPhoneSnapshot}</p>
                
                <p class="mb-1 text-muted small"><i class="bi bi-geo-alt"></i> Địa chỉ giao hàng:</p>
                <p class="mb-3">${order.shippingAddressSnapshot}</p>
                
                <c:if test="${not empty order.note}">
                    <div class="p-2 bg-warning bg-opacity-10 border border-warning rounded small">
                        <strong>Ghi chú:</strong> ${order.note}
                    </div>
                </c:if>
            </div>

            <div class="border-top pt-3">
                <h6 class="fw-bold mb-3"><i class="bi bi-list-ul me-2"></i>Danh sách sản phẩm</h6>
                <c:forEach items="${itemList}" var="item">
                    <div class="d-flex align-items-center mb-3">
                        <img src="${item.imageUrlSnapshot}" class="rounded shadow-sm me-3" style="width: 45px; height: 45px; object-fit: cover;">
                        <div class="flex-grow-1">
                            <div class="fw-bold small">${item.productNameSnapshot}</div>
                            <small class="text-muted">SL: ${item.orderedQuantity} x <fmt:formatNumber value="${item.computedPackBasePriceSnapshot}" type="number"/>đ</small>
                        </div>
                        <div class="text-end fw-bold text-success small">
                            <fmt:formatNumber value="${item.lineTotalSnapshot}" type="number"/>đ
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </div>

    <div class="card border-0 shadow-sm">
        <div class="card-body">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <span class="text-muted">Tạm tính:</span>
                <span><fmt:formatNumber value="${order.subtotalAmount}" type="number"/> đ</span>
            </div>
            <div class="d-flex justify-content-between align-items-center mb-3">
                <span class="text-muted">Phí giao hàng:</span>
                <span>+ <fmt:formatNumber value="${order.shippingFee}" type="number"/> đ</span>
            </div>
            <div class="d-flex justify-content-between align-items-center mb-3">
                <span class="text-muted">Giảm giá:</span>
                <span class="text-success">- <fmt:formatNumber value="${order.discountAmount}" type="number"/> đ</span>
            </div>
            <div class="d-flex justify-content-between align-items-center pt-2 border-top">
                <h5 class="fw-bold text-danger mb-0">TỔNG THU:</h5>
                <h4 class="fw-bold text-danger mb-0"><fmt:formatNumber value="${order.totalAmount}" type="number"/> đ</h4>
            </div>
            <div class="text-end mt-2">
                <c:choose>
                    <c:when test="${order.paymentStatus == 1}">
                        <span class="badge bg-success"><i class="bi bi-check-circle"></i> Đã thanh toán trước</span>
                    </c:when>
                    <c:otherwise>
                        <span class="badge bg-warning text-dark"><i class="bi bi-cash"></i> Thu hộ (COD)</span>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

    <div class="fixed-bottom p-3 bg-white border-top shadow-lg">
        <c:choose>
            <c:when test="${order.shippingStatus == 1}">
                <form action="orders" method="post" class="m-0">
                    <input type="hidden" name="action" value="startShipping">
                    <input type="hidden" name="orderId" value="${order.orderId}">
                    <button class="btn btn-primary w-100 fw-bold py-2"><i class="bi bi-truck me-2"></i> Bắt đầu giao ngay</button>
                </form>
            </c:when>
            <c:when test="${order.shippingStatus == 2}">
                <div class="d-flex gap-2">
                    <form action="orders" method="post" class="flex-grow-1 m-0">
                        <input type="hidden" name="action" value="delivered">
                        <input type="hidden" name="orderId" value="${order.orderId}">
                        <input type="hidden" name="isCod" value="${order.paymentStatus == 0 ? 'true' : 'false'}">
                        <button class="btn btn-success w-100 fw-bold py-2"><i class="bi bi-check-circle me-1"></i> Đã giao</button>
                    </form>
                    <button type="button" class="btn btn-outline-danger py-2 px-3" data-bs-toggle="modal" data-bs-target="#failModal">
                        Thất bại
                    </button>
                </div>
            </c:when>
            <c:otherwise>
                <a href="${pageContext.request.contextPath}/shipper/orders" class="btn btn-secondary w-100 fw-bold py-2">Quay lại danh sách</a>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<!-- Modal Báo cáo thất bại -->
<div class="modal fade" id="failModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered mx-2">
        <div class="modal-content border-0 shadow">
            <form action="orders" method="post" class="m-0">
                <div class="modal-header bg-danger text-white py-2">
                    <h6 class="modal-title">Giao thất bại</h6>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <input type="hidden" name="action" value="failed">
                    <input type="hidden" name="orderId" value="${order.orderId}">
                    <label class="form-label small">Lý do không thể giao:</label>
                    <select name="reason" class="form-select border-danger" required>
                        <option value="">-- Chọn lý do --</option>
                        <option value="Khách không nghe máy">Không liên lạc được</option>
                        <option value="Khách hủy trực tiếp">Khách đổi ý không nhận</option>
                        <option value="Sai địa chỉ / SĐT">Sai thông tin khách hàng</option>
                        <option value="Sự cố ngoại cảnh">Lý do khách quan khác</option>
                    </select>
                </div>
                <div class="modal-footer p-2 border-0">
                    <button type="submit" class="btn btn-danger w-100 py-2 fw-bold">Xác nhận báo cáo</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
