<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết phiếu nhập | FoodStore Admin</title>
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

<main class="container my-4">
    <c:choose>
        <c:when test="${empty receipt}">
            <div class="alert alert-warning">Không tìm thấy phiếu nhập.</div>
        </c:when>
        <c:otherwise>
            <div class="page-header mt-n2 mb-4">
                <div class="container d-flex justify-content-between align-items-center">
                    <div>
                        <nav aria-label="breadcrumb">
                            <ol class="breadcrumb mb-1">
                                <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/manager/goods-receipts">Phiếu nhập</a></li>
                                <li class="breadcrumb-item active">${receipt.receiptCode}</li>
                            </ol>
                        </nav>
                        <h2 class="fw-800 mb-0">Chi tiết ${receipt.receiptCode}</h2>
                    </div>
                    <c:if test="${receipt.editable && sessionScope.user.roleId != 1}">
                        <a href="${pageContext.request.contextPath}/manager/goods-receipts?action=edit&id=${receipt.receiptId}" class="btn btn-brand rounded-pill">
                            <i class="fas fa-edit me-2"></i>Chỉnh sửa phiếu
                        </a>
                    </c:if>
                </div>
            </div>

            <div class="row g-4 mb-4">
                <div class="col-lg-4">
                    <div class="user-table-card h-100 p-4">
                        <div class="fw-bold mb-3">Thông tin phiếu</div>
                        <div class="small text-muted mb-2">Nhà cung cấp</div>
                        <div class="fw-semibold mb-3">${receipt.supplierName}</div>
                        <div class="small text-muted mb-2">Thời điểm nhận</div>
                        <div class="fw-semibold mb-3">${receipt.receivedAt}</div>
                        <c:if test="${sessionScope.user.roleId != 1}">
                            <div class="small text-muted mb-2">Tình trạng sửa</div>
                            <div>
                                <c:choose>
                                    <c:when test="${receipt.editable}">
                                        <span class="badge-pill badge-active">Có thể sửa</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge-pill badge-role">Đã khóa</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </c:if>
                    </div>
                </div>
                <div class="col-lg-8">
                    <div class="user-table-card h-100 p-4">
                        <div class="fw-bold mb-3">Tóm tắt</div>
                        <div class="row g-3">
                            <div class="col-md-4">
                                <div class="text-muted small">Số dòng hàng</div>
                                <div class="fs-4 fw-bold">${receipt.totalLines}</div>
                            </div>
                            <div class="col-md-4">
                                <div class="text-muted small">Tổng số lượng nhập</div>
                                <div class="fs-4 fw-bold">${receipt.totalQuantity}</div>
                            </div>
                            <div class="col-md-4">
                                <div class="text-muted small">Ghi chú</div>
                                <div class="fw-semibold">${empty receipt.note ? 'Không có' : receipt.note}</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="user-table-card">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead>
                        <tr>
                            <th>Sản phẩm</th>
                            <th>Batch</th>
                            <th>HSD</th>
                            <th>SL nhập</th>
                            <th>Tồn khả dụng</th>
                            <th>Chi tiết lô</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="item" items="${receipt.items}">
                            <tr>
                                <td>
                                    <div class="fw-semibold">${item.productName}</div>
                                    <div class="small text-muted">${item.packWeightGram}g</div>
                                </td>
                                <td>
                                    <div class="fw-semibold">${item.batchCode}</div>
                                    <div class="small text-muted">Batch #${item.batchId}</div>
                                </td>
                                <td>
                                    <div class="fw-semibold">${item.expiryDate}</div>
                                    <c:choose>
                                        <c:when test="${item.expired}">
                                            <div class="small text-danger">Đã hết hạn</div>
                                        </c:when>
                                        <c:when test="${item.expiringSoon}">
                                            <div class="small text-warning">Còn ${item.daysRemaining} ngày</div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="small text-muted">Còn ${item.daysRemaining} ngày</div>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>${item.quantityReceived}</td>
                                <td>${item.availableStock}</td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/manager/inventory?action=detail&id=${item.batchId}" class="btn btn-sm btn-outline-secondary rounded-pill">Xem lô</a>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </c:otherwise>
    </c:choose>
</main>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
