<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
            <html>

            <head>
                <title>Quản lý Đơn hàng | Fresh Food</title>
                <!-- Google Fonts -->
                <link
                    href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&display=swap"
                    rel="stylesheet">
                <!-- Bootstrap 5 -->
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
                <!-- FontAwesome -->
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
                <link rel="stylesheet"
                    href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
                <jsp:include page="../components/admin-style.jsp" />
            </head>

            <body>
                <jsp:include page="../components/admin-nav.jsp">
                    <jsp:param name="active" value="orders" />
                </jsp:include>

                <div class="page-header mt-n2 mb-4">
                    <div class="container-fluid px-4 d-flex justify-content-between align-items-center">
                        <div>
                            <nav aria-label="breadcrumb">
                                <ol class="breadcrumb mb-1">
                                    <li class="breadcrumb-item"><a
                                            href="${pageContext.request.contextPath}/staff/orders">Bán hàng</a></li>
                                    <li class="breadcrumb-item active">Đơn hàng</li>
                                </ol>
                            </nav>
                            <h2 class="fw-800 mb-0">Quản lý Đơn hàng</h2>
                            <p class="text-white-50 small mb-0 mt-1">Danh sách toàn bộ đơn hàng trong hệ thống.</p>
                        </div>
                        <div class="d-flex gap-2">
                            <a href="${pageContext.request.contextPath}/staff/orders"
                                class="btn btn-brand shadow-sm rounded-pill">
                                <i class="fas fa-sync-alt me-2"></i> Làm mới
                            </a>
                        </div>
                    </div>
                </div>

                <div class="container-fluid px-4">

                    <div class="card border-0 shadow-sm rounded-4 mb-4 mt-3">
                        <div class="card-body p-3">
                            <form action="${pageContext.request.contextPath}/staff/orders" method="get"
                                class="row g-2 align-items-center m-0">
                                <input type="hidden" name="action" value="list">
                                <div class="col-md-5 col-lg-4">
                                    <div class="input-group">
                                        <span class="input-group-text bg-light border-end-0 rounded-start-pill px-3">
                                            <i class="bi bi-search text-muted"></i>
                                        </span>
                                        <input type="text" name="query"
                                            class="form-control bg-light border-start-0 rounded-end-pill py-2"
                                            placeholder="Tìm theo Mã đơn hoặc Tên khách..." value="${searchQuery}">
                                    </div>
                                </div>
<<<<<<< HEAD
                                <div class="mt-1">
                                    <c:choose>
                                        <c:when test="${o.paymentStatus == 1}">
                                            <span class="badge rounded-pill bg-success fw-normal"><i class="bi bi-credit-card-2-back"></i> Đã thanh toán Online</span>
                                        </c:when>
                                        <c:when test="${o.paymentStatus == 2}">
                                            <c:choose>
                                                <c:when test="${o.orderStatus == 5 or o.shippingStatus == 3}">
                                                    <span class="badge rounded-pill bg-success fw-normal"><i class="bi bi-cash-coin"></i> Shipper đã thu</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge rounded-pill bg-info text-dark fw-normal"><i class="bi bi-clock"></i> Đang giao COD</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </c:when>
                                        <c:when test="${o.paymentStatus == 3}">
                                            <span class="badge rounded-pill bg-primary fw-normal"><i class="bi bi-safe2"></i> Đã kết toán quỹ</span>
                                        </c:when>

                                        <c:otherwise>
                                            <div class="text-muted small">
                                                <i class="bi bi-clock"></i> Đã trả: 0 đ
                                            </div>
                                            <c:if test="${o.orderStatus != 6}">
                                                <span class="badge rounded-pill bg-light text-dark border fw-normal text-muted"><i class="bi bi-clock"></i> Chưa thanh toán</span>
                                            </c:if>
                                            <c:if test="${o.orderStatus == 6}">
                                                <span class="text-muted small italic">-- Đã hủy --</span>
                                            </c:if>
                                        </c:otherwise>
                                    </c:choose>

=======
                                <div class="col-auto">
                                    <button type="submit"
                                        class="btn btn-primary rounded-pill px-4 fw-bold shadow-sm">Tìm kiếm</button>
                                    <c:if test="${not empty searchQuery}">
                                        <a href="${pageContext.request.contextPath}/staff/orders?action=list"
                                            class="btn btn-outline-secondary rounded-pill px-3 ms-1">
                                            <i class="bi bi-x-lg"></i> Xóa lọc
                                        </a>
                                    </c:if>
