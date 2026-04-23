<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Phiếu nhập kho | FoodStore Admin</title>
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <jsp:include page="../components/admin-style.jsp" />
</head>
<body>
<jsp:include page="../components/admin-nav.jsp">
    <jsp:param name="active" value="inventory" />
</jsp:include>

<div class="page-header mt-n2">
    <div class="container d-flex justify-content-between align-items-center">
        <div>
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb mb-1">
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/manager/inventory">Kho hàng</a></li>
                    <li class="breadcrumb-item active">Phiếu nhập</li>
                </ol>
            </nav>
            <h2 class="fw-800 mb-0">Danh sách phiếu nhập kho</h2>
        </div>
        <c:if test="${sessionScope.user.roleId != 1}">
            <a href="${pageContext.request.contextPath}/manager/goods-receipts?action=new" class="btn btn-brand rounded-pill shadow-sm">
                <i class="fas fa-plus-circle me-2"></i>Tạo phiếu nhập
            </a>
        </c:if>
    </div>
</div>

<main class="container mb-5">
    <div class="user-table-card">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead>
                <tr>
                    <th>Mã phiếu</th>
                    <th>Nhà cung cấp</th>
                    <th>Thời điểm nhận</th>
                    <th>Số dòng</th>
                    <th>Tổng SL</th>
                    <c:if test="${sessionScope.user.roleId != 1}">
                        <th>Trạng thái sửa</th>
                    </c:if>
                    <th class="text-end pe-4">Chi tiết</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="r" items="${receipts}">
                    <tr>
                        <td>
                            <div class="fw-bold text-dark">${r.receiptCode}</div>
                            <c:if test="${not empty r.note}">
                                <div class="small text-muted">${r.note}</div>
                            </c:if>
                        </td>
                        <td>
                            <div class="fw-semibold">${r.supplierName}</div>
                            <div class="small text-muted">${r.supplierPhone}</div>
                        </td>
                        <td class="small text-muted">${r.receivedAt}</td>
                        <td><span class="badge bg-light text-dark">${r.totalLines}</span></td>
                        <td><span class="fw-semibold">${r.totalQuantity}</span></td>
                        <c:if test="${sessionScope.user.roleId != 1}">
                            <td>
                                <c:choose>
                                    <c:when test="${r.editable}">
                                        <span class="badge-pill badge-active"><i class="fas fa-pen me-1"></i>Có thể sửa</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge-pill badge-role"><i class="fas fa-lock me-1"></i>Đã khóa</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </c:if>
                        <td class="text-end pe-4">
                            <a href="${pageContext.request.contextPath}/manager/goods-receipts?action=detail&id=${r.receiptId}" class="btn-action btn-action-edit d-inline-flex" title="Xem chi tiết">
                                <i class="fas fa-eye"></i>
                            </a>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty receipts}">
                    <tr>
                        <td colspan="${sessionScope.user.roleId == 1 ? 6 : 7}" class="text-center py-5 text-muted">Chưa có phiếu nhập nào.</td>
                    </tr>
                </c:if>
                </tbody>
            </table>
        </div>
    </div>
</main>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
