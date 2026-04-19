<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<html>
<head>
    <title>Danh sách Voucher | Staff</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
</head>
<body class="bg-light">
<c:import url="/staff/common/nav.jsp" />

<div class="container-fluid py-3 px-4">

    <%-- Header --%>
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h3 class="fw-bold"><i class="bi bi-ticket-perforated me-2"></i>Quản lý Voucher</h3>
            <p class="text-muted small mb-0">Tạo và theo dõi các chương trình khuyến mãi.</p>
        </div>
        <div class="d-flex gap-2">
            <a href="${pageContext.request.contextPath}/staff/voucher" class="btn btn-outline-secondary shadow-sm">
                <i class="bi bi-arrow-clockwise"></i> Làm mới
            </a>
            <a href="${pageContext.request.contextPath}/staff/voucher?action=create" class="btn btn-success shadow-sm">
                <i class="bi bi-plus-lg me-1"></i> Thêm Voucher
            </a>
        </div>
    </div>

    <%-- Alert --%>
    <c:if test="${not empty param.msg}">
        <div class="alert alert-success border-0 shadow-sm alert-dismissible fade show">
            <i class="bi bi-check-circle-fill me-2"></i>
            ${param.msg == 'success' ? 'Đã thêm voucher thành công!' : 'Thao tác thành công!'}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>
    <c:if test="${not empty param.error}">
        <div class="alert alert-danger border-0 shadow-sm alert-dismissible fade show">
            <i class="bi bi-exclamation-triangle-fill me-2"></i>
            Lỗi: ${param.error}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <%-- Table --%>
    <div class="card border-0 shadow-sm">
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-success">
                    <tr>
                        <th class="ps-4">Mã / Tên chương trình</th>
                        <th>Loại / Giá trị</th>
                        <th>Đơn tối thiểu</th>
                        <th>Giới hạn sử dụng</th>
                        <th>Thời hạn</th>
                        <th>Trạng thái</th>
                        <th class="text-center">Thao tác</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach items="${voucherList}" var="v">
                        <tr>
                            <td class="ps-4">
                                <div class="fw-bold text-primary font-monospace">${v.voucherCode}</div>
                                <small class="text-muted">${v.voucherName}</small>
                            </td>
                            <td>
                                <span class="badge ${v.discountType == 1 ? 'bg-info text-dark' : 'bg-warning text-dark'} rounded-pill mb-1">
                                    <i class="bi ${v.discountType == 1 ? 'bi-percent' : 'bi-currency-dollar'} me-1"></i>
                                    ${v.discountType == 1 ? 'Giảm %' : 'Giảm tiền'}
                                </span>
                                <div class="fw-bold text-danger">
                                    <fmt:formatNumber value="${v.discountValue}" type="number"/>
                                    ${v.discountType == 1 ? '%' : ' đ'}
                                </div>
                            </td>
                            <td>
                                <div class="small">
                                    <i class="bi bi-cart-check text-muted me-1"></i>
                                    <fmt:formatNumber value="${v.minOrderAmount}" type="number"/> đ
                                </div>
                                <c:if test="${not empty v.maxDiscountAmount}">
                                    <small class="text-muted">
                                        Tối đa: <fmt:formatNumber value="${v.maxDiscountAmount}" type="number"/> đ
                                    </small>
                                </c:if>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty v.usageLimit and v.usageLimit > 0}">
                                        <div class="progress mb-1" style="height:8px; width:90px;">
                                            <div class="progress-bar bg-success"
                                                 style="width:${(v.usedCount * 100) / v.usageLimit}%"></div>
                                        </div>
                                        <small class="text-muted">${v.usedCount} / ${v.usageLimit} lượt</small>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-secondary rounded-pill">Không giới hạn</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td class="small">
                                <div><i class="bi bi-calendar-check text-success me-1"></i>${v.startAt.toString().substring(0,10)}</div>
                                <div class="text-danger"><i class="bi bi-calendar-x me-1"></i>${v.endAt.toString().substring(0,10)}</div>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${v.status == 1}">
                                        <span class="badge bg-success rounded-pill px-3 py-2">
                                            <i class="bi bi-play-fill me-1"></i>Đang chạy
                                        </span>
                                    </c:when>
                                    <c:when test="${v.status == 0}">
                                        <span class="badge bg-warning text-dark rounded-pill px-3 py-2">
                                            <i class="bi bi-hourglass-split me-1"></i>Chờ duyệt
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-secondary rounded-pill px-3 py-2">
                                            <i class="bi bi-pause-fill me-1"></i>Tạm dừng
                                        </span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td class="text-center">
                                <a href="${pageContext.request.contextPath}/staff/voucher?action=delete&id=${v.voucherId}"
                                   class="btn btn-sm btn-outline-danger rounded-pill px-3"
                                   onclick="return confirm('Bạn có chắc chắn muốn xóa voucher này?')">
                                    <i class="bi bi-trash me-1"></i>Xóa
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty voucherList}">
                        <tr>
                            <td colspan="7" class="text-center py-5 text-muted">
                                <i class="bi bi-ticket-perforated fs-2 d-block mb-2 opacity-50"></i>
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