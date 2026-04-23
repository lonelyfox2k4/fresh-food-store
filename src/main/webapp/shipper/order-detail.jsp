<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<html>
<head>
    <title>Chi Tiết Đơn Hàng | Shipper</title>
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=0">
    <style>
        body { font-family: 'Inter', sans-serif; background-color: #f4f7fe; padding-bottom: 90px; }
        .detail-card { border-radius: 20px; border: none; box-shadow: 0 4px 20px rgba(0,0,0,0.03); }
        .item-img { width: 56px; height: 56px; object-fit: cover; border-radius: 12px; border: 1px solid #f1f5f9; padding: 2px; }
        
        /* Cải tiến Timeline */
        .timeline { position: relative; padding-left: 32px; margin-bottom: 0; list-style: none; }
        .timeline::before { content: ''; position: absolute; left: 11px; top: 8px; height: calc(100% - 20px); width: 2px; background: #e2e8f0; }
        .timeline-item { position: relative; margin-bottom: 24px; }
        .timeline-item:last-child { margin-bottom: 0; }
        
        .timeline-indicator { position: absolute; left: -32px; top: 0; width: 24px; height: 24px; border-radius: 50%; background: #e2e8f0; display: flex; align-items: center; justify-content: center; z-index: 1; border: 4px solid #fff; box-shadow: 0 0 0 1px #e2e8f0;}
        .timeline-indicator.active { background: #0d6efd; box-shadow: 0 0 0 4px rgba(13,110,253,0.15); border: 4px solid #fff; }
        .timeline-indicator.success { background: #198754; box-shadow: 0 0 0 4px rgba(25,135,84,0.15); border: 4px solid #fff; }
        .timeline-indicator.danger { background: #dc3545; box-shadow: 0 0 0 4px rgba(220,53,69,0.15); border: 4px solid #fff; }
        
        .sticky-action-bar { border-radius: 24px 24px 0 0; box-shadow: 0 -10px 30px rgba(0,0,0,0.06); background: #ffffff; padding: 16px 20px 24px; }
        
        .contact-action-btn { width: 48px; height: 48px; border-radius: 50%; display: flex; align-items: center; justify-content: center; transition: all 0.2s; font-size: 1.25rem;}
        .contact-action-btn:hover { filter: brightness(0.95); transform: translateY(-2px); }
        
        .dashed-divider { border-top: 2px dashed #e2e8f0; margin: 15px 0; }
    </style>
</head>
<body>

<jsp:include page="../components/shipper-nav.jsp">
    <jsp:param name="showBack" value="true" />
</jsp:include>

<div class="container pb-5">
    
    <!-- Header Nhỏ -->
    <div class="d-flex justify-content-between align-items-center mb-4 px-1">
        <h5 class="fw-bold text-dark mb-0 d-flex align-items-center">
            Đơn <span class="badge bg-white text-primary border border-primary border-opacity-25 ms-2 rounded-3 fs-6">#${order.orderCode}</span>
        </h5>
        <div class="text-end small text-muted fw-medium">
            <c:choose>
                <c:when test="${order.paymentStatus == 1}">
                    <span class="text-success"><i class="bi bi-shield-check me-1"></i>Đã thanh toán</span>
                </c:when>
                <c:otherwise>
                    <span class="text-warning text-dark"><i class="bi bi-wallet2 me-1"></i>Thu hộ COD</span>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <!-- Timeline Trạng Thái -->
    <div class="card detail-card mb-4 bg-white">
        <div class="card-body p-4">
            <h6 class="fw-bold text-muted text-uppercase mb-4 small"><i class="bi bi-funnel me-1"></i> Trạng thái giao hàng</h6>
            <ul class="timeline">
                <li class="timeline-item">
                    <div class="timeline-indicator ${order.orderStatus >= 3 ? 'active' : ''} ${order.orderStatus > 3 ? 'success' : ''}"></div>
                    <div class="fw-bold ${order.orderStatus >= 3 ? 'text-dark fs-6' : 'text-muted'}">Nhận đơn hàng</div>
                    <small class="text-muted d-block mt-1">Đã điều phối đơn hàng thành công</small>
                </li>
                
                <li class="timeline-item">
                    <div class="timeline-indicator ${order.shippingStatus == 2 ? 'active' : (order.shippingStatus > 2 ? 'success' : '')}"></div>
                    <div class="fw-bold ${order.shippingStatus >= 2 ? 'text-dark fs-6' : 'text-muted'}">Đang đi giao</div>
                    <small class="text-muted d-block mt-1">Shipper đang trên đường giao hàng đến kho</small>
                </li>
                
                <li class="timeline-item">
                    <c:choose>
                        <c:when test="${order.orderStatus == 5}"><div class="timeline-indicator success"></div></c:when>
                        <c:when test="${order.orderStatus == 6}"><div class="timeline-indicator danger"></div></c:when>
                        <c:otherwise><div class="timeline-indicator"></div></c:otherwise>
                    </c:choose>
                    <c:choose>
                        <c:when test="${order.orderStatus == 5}">
                            <div class="fw-bold text-success fs-6">Giao thành công</div>
                            <small class="text-muted d-block mt-1">Cảm ơn bạn đã hoàn thành chuyến!</small>
                        </c:when>
                        <c:when test="${order.orderStatus == 6}">
                            <div class="fw-bold text-danger fs-6">Giao hàng thất bại</div>
                            <small class="text-danger fw-medium d-block mt-1">${order.cancelledReason}</small>
                        </c:when>
                        <c:otherwise>
                            <div class="fw-bold text-muted">Hoàn thành</div>
                            <small class="text-muted d-block mt-1">Giao tận tay khách nhận hàng</small>
                        </c:otherwise>
                    </c:choose>
                </li>
            </ul>
        </div>
    </div>

    <!-- Thông Tin Người Nhận -->
    <div class="card detail-card mb-4 bg-white overflow-hidden">
        <div class="p-3 border-bottom d-flex align-items-center">
            <span class="bg-primary bg-opacity-10 text-primary rounded-circle d-flex align-items-center justify-content-center me-2" style="width: 32px; height: 32px;">
                <i class="bi bi-geo-alt-fill"></i>
            </span>
            <h6 class="fw-bold text-dark mb-0">Địa điểm & Liên hệ</h6>
        </div>
        <div class="card-body p-4">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h5 class="fw-bold text-dark mb-1">${order.recipientNameSnapshot}</h5>
                    <p class="text-muted mb-0 fw-medium"><i class="bi bi-telephone-fill me-1 small"></i> ${order.recipientPhoneSnapshot}</p>
                </div>
                <a href="tel:${order.recipientPhoneSnapshot}" class="contact-action-btn bg-success text-white text-decoration-none shadow-sm">
                    <i class="bi bi-telephone-outbound"></i>
                </a>
            </div>
            
            <div class="bg-light p-3 rounded-4 mb-2">
                <div class="fw-semibold small text-muted text-uppercase mb-1">Giao đến:</div>
                <div class="fw-medium text-dark lh-base">${order.shippingAddressSnapshot}</div>
            </div>
            
            <c:if test="${not empty order.note}">
                <div class="bg-warning bg-opacity-10 border border-warning border-opacity-25 p-3 rounded-4 mt-3 d-flex align-items-start">
                    <i class="bi bi-journal-text text-warning fs-4 me-2 mt-n1"></i>
                    <div>
                        <div class="fw-bold text-warning-emphasis small mb-1">Ghi chú nhà hàng</div>
                        <div class="fw-medium text-dark small">${order.note}</div>
                    </div>
                </div>
            </c:if>
        </div>
    </div>

    <!-- Danh sách Sản Phẩm -->
    <div class="card detail-card mb-4 bg-white overflow-hidden">
        <div class="p-3 border-bottom d-flex align-items-center justify-content-between">
            <div class="d-flex align-items-center">
                <span class="bg-danger bg-opacity-10 text-danger rounded-circle d-flex align-items-center justify-content-center me-2" style="width: 32px; height: 32px;">
                    <i class="bi bi-basket-fill"></i>
                </span>
                <h6 class="fw-bold text-dark mb-0">Sản phẩm khách đặt</h6>
            </div>
            <span class="badge bg-light text-dark fw-bold rounded-pill border">${itemList.size()} món</span>
        </div>
        <div class="card-body p-0">
            <c:forEach items="${itemList}" var="item" varStatus="loop">
                <div class="d-flex align-items-center p-3 ${!loop.last ? 'border-bottom' : ''}">
                    <!-- Image handling logic, usually it's absolute URL in DB but we fallback just in case -->
                    <img src="${item.imageUrlSnapshot}" onerror="this.src='https://placehold.co/100x100?text=Food'" class="item-img shadow-sm bg-white me-3">
                    <div class="flex-grow-1">
                        <div class="fw-bold text-dark mb-1 small">${item.productNameSnapshot}</div>
                        <div class="text-muted" style="font-size: 0.8rem;">
                            Đơn giá: <fmt:formatNumber value="${item.computedPackBasePriceSnapshot}" type="number"/>đ
                        </div>
                    </div>
                    <div class="text-end">
                        <div class="fw-bold text-dark small">x ${item.orderedQuantity}</div>
                        <div class="fw-bold text-primary mt-1">
                            <fmt:formatNumber value="${item.lineTotalSnapshot}" type="number"/>đ
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>
    </div>

    <!-- Tóm Tắt Thanh Toán -->
    <div class="card detail-card mb-5 bg-white shadow-sm border-0">
        <div class="card-body p-4">
            <h6 class="fw-bold text-dark mb-4 text-center"><i class="bi bi-receipt me-2 text-muted"></i>CHI TIẾT THANH TOÁN</h6>
            
            <div class="d-flex justify-content-between mb-2">
                <span class="text-muted fw-medium small">Tổng tiền đồ ăn:</span>
                <span class="fw-semibold text-dark"><fmt:formatNumber value="${order.subtotalAmount}" type="number"/> đ</span>
            </div>
            <div class="d-flex justify-content-between mb-2">
                <span class="text-muted fw-medium small">Phí giao hàng:</span>
                <span class="fw-semibold text-dark">+ <fmt:formatNumber value="${order.shippingFee}" type="number"/> đ</span>
            </div>
            <div class="d-flex justify-content-between mb-2">
                <span class="text-muted fw-medium small">Mã giảm giá (Hệ thống):</span>
                <span class="text-success fw-bold">- <fmt:formatNumber value="${order.discountAmount}" type="number"/> đ</span>
            </div>
            
            <div class="dashed-divider"></div>
            
            <div class="d-flex justify-content-between align-items-center bg-light p-3 rounded-4 mt-3">
                <h6 class="fw-bold text-dark mb-0 text-uppercase">TỔNG KHÁCH TRẢ</h6>
                <h4 class="fw-bold text-danger mb-0 fs-3"><fmt:formatNumber value="${order.totalAmount}" type="number"/> đ</h4>
            </div>
            
            <div class="mt-4">
                <c:choose>
                    <c:when test="${order.paymentStatus == 1}">
                        <div class="bg-success bg-opacity-10 border border-success border-opacity-25 rounded-4 p-3 d-flex align-items-center">
                            <i class="bi bi-check-circle-fill text-success fs-2 me-3"></i>
                            <div>
                                <h6 class="fw-bold text-success mb-1">ĐƠN ĐÃ ĐƯỢC TRẢ TRƯỚC</h6>
                                <p class="small text-dark fw-medium mb-0">Chỉ cần đưa hàng, <strong class="text-danger">KHÔNG THU TIỀN</strong>.</p>
                            </div>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="bg-warning bg-opacity-10 border border-warning border-opacity-50 rounded-4 p-3 d-flex align-items-center">
                            <i class="bi bi-cash-coin text-warning-emphasis fs-2 me-3"></i>
                            <div>
                                <h6 class="fw-bold text-dark mb-1">ĐƠN TRẢ TIỀN MẶT C.O.D</h6>
                                <p class="small text-dark fw-medium mb-0">Cần thu khách đủ: <strong class="text-danger fs-6"><fmt:formatNumber value="${order.totalAmount}" type="number"/> đ</strong></p>
                            </div>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>
    
    <!-- Spacer for sticky bottom bar -->
    <div style="height: 40px;"></div>
</div>

<!-- STICKY ACTION BAR -->
<div class="fixed-bottom sticky-action-bar z-3">
    <div class="container px-xl-5">
        <c:choose>
            <c:when test="${order.shippingStatus == 1}">
                <form action="orders" method="post" class="m-0 w-100">
                    <input type="hidden" name="action" value="startShipping">
                    <input type="hidden" name="orderId" value="${order.orderId}">
                    <button class="btn btn-primary w-100 fw-bold py-3 fs-5 rounded-pill shadow-lg d-flex justify-content-center align-items-center">
                        <i class="bi bi-scooter me-2 text-warning fs-4"></i> BẮT ĐẦU ĐI GIAO
                    </button>
                </form>
            </c:when>
            <c:when test="${order.shippingStatus == 2}">
                <div class="d-flex gap-3">
                    <form action="orders" method="post" class="flex-grow-1 m-0" onsubmit="return confirm('XÁC NHẬN: Bạn đã giao hàng cho khách và thu đủ tiền COD (nếu có)?');">
                        <input type="hidden" name="action" value="delivered">
                        <input type="hidden" name="orderId" value="${order.orderId}">
                        <button class="btn btn-success w-100 fw-bold py-3 rounded-pill shadow-lg text-uppercase fs-6">
                            <i class="bi bi-check2-circle fs-5 me-1"></i> XONG ĐƠN
                        </button>
                    </form>
                    <button type="button" class="btn btn-outline-danger py-3 px-4 rounded-pill shadow-sm fw-bold border-2" data-bs-toggle="modal" data-bs-target="#failModal">
                        <i class="bi bi-x-octagon fs-5"></i>
                    </button>
                </div>
            </c:when>
            <c:otherwise>
                <!-- Trạng thái đã hoàn tất (5) hoặc Thất bại (6) -->
                <a href="${pageContext.request.contextPath}/shipper/orders" class="btn btn-light border-2 text-dark w-100 fw-bold py-3 rounded-pill shadow-sm">
                    Quay lại danh sách
                </a>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<!-- Modal Báo cáo thất bại -->
<div class="modal fade" id="failModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered mx-3">
        <div class="modal-content border-0 rounded-4 shadow-lg overflow-hidden">
            <form action="orders" method="post" class="m-0">
                <div class="modal-header bg-danger text-white py-3 border-0">
                    <h5 class="modal-title fw-bold d-flex align-items-center">
                        <i class="bi bi-exclamation-triangle-fill me-2 fs-4 text-warning"></i> Cập Nhật Lỗi Giao
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body p-4 bg-white">
                    <input type="hidden" name="action" value="failed">
                    <input type="hidden" name="orderId" value="${order.orderId}">
                    
                    <p class="small text-muted mb-3">Mã đơn đang cần đóng: <strong class="text-dark">#${order.orderCode}</strong></p>
                    
                    <label class="form-label fw-bold text-dark">Hãy chọn lý do chính xác:</label>
                    <div class="position-relative">
                        <select name="reason" class="form-select form-select-lg border-danger fw-medium fs-6 py-3 rounded-3" style="box-shadow: 0 0 0 4px rgba(220,53,69,0.1);" required>
                            <option value="">-- Bấm chọn lý do --</option>
                            <option value="Không liên lạc được khách">Thuê bao / Không nghe máy</option>
                            <option value="Khách đổi ý hủy đơn">Khách từ chối nhận hàng (Boom)</option>
                            <option value="Sai thông tin liên hệ">Số điện thoại hỏng / Địa chỉ sai</option>
                            <option value="Sự cố xe cộ/thời tiết">Shipper gặp sự cố bất khả kháng</option>
                        </select>
                    </div>
                </div>
                <div class="modal-footer p-3 border-top-0 bg-light justify-content-between">
                    <button type="button" class="btn btn-light fw-bold px-4" data-bs-dismiss="modal">Trở lại</button>
                    <button type="submit" class="btn btn-danger fw-bold px-4 rounded-pill shadow-sm">Xác nhận báo lỗi</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