>>>>>>> eb2bf60 (feat(shipper/staff): add order detail preview before claim, fix merge conflicts, add overloaded updatePaymentStatus)
                                </div>
                                <c:if test="${not empty searchQuery}">
                                    <div class="col-auto">
                                        <span class="text-muted small ms-2">Tìm thấy
                                            <strong>${orderList.size()}</strong> kết quả cho
                                            <em>"${searchQuery}"</em></span>
                                    </div>
                                </c:if>
                            </form>
                        </div>
                    </div>

                    <c:if test="${not empty param.msg}">
                        <div class="alert alert-success border-0 shadow-sm alert-dismissible fade show">
                            <i class="bi bi-check-circle-fill me-2"></i>
                            <c:choose>
                                <c:when test="${param.msg == 'confirmed'}">Đơn hàng đã được xác nhận thành công.
                                </c:when>
                                <c:when test="${param.msg == 'ready'}">Đơn hàng đã sẵn sàng để Shipper lấy hàng.
                                </c:when>
                                <c:when test="${param.msg == 'shipper_assigned'}">Đã điều phối Shipper thành công cho
                                    đơn hàng.</c:when>
                                <c:when test="${param.msg == 'payment_updated'}">Đã cập nhật trạng thái thanh toán.
                                </c:when>
                                <c:when test="${param.msg == 'completed'}">Đơn hàng đã được hoàn thành.</c:when>
                                <c:when test="${param.msg == 'cancelled'}">Đơn hàng đã được hủy bỏ.</c:when>
                                <c:when test="${param.msg == 'refunded'}">Đã xác nhận hoàn tiền thành công.</c:when>
                                <c:when test="${param.msg == 'redelivered'}">Đã chuyển đơn hàng xang trạng thái giao
                                    lại.</c:when>
                                <c:otherwise>Thao tác dữ liệu thành công!</c:otherwise>
                            </c:choose>
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>
<<<<<<< HEAD
                    </tbody>
                </table>
            </div>
            
            <%-- Pagination --%>
            <c:if test="${totalPages > 1}">
                <div class="card-footer bg-white border-top-0 py-3">
                    <nav aria-label="Page navigation">
                        <ul class="pagination justify-content-center mb-0">
                            <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                <a class="page-link rounded-circle me-2" href="?action=list&page=${currentPage - 1}${not empty searchQuery ? '&query='.concat(searchQuery) : ''}" aria-label="Previous">
                                    <i class="bi bi-chevron-left"></i>
                                </a>
                            </li>
                            
                            <c:forEach var="i" begin="1" end="${totalPages}">
                                <c:choose>
                                    <c:when test="${i == currentPage}">
                                        <li class="page-item active"><span class="page-link rounded-circle me-2">${i}</span></li>
                                    </c:when>
                                    <c:otherwise>
                                        <li class="page-item"><a class="page-link rounded-circle me-2" href="?action=list&page=${i}${not empty searchQuery ? '&query='.concat(searchQuery) : ''}">${i}</a></li>
                                    </c:otherwise>
                                </c:choose>
                            </c:forEach>
                            
                            <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                <a class="page-link rounded-circle" href="?action=list&page=${currentPage + 1}${not empty searchQuery ? '&query='.concat(searchQuery) : ''}" aria-label="Next">
                                    <i class="bi bi-chevron-right"></i>
                                </a>
                            </li>
                        </ul>
                    </nav>
                </div>
            </c:if>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
