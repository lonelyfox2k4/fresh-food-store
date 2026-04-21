<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chính sách Giảm giá | Fresh Food</title>
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
        <jsp:param name="active" value="policies" />
    </jsp:include>

    <div class="page-header mt-n2">
        <div class="container d-flex justify-content-between align-items-center">
            <div>
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb mb-1">
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/manager/products">Quản lý</a></li>
                        <li class="breadcrumb-item active">Chính sách giảm giá</li>
                    </ol>
                </nav>
                <h2 class="fw-800 mb-0">Chính sách Giảm giá</h2>
            </div>
            <c:if test="${sessionScope.user.roleId != 1}">
                <button type="button" class="btn btn-brand shadow-sm rounded-pill" data-bs-toggle="modal" data-bs-target="#addPolicyModal">
                    <i class="fas fa-plus-circle me-2"></i>Tạo chính sách mới
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
                            <th style="width: 80px;">ID</th>
                            <th>Tên chính sách</th>
                            <th>Mô tả / Ghi chú</th>
                            <th>Trạng thái hoạt động</th>
                            <c:if test="${sessionScope.user.roleId != 1}">
                                <th class="text-end pe-4">Cấu hình & Thao tác</th>
                            </c:if>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="p" items="${policies}">
                            <tr>
                                <td class="text-muted fw-medium">#POL-${p.policyId}</td>
                                <td>
                                    <div class="fw-bold text-dark fs-6">${p.policyName}</div>
                                </td>
                                <td>
                                    <div class="small text-secondary">${p.note}</div>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${p.status}"><span class="badge-pill badge-active"><i class="fas fa-check-circle me-1"></i>Đang áp dụng</span></c:when>
                                        <c:otherwise><span class="badge-pill badge-role"><i class="fas fa-pause-circle me-1"></i>Tạm dừng</span></c:otherwise>
                                    </c:choose>
                                </td>
                                <c:if test="${sessionScope.user.roleId != 1}">
                                    <td class="text-end pe-4">
                                        <div class="d-flex justify-content-end gap-2">
                                            <a href="policies?action=edit-rules&id=${p.policyId}" class="btn btn-sm btn-outline-brand rounded-pill px-3 shadow-sm d-flex align-items-center">
                                                <i class="fas fa-sliders-h me-1"></i> Cấu hình
                                            </a>
                                            <button class="btn-action btn-action-edit" onclick="editPolicy(${p.policyId}, '${p.policyName}', '${p.note}', ${p.status})" title="Sửa chính sách">
                                                <i class="fas fa-edit"></i>
                                            </button>
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
        <!-- Modal Thêm/Sửa Policy -->
        <div class="modal fade" id="addPolicyModal" tabindex="-1">
            <div class="modal-dialog modal-dialog-centered">
                <form action="policies" method="post" class="modal-content">
                    <div class="modal-header border-0 pb-0 p-4">
                        <h5 class="fw-bold" id="modalTitle">Thông tin Chính sách</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body p-4">
                        <input type="hidden" name="id" id="policyId">
                        <div class="mb-4">
                            <label class="form-label fw-semibold small text-muted text-uppercase">Tên chính sách</label>
                            <input type="text" name="policyName" id="policyName" class="form-control form-control-lg bg-light border-0" placeholder="VD: Giảm giá hàng rau củ" required>
                        </div>
                        <div class="mb-4">
                            <label class="form-label fw-semibold small text-muted text-uppercase">Mô tả / Ghi chú</label>
                            <textarea name="note" id="policyNote" class="form-control bg-light border-0" rows="3" placeholder="Ghi chú về mục đích của chính sách này..."></textarea>
                        </div>
                        <div class="form-check form-switch d-flex align-items-center p-0">
                            <label class="form-check-label fw-semibold me-3">Kích hoạt áp dụng ngay</label>
                            <input class="form-check-input ms-auto" type="checkbox" name="status" id="policyStatus" checked style="width: 3rem; height: 1.5rem;">
                        </div>
                    </div>
                    <div class="modal-footer border-0 pt-0 p-4">
                        <button type="button" class="btn btn-light rounded-pill px-4" data-bs-dismiss="modal">Đóng</button>
                        <button type="submit" class="btn btn-primary rounded-pill px-5 fw-bold">Lưu thay đổi</button>
                    </div>
                </form>
            </div>
        </div>

        <script>
            function editPolicy(id, name, note, status) {
                document.getElementById('modalTitle').innerText = 'Chỉnh sửa chính sách';
                document.getElementById('policyId').value = id;
                document.getElementById('policyName').value = name;
                document.getElementById('policyNote').value = note;
                document.getElementById('policyStatus').checked = status;
                new bootstrap.Modal(document.getElementById('addPolicyModal')).show();
            }
        </script>
    </c:if>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
