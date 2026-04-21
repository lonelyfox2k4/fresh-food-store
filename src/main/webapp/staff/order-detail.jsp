<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<html>
<head>
    <title>Chi tiết Đơn hàng #${order.orderCode} | Fresh Food</title>
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <!-- Bootstrap 5 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- FontAwesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <jsp:include page="../components/admin-style.jsp" />
    <style>
        .bill-header { background: #f8f9fa; border-bottom: 2px dashed #dee2e6; }
        .timeline-dot {
            width: 12px; height: 12px; border-radius: 50%;
            background: var(--brand-color); flex-shrink: 0; margin-top: 4px;
        }
    </style>
</head>
<body>
<jsp:include page="../components/admin-nav.jsp">
    <jsp:param name="active" value="${param.from == 'feedback' ? 'partners' : 'orders'}" />
</jsp:include>

<div class="container py-3">
    <div class="page-header mt-n2 mb-4">
        <div class="container d-flex justify-content-between align-items-center">
            <div>
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb mb-1">
                        <c:choose>
                            <c:when test="${param.from == 'feedback'}">
                                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/staff/feedback">Phản hồi</a></li>
                            </c:when>
                            <c:otherwise>
                                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/staff/orders">Bán hàng</a></li>
                                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/staff/orders">Đơn hàng</a></li>
                            </c:otherwise>
                        </c:choose>
                        <li class="breadcrumb-item active">Chi tiết</li>
                    </ol>
                </nav>
                <h2 class="fw-800 mb-0">Hóa đơn #${order.orderCode}</h2>
            </div>
            <c:choose>
                <c:when test="${param.from == 'feedback'}">
                    <a href="${pageContext.request.contextPath}/staff/feedback" class="btn btn-outline-brand rounded-pill px-4 shadow-sm">
                        <i class="fas fa-arrow-left me-2"></i>Quay lại Phản hồi
                    </a>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/staff/orders" class="btn btn-outline-brand rounded-pill px-4 shadow-sm">
                        <i class="fas fa-arrow-left me-2"></i>Quay lại Danh sách
                    </a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <div class="row justify-content-center">
        <div class="col-lg-8">
            <div class="card border-0 shadow-sm">

                <%-- Header hóa đơn --%>
                <div class="card-body p-4 bill-header text-center">
                    <h3 class="fw-bold text-brand mb-1">
                        <i class="bi bi-leaf me-1"></i>FRESH FOOD STORE
                    </h3>
                    <p class="text-muted mb-0 small text-uppercase">Hóa đơn bán lẻ</p>
                    <h5 class="fw-bold mt-3 mb-0">Mã đơn: #${order.orderCode}</h5>
                    <div class="small text-muted mt-1">
                        <i class="bi bi-calendar3 me-1"></i>
                        Đặt lúc: ${order.placedAt.toString().replace('T',' ').substring(0,16)}
                    </div>
                </div>

                <%-- Thông tin khách + Thanh toán --%>
                <div class="card-body p-4 border-bottom">
                    <div class="row g-3">
                        <div class="col-sm-6">
                            <h6 class="text-muted text-uppercase small mb-2">Thông tin khách hàng</h6>
                            <div class="fw-bold fs-5">${order.recipientNameSnapshot}</div>
                            <div class="text-muted">
                                <i class="bi bi-telephone me-1"></i>${order.recipientPhoneSnapshot}
                            </div>
                        </div>
                        <div class="col-sm-6 text-sm-end">
                            <h6 class="text-muted text-uppercase small mb-2">Trạng thái thanh toán</h6>
                            <c:choose>
                                <c:when test="${order.paymentStatus == 1}">
                                    <span class="badge bg-success fs-6 rounded-pill px-3">
                                        <i class="bi bi-credit-card me-1"></i>Đã TT Online
                                    </span>
                                    <div class="small mt-1 text-muted">
                                        Lúc: ${not empty order.paidAt ? order.paidAt.toString().replace('T',' ').substring(0,16) : 'N/A'}
                                    </div>
                                </c:when>
                                <c:when test="${order.paymentStatus == 2}">
                                    <span class="badge bg-success fs-6 rounded-pill px-3">
                                        <i class="bi bi-cash-coin me-1"></i>Đã thu (COD)
                                    </span>
                                    <div class="small mt-1 text-muted">
                                        Lúc: ${not empty order.paidAt ? order.paidAt.toString().replace('T',' ').substring(0,16) : 'N/A'}
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge bg-warning text-dark fs-6 rounded-pill px-3">
                                        <i class="bi bi-clock me-1"></i>Chờ thanh toán (COD)
                                    </span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="col-12">
                            <h6 class="text-muted text-uppercase small mb-2">Địa chỉ giao hàng</h6>
                            <div class="bg-light p-3 rounded border">
                                <i class="bi bi-geo-alt-fill text-danger me-2"></i>${order.shippingAddressSnapshot}
                            </div>
                        </div>
                        <c:if test="${not empty order.note}">
                            <div class="col-12">
                                <h6 class="text-muted text-uppercase small mb-2">Ghi chú</h6>
                                <div class="p-3 rounded border border-warning bg-warning bg-opacity-10 small">
                                    <i class="bi bi-info-circle-fill text-warning me-1"></i>${order.note}
                                </div>
                            </div>
                        </c:if>
                    </div>
                </div>

                <%-- Danh sách sản phẩm --%>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-borderless table-striped align-middle mb-0">
                            <thead class="bg-light text-muted small text-uppercase">
                            <tr>
                                <th class="ps-4">Sản phẩm</th>
                                <th class="text-center">Số lượng</th>
                                <th class="text-end">Đơn giá</th>
                                <th class="text-end pe-4">Thành tiền</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach items="${itemList}" var="i">
                                <tr>
                                    <td class="ps-4">
                                        <div class="fw-semibold">${i.productNameSnapshot}</div>
                                        <small class="text-muted">
                                            <i class="bi bi-box me-1"></i>Đóng gói: ${i.packWeightGramSnapshot}g
                                        </small>
                                    </td>
                                    <td class="text-center fw-bold">x${i.orderedQuantity}</td>
                                    <td class="text-end text-muted">
                                        <fmt:formatNumber value="${i.computedPackBasePriceSnapshot}" type="number"/> đ
                                    </td>
                                    <td class="text-end text-danger fw-bold pe-4">
                                        <fmt:formatNumber value="${i.lineTotalSnapshot}" type="number"/> đ
                                    </td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>

                <%-- Tổng tiền --%>
                <div class="card-footer bg-white p-4">
                    <div class="row justify-content-end">
                        <div class="col-md-6 col-lg-5">
                            <div class="d-flex justify-content-between mb-2 text-muted">
                                <span>Tạm tính:</span>
                                <span><fmt:formatNumber value="${order.subtotalAmount}" type="number"/> đ</span>
                            </div>
                            <div class="d-flex justify-content-between mb-2 text-muted">
                                <span>Phí giao hàng:</span>
                                <span><fmt:formatNumber value="${order.shippingFee}" type="number"/> đ</span>
                            </div>
                            <div class="d-flex justify-content-between mb-3 text-success">
                                <span>Giảm giá:</span>
                                <span>- <fmt:formatNumber value="${order.discountAmount}" type="number"/> đ</span>
                            </div>
                            <hr class="border-secondary opacity-25">
                            <div class="d-flex justify-content-between align-items-center">
                                <span class="fw-bold text-uppercase">Tổng cộng:</span>
                                <span class="fs-4 fw-bold text-brand">
                                    <fmt:formatNumber value="${order.totalAmount}" type="number"/> đ
                                </span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
