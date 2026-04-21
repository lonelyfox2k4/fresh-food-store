<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Đối tác | FoodStore Admin</title>
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    
    <jsp:include page="../components/admin-style.jsp" />
</head>
<body>
    <jsp:include page="../components/admin-nav.jsp">
        <jsp:param name="active" value="suppliers" />
    </jsp:include>

    <div class="page-header mt-n2">
        <div class="container d-flex justify-content-between align-items-center">
            <div>
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb mb-1">
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/manager/products">Quản lý</a></li>
                        <li class="breadcrumb-item active">Đối tác</li>
                    </ol>
                </nav>
                <h2 class="fw-800 mb-0">Quản lý Đối tác Cung ứng</h2>
            </div>
            <c:if test="${sessionScope.user.roleId != 1}">
                <button type="button" class="btn btn-brand shadow-sm rounded-pill" data-bs-toggle="modal" data-bs-target="#supplierModal">
                    <i class="fas fa-plus-circle me-2"></i>Thêm đối tác
                </button>
            </c:if>
        </div>
    </div>

    <main class="container mb-5">
        <div class="user-table-card">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead>
                        <tr>
                            <th>Tên đối tác</th>
                            <th>Thông tin liên hệ</th>
                            <th>Địa chỉ kho hàng</th>
                            <th>Trạng thái hợp tác</th>
                            <c:if test="${sessionScope.user.roleId != 1}">
                                <th class="text-end pe-4">Hành động</th>
                            </c:if>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="s" items="${suppliers}">
                            <tr>
                                <td>
                                    <div class="d-flex align-items-center">
                                        <div class="bg-primary-subtle text-primary rounded-3 p-2 me-3">
                                            <i class="fas fa-store fs-5"></i>
                                        </div>
                                        <div class="fw-bold text-dark fs-6">${s.supplierName}</div>
                                    </div>
                                </td>
                                <td>
                                    <div class="text-muted small"><i class="fas fa-phone-alt text-brand me-1"></i> ${s.phone}</div>
                                    <div class="text-muted small mt-1"><i class="fas fa-envelope text-brand me-1"></i> ${s.email}</div>
                                </td>
                                <td>
                                    <div class="small text-secondary"><i class="fas fa-map-marker-alt me-1"></i> ${s.address}</div>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${s.status}"><span class="badge-pill badge-active"><i class="fas fa-check-circle me-1"></i>Đang hợp tác</span></c:when>
                                        <c:otherwise><span class="badge-pill badge-role"><i class="fas fa-minus-circle me-1"></i>Tạm dừng</span></c:otherwise>
                                    </c:choose>
                                </td>
                                <c:if test="${sessionScope.user.roleId != 1}">
                                    <td class="text-end pe-4">
                                        <div class="d-flex justify-content-end gap-2">
                                            <button class="btn-action btn-action-edit" onclick='editSupplier(${s.supplierId}, "${s.supplierName}", "${s.phone}", "${s.email}", "${s.address}", ${s.status})' title="Cập nhật thông tin">
                                                <i class="fas fa-edit"></i>
                                            </button>
                                            <c:choose>
                                                <c:when test="${s.status}">
                                                    <a href="suppliers?action=toggle-status&id=${s.supplierId}&status=false" class="btn-action btn-action-delete" title="Ngừng hợp tác" onclick="return confirm('Bạn có chắc muốn tạm dừng hợp tác với đơn vị này?')">
                                                        <i class="fas fa-ban"></i>
                                                    </a>
                                                </c:when>
                                                <c:otherwise>
                                                    <a href="suppliers?action=toggle-status&id=${s.supplierId}&status=true" class="btn-action text-success bg-success bg-opacity-10" title="Kích hoạt lại" onclick="return confirm('Bạn có muốn kích hoạt lại hợp tác với đơn vị này?')">
                                                        <i class="fas fa-check"></i>
                                                    </a>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </td>
                                </c:if>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </main>

    <c:if test="${sessionScope.user.roleId != 1}">
        <!-- Modal -->
        <div class="modal fade" id="supplierModal" tabindex="-1">
            <div class="modal-dialog modal-dialog-centered modal-lg">
                <form action="suppliers" method="POST" class="modal-content">
                    <div class="modal-header border-0 pb-0 p-4">
                        <h5 class="fw-bold">Thông tin chi tiết Đối tác</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body p-4">
                        <input type="hidden" name="id" id="supId">
                        <div class="mb-4">
                            <label class="form-label fw-semibold small text-muted text-uppercase">Tên nhà cung cấp / Công ty</label>
                            <input type="text" name="supplierName" id="supName" class="form-control form-control-lg bg-light border-0" placeholder="VD: Công ty TNHH Thực phẩm Sạch" required>
                        </div>
                        <div class="row g-4 mb-4">
                            <div class="col-md-6">
                                <label class="form-label fw-semibold small text-muted text-uppercase">Số điện thoại liên hệ</label>
                                <input type="text" name="phone" id="supPhone" class="form-control bg-light border-0" placeholder="090x.xxx.xxx">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-semibold small text-muted text-uppercase">Địa chỉ Email</label>
                                <input type="email" name="email" id="supEmail" class="form-control bg-light border-0" placeholder="contact@supplier.com">
                            </div>
                        </div>
                        <div class="mb-4">
                            <label class="form-label fw-semibold small text-muted text-uppercase">Địa chỉ kho bãi / Trụ sở</label>
                            <input type="text" name="address" id="supAddress" class="form-control bg-light border-0" placeholder="Số nhà, Tên đường, Quận/Huyện, Tỉnh/TP">
                        </div>
                        <div class="form-check form-switch d-flex align-items-center p-0">
                            <label class="form-check-label fw-semibold me-3">Trạng thái hợp tác hiện tại</label>
                            <input class="form-check-input ms-auto" type="checkbox" name="status" id="supStatus" checked style="width: 3rem; height: 1.5rem;">
                        </div>
                    </div>
                    <div class="modal-footer border-0 pt-0 p-4">
                        <button type="button" class="btn btn-light rounded-pill px-4" data-bs-dismiss="modal">Đóng</button>
                        <button type="submit" class="btn btn-primary rounded-pill px-5 fw-bold">Xác nhận Lưu</button>
                    </div>
                </form>
            </div>
        </div>
        <script>
            function editSupplier(id, name, phone, email, address, status) {
                document.getElementById('supId').value = id;
                document.getElementById('supName').value = name;
                document.getElementById('supPhone').value = phone;
                document.getElementById('supEmail').value = email;
                document.getElementById('supAddress').value = address;
                document.getElementById('supStatus').checked = status;
                new bootstrap.Modal(document.getElementById('supplierModal')).show();
            }
        </script>
    </c:if>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
