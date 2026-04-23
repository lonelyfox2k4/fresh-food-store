<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết lô hàng | FoodStore Admin</title>
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
        <c:when test="${empty batch}">
            <div class="alert alert-warning">Không tìm thấy lô hàng.</div>
        </c:when>
        <c:otherwise>
            <div class="page-header mt-n2 mb-4">
                <div class="container">
                    <nav aria-label="breadcrumb">
                        <ol class="breadcrumb mb-1">
                            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/manager/inventory">Tồn kho</a></li>
                            <li class="breadcrumb-item active">${batch.batchCode}</li>
                        </ol>
                    </nav>
                    <h2 class="fw-800 mb-0">Chi tiết lô ${batch.batchCode}</h2>
                </div>
            </div>

            <div class="row g-4 mb-4">
                <div class="col-lg-8">
                    <div class="user-table-card p-4 h-100">
                        <div class="row g-3">
                            <div class="col-md-6">
                                <div class="text-muted small">Sản phẩm</div>
                                <div class="fw-semibold">${batch.productName} - ${batch.packWeightGram}g</div>
                            </div>
                            <div class="col-md-6">
                                <div class="text-muted small">Nhà cung cấp</div>
                                <div class="fw-semibold">${batch.supplierName}</div>
                            </div>
                            <div class="col-md-6">
                                <div class="text-muted small">Phiếu nhập</div>
                                <div class="fw-semibold">
                                    <a href="${pageContext.request.contextPath}/manager/goods-receipts?action=detail&id=${batch.receiptId}">${batch.receiptCode}</a>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="text-muted small">Thời điểm nhập</div>
                                <div class="fw-semibold">${batch.receivedAt}</div>
                            </div>
                            <div class="col-md-4">
                                <div class="text-muted small">Ngày SX</div>
                                <div class="fw-semibold">${empty batch.manufactureDate ? '--' : batch.manufactureDate}</div>
                            </div>
                            <div class="col-md-4">
                                <div class="text-muted small">Ngày hết hạn</div>
                                <div class="fw-semibold">${batch.expiryDate}</div>
                            </div>
                            <div class="col-md-4">
                                <div class="text-muted small">Tình trạng hạn</div>
                                <c:choose>
                                    <c:when test="${batch.expired}">
                                        <span class="badge bg-danger">Đã hết hạn</span>
                                    </c:when>
                                    <c:when test="${batch.expiringSoon}">
                                        <span class="badge bg-warning text-dark">Còn ${batch.daysRemaining} ngày</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-success">Còn ${batch.daysRemaining} ngày</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-lg-4">
                    <div class="user-table-card p-4 h-100">
                        <div class="fw-bold mb-3">Số lượng tồn</div>
                        <div class="mb-3">
                            <div class="text-muted small">Tồn tay</div>
                            <div class="fs-4 fw-bold">${batch.quantityOnHand}</div>
                        </div>
                        <div class="mb-3">
                            <div class="text-muted small">Đang giữ</div>
                            <div class="fs-4 fw-bold">${batch.quantityReserved}</div>
                        </div>
                        <div>
                            <div class="text-muted small">Khả dụng</div>
                            <div class="fs-4 fw-bold">${batch.availableStock}</div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="user-table-card">
                <div class="p-4 border-bottom fw-bold">Lịch sử biến động kho</div>
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead>
                        <tr>
                            <th>Thời điểm</th>
                            <th>Loại</th>
                            <th>Số lượng</th>
                            <th>Tham chiếu</th>
                            <th>Người thực hiện</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="tx" items="${batch.transactions}">
                            <tr>
                                <td class="small text-muted">${tx.transactionAt}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${tx.transactionType == 1}">Nhập kho</c:when>
                                        <c:when test="${tx.transactionType == 2}">Giữ hàng</c:when>
                                        <c:when test="${tx.transactionType == 3}">Hoàn giữ</c:when>
                                        <c:otherwise>Khác</c:otherwise>
                                    </c:choose>
                                </td>
                                <td>${tx.quantity}</td>
                                <td>${tx.referenceType} #${tx.referenceId}</td>
                                <td>${empty tx.performerName ? '--' : tx.performerName}</td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty batch.transactions}">
                            <tr>
                                <td colspan="5" class="text-center py-4 text-muted">Chưa có biến động kho.</td>
                            </tr>
                        </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </c:otherwise>
    </c:choose>
</main>
</body>
</html>
