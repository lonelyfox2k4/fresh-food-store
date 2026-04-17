<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<html>
<head>
    <title>Chi tiết Đơn hàng #${order.orderCode}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <style>
        .bill-header { background: #f8f9fa; border-bottom: 2px dashed #dee2e6; }
        .product-img { width: 50px; height: 50px; object-fit: cover; border-radius: 4px; }
    </style>
</head>
<body class="bg-light">
<c:import url="/staff/common/nav.jsp" />

<div class="container py-3">
    <div class="mb-4">
        <c:choose>
            <c:when test="${param.from == 'feedback'}">
                <a href="feedback" class="btn btn-sm btn-light text-muted border-0 shadow-sm"><i class="bi bi-arrow-left"></i> Quay lại phản hồi</a>
            </c:when>
            <c:otherwise>
                <a href="orders?action=list" class="btn btn-sm btn-light text-muted border-0 shadow-sm"><i class="bi bi-arrow-left"></i> Quay lại danh sách</a>
            </c:otherwise>
        </c:choose>
    </div>

    <div class="row justify-content-center">
        <div class="col-lg-8">
            <div class="card border-0 shadow-sm">
                <!-- Bill Header -->
                <div class="card-body p-4 bill-header text-center">
                    <h3 class="fw-bold text-success mb-1">FRESH FOOD STORE</h3>
                    <p class="text-muted mb-0">HÓA ĐƠN BÁN LẺ</p>
                    <h5 class="fw-bold mt-3 mb-0">Mã đơn: #${order.orderCode}</h5>
                    <div class="small text-muted">Ngày đặt: ${order.placedAt.toString().replace('T', ' ').substring(0, 16)}</div>
                </div>

                <!-- Customer Details -->
                <div class="card-body p-4 border-bottom">
                    <div class="row g-3">
                        <div class="col-sm-6">
                            <h6 class="text-muted text-uppercase small mb-2">Khách hàng</h6>
                            <div class="fw-bold fs-5">${order.recipientNameSnapshot}</div>
                            <div><i class="bi bi-telephone text-muted"></i> ${order.recipientPhoneSnapshot}</div>
                        </div>
                        <div class="col-sm-6 text-sm-end">
                            <h6 class="text-muted text-uppercase small mb-2">Trạng thái thanh toán</h6>
                            <c:choose>
                                <c:when test="${order.paymentStatus == 1}">
                                    <span class="badge bg-success fs-6"><i class="bi bi-check-circle"></i> Đã thanh toán</span>
                                    <div class="small mt-1 text-muted">Lúc: ${order.paidAt != null ? order.paidAt.toString().replace('T', ' ').substring(0, 16) : 'N/A'}</div>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge bg-warning text-dark fs-6"><i class="bi bi-cash"></i> Chưa thanh toán (Nhận hàng thu tiền)</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="col-12 mt-3">
                            <h6 class="text-muted text-uppercase small mb-2">Giao đến</h6>
                            <div class="bg-light p-3 rounded">
                                <i class="bi bi-geo-alt-fill text-danger me-2"></i> ${order.shippingAddressSnapshot}
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Order Items -->
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
                                            <div class="fw-bold">${i.productNameSnapshot}</div>
                                            <small class="text-muted">Đóng gói: ${i.packWeightGramSnapshot}g</small>
                                        </td>
                                        <td class="text-center fw-bold">x${i.orderedQuantity}</td>
                                        <td class="text-end"><fmt:formatNumber value="${i.computedPackBasePriceSnapshot}" type="number"/> đ</td>
                                        <td class="text-end text-danger fw-bold pe-4"><fmt:formatNumber value="${i.lineTotalSnapshot}" type="number"/> đ</td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- Summary -->
                <div class="card-footer bg-white p-4">
                    <div class="row justify-content-end">
                        <div class="col-md-6 col-lg-5">
                            <div class="d-flex justify-content-between mb-2">
                                <span class="text-muted">Tạm tính:</span>
                                <span><fmt:formatNumber value="${order.subtotalAmount}" type="number"/> đ</span>
                            </div>
                            <div class="d-flex justify-content-between mb-2">
                                <span class="text-muted">Phí giao hàng:</span>
                                <span><fmt:formatNumber value="${order.shippingFee}" type="number"/> đ</span>
                            </div>
                            <div class="d-flex justify-content-between mb-3 text-success">
                                <span>Giảm giá:</span>
                                <span>- <fmt:formatNumber value="${order.discountAmount}" type="number"/> đ</span>
                            </div>
                            <hr class="border-secondary opacity-25">
                            <div class="d-flex justify-content-between align-items-center">
                                <span class="fw-bold text-uppercase">Tổng cộng:</span>
                                <span class="fs-4 fw-bold text-danger"><fmt:formatNumber value="${order.totalAmount}" type="number"/> đ</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>
