<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Chỉnh sửa người dùng</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <style>
        body { 
            font-family: 'Be Vietnam Pro', sans-serif; 
            background: radial-gradient(circle at bottom right, #fff5f5, #f0f2f5);
            min-height: 100vh;
        }
        .premium-card { 
            background: rgba(255, 255, 255, 0.85);
            backdrop-filter: blur(20px);
            border: 1px solid rgba(255, 255, 255, 0.4);
            border-radius: 24px;
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.1);
            overflow: hidden;
        }
        .form-label { font-weight: 800; color: #1a1a2e; font-size: 0.75rem; text-transform: uppercase; letter-spacing: 1px; margin-bottom: 0.6rem; }
        .form-control, .form-select { 
            border-radius: 12px; 
            padding: 0.75rem 1.2rem; 
            border: 1px solid rgba(0,0,0,0.06); 
            background: rgba(255,255,255,0.6);
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }
        .form-control:focus, .form-select:focus { 
            border-color: var(--brand); 
            box-shadow: 0 0 0 4px rgba(227, 0, 15, 0.1);
            background: #fff;
            transform: translateY(-1px);
        }
        .btn-brand { 
            background: linear-gradient(135deg, var(--brand), #b5000c);
            border: none; 
            padding: 1rem 2rem; 
            border-radius: 12px; 
            font-weight: 700; 
            color: white;
            transition: all 0.3s;
        }
        .btn-brand:hover { transform: translateY(-2px); box-shadow: 0 12px 25px rgba(227, 0, 15, 0.35); color: white; }
        .bg-brand-soft { background: var(--brand-light); color: var(--brand); }
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
            <div class="mb-4">
                <a href="users" class="text-decoration-none text-muted fw-600 small">
                    <i class="fas fa-chevron-left me-1"></i> Quay lại danh sách
                </a>
            </div>
 
            <div class="premium-card">
                <div class="card-body p-4 p-md-5">
                    <div class="d-flex align-items-center mb-4">
                        <div class="bg-brand-soft rounded-3 d-flex align-items-center justify-content-center me-3" style="width: 60px; height: 60px;">
                            <i class="fas fa-user-edit fs-3"></i>
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
                                <c:choose>
                                    <c:when test="${user.roleId == 1}">
                                        <select class="form-select bg-light" disabled>
                                            <option selected>Admin (Bảo vệ)</option>
                                        </select>
                                        <input type="hidden" name="roleId" value="1">
                                    </c:when>
                                    <c:otherwise>
                                        <select name="roleId" class="form-select">
                                            <option value="1" ${user.roleId == 1 ? 'selected' : ''}>Admin</option>
                                            <option value="2" ${user.roleId == 2 ? 'selected' : ''}>Manager</option>
                                            <option value="3" ${user.roleId == 3 ? 'selected' : ''}>Staff</option>
                                            <option value="4" ${user.roleId == 4 ? 'selected' : ''}>Shipper</option>
                                            <option value="5" ${user.roleId == 5 ? 'selected' : ''}>Customer</option>
                                        </select>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <div class="col-md-6">
                                <label class="form-label text-uppercase">Trạng thái</label>
                                <c:choose>
                                    <c:when test="${user.roleId == 1}">
                                        <select class="form-select bg-light" disabled>
                                            <option selected>Hoạt động (Bảo vệ)</option>
                                        </select>
                                        <input type="hidden" name="status" value="true">
                                    </c:when>
                                    <c:otherwise>
                                        <select name="status" class="form-select">
                                            <option value="true" ${user.status ? 'selected' : ''}>Hoạt động (Active)</option>
                                            <option value="false" ${!user.status ? 'selected' : ''}>Bị khóa (Banned)</option>
                                        </select>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <div class="col-12 mt-4 pt-2">
                                <div class="d-flex gap-2">
                                    <button type="submit" class="btn btn-brand flex-grow-1 shadow-sm">
                                        <i class="fas fa-save me-2"></i>Lưu thay đổi
                                    </button>
                                    <a href="users" class="btn btn-outline-secondary px-4" style="border-radius: 8px; padding: 0.7rem 1.5rem; font-weight: 600;">Hủy</a>
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
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>