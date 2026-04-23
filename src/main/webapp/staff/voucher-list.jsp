<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<html>
<head>
    <title>Danh sách Voucher | Fresh Food Store</title>
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <!-- Bootstrap 5 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- FontAwesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <jsp:include page="../components/admin-style.jsp" />
</head>
<body>
    <jsp:include page="../components/admin-nav.jsp">
        <jsp:param name="active" value="voucher" />
    </jsp:include>

    <div class="page-header mt-n2 mb-4">
        <div class="container-fluid px-4 d-flex justify-content-between align-items-center">
            <div>
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb mb-1">
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/staff/news">Marketing</a></li>
                        <li class="breadcrumb-item active">Voucher</li>
                    </ol>
                </nav>
                <h2 class="fw-800 mb-0">Quản lý Mã Giảm Giá</h2>
                <p class="text-white-50 small mb-0 mt-1">Tạo và theo dõi các chương trình khuyến mãi của cửa hàng.</p>
            </div>
            <div class="d-flex gap-2">
                <a href="?action=list" class="btn btn-brand-outline shadow-sm rounded-pill bg-white text-dark">
                    <i class="fas fa-sync-alt"></i> Làm mới
                </a>
                <a href="?action=create" class="btn btn-brand shadow-sm rounded-pill">
                    <i class="fas fa-plus-circle me-2"></i> Thêm Voucher mới
                </a>
            </div>
        </div>
    </div>

    <div class="container-fluid px-4 pb-5">
        <c:if test="${not empty param.msg}">
            <div class="alert alert-success border-0 shadow-sm alert-dismissible fade show">
                <i class="bi bi-check-circle-fill me-2"></i>
                ${param.msg == 'success' ? 'Đã thực hiện thao tác thành công!' : 'Thao tác thành công!'}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <div class="user-table-card">
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead>
                        <tr>
                            <th class="ps-4">Mã / Tên chương trình</th>
                            <th>Loại / Giá trị</th>
                            <th>Giới hạn sử dụng</th>
                            <th>Thời hạn</th>
                            <th>Trạng thái</th>
                            <th class="text-end pe-4">Thao tác</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach items="${voucherList}" var="v">
                            <tr>
                                <td class="ps-4">
                                    <div class="fw-bold text-primary fs-6">${v.voucherCode}</div>
                                    <small class="text-muted">${v.voucherName}</small>
                                </td>
                                <td>
                                    <span class="badge rounded-pill bg-light text-dark border">
                                        <i class="fas fa-tag me-1 text-primary"></i>
                                        ${v.discountType == 1 ? 'Giảm %' : 'Giảm tiền'}
                                    </span>
                                    <div class="fw-bold text-danger mt-1 fs-5">
                                        <fmt:formatNumber value="${v.discountValue}" type="number"/> ${v.discountType == 1 ? '%' : 'đ'}
                                    </div>
                                </td>
                                <td>
                                    <div class="d-flex align-items-center gap-2">
                                        <div class="progress flex-grow-1" style="height: 6px; border-radius: 10px; max-width: 120px;">
                                            <div class="progress-bar bg-success" style="width: ${(v.usedCount / v.usageLimit) * 100}%"></div>
                                        </div>
                                        <small class="fw-bold">${v.usedCount}/${v.usageLimit}</small>
                                    </div>
                                    <small class="text-muted small">Lượt đã dùng</small>
                                </td>
                                <td class="small">
                                    <div class="mb-1"><i class="far fa-calendar-alt me-1 text-success"></i> ${v.startAt}</div>
                                    <div class="text-danger"><i class="far fa-calendar-times me-1"></i> ${v.endAt}</div>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${v.status == 1}">
                                            <span class="badge rounded-pill bg-success-subtle text-success border border-success px-3">
                                                <i class="fas fa-check-circle me-1"></i> Đang chạy
                                            </span>
                                        </c:when>
                                        <c:when test="${v.status == 2}">
                                            <span class="badge rounded-pill bg-danger-subtle text-danger border border-danger px-3">
                                                <i class="fas fa-times-circle me-1"></i> Bị từ chối
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge rounded-pill bg-warning-subtle text-warning border border-warning px-3">
                                                <i class="fas fa-clock me-1"></i> Chờ duyệt
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="text-end pe-4">
                                    <div class="btn-group shadow-sm rounded-pill overflow-hidden">
                                        <a href="${pageContext.request.contextPath}/staff/voucher?action=delete&id=${v.voucherId}" 
                                           class="btn btn-light btn-sm text-danger border-0"
                                           onclick="return confirm('Bạn có chắc chắn muốn xóa voucher này?')">
                                            <i class="fas fa-trash-alt"></i>
                                        </a>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty voucherList}">
                            <tr>
                                <td colspan="6" class="text-center py-5 text-muted">
                                    <i class="bi bi-ticket-perforated fs-1 d-block mb-3 opacity-25"></i>
                                    Chưa có voucher nào được tạo.
                                </td>
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