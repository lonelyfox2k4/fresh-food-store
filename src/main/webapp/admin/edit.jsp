<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Chỉnh sửa người dùng</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body { background-color: #f4f7f6; }
        .card { border: none; border-radius: 12px; }
        .form-label { font-weight: 600; color: #495057; font-size: 0.9rem; }
        .form-control, .form-select { border-radius: 8px; padding: 0.6rem 1rem; border: 1px solid #ced4da; }
        .form-control:focus { border-color: #0d6efd; box-shadow: 0 0 0 0.25rem rgba(13, 110, 253, 0.1); }
        .btn-primary { background-color: #0d6efd; border: none; padding: 0.7rem 1.5rem; border-radius: 8px; font-weight: 600; }
        .btn-light { border-radius: 8px; padding: 0.7rem 1.5rem; font-weight: 600; background: #fff; border: 1px solid #dee2e6; }
    </style>
</head>
<body class="bg-light">
<jsp:include page="../components/admin-nav.jsp">
    <jsp:param name="active" value="users"/>
</jsp:include>
<div class="py-5">
<div class="container">
    <div class="row justify-content-center">
        <div class="col-md-8 col-lg-6">
            <div class="mb-3">
                <a href="users" class="text-decoration-none text-muted small">
                    <i class="fas fa-arrow-left me-1"></i> Quay lại danh sách
                </a>
            </div>

            <div class="card shadow-sm">
                <div class="card-body p-4 p-md-5">
                    <div class="d-flex align-items-center mb-4">
                        <div class="bg-primary text-white rounded-circle d-flex align-items-center justify-content-center me-3" style="width: 50px; height: 50px;">
                            <i class="fas fa-user-edit fs-4"></i>
                        </div>
                        <div>
                            <h3 class="mb-0 fw-bold">Chỉnh sửa thông tin</h3>
                            <p class="text-muted mb-0 small">Mã tài khoản: #${user.accountId}</p>
                        </div>
                    </div>

                    <hr class="text-muted mb-4">

                    <form action="edit" method="post">
                        <input type="hidden" name="id" value="${user.accountId}">

                        <div class="row g-3">
                            <div class="col-12">
                                <label class="form-label text-uppercase">Địa chỉ Email</label>
                                <input type="email" class="form-control bg-light" value="${user.email}" readonly>
                            </div>

                            <div class="col-12">
                                <label class="form-label text-uppercase">Họ và tên</label>
                                <input type="text" name="name" class="form-control" value="${user.fullName}" required placeholder="Nhập họ tên đầy đủ">
                            </div>

                            <div class="col-12">
                                <label class="form-label text-uppercase">Số điện thoại</label>
                                <input type="text" name="phone" class="form-control" value="${user.phone}" placeholder="Nhập số điện thoại">
                            </div>

                            <div class="col-md-6">
                                <label class="form-label text-uppercase">Quyền hạn</label>
                                <select name="roleId" class="form-select">
                                    <option value="1" ${user.roleId == 1 ? 'selected' : ''}>Admin</option>
                                    <option value="2" ${user.roleId == 2 ? 'selected' : ''}>Manager</option>
                                    <option value="3" ${user.roleId == 3 ? 'selected' : ''}>Staff</option>
                                    <option value="4" ${user.roleId == 4 ? 'selected' : ''}>Shipper</option>
                                    <option value="5" ${user.roleId == 5 ? 'selected' : ''}>Customer</option>
                                </select>
                            </div>

                            <div class="col-md-6">
                                <label class="form-label text-uppercase">Trạng thái</label>
                                <select name="status" class="form-select">
                                    <option value="true" ${user.status ? 'selected' : ''}>Hoạt động (Active)</option>
                                    <option value="false" ${!user.status ? 'selected' : ''}>Bị khóa (Banned)</option>
                                </select>
                            </div>

                            <div class="col-12 mt-4 pt-2">
                                <div class="d-flex gap-2">
                                    <button type="submit" class="btn btn-primary flex-grow-1 shadow-sm">
                                        <i class="fas fa-save me-2"></i>Lưu thay đổi
                                    </button>
                                    <a href="users" class="btn btn-light px-4">Hủy</a>
                                </div>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
</div>
</body>
</html>