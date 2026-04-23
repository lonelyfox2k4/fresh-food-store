<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<html>
<head>
    <title>Bảng Điều Khiển | Shipper</title>
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=0">
    <style>
        body { font-family: 'Inter', sans-serif; background-color: #f4f7fe; }
        .dashboard-card { border-radius: 16px; border: none; box-shadow: 0 4px 20px rgba(0,0,0,0.03); transition: transform 0.2s; }
        .dashboard-card:hover { transform: translateY(-3px); }
        .stat-icon { width: 44px; height: 44px; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 1.4rem; }
        
        .order-card { 
            border-radius: 16px; border: none; 
            box-shadow: 0 4px 15px rgba(0,0,0,0.04); 
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
            background: #ffffff;
        }
        .order-card:hover { transform: translateY(-4px); box-shadow: 0 10px 25px rgba(0,0,0,0.08); }
        .card-accent-success { border-left: 5px solid #198754 !important; }
        .card-accent-danger { border-left: 5px solid #dc3545 !important; }
        .card-accent-warning { border-left: 5px solid #ffc107 !important; }
        .card-accent-info { border-left: 5px solid #0dcaf0 !important; }
        
        .nav-pills { background: #ffffff; padding: 6px; border-radius: 16px; box-shadow: 0 2px 10px rgba(0,0,0,0.02); }
        .nav-pills .nav-link { border-radius: 12px; font-weight: 600; padding: 12px 20px; transition: all 0.3s ease; color: #6c757d; }
        .nav-pills .nav-link.active { background: #0d6efd; color: #ffffff; box-shadow: 0 4px 12px rgba(13,110,253,0.3); transform: scale(1.02); }
        .nav-pills .nav-item { margin: 0 2px; }
        .nav-pills .nav-link:not(.active):hover { background: #f8f9fa; color: #0d6efd; }
        
        /* Progress Bar */
        .progress-slim { height: 6px; border-radius: 10px; }
    </style>
</head>
<body>

<jsp:include page="../components/shipper-nav.jsp" />

<div class="container pb-5">
    
    <!-- STATS DASHBOARD -->
    <div class="row row-cols-2 row-cols-lg-3 row-cols-xl-5 g-3 mb-4">
        <!-- Calculate Success Rate -->
        <c:set var="total" value="${stats.totalOrders != null ? stats.totalOrders : 0}" />
        <c:set var="success" value="${stats.successOrders != null ? stats.successOrders : 0}" />
        <c:set var="successRate" value="${total > 0 ? (success * 100 / total) : 0}" />
        
        <!-- CARD 1: TỔNG ĐƠN -->
        <div class="col">
            <div class="card dashboard-card h-100">
                <div class="card-body p-3">
                    <div class="d-flex justify-content-between align-items-center mb-2">
                        <div class="stat-icon bg-primary bg-opacity-10 text-primary">
                            <i class="bi bi-box-seam"></i>
                        </div>
                    </div>
                    <h6 class="text-muted small fw-semibold mb-1 text-uppercase">TỔNG ĐƠN</h6>
                    <h3 class="fw-bold text-dark lh-1 mb-0">${total}</h3>
                </div>
            </div>
        </div>
        
        <!-- CARD 2: THÀNH CÔNG -->
        <div class="col">
            <div class="card dashboard-card h-100">
                <div class="card-body p-3">
                    <div class="d-flex justify-content-between align-items-center mb-2">
                        <div class="stat-icon bg-success bg-opacity-10 text-success">
                            <i class="bi bi-check-circle"></i>
                        </div>
                    </div>
                    <h6 class="text-muted small fw-semibold mb-1 text-uppercase">Thành Công</h6>
                    <h3 class="fw-bold text-dark lh-1 mb-0">${success}</h3>
                    <div class="d-flex align-items-center mt-2">
                        <div class="progress progress-slim w-100 me-2 bg-light">
                            <div class="progress-bar bg-success" style="width: ${successRate}%"></div>
                        </div>
                        <span class="small fw-bold text-success"><fmt:formatNumber type="number" minFractionDigits="0" maxFractionDigits="1" value="${successRate}"/>%</span>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- CARD 3: ĐANG CHẠY -->
        <div class="col">
            <div class="card dashboard-card h-100">
                <div class="card-body p-3">
                    <div class="d-flex justify-content-between align-items-center mb-2">
                        <div class="stat-icon bg-info bg-opacity-10 text-info">
                            <i class="bi bi-scooter"></i>
                        </div>
                    </div>
                    <h6 class="text-muted small fw-semibold mb-1 text-uppercase">Đang Đi Giao</h6>
                    <h3 class="fw-bold text-dark lh-1 mb-0">${stats.activeOrders != null ? stats.activeOrders : 0}</h3>
                </div>
            </div>
        </div>

        <!-- CARD 4: TỔNG TIỀN ĐÃ THU -->
        <div class="col">
            <div class="card dashboard-card h-100">
                <div class="card-body p-3">
                    <div class="d-flex justify-content-between align-items-center mb-2">
                        <div class="stat-icon bg-danger bg-opacity-10 text-danger">
                            <i class="bi bi-cash-stack"></i>
                        </div>
                    </div>
                    <h6 class="text-muted small fw-semibold mb-1 text-uppercase">Tổng C.O.D Đã Thu</h6>
                    <h3 class="fw-bold text-dark lh-1 mb-0"><fmt:formatNumber value="${stats.totalEarnings}" type="number"/>đ</h3>
                </div>
            </div>
        </div>

        <!-- CARD 5: ĐÃ NỘP LÊN CỬA HÀNG -->
        <div class="col">
            <div class="card dashboard-card h-100">
                <div class="card-body p-3">
                    <div class="d-flex justify-content-between align-items-center mb-2">
                        <div class="stat-icon bg-secondary bg-opacity-10 text-secondary">
                            <i class="bi bi-safe2"></i>
                        </div>
                    </div>
                    <h6 class="text-muted small fw-semibold mb-1 text-uppercase">Đã Nộp Cho Cửa Hàng</h6>
                    <h3 class="fw-bold text-dark lh-1 mb-0"><fmt:formatNumber value="${stats.totalRemitted}" type="number"/>đ</h3>
                </div>
            </div>
        </div>
    </div>

    <!-- REMIT ACTIONS -->
    <c:if test="${stats.totalEarnings > 0}">
        <div class="alert alert-danger border-danger border border-opacity-25 shadow-sm rounded-4 d-flex flex-column flex-md-row align-items-md-center justify-content-between mb-4 bg-danger bg-opacity-10">
            <div class="d-flex align-items-center mb-3 mb-md-0">
                <i class="bi bi-shield-lock-fill fs-2 me-3 text-danger"></i>
                <div>
                    <h6 class="fw-bold mb-1 text-danger">Yêu cầu Trả Tiền Thu Hộ (C.O.D)</h6>
                    <span class="small text-dark fw-medium">Bạn đang nợ cửa hàng số tiền mặt: <strong class="text-danger fs-6"><fmt:formatNumber value="${stats.totalEarnings}" type="number"/>đ</strong></span>
                </div>
            </div>
            <form action="orders" method="post" class="m-0" onsubmit="return confirm('CẢNH BÁO: \n\nBạn xác nhận ĐÃ NỘP TOÀN BỘ SỐ TIỀN MẶT <fmt:formatNumber value="${stats.totalEarnings}" type="number"/>đ GIAO CHO QUẢN LÝ CỬA HÀNG?\n\nNhấn OK để hoàn tất thanh toán. Hành động này không thể hoàn tác!');">
                <input type="hidden" name="action" value="remit">
                <button type="submit" class="btn btn-danger fw-bold rounded-pill px-4 py-2 shadow w-100">
                    <i class="bi bi-safe2 me-1"></i> Bàn Giao Quỹ
                </button>
            </form>
        </div>
    </c:if>

    <!-- Messages & Alerts -->
    <c:if test="${not empty param.msg}">
        <div class="alert alert-success border-0 shadow-sm alert-dismissible fade show rounded-4 d-flex align-items-center">
            <i class="bi bi-check-circle-fill fs-4 me-3 text-success"></i>
            <div class="fw-medium text-dark">
                <c:choose>
                    <c:when test="${param.msg == 'claimed'}">Đã nhận đơn hàng thành công! Hãy bắt đầu đi giao nhé.</c:when>
                    <c:when test="${param.msg == 'started'}">Trạng thái: Shipper đang trên đường giao.</c:when>
                    <c:when test="${param.msg == 'delivered'}">Giao hàng hoàn tất! Bạn làm tốt lắm.</c:when>
                    <c:when test="${param.msg == 'failed'}">Đã cập nhật lỗi giao hàng lên hệ thống.</c:when>
                    <c:when test="${param.msg == 'remitted'}">Quỹ đã nhận tiền. Cảm ơn bạn, chuyến giao hàng khép lại hoàn hảo!</c:when>
                    <c:otherwise>Thao tác hoàn tất thành công!</c:otherwise>
                </c:choose>
            </div>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>
    <c:if test="${param.error == 'claim_failed'}">
        <div class="alert alert-warning border-0 shadow-sm rounded-4 d-flex align-items-center">
            <i class="bi bi-exclamation-triangle-fill fs-4 me-3 text-warning"></i> 
            <div class="fw-medium text-dark">Rất tiếc! Đơn này vừa bị thu hồi hoặc đã có Shipper khác nhận.</div>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <!-- UI TABS -->
    <div class="mb-4">
        <ul class="nav nav-pills nav-fill" id="orderTabs" role="tablist">
            <li class="nav-item" role="presentation">
                <button class="nav-link ${empty param.msg or param.msg == 'updated' ? 'active' : ''}" id="available-tab" data-bs-toggle="tab" data-bs-target="#available" type="button" role="tab">
                    <i class="bi bi-basket me-1"></i> Kho Chờ Nhận <span class="badge ${empty param.msg or param.msg == 'updated' ? 'bg-white text-primary' : 'bg-primary text-white'} ms-1 rounded-pill">${availableList.size()}</span>
                </button>
            </li>
            <li class="nav-item" role="presentation">
                <button class="nav-link ${not empty param.msg and param.msg != 'updated' ? 'active' : ''}" id="my-orders-tab" data-bs-toggle="tab" data-bs-target="#my-orders" type="button" role="tab">
                    <i class="bi bi-person-check me-1"></i> Đơn Đang Chạy <span class="badge ${not empty param.msg and param.msg != 'updated' ? 'bg-white text-primary' : 'bg-primary text-white'} ms-1 rounded-pill">${orderList.size()}</span>
                </button>
            </li>
        </ul>
    </div>

    <!-- TABS CONTENT -->
    <div class="tab-content" id="orderTabsContent">
        <!-- TAB 1: KHO TỔNG (AVAILABLE) -->
        <div class="tab-pane fade ${empty param.msg or param.msg == 'updated' ? 'show active' : ''}" id="available" role="tabpanel">
            <div class="row row-cols-1 row-cols-md-2 row-cols-xl-3 g-4">
                <c:forEach items="${availableList}" var="o">
                    <div class="col">
                        <div class="card order-card h-100">
                            <div class="card-body p-4 d-flex flex-column">
                                <div class="d-flex justify-content-between align-items-start mb-3">
                                    <div>
                                        <span class="badge bg-primary bg-opacity-10 text-primary mb-2 border border-primary border-opacity-10 rounded-pill px-3 py-2">
                                            Chờ lấy hàng
                                        </span>
                                        <h5 class="fw-bold text-dark mb-0">#${o.orderCode}</h5>
                                    </div>
                                    <div class="text-end">
                                        <span class="d-block text-muted small fw-semibold">Thu C.O.D</span>
                                        <h4 class="fw-bold text-danger mb-0"><fmt:formatNumber value="${o.totalAmount}" type="number"/>đ</h4>
                                    </div>
                                </div>
                                
                                <div class="bg-light rounded-4 p-3 mb-4">
                                    <div class="d-flex align-items-start mb-2">
                                        <i class="bi bi-person text-secondary mt-1 me-2 fs-5"></i>
                                        <div>
                                            <div class="fw-bold text-dark">${o.recipientNameSnapshot}</div>
                                            <div class="text-muted small">${o.recipientPhoneSnapshot}</div>
                                        </div>
                                    </div>
                                    <div class="d-flex align-items-start">
                                        <i class="bi bi-geo-alt text-danger mt-1 me-2 fs-5"></i>
                                        <div class="text-dark small fw-medium text-truncate-2" title="${o.shippingAddressSnapshot}">${o.shippingAddressSnapshot}</div>
                                    </div>
                                </div>

                                <form action="orders" method="post" class="m-0 mt-auto">
                                    <input type="hidden" name="action" value="claim">
                                    <input type="hidden" name="orderId" value="${o.orderId}">
                                    <button class="btn btn-primary w-100 fw-bold py-3 rounded-3 shadow-sm btn-lg fs-6 d-flex align-items-center justify-content-center">
                                        <i class="bi bi-lightning-charge-fill me-2 text-warning fs-5"></i> GIÀNH ĐƠN NGAY
                                    </button>
                                </form>
                            </div>
                        </div>
                    </div>
                </c:forEach>
                <c:if test="${empty availableList}">
                    <div class="col-12 py-5 text-center">
                        <div class="p-5 w-100">
                            <i class="bi bi-emoji-sunglasses text-muted opacity-50 fs-1 mb-3 d-block"></i>
                            <h5 class="fw-bold text-dark">Hôm nay anh em nghỉ ngơi</h5>
                            <p class="text-muted mb-0">Hiện tại kho tổng đã xử lý hết đơn, bạn quay lại sau nhé!</p>
                        </div>
                    </div>
                </c:if>
            </div>
        </div>

        <!-- TAB 2: ĐƠN CỦA BẠN (MY ORDERS) -->
        <div class="tab-pane fade ${not empty param.msg and param.msg != 'updated' ? 'show active' : ''}" id="my-orders" role="tabpanel">
            <div class="row row-cols-1 row-cols-md-2 row-cols-xl-3 g-4">
                <c:forEach items="${orderList}" var="o">
                    <c:set var="statusAccent" value="card-accent-warning"/>
                    <c:if test="${o.shippingStatus == 2 || o.orderStatus == 4}"><c:set var="statusAccent" value="card-accent-info"/></c:if>
                    <c:if test="${o.shippingStatus == 3 || o.orderStatus == 5}"><c:set var="statusAccent" value="card-accent-success"/></c:if>
                    <c:if test="${o.shippingStatus == 4 || o.orderStatus == 6}"><c:set var="statusAccent" value="card-accent-danger"/></c:if>
                    
                    <div class="col">
                        <div class="card order-card h-100 ${statusAccent}">
                            <div class="card-body p-4 d-flex flex-column">
                                <div class="d-flex justify-content-between align-items-start mb-3">
                                    <h5 class="fw-bold text-dark mb-0">
                                        <a href="orders?action=detail&id=${o.orderId}" class="text-decoration-none text-dark stretched-link">
                                            #${o.orderCode} <i class="bi bi-arrow-up-right-square ms-1 text-muted small"></i>
                                        </a>
                                    </h5>
                                    <div class="position-relative z-3">
                                        <c:choose>
                                            <c:when test="${o.orderStatus == 3}"><span class="badge bg-warning text-dark py-2 px-3 rounded-pill fw-bold">Chờ lấy hàng</span></c:when>
                                            <c:when test="${o.orderStatus == 4}"><span class="badge bg-info text-dark py-2 px-3 rounded-pill fw-bold">Đang giao hàng</span></c:when>
                                            <c:when test="${o.orderStatus == 5}"><span class="badge bg-success py-2 px-3 rounded-pill fw-bold"><i class="bi bi-check2-all"></i> Thành công</span></c:when>
                                            <c:when test="${o.orderStatus == 6}"><span class="badge bg-danger py-2 px-3 rounded-pill fw-bold"><i class="bi bi-x-octagon"></i> Thất bại</span></c:when>
                                        </c:choose>
                                    </div>
                                </div>
                                
                                <div class="bg-light rounded-4 p-3 mb-4 d-flex justify-content-between align-items-center position-relative z-3">
                                    <div>
                                        <div class="small fw-semibold text-muted text-uppercase mb-1">Khách Nhận</div>
                                        <div class="fw-bold text-dark"><i class="bi bi-person me-1"></i> ${o.recipientNameSnapshot}</div>
                                    </div>
                                    <div class="text-end">
                                        <div class="small fw-semibold text-muted text-uppercase mb-1">Thu C.O.D</div>
                                        <div class="fw-bold text-danger fs-5"><fmt:formatNumber value="${o.totalAmount}" type="number"/>đ</div>
                                    </div>
                                </div>
                                
                                <c:if test="${o.orderStatus == 6 && not empty o.cancelledReason}">
                                    <div class="alert alert-danger px-3 py-2 small fw-medium mb-4 rounded-3 d-flex align-items-center position-relative z-3 border-0">
                                        <i class="bi bi-info-circle me-2 fs-5"></i> ${o.cancelledReason}
                                    </div>
                                </c:if>

                                <div class="d-flex gap-2 position-relative mt-auto z-3">
                                    <c:if test="${o.shippingStatus == 1}">
                                        <form action="orders" method="post" class="w-100 m-0">
                                            <input type="hidden" name="action" value="startShipping">
                                            <input type="hidden" name="orderId" value="${o.orderId}">
                                            <button class="btn btn-outline-primary w-100 fw-bold py-2 rounded-3 border-2"><i class="bi bi-scooter text-primary me-2"></i> Bật app đi giao</button>
                                        </form>
                                    </c:if>
                                    
                                    <c:if test="${o.shippingStatus == 2}">
                                        <form action="orders" method="post" class="flex-grow-1 m-0" onsubmit="return confirm('Bạn chắc chắn đã giao hàng an toàn và thu tiền rồi chứ?');">
                                            <input type="hidden" name="action" value="delivered">
                                            <input type="hidden" name="orderId" value="${o.orderId}">
                                            <button class="btn btn-success w-100 fw-bold py-2 rounded-3 shadow-sm"><i class="bi bi-check-circle-fill me-1"></i> Giao tốt</button>
                                        </form>
                                        <button type="button" class="btn btn-outline-danger shadow-sm rounded-3 px-3 py-2 fw-bold" data-bs-toggle="modal" data-bs-target="#failModal${o.orderId}">
                                            Báo lỗi
                                        </button>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Modal Báo cáo thất bại -->
                    <div class="modal fade" id="failModal${o.orderId}" tabindex="-1">
                        <div class="modal-dialog modal-dialog-centered mx-2 mx-md-auto">
                            <div class="modal-content border-0 rounded-4 shadow-lg">
                                <form action="orders" method="post" class="m-0">
                                    <div class="modal-header bg-danger text-white border-0 rounded-top-4 py-3">
                                        <h5 class="modal-title fw-bold"><i class="bi bi-exclamation-triangle-fill me-2 text-warning"></i> Báo cáo giao hàng lỗi</h5>
                                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                                    </div>
                                    <div class="modal-body p-4">
                                        <input type="hidden" name="action" value="failed">
                                        <input type="hidden" name="orderId" value="${o.orderId}">
                                        <p class="text-muted small mb-3">Mã đơn hàng bị lỗi: <strong class="text-dark fs-6">#${o.orderCode}</strong></p>
                                        
                                        <label class="form-label fw-semibold text-dark">Lý do thất bại:</label>
                                        <select name="reason" class="form-select form-select-lg border-danger fs-6 mb-3 rounded-3" required>
                                            <option value="">-- Click chọn nguyên nhân --</option>
                                            <option value="Không liên lạc được khách">Thuê bao/Không nghe máy</option>
                                            <option value="Khách đổi ý hủy đơn">Khách từ chối nhận hàng (Boom)</option>
                                            <option value="Sai thông tin liên hệ">Địa chỉ / SĐT khách bị sai</option>
                                            <option value="Sự cố xe cộ/thời tiết">Gặp sự cố ngoài ý muốn</option>
                                        </select>
                                        
                                        <div class="alert alert-warning mb-0 border-0 bg-warning bg-opacity-10 rounded-3 text-dark fw-medium">
                                            <i class="bi bi-info-circle me-1"></i> Lưu ý: Đơn sẽ tự động bị hủy và trả hàng về kho.
                                        </div>
                                    </div>
                                    <div class="modal-footer p-3 border-0 bg-light rounded-bottom-4">
                                        <button type="button" class="btn btn-light fw-bold px-4" data-bs-dismiss="modal">Trở lại</button>
                                        <button type="submit" class="btn btn-danger fw-bold px-4 shadow-sm">Xác nhận báo lỗi</button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </c:forEach>
                
                <c:if test="${empty orderList}">
                    <div class="col-12 py-5 text-center">
                        <div class="p-5 w-100">
                            <i class="bi bi-box-seam text-muted opacity-50 fs-1 d-block mb-3"></i>
                            <h5 class="fw-bold text-dark">Chưa có đơn hàng nào</h5>
                            <button onclick="document.getElementById('available-tab').click()" class="btn btn-primary mt-3 fw-bold rounded-pill px-4 py-2 shadow-sm">
                                Chuyển sang Kho Chờ Nhận
                            </button>
                        </div>
                    </div>
                </c:if>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
