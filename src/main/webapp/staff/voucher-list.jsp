<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<html>
<head>
    <title>Danh sách Voucher | Fresh Food</title>
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
    <div class="container d-flex justify-content-between align-items-center">
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
        <c:if test="${sessionScope.user.roleId != 1}">
            <a href="voucher?action=create" class="btn btn-brand shadow-sm rounded-pill">
                <i class="fas fa-plus-circle me-2"></i> Thêm Voucher mới
            </a>
        </c:if>
    </div>
</div>

<div class="container pb-5">
    <c:if test="${not empty param.msg}">
        <div class="alert alert-success border-0 shadow-sm">${param.msg == 'success' ? 'Đã thêm voucher thành công!' : 'Thao tác thành công!'}</div>
    </c:if>

    <div class="user-table-card">
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead>
                <tr>
                    <th class="ps-4">Mã / Tên</th>
                    <th>Loại / Giá trị</th>
                    <th>Giới hạn dùng</th>
                    <th>Thời hạn</th>
                    <th>Trạng thái</th>
                    <c:if test="${sessionScope.user.roleId != 1}">
                        <th class="text-end pe-4">Thao tác</th>
                    </c:if>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${voucherList}" var="v">
                    <tr>
                        <td class="ps-4">
                            <div class="fw-bold text-primary">${v.voucherCode}</div>
                            <small class="text-muted">${v.voucherName}</small>
                        </td>
                        <td>
                            <span class="badge-pill" style="background:#eff6ff;color:#1d4ed8;border:1px solid #bfdbfe">
                                    <i class="fas fa-tag"></i> ${v.discountType == 1 ? 'Giảm %' : 'Giảm tiền'}
                            </span>
                            <div class="fw-bold text-brand mt-1 fs-6">
                                <fmt:formatNumber value="${v.discountValue}" type="number"/> ${v.discountType == 1 ? '%' : 'đ'}
                            </div>
                        </td>
                        <td>
                            <div class="progress" style="height: 6px; width: 100px; border-radius: 4px;">
                                <div class="progress-bar" style="background-color: var(--brand-color); width: ${(v.usedCount / v.usageLimit) * 100}%"></div>
                            </div>
                            <small>${v.usedCount} / ${v.usageLimit}</small>
                        </td>
                        <td class="small">
                            <div><i class="fas fa-play-circle text-success me-1"></i> Bắt đầu: ${v.startAt}</div>
                            <div class="text-danger mt-1"><i class="fas fa-stop-circle me-1"></i> Hết hạn: ${v.endAt}</div>
                        </td>
                        <td>
                            <span class="badge-pill ${v.status == 1 ? 'badge-active' : 'badge-role'}">
                                    ${v.status == 1 ? '<i class="fas fa-check-circle me-1"></i> Đang chạy' : '<i class="fas fa-clock me-1"></i> Chờ duyệt'}
                            </span>
                        </td>
                        <c:if test="${sessionScope.user.roleId != 1}">
                            <td class="text-end pe-4">
                                <a href="voucher?action=delete&id=${v.voucherId}"
                                   class="btn-action btn-action-delete ms-auto"
                                   onclick="return confirm('Bạn có chắc chắn muốn xóa voucher này?')">
                                    <i class="fas fa-trash-alt"></i>
                                </a>
                            </td>
                        </c:if>
                    </tr>
                </c:forEach>
                <c:if test="${empty voucherList}">
                    <tr><td colspan="6" class="text-center py-5 text-muted">Chưa có voucher nào được tạo.</td></tr>
                </c:if>
                </tbody>
            </table>
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</div>
</body>
</html>