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
<div class="container py-5">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div class="mb-3 mb-md-0">
            <h2 class="fw-bold text-success">🎟️ Quản lý Mã Giảm Giá</h2>
            <p class="text-muted">Tạo và theo dõi các chương trình khuyến mãi của cửa hàng.</p>
        </div>
        <c:if test="${sessionScope.user.roleId != 1}">
            <a href="voucher?action=create" class="btn btn-success shadow-sm">
                <i class="bi bi-plus-lg"></i> Thêm Voucher mới
            </a>
        </c:if>
    </div>

    <c:if test="${not empty param.msg}">
        <div class="alert alert-success border-0 shadow-sm">${param.msg == 'success' ? 'Đã thêm voucher thành công!' : 'Thao tác thành công!'}</div>
    </c:if>

    <div class="card border-0 shadow-sm">
        <div class="card-body p-0">
            <table class="table table-hover align-middle mb-0">
                <thead class="table-success">
                <tr>
                    <th class="ps-4">Mã / Tên</th>
                    <th>Loại / Giá trị</th>
                    <th>Giới hạn dùng</th>
                    <th>Thời hạn</th>
                    <th>Trạng thái</th>
                    <c:if test="${sessionScope.user.roleId != 1}">
                        <th class="text-center">Thao tác</th>
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
                                <span class="badge bg-info text-dark">
                                        ${v.discountType == 1 ? 'Giảm %' : 'Giảm tiền'}
                                </span>
                            <div class="fw-bold text-danger">
                                <fmt:formatNumber value="${v.discountValue}" type="number"/> ${v.discountType == 1 ? '%' : 'đ'}
                            </div>
                        </td>
                        <td>
                            <div class="progress" style="height: 10px; width: 100px;">
                                <div class="progress-bar bg-success" style="width: ${(v.usedCount / v.usageLimit) * 100}%"></div>
                            </div>
                            <small>${v.usedCount} / ${v.usageLimit}</small>
                        </td>
                        <td class="small">
                            <div>Bắt đầu: ${v.startAt}</div>
                            <div class="text-danger">Hết hạn: ${v.endAt}</div>
                        </td>
                        <td>
                                <span class="badge ${v.status == 1 ? 'bg-success' : 'bg-secondary'}">
                                        ${v.status == 1 ? 'Đang chạy' : 'Chờ xét duyệt'}
                                </span>
                        </td>
                        <c:if test="${sessionScope.user.roleId != 1}">
                            <td class="text-center">
                                <a href="voucher?action=delete&id=${v.voucherId}"
                                   class="btn btn-sm btn-outline-danger"
                                   onclick="return confirm('Bạn có chắc chắn muốn xóa voucher này?')">
                                    <i class="bi bi-trash"></i>
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
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</div>
</body>
</html>