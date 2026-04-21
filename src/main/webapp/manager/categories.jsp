<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Loại sản phẩm | Fresh Food</title>
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
        <jsp:param name="active" value="categories" />
    </jsp:include>

    <div class="page-header mt-n2">
        <div class="container d-flex justify-content-between align-items-center">
            <div>
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb mb-1">
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/manager/products">Quản lý</a></li>
                        <li class="breadcrumb-item active">Danh mục</li>
                    </ol>
                </nav>
                <h2 class="fw-800 mb-0">Quản lý Phân loại</h2>
            </div>
            <c:if test="${sessionScope.user.roleId != 1}">
                <button type="button" class="btn btn-brand shadow-sm rounded-pill" data-bs-toggle="modal" data-bs-target="#categoryModal">
                    <i class="fas fa-plus-circle me-2"></i>Thêm phân loại
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
                            <th style="width: 120px;">Mã số</th>
                            <th>Tên phân loại</th>
                            <th>Trạng thái hiển thị</th>
                            <c:if test="${sessionScope.user.roleId != 1}">
                                <th class="text-end pe-4">Hành động</th>
                            </c:if>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="c" items="${categories}">
                            <tr>
                                <td class="text-muted fw-600">#CAT-${c.categoryId}</td>
                                <td>
                                    <div class="fw-bold text-dark fs-6">${c.categoryName}</div>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${c.status}"><span class="badge-pill badge-active"><i class="fas fa-eye me-1"></i>Đang hiển thị</span></c:when>
                                        <c:otherwise><span class="badge-pill badge-role"><i class="fas fa-eye-slash me-1"></i>Đã ẩn</span></c:otherwise>
                                    </c:choose>
                                </td>
                                <c:if test="${sessionScope.user.roleId != 1}">
                                    <td class="text-end pe-4">
                                        <div class="d-flex justify-content-end gap-2">
                                            <button class="btn-action btn-action-edit" onclick="editCategory(${c.categoryId}, '${c.categoryName}', ${c.status})" title="Chỉnh sửa">
                                                <i class="fas fa-edit"></i>
                                            </button>
                                            <a href="categories?action=delete&id=${c.categoryId}" class="btn-action btn-action-delete" title="Ẩn phân loại" onclick="return confirm('Bạn có muốn ẩn phân loại này khỏi danh mục bán hàng?')">
                                                <i class="fas fa-trash-alt"></i>
                                            </a>
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
        <div class="modal fade" id="categoryModal" tabindex="-1">
            <div class="modal-dialog modal-dialog-centered">
                <form action="categories" method="POST" class="modal-content">
                    <div class="modal-header border-0 pb-0">
                        <h5 class="fw-bold">Thông tin phân loại</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body p-4">
                        <input type="hidden" name="id" id="catId">
                        <div class="mb-4">
                            <label class="form-label fw-semibold small text-muted text-uppercase">Tên phân loại</label>
                            <input type="text" name="categoryName" id="catName" class="form-control form-control-lg bg-light border-0" placeholder="VD: Thực phẩm đông lạnh" required>
                        </div>
                        <div class="form-check form-switch d-flex align-items-center p-0">
                            <label class="form-check-label fw-semibold me-3">Trạng thái hiển thị công khai</label>
                            <input class="form-check-input ms-auto" type="checkbox" name="status" id="catStatus" checked style="width: 3rem; height: 1.5rem;">
                        </div>
                    </div>
                    <div class="modal-footer border-0 pt-0">
                        <button type="button" class="btn btn-light rounded-pill px-4" data-bs-dismiss="modal">Hủy bỏ</button>
                        <button type="submit" class="btn btn-primary rounded-pill px-4">Lưu thông tin</button>
                    </div>
                </form>
            </div>
        </div>

        <script>
            function editCategory(id, name, status) {
                document.getElementById('catId').value = id;
                document.getElementById('catName').value = name;
                document.getElementById('catStatus').checked = status;
                new bootstrap.Modal(document.getElementById('categoryModal')).show();
            }
        </script>
    </c:if>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
