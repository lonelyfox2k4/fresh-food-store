<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
            <html>

            <head>
                <title>Bảng Điều Khiển | Shipper</title>
                <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap"
                    rel="stylesheet">
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
                <link rel="stylesheet"
                    href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
                <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=0">
                <style>
                    body {
                        font-family: 'Inter', sans-serif;
                        background-color: #f0f2f5;
                    }

                    .dashboard-header {
                        background: linear-gradient(135deg, #0d6efd 0%, #0a58ca 100%);
                        color: white;
                        padding: 2rem 0;
                        margin-bottom: 2rem;
                        border-radius: 0 0 24px 24px;
                        box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
                    }

                    .section-title {
                        font-weight: 800;
                        color: #1e293b;
                        letter-spacing: -0.5px;
                        border-bottom: 3px solid #0d6efd;
                        display: inline-block;
                        padding-bottom: 5px;
                        margin-bottom: 1.5rem;
                    }

                    .order-card {
                        border-radius: 16px;
                        border: none;
                        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
                        transition: all 0.3s ease;
                        margin-bottom: 1rem;
                        overflow: hidden;
                    }

                    .order-card:hover {
                        transform: translateY(-3px);
                        box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1);
                    }

                    .status-badge {
                        padding: 6px 12px;
                        border-radius: 50px;
                        font-weight: 700;
                        font-size: 0.75rem;
                        text-uppercase: true;
                    }

                    .btn-claim {
                        background: #0d6efd;
                        color: white;
                        border-radius: 12px;
                        font-weight: 700;
                        transition: all 0.2s;
                        border: none;
                    }

                    .btn-claim:hover:not(:disabled) {
                        background: #0a58ca;
                        transform: scale(1.05);
                    }

                    .btn-claim:disabled {
                        background: #e2e8f0;
                        color: #94a3b8;
                        cursor: not-allowed;
                    }

                    .price-tag {
                        font-size: 1.25rem;
                        font-weight: 800;
                        color: #dc3545;
                    }

                    .column-container {
                        max-height: calc(100vh - 250px);
                        overflow-y: auto;
                        padding-right: 5px;
                    }

                    .column-container::-webkit-scrollbar {
                        width: 5px;
                    }

                    .column-container::-webkit-scrollbar-thumb {
                        background: #cbd5e1;
                        border-radius: 10px;
                    }

                    .busy-alert {
                        background: #fffbeb;
                        border: 1px solid #fde68a;
                        border-radius: 12px;
                        padding: 10px 15px;
                        color: #92400e;
                        font-weight: 600;
                        font-size: 0.85rem;
                    }
                </style>
            </head>

            <body>

                <jsp:include page="../components/shipper-nav.jsp" />

                <div class="dashboard-header">
                    <div class="container text-center">
                        <h3 class="mb-1">Xin chào,
                            <c:out value="${user.fullName}" />!
                        </h3>
                        <p class="mb-0 opacity-75">Hôm nay bạn muốn giao bao nhiêu đơn hàng?</p>
                    </div>
                </div>

                <div class="container">
                    <!-- Thống kê nhanh -->
                    <div class="row g-3 mb-4">
                        <div class="col-6 col-md-3">
                            <div class="card border-0 shadow-sm rounded-4 p-3 text-center h-100">
                                <div class="text-muted small fw-bold mb-1">Tỉ lệ thành công</div>
                                <c:set var="total" value="${stats.totalOrders != null ? stats.totalOrders : 0}" />
                                <c:set var="success" value="${stats.successOrders != null ? stats.successOrders : 0}" />
                                <c:set var="rate" value="${total > 0 ? (success * 100 / total) : 0}" />
                                <h4 class="mb-0 text-success fw-800">
                                    <fmt:formatNumber value="${rate}" maxFractionDigits="1" />%
                                </h4>
                            </div>
                        </div>
                        <div class="col-6 col-md-3">
                            <div class="card border-0 shadow-sm rounded-4 p-3 text-center h-100">
                                <div class="text-muted small fw-bold mb-1">Tổng đã giao</div>
                                <h4 class="mb-0 text-primary fw-800">${success}</h4>
                            </div>
                        </div>
                        <div class="col-12 col-md-6">
                            <c:if test="${isBusy}">
                                <div class="busy-alert h-100 d-flex align-items-center">
                                    <i class="bi bi-info-circle-fill me-2 fs-5"></i>
                                    Bạn đang bận giao 1 đơn hàng. Hãy giao xong để nhận thêm đơn khác nhé!
                                </div>
                            </c:if>
                            <c:if test="${not isBusy}">
                                <div
                                    class="alert alert-success border-0 rounded-4 h-100 d-flex align-items-center mb-0 py-2 px-3 fw-bold">
                                    <i class="bi bi-lightning-charge-fill me-2 fs-5"></i> Sẵn sàng nhận đơn mới!
                                </div>
                            </c:if>
                        </div>
                    </div>

                    <!-- Layout 2 Cột -->
                    <div class="row g-4">
                        <!-- Cột 1: Sàn đơn hàng -->
                        <div class="col-lg-5">
                            <h4 class="section-title"><i class="bi bi-geo-alt-fill me-2"></i>SÀN ĐƠN HÀNG <span
                                    class="badge bg-secondary ms-2">${availableList.size()}</span></h4>
                            <div class="column-container">
                                <c:forEach items="${availableList}" var="o">
                                    <div class="card order-card">
                                        <div class="card-body p-4">
                                            <div class="d-flex justify-content-between align-items-center mb-3">
                                                <span class="fw-800 text-dark">#${o.orderCode}</span>
                                                <span class="status-badge bg-warning text-dark"><i
                                                        class="bi bi-clock me-1"></i> Chờ lấy</span>
                                            </div>
                                            <div class="mb-3">
                                                <div class="text-muted small fw-bold text-uppercase">Địa chỉ giao:</div>
                                                <div class="text-dark fw-medium mt-1"><i
                                                        class="bi bi-geo-alt me-1 text-danger"></i>${o.shippingAddressSnapshot}
                                                </div>
                                            </div>
                                            <div class="d-flex justify-content-between align-items-end">
                                                <div>
                                                    <div class="text-muted small fw-bold text-uppercase">Thu C.O.D:
                                                    </div>
                                                    <div class="price-tag">
                                                        <fmt:formatNumber value="${o.totalAmount}" type="number" />đ
                                                    </div>
                                                </div>
                                                <div class="d-flex flex-column gap-2">
                                                    <a href="orders?action=available-detail&id=${o.orderId}"
                                                        class="btn btn-sm btn-outline-primary rounded-3 fw-bold text-center">
                                                        <i class="bi bi-eye"></i> XEM CHI TIẾT
                                                    </a>
                                                    <form action="orders" method="post" class="m-0">
                                                        <input type="hidden" name="action" value="claim">
                                                        <input type="hidden" name="id" value="${o.orderId}">
                                                        <button type="submit" class="btn btn-claim w-100 px-3 py-2" ${isBusy ? 'disabled' : ''}>
                                                            <i class="bi bi-hand-thumbs-up-fill me-1"></i> NHẬN ĐƠN
                                                        </button>
                                                    </form>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                                <c:if test="${empty availableList}">
                                    <div
                                        class="text-center py-5 text-muted bg-white rounded-4 shadow-sm border border-dashed p-4">
                                        <i class="bi bi-inbox fs-1 d-block mb-2 opacity-25"></i>
                                        Hiện tại chưa có đơn hàng mới nào trên sàn.
                                    </div>
                                </c:if>
                            </div>
                        </div>

                        <!-- Cột 2: Nhiệm vụ cá nhân -->
                        <div class="col-lg-7">
                            <h4 class="section-title"><i class="bi bi-person-badge-fill me-2"></i>NHIỆM VỤ CỦA TÔI</h4>
                            <div class="column-container">
                                <c:forEach items="${myTasks}" var="o">
                                    <c:set var="statusClass"
                                        value="${o.shippingStatus == 2 ? 'border-primary' : 'border-light'}" />
                                    <div
                                        class="card order-card shadow-sm ${statusClass} ${o.shippingStatus == 2 ? 'border-2' : ''}">
                                        <div class="card-body p-4">
                                            <div class="d-flex justify-content-between align-items-start mb-3">
                                                <div>
                                                    <h5 class="fw-800 text-dark mb-1">#${o.orderCode}</h5>
                                                    <div class="text-muted small"><i class="bi bi-person me-1"></i>
                                                        ${o.recipientNameSnapshot} - ${o.recipientPhoneSnapshot}</div>
                                                </div>
                                                <c:choose>
                                                    <c:when test="${o.shippingStatus == 1}"><span
                                                            class="status-badge bg-info text-white">Vừa nhận đơn</span>
                                                    </c:when>
                                                    <c:when test="${o.shippingStatus == 2}"><span
                                                            class="status-badge bg-primary text-white"><i
                                                                class="bi bi-scooter me-1"></i> Đang giao</span>
                                                    </c:when>
                                                    <c:when test="${o.shippingStatus == 3}"><span
                                                            class="status-badge bg-success text-white"><i
                                                                class="bi bi-check-circle me-1"></i> Hoàn tất</span>
                                                    </c:when>
                                                    <c:when test="${o.shippingStatus == 4}"><span
                                                            class="status-badge bg-danger text-white">Giao thất
                                                            bại</span></c:when>
                                                </c:choose>
                                            </div>

                                            <p class="small text-dark mb-3"><i
                                                    class="bi bi-geo-alt-fill text-danger me-1"></i>
                                                ${o.shippingAddressSnapshot}</p>

                                            <div
                                                class="d-flex justify-content-between align-items-center bg-light rounded-3 p-2 mb-3">
                                                <span class="small fw-bold">Tổng thu:</span>
                                                <span class="fw-bold text-danger">
                                                    <fmt:formatNumber value="${o.totalAmount}" type="number" />đ
                                                </span>
                                            </div>

                                            <div class="d-flex gap-2">
                                                <a href="orders?action=detail&id=${o.orderId}"
                                                    class="btn btn-sm btn-outline-dark rounded-pill px-3"><i
                                                        class="bi bi-eye"></i> Chi tiết</a>

                                                <c:if test="${o.shippingStatus == 1}">
                                                    <form action="orders" method="post" class="m-0 flex-grow-1">
                                                        <input type="hidden" name="action" value="startShipping">
                                                        <input type="hidden" name="orderId" value="${o.orderId}">
                                                        <button
                                                            class="btn btn-sm btn-primary w-100 rounded-pill fw-bold"><i
                                                                class="bi bi-box-arrow-right"></i> Bắt đầu đi
                                                            giao</button>
                                                    </form>
                                                </c:if>

                                                <c:if test="${o.shippingStatus == 2}">
                                                    <form action="orders" method="post" class="m-0 flex-grow-1"
                                                        onsubmit="return confirm('Xác nhận đã giao thành công?');">
                                                        <input type="hidden" name="action" value="delivered">
                                                        <input type="hidden" name="orderId" value="${o.orderId}">
                                                        <button
                                                            class="btn btn-sm btn-success w-100 rounded-pill fw-bold"><i
                                                                class="bi bi-check-lg"></i> Xong!</button>
                                                    </form>
                                                </c:if>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                                <c:if test="${empty myTasks}">
                                    <div
                                        class="text-center py-5 text-muted bg-white rounded-4 shadow-sm border border-dashed p-4">
                                        <i class="bi bi-clipboard-x fs-1 d-block mb-2 opacity-25"></i>
                                        Bạn chưa nhận đơn nào. Hãy chọn đơn ở cột bên trái!
                                    </div>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </div>

                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
            </body>

            </html>