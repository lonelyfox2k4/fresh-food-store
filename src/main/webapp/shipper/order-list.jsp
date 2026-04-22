<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<html>
<head>
    <title>Giao hàng | Shipper</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <meta name="viewport" content="width=device-width, initial-scale=1">
</head>
<body class="bg-light">

<nav class="navbar navbar-dark bg-primary mb-4 shadow-sm py-3">
    <div class="container d-flex justify-content-between align-items-center">
        <a class="navbar-brand fw-bold" href="${pageContext.request.contextPath}/shipper/orders">
            <i class="bi bi-truck me-2"></i>Shipper Panel
        </a>
        <div class="d-flex align-items-center">
            <span class="text-white me-3 small d-none d-sm-inline">
                <i class="bi bi-person-circle"></i> ${sessionScope.user.fullName}
            </span>
            <a href="${pageContext.request.contextPath}/logout" class="btn btn-sm btn-light text-primary fw-bold">
                <i class="bi bi-box-arrow-right"></i> Thoát
            </a>
        </div>
    </div>
</nav>

<div class="container pb-5">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h4 class="fw-bold mb-0">Quản lý giao hàng</h4>
        <a href="orders" class="btn btn-sm btn-outline-primary shadow-sm">
            <i class="bi bi-arrow-clockwise"></i> Cập nhật
        </a>
    </div>

    <!-- Messages -->
    <c:if test="${not empty param.msg}">
        <div class="alert alert-success border-0 shadow-sm alert-dismissible fade show">
            <i class="bi bi-check-circle-fill me-2"></i>
            <c:choose>
                <c:when test="${param.msg == 'claimed'}">Chúc mừng! Bạn đã nhận đơn hàng thành công.</c:when>
                <c:when test="${param.msg == 'started'}">Đã bắt đầu giao đơn hàng.</c:when>
                <c:when test="${param.msg == 'delivered'}">Đã giao thành công!</c:when>
                <c:when test="${param.msg == 'failed'}">Đã báo cáo giao thất bại.</c:when>
                <c:otherwise>Thao tác thành công!</c:otherwise>
            </c:choose>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>
    <c:if test="${param.error == 'claim_failed'}">
        <div class="alert alert-warning border-0 shadow-sm">
            <i class="bi bi-exclamation-triangle-fill me-2"></i> Rất tiếc, đơn hàng này đã có người khác nhận trước mất rồi!
        </div>
    </c:if>
    <c:if test="${param.error == 'unauthorized'}">
        <div class="alert alert-danger border-0 shadow-sm">
            <i class="bi bi-shield-lock-fill me-2"></i> Bạn không có quyền xử lý đơn hàng này!
        </div>
    </c:if>

    <!-- Tabs Nav -->
    <ul class="nav nav-pills nav-fill mb-4 bg-white p-2 rounded shadow-sm" id="orderTabs" role="tablist">
        <li class="nav-item" role="presentation">
            <button class="nav-link fw-bold ${empty param.msg or param.msg == 'updated' ? 'active' : ''}" id="available-tab" data-bs-toggle="tab" data-bs-target="#available" type="button" role="tab">
                <i class="bi bi-grid-3x3-gap"></i> Đơn hàng tự do (${availableList.size()})
            </button>
        </li>
        <li class="nav-item" role="presentation">
            <button class="nav-link fw-bold ${not empty param.msg and param.msg != 'updated' ? 'active' : ''}" id="my-orders-tab" data-bs-toggle="tab" data-bs-target="#my-orders" type="button" role="tab">
                <i class="bi bi-person-check"></i> Đơn của tôi (${orderList.size()})
            </button>
        </li>
    </ul>

    <!-- Tabs Content -->
    <div class="tab-content" id="orderTabsContent">
        <!-- TAB 1: AVAILABLE ORDERS -->
        <div class="tab-pane fade ${empty param.msg or param.msg == 'updated' ? 'show active' : ''}" id="available" role="tabpanel">
            <div class="row row-cols-1 row-cols-md-2 g-3">
                <c:forEach items="${availableList}" var="o">
                    <div class="col">
                        <div class="card h-100 border-0 shadow-sm">
                            <div class="card-body">
                                <div class="d-flex justify-content-between align-items-center mb-2">
                                    <h6 class="card-title fw-bold text-primary mb-0">#${o.orderCode}</h6>
                                    <span class="badge bg-secondary">Đơn chờ nhận</span>
                                </div>
                                <div class="mb-3">
                                    <p class="mb-1 small text-dark"><i class="bi bi-person text-muted"></i> <strong>${o.recipientNameSnapshot}</strong></p>
                                    <p class="mb-0 small text-muted text-truncate-2"><i class="bi bi-geo-alt text-muted"></i> ${o.shippingAddressSnapshot}</p>
                                </div>
                                
                                <div class="d-flex justify-content-between align-items-center bg-light p-2 rounded mb-3">
                                    <div>
                                        <small class="text-muted d-block">Phí thu hộ & Ship:</small>
                                        <strong class="text-danger fs-5"><fmt:formatNumber value="${o.totalAmount}" type="number"/> đ</strong>
                                    </div>
                                    <div class="text-end">
                                        <c:choose>
                                            <c:when test="${o.paymentStatus == 1}">
                                                <span class="badge bg-outline-success text-success"><i class="bi bi-check-circle"></i> Đã thanh toán</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-outline-warning text-warning"><i class="bi bi-cash"></i> Thu COD</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>

                                <form action="orders" method="post" class="m-0">
                                    <input type="hidden" name="action" value="claim">
                                    <input type="hidden" name="orderId" value="${o.orderId}">
                                    <button class="btn btn-primary w-100 fw-bold py-2 shadow-sm"><i class="bi bi-plus-circle-dotted me-1"></i> Nhận đơn này ngay</button>
                                </form>
                            </div>
                        </div>
                    </div>
                </c:forEach>
                <c:if test="${empty availableList}">
                    <div class="col-12 text-center py-5 text-muted">
                        <i class="bi bi-emoji-smile fs-1 d-block mb-3"></i>
                        Hiện tại chưa có đơn hàng nào cần giao.
                    </div>
                </c:if>
            </div>
        </div>

        <!-- TAB 2: MY ORDERS -->
        <div class="tab-pane fade ${not empty param.msg and param.msg != 'updated' ? 'show active' : ''}" id="my-orders" role="tabpanel">
            <div class="row row-cols-1 row-cols-md-2 g-3">
                <c:forEach items="${orderList}" var="o">
                    <div class="col">
                        <div class="card h-100 border-0 shadow-sm ${o.shippingStatus == 3 ? 'border-start border-success border-4' : (o.shippingStatus == 4 ? 'border-start border-danger border-4' : '')}">
                            <div class="card-body">
                                <div class="d-flex justify-content-between align-items-center mb-2">
                                    <h6 class="card-title fw-bold text-primary mb-0">#${o.orderCode}</h6>
                                    <a href="orders?action=detail&id=${o.orderId}" class="btn btn-sm btn-link text-decoration-none p-0 fw-bold">Chi tiết <i class="bi bi-chevron-right"></i></a>
                                </div>
                                <div class="mb-2">
                                    <c:choose>
                                        <c:when test="${o.orderStatus == 3}"><span class="badge bg-warning text-dark">Chờ lấy hàng</span></c:when>
                                        <c:when test="${o.orderStatus == 4}"><span class="badge bg-info text-dark">Đang giao hàng</span></c:when>
                                        <c:when test="${o.orderStatus == 5}">
                                            <span class="badge bg-success">Đã hoàn tất</span>
                                            <span class="ms-1 text-success small fw-bold"><i class="bi bi-cash-stack"></i> Đã thu tiền</span>
                                        </c:when>
                                        <c:when test="${o.orderStatus == 6}">
                                            <span class="badge bg-danger">Hủy / Thất bại</span>
                                            <c:if test="${not empty o.cancelledReason}">
                                                <div class="small text-danger mt-1 fw-medium"><i class="bi bi-info-circle"></i> Lý do: ${o.cancelledReason}</div>
                                            </c:if>
                                        </c:when>
                                    </c:choose>
                                </div>
                                
                                <p class="mb-1 small text-dark"><i class="bi bi-person text-muted"></i> <strong>${o.recipientNameSnapshot}</strong></p>
                                <p class="mb-2 small text-muted text-truncate-2" title="${o.shippingAddressSnapshot}"><i class="bi bi-geo-alt text-muted"></i> ${o.shippingAddressSnapshot}</p>
                                
                                <div class="d-flex justify-content-between align-items-center bg-light p-2 rounded mb-3">
                                    <div>
                                        <small class="text-muted d-block">Tổng thu:</small>
                                        <strong class="text-danger fs-5"><fmt:formatNumber value="${o.totalAmount}" type="number"/> đ</strong>
                                    </div>
                                    <div class="text-end">
                                        <c:choose>
                                            <c:when test="${o.paymentStatus == 1}">
                                                <span class="badge bg-success">Đã thanh toán</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-warning text-dark">Thu COD</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>

                                <div class="d-flex gap-2">
                                    <c:if test="${o.shippingStatus == 1}">
                                        <form action="orders" method="post" class="w-100 m-0">
                                            <input type="hidden" name="action" value="startShipping">
                                            <input type="hidden" name="orderId" value="${o.orderId}">
                                            <button class="btn btn-primary w-100 fw-bold"><i class="bi bi-play-circle"></i> Bắt đầu giao</button>
                                        </form>
                                    </c:if>
                                    
                                    <c:if test="${o.shippingStatus == 2}">
                                        <form action="orders" method="post" class="flex-grow-1 m-0" onsubmit="return confirm('Xác nhận ĐÃ GIAO hàng thành công?');">
                                            <input type="hidden" name="action" value="delivered">
                                            <input type="hidden" name="orderId" value="${o.orderId}">
                                            <button class="btn btn-success w-100 fw-bold"><i class="bi bi-check-square"></i> Đã giao tốt</button>
                                        </form>
                                        <button type="button" class="btn btn-outline-danger btn-sm" data-bs-toggle="modal" data-bs-target="#failModal${o.orderId}">
                                            Lỗi giao
                                        </button>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Modal Báo cáo thất bại -->
                    <div class="modal fade" id="failModal${o.orderId}" tabindex="-1">
                        <div class="modal-dialog modal-dialog-centered">
                            <div class="modal-content border-0 shadow">
                                <form action="orders" method="post" class="m-0">
                                    <div class="modal-header bg-danger text-white">
                                        <h6 class="modal-title m-0">Báo cáo Giao Thất Bại</h6>
                                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                                    </div>
                                    <div class="modal-body">
                                        <input type="hidden" name="action" value="failed">
                                        <input type="hidden" name="orderId" value="${o.orderId}">
                                        <label class="form-label">Chọn lý do thất bại:</label>
                                        <select name="reason" class="form-select mb-3" required>
                                            <option value="">-- Chọn lý do --</option>
                                            <option value="Không liên lạc được khách">Không liên lạc được khách</option>
                                            <option value="Khách đổi ý hủy đơn">Khách đổi ý không nhận</option>
                                            <option value="Sai địa chỉ">Sai địa chỉ</option>
                                            <option value="Sự cố xe cộ/thời tiết">Sự cố xe cộ / thời tiết</option>
                                        </select>
                                    </div>
                                    <div class="modal-footer border-0">
                                        <button type="button" class="btn btn-light" data-bs-dismiss="modal">Hủy</button>
                                        <button type="submit" class="btn btn-danger">Xác nhận</button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </c:forEach>
                <c:if test="${empty orderList}">
                    <div class="col-12 text-center py-5 text-muted">
                        <i class="bi bi-box-seam fs-1 d-block mb-3"></i>
                        Bạn chưa nhận đơn hàng nào.
                    </div>
                </c:if>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
