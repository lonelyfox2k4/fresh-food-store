<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${expiredOnly ? 'Hàng hết hạn' : 'Tồn kho theo lô'} | FoodStore Admin</title>
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
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/manager/goods-receipts">Phiếu nhập</a></li>
                    <li class="breadcrumb-item active">${expiredOnly ? 'Hàng hết hạn' : 'Tồn kho theo lô'}</li>
                </ol>
            </nav>
            <h2 class="fw-800 mb-0">${expiredOnly ? 'Danh sách hàng hết hạn' : 'Tồn kho theo từng lô'}</h2>
        </div>
        <div class="d-flex gap-2">
            <a href="${pageContext.request.contextPath}/manager/inventory" class="btn ${expiredOnly ? 'btn-outline-secondary' : 'btn-brand'} rounded-pill">Đang theo dõi</a>
            <a href="${pageContext.request.contextPath}/manager/inventory?action=expired" class="btn ${expiredOnly ? 'btn-brand' : 'btn-outline-secondary'} rounded-pill">Đã hết hạn</a>
        </div>
    </div>
</div>

<main class="container mb-5">
    <div class="user-table-card">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead>
                <tr>
                    <th>Sản phẩm</th>
                    <th>Batch</th>
                    <th>Nhập từ</th>
                    <th>Hạn dùng</th>
                    <th>Tồn</th>
                    <th>Chi tiết</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach var="b" items="${batches}">
                    <tr>
                        <td>
                            <div class="fw-semibold">${b.productName}</div>
                            <div class="small text-muted">${b.packWeightGram}g • ${b.supplierName}</div>
                        </td>
                        <td>
                            <div class="fw-semibold">${b.batchCode}</div>
                            <div class="small text-muted">${b.receiptCode}</div>
                        </td>
                        <td>
                            <div class="small text-muted">${b.receivedAt}</div>
                            <div class="small text-muted">Giá vốn: <fmt:formatNumber value="${b.unitCost}" pattern="#,###.##"/>đ</div>
                        </td>
                        <td>
                            <div class="fw-semibold">${b.expiryDate}</div>
                            <c:choose>
                                <c:when test="${b.expired}">
                                    <span class="badge bg-danger">Đã hết hạn</span>
                                </c:when>
                                <c:when test="${b.expiringSoon}">
                                    <span class="badge bg-warning text-dark">Còn ${b.daysRemaining} ngày</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="small text-muted">Còn ${b.daysRemaining} ngày</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <div class="fw-semibold">Khả dụng: ${b.availableStock}</div>
                            <div class="small text-muted">Tồn tay ${b.quantityOnHand} / Giữ ${b.quantityReserved}</div>
                        </td>
                        <td>
                            <a href="${pageContext.request.contextPath}/manager/inventory?action=detail&id=${b.batchId}" class="btn btn-sm btn-outline-secondary rounded-pill">Xem lô</a>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty batches}">
                    <tr>
                        <td colspan="6" class="text-center py-5 text-muted">Không có dữ liệu phù hợp.</td>
                    </tr>
                </c:if>
                </tbody>
            </table>
        </div>
    </div>
</main>
</body>
</html>
