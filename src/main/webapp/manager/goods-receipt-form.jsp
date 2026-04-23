<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${empty form.receiptId ? 'Tạo phiếu nhập' : 'Chỉnh sửa phiếu nhập'} | FoodStore Admin</title>
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
    <div class="page-header mt-n2 mb-4">
        <div class="container d-flex justify-content-between align-items-center">
            <div>
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb mb-1">
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/manager/goods-receipts">Phiếu nhập</a></li>
                        <li class="breadcrumb-item active">${empty form.receiptId ? 'Tạo mới' : 'Chỉnh sửa'}</li>
                    </ol>
                </nav>
                <h2 class="fw-800 mb-0">${empty form.receiptId ? 'Tạo phiếu nhập kho' : 'Chỉnh sửa phiếu nhập'}</h2>
            </div>
        </div>
    </div>

    <c:if test="${not empty error}">
        <div class="alert alert-danger">${error}</div>
    </c:if>

    <form method="post" action="${pageContext.request.contextPath}/manager/goods-receipts">
        <input type="hidden" name="receiptId" value="${form.receiptId}">
        <div class="user-table-card p-4 mb-4">
            <div class="row g-4">
                <div class="col-md-4">
                    <label class="form-label fw-semibold">Mã phiếu nhập</label>
                    <input type="text" name="receiptCode" class="form-control" value="${form.receiptCode}" required>
                </div>
                <div class="col-md-4">
                    <label class="form-label fw-semibold">Nhà cung cấp</label>
                    <select name="supplierId" class="form-select" required>
                        <option value="">-- Chọn nhà cung cấp --</option>
                        <c:forEach var="s" items="${suppliers}">
                            <option value="${s.supplierId}" ${form.supplierId == s.supplierId ? 'selected' : ''}>${s.supplierName}</option>
                        </c:forEach>
                    </select>
                </div>
                <div class="col-md-4">
                    <label class="form-label fw-semibold">Thời điểm nhận</label>
                    <input type="datetime-local" name="receivedAt" class="form-control" value="${form.receivedAt}" required>
                </div>
                <div class="col-12">
                    <label class="form-label fw-semibold">Ghi chú phiếu</label>
                    <textarea name="note" class="form-control" rows="2">${form.note}</textarea>
                </div>
            </div>
        </div>

        <div class="user-table-card p-4">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <div class="fw-bold">Dòng nhập hàng</div>
                <button type="submit" name="mode" value="add-line" class="btn btn-outline-secondary rounded-pill">
                    <i class="fas fa-plus me-2"></i>Thêm dòng
                </button>
            </div>
            <div class="table-responsive">
                <table class="table table-bordered align-middle">
                    <thead>
                    <tr>
                        <th>Sản phẩm</th>
                        <th>Batch code</th>
                        <th>Ngày SX</th>
                        <th>Ngày hết hạn</th>
                        <th>Số lượng nhập</th>
                        <th>Giá vốn</th>
                        <th>Ghi chú</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="line" items="${form.lines}">
                        <tr>
                            <td>
                                <input type="hidden" name="receiptItemId" value="${line.receiptItemId}">
                                <select name="productPackId" class="form-select">
                                    <option value="">-- Chọn gói --</option>
                                    <c:forEach var="p" items="${productPacks}">
                                        <option value="${p.productPackId}" ${line.productPackId == p.productPackId ? 'selected' : ''}>${p.displayName}</option>
                                    </c:forEach>
                                </select>
                            </td>
                            <td><input type="text" name="batchCode" class="form-control" value="${line.batchCode}"></td>
                            <td><input type="date" name="manufactureDate" class="form-control" value="${line.manufactureDate}"></td>
                            <td><input type="date" name="expiryDate" class="form-control" value="${line.expiryDate}"></td>
                            <td><input type="number" name="quantityReceived" min="1" class="form-control" value="${line.quantityReceived}"></td>
                            <td><input type="number" name="unitCost" min="0" step="0.01" class="form-control" value="${line.unitCost}"></td>
                            <td><input type="text" name="lineNote" class="form-control" value="${line.note}"></td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>

            <div class="d-flex gap-2 justify-content-end mt-4">
                <a href="${pageContext.request.contextPath}/manager/goods-receipts" class="btn btn-light rounded-pill px-4">Quay lại</a>
                <button type="submit" class="btn btn-brand rounded-pill px-4">
                    <i class="fas fa-save me-2"></i>Lưu phiếu nhập
                </button>
            </div>
        </div>
    </form>
</main>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