=======
                    <c:if test="${not empty param.error}">
                        <div class="alert alert-danger border-0 shadow-sm alert-dismissible fade show">
                            <i class="bi bi-exclamation-triangle-fill me-2"></i>
                            <c:choose>
                                <c:when test="${param.error == 'missing_shipper'}">Vui lòng chọn Shipper trước khi gán!
                                </c:when>
                                <c:when test="${param.error == 'no_shipper_assigned'}">Hãy gán Shipper cho đơn hàng
                                    trước khi xác nhận Sẵn sàng giao!</c:when>
                                <c:otherwise>Lỗi thao tác: ${param.error}</c:otherwise>
                            </c:choose>
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                    <div class="user-table-card mb-4">
                        <div class="card-body p-0">
                            <div class="table-responsive">
                                <table class="table table-hover align-middle mb-0">
                                    <thead>
                                        <tr>
                                            <th class="ps-4">Mã Đơn / Khách hàng</th>
                                            <th>Địa chỉ / Ghi chú</th>
                                            <th>Tổng tiền / Đã trả</th>
                                            <th>Trạng thái Đơn</th>
                                            <th>Điều phối Shipper</th>
                                            <th>Trạng thái Giao hàng</th>
                                            <th class="text-end pe-4">Thao tác</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${orderList}" var="o">
                                            <tr>
                                                <td class="ps-4">
                                                    <div class="fw-bold text-primary">${o.orderCode}</div>
                                                    <div>${o.recipientNameSnapshot}</div>
                                                    <small class="text-muted"><i class="bi bi-telephone"></i>
                                                        ${o.recipientPhoneSnapshot}</small>
                                                    <div class="small text-muted">Đặt lúc:
                                                        ${o.placedAt.toString().replace('T', ' ').substring(0, 16)}
                                                    </div>
                                                </td>
                                                <td style="max-width: 250px;">
                                                    <div class="text-truncate-2 small"
                                                        title="${o.shippingAddressSnapshot}">
                                                        ${o.shippingAddressSnapshot}</div>
                                                    <c:if test="${not empty o.note}">
                                                        <c:choose>
                                                            <c:when test="${o.note.contains('Giao thất bại')}">
                                                                <div
                                                                    class="mt-1 p-2 border border-danger rounded bg-danger bg-opacity-10 small">
                                                                    <div class="fw-bold text-danger"><i
                                                                            class="bi bi-exclamation-octagon-fill"></i>
                                                                        Phản hồi từ Shipper:</div>
                                                                    <span class="text-dark">${o.note}</span>
                                                                </div>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <div
                                                                    class="mt-1 p-1 px-2 border border-warning rounded bg-warning bg-opacity-10 small">
                                                                    <i
                                                                        class="bi bi-info-circle-fill text-warning me-1"></i>
                                                                    <span class="text-dark">${o.note}</span>
                                                                </div>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </c:if>
                                                </td>
                                                <td>
                                                    <div class="fw-bold text-danger">
                                                        <fmt:formatNumber value="${o.totalAmount}" type="number" /> đ
                                                    </div>
                                                    <div class="mt-1">
                                                        <c:choose>
                                                            <c:when test="${o.paymentStatus == 2}">
                                                                <c:choose>
                                                                    <c:when
                                                                        test="${o.orderStatus == 5 or o.shippingStatus == 3}">
                                                                        <span
                                                                            class="badge rounded-pill bg-success fw-normal"><i
                                                                                class="bi bi-cash-coin"></i> Shipper đã
                                                                            thu</span>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <span
                                                                            class="badge rounded-pill bg-info text-dark fw-normal"><i
                                                                                class="bi bi-clock"></i> Đang giao
                                                                            COD</span>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </c:when>
                                                            <c:when test="${o.paymentStatus == 3}">
                                                                <span class="badge rounded-pill bg-primary fw-normal"><i
                                                                        class="bi bi-safe2"></i> Đã kết toán quỹ</span>
                                                            </c:when>
                                                            <c:when test="${o.paymentStatus == 4}">
                                                                <span
                                                                    class="badge rounded-pill bg-secondary fw-normal"><i
                                                                        class="bi bi-arrow-left-right"></i> Đã hoàn
                                                                    trả</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <div class="text-muted small">
                                                                    <i class="bi bi-clock"></i> Đã trả: 0 đ
                                                                </div>
                                                                <c:if test="${o.orderStatus != 6}">
                                                                    <span
                                                                        class="badge rounded-pill bg-light text-dark border fw-normal text-muted"><i
                                                                            class="bi bi-clock"></i> Chưa thanh
                                                                        toán</span>
                                                                </c:if>
                                                                <c:if test="${o.orderStatus == 6}">
                                                                    <span class="text-muted small italic">-- Đã hủy
                                                                        --</span>
                                                                </c:if>
                                                            </c:otherwise>
                                                        </c:choose>
                                                        <c:if
                                                            test="${o.orderStatus == 6 && (o.paymentStatus == 1 || o.paymentStatus == 2)}">
                                                            <div class="mt-2 text-center">
                                                                <span class="badge bg-danger p-2"
                                                                    style="font-size: 0.7rem; border: 1px solid #ff0000;">
                                                                    <i class="bi bi-exclamation-diamond-fill"></i> CẦN
                                                                    HOÀN TIỀN
                                                                </span>
                                                            </div>
                                                        </c:if>
                                                    </div>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${o.orderStatus == 1}"><span
                                                                class="badge-pill badge-role"><i
                                                                    class="fas fa-clock fs-8 me-1"></i>Chờ xác
                                                                nhận</span></c:when>
                                                        <c:when test="${o.orderStatus == 2}"><span class="badge-pill"
                                                                style="background:#fff7ed;color:#c2410c;border:1px solid #ffd8a8"><i
                                                                    class="fas fa-box-open fs-8 me-1"></i> Đã xác
                                                                nhận</span></c:when>
                                                        <c:when test="${o.orderStatus == 3}"><span
                                                                class="badge-pill badge-active"><i
                                                                    class="fas fa-box fs-8 me-1"></i> Đã đóng gói</span>
                                                        </c:when>
                                                        <c:when test="${o.orderStatus == 4}"><span class="badge-pill"
                                                                style="background:#eff6ff;color:#1d4ed8;border:1px solid #bfdbfe"><i
                                                                    class="fas fa-truck fs-8 me-1"></i> Đang giao
                                                                hàng</span></c:when>
                                                        <c:when test="${o.orderStatus == 5}"><span
                                                                class="badge-pill badge-active"><i
                                                                    class="fas fa-check-double fs-8 me-1"></i> Đã hoàn
                                                                tất</span></c:when>
                                                        <c:when test="${o.orderStatus == 6}">
                                                            <span class="badge-pill"
                                                                style="background:#fef2f2;color:#b91c1c;border:1px solid #fecaca"><i
                                                                    class="fas fa-times fs-8 me-1"></i> Đã hủy</span>
                                                            <c:if test="${not empty o.cancelledReason}">
                                                                <div class="small text-danger mt-1"
                                                                    style="font-size: 0.75rem;">Lý do:
                                                                    ${o.cancelledReason}</div>
                                                            </c:if>
                                                        </c:when>
                                                        <c:otherwise><span class="badge-pill badge-role">Không xác
                                                                định</span></c:otherwise>
                                                    </c:choose>
                                                </td>

                                                <!-- Cột Shipper: Hiển thị thông tin Shipper đã nhận đơn -->
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${not empty o.shipperId}">
                                                            <div class="d-flex align-items-center">
                                                                <div class="flex-shrink-0 me-2 text-primary">
                                                                    <i class="bi bi-person-check-fill fs-5"></i>
                                                                </div>
                                                                <div>
                                                                    <c:forEach items="${shipperList}" var="s">
                                                                        <c:if test="${o.shipperId == s.accountId}">
                                                                            <div class="small fw-bold text-dark">
                                                                                ${s.fullName}</div>
                                                                        </c:if>
                                                                    </c:forEach>
                                                                    <div class="badge bg-success bg-opacity-10 text-success p-1 px-2"
                                                                        style="font-size: 0.65rem;">
                                                                        <i class="bi bi-hand-thumbs-up-fill"></i>
                                                                        Shipper đã nhận
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <c:choose>
                                                                <c:when test="${o.orderStatus == 3}">
                                                                    <span
                                                                        class="badge bg-warning bg-opacity-10 text-dark p-2 rounded-3 w-100 border border-warning border-opacity-25 shadow-sm">
                                                                        <i class="bi bi-broadcast text-danger me-1"></i>
                                                                        Chờ nhận đơn...
                                                                    </span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="text-muted small italic">Chờ đóng
                                                                        gói...</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>

                                                <!-- Cột Trạng thái Giao -->
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${o.shippingStatus == 0}"><span
                                                                class="text-muted small"><i
                                                                    class="bi bi-dash-circle"></i> Chưa chuẩn bị</span>
                                                        </c:when>
                                                        <c:when test="${o.shippingStatus == 1}"><span
                                                                class="text-primary small fw-bold"><i
                                                                    class="bi bi-box-seam"></i> Chờ shipper</span>
                                                        </c:when>
                                                        <c:when test="${o.shippingStatus == 2}"><span
                                                                class="text-info small fw-bold"><i
                                                                    class="bi bi-truck"></i> Đang giao</span></c:when>
                                                        <c:when test="${o.shippingStatus == 3}"><span
                                                                class="text-success small fw-bold"><i
                                                                    class="bi bi-house-check"></i> Đã giao</span>
                                                        </c:when>
                                                        <c:when test="${o.shippingStatus == 4}"><span
                                                                class="badge bg-danger bg-opacity-10 text-danger border border-danger border-opacity-25 small"><i
                                                                    class="bi bi-x-octagon"></i> Giao thất bại</span>
                                                        </c:when>
                                                    </c:choose>
                                                </td>

                                                <td class="text-end pe-4">
                                                    <div class="dropdown">
                                                        <button
                                                            class="btn btn-sm btn-outline-secondary dropdown-toggle rounded-pill"
                                                            type="button" data-bs-toggle="dropdown">
                                                            <i class="fas fa-ellipsis-v"></i>
                                                        </button>
                                                        <ul class="dropdown-menu dropdown-menu-end shadow border-0"
                                                            style="border-radius: 0.75rem;">
                                                            <li>
                                                                <a class="dropdown-item py-2 fw-medium text-brand"
                                                                    href="${pageContext.request.contextPath}/staff/orders?action=detail&id=${o.orderId}"><i
                                                                        class="fas fa-eye me-2"></i> Chi tiết</a>
                                                            </li>
                                                            <li>
                                                                <hr class="dropdown-divider">
                                                            </li>

                                                            <c:choose>
                                                                <c:when test="${o.orderStatus == 1}">
                                                                    <li>
                                                                        <form
                                                                            action="${pageContext.request.contextPath}/staff/orders"
                                                                            method="post" class="m-0">
                                                                            <input type="hidden" name="action"
                                                                                value="confirm"><input type="hidden"
                                                                                name="orderId" value="${o.orderId}">
                                                                            <button type="submit"
                                                                                class="dropdown-item text-primary py-2 fw-medium"><i
                                                                                    class="fas fa-check-circle me-2"></i>
                                                                                Duyệt đơn (Đang xử lý)</button>
                                                                        </form>
                                                                    </li>
                                                                </c:when>
                                                                <c:when test="${o.orderStatus == 2}">
                                                                    <c:if
                                                                        test="${empty o.shippingStatus or o.shippingStatus == 0}">
                                                                        <li>
                                                                            <form
                                                                                action="${pageContext.request.contextPath}/staff/orders"
                                                                                method="post" class="m-0">
                                                                                <input type="hidden" name="action"
                                                                                    value="ready"><input type="hidden"
                                                                                    name="orderId" value="${o.orderId}">
                                                                                <button type="submit"
                                                                                    class="dropdown-item text-info py-2 fw-medium"><i
                                                                                        class="fas fa-box-open me-2"></i>
                                                                                    Đóng gói xong (Chờ giao)</button>
                                                                            </form>
                                                                        </li>
                                                                    </c:if>
                                                                </c:when>
                                                                <c:when
                                                                    test="${o.orderStatus == 3 or o.orderStatus == 4}">
                                                                    <c:if test="${o.shippingStatus == 3}">
                                                                        <li>
                                                                            <form action="orders" method="post"
                                                                                class="m-0"
                                                                                onsubmit="return confirm('Xác nhận Đóng đơn?');">
                                                                                <input type="hidden" name="action"
                                                                                    value="complete"><input
                                                                                    type="hidden" name="orderId"
                                                                                    value="${o.orderId}">
                                                                                <button type="submit"
                                                                                    class="dropdown-item text-success fw-bold py-2"><i
                                                                                        class="fas fa-flag me-2"></i>
                                                                                    Lưu kho & Hoàn thành</button>
                                                                            </form>
                                                                        </li>
                                                                    </c:if>
                                                                </c:when>
                                                            </c:choose>
                                                        </ul>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                        <c:if test="${empty orderList}">
                                            <tr>
                                                <td colspan="7" class="text-center py-5 text-muted">Chưa có đơn hàng
                                                    nào.</td>
                                            </tr>
                                        </c:if>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>
                </div>
                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
            </body>

            </html>
>>>>>>> eb2bf60 (feat(shipper/staff): add order detail preview before claim, fix merge conflicts, add overloaded updatePaymentStatus)
