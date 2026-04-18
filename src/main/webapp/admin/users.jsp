<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Quản lý người dùng</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <style>
        body { font-family: 'Be Vietnam Pro', sans-serif; background: #f8fafc; color: #1e293b; }
        
        .page-header { background: #fff; padding: 2rem 0; border-bottom: 1px solid #e2e8f0; margin-bottom: 2rem; }
        .breadcrumb-item a { color: var(--brand); text-decoration: none; font-weight: 500; }
        
        .stat-card {
            background: #fff; border-radius: 16px; padding: 1.5rem; border: 1px solid #e2e8f0;
            transition: all 0.3s ease; display: flex; align-items: center; gap: 1rem;
        }
        .stat-card:hover { transform: translateY(-3px); box-shadow: 0 10px 20px rgba(0,0,0,0.05); }
        .stat-icon { width: 48px; height: 48px; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 1.25rem; }
        
        .filter-section {
            background: #fff; border-radius: 16px; padding: 1.5rem; border: 1px solid #e2e8f0; margin-bottom: 2rem;
        }
        
        .user-table-card { background: #fff; border-radius: 16px; border: 1px solid #e2e8f0; overflow: hidden; }
        .table thead th { 
            background: #f8fafc; color: #64748b; font-weight: 600; text-transform: uppercase; 
            font-size: 0.75rem; letter-spacing: 0.5px; padding: 1rem 1.5rem; border-bottom: 1px solid #e2e8f0;
        }
        .table tbody td { padding: 1rem 1.5rem; vertical-align: middle; border-bottom: 1px solid #f1f5f9; }
        
        .avatar-circle {
            width: 40px; height: 40px; border-radius: 50%; display: flex; align-items: center; 
            justify-content: center; font-weight: 700; font-size: 0.875rem; color: #fff;
        }
        
        .badge-pill { padding: 0.35rem 0.75rem; border-radius: 30px; font-weight: 600; font-size: 0.75rem; }
        .badge-active { background: #dcfce7; color: #166534; }
        .badge-banned { background: #fee2e2; color: #991b1b; }
        .badge-role { background: #f1f5f9; color: #475569; border: 1px solid #e2e8f0; }
        
        .btn-action { width: 32px; height: 32px; border-radius: 8px; display: flex; align-items: center; justify-content: center; transition: all 0.2s; border: none; background: #f1f5f9; color: #64748b; }
        .btn-action:hover { background: var(--brand); color: #fff; }
        .btn-action-edit:hover { background: #0ea5e9; color: #fff; }
        
        .search-input { border-radius: 10px; border: 1px solid #e2e8f0; padding: 0.6rem 1rem 0.6rem 2.5rem; }
        .search-container { position: relative; }
        .search-container i { position: absolute; left: 1rem; top: 50%; transform: translateY(-50%); color: #94a3b8; }
    </style>
</head>
<body class="bg-light">
<jsp:include page="../components/admin-nav.jsp">
    <jsp:param name="active" value="users"/>
</jsp:include>
<div class="container py-4">

<div class="page-header mt-n2">
    <div class="container d-flex justify-content-between align-items-center">
        <div>
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb mb-1">
                    <li class="breadcrumb-item"><a href="dashboard">Admin</a></li>
                    <li class="breadcrumb-item active">Người dùng</li>
                </ol>
            </nav>
            <h2 class="fw-800 mb-0">Quản lý người dùng</h2>
        </div>
        <a href="${pageContext.request.contextPath}/admin/assign" class="btn btn-brand shadow-sm">
            <i class="fas fa-plus-circle me-2"></i> Cấp tài khoản mới
        </a>
    </div>
</div>

<div class="container pb-5">
    <!-- Quick Stats -->
    <div class="row g-3 mb-4">
        <div class="col-md-3">
            <div class="stat-card">
                <div class="stat-icon bg-brand-light text-brand"><i class="fas fa-users"></i></div>
                <div>
                    <div class="text-muted small fw-600">Tổng User</div>
                    <div class="fw-800 fs-5">${totalRecords}</div>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="stat-card">
                <div class="stat-icon bg-success bg-opacity-10 text-success"><i class="fas fa-user-check"></i></div>
                <div>
                    <div class="text-muted small fw-600">Đang hoạt động</div>
                    <div class="fw-800 fs-5">${stats.totalUsers - stats.totalBanned}</div> <%-- Placeholder logic --%>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="stat-card">
                <div class="stat-icon bg-info bg-opacity-10 text-info"><i class="fas fa-user-shield"></i></div>
                <div>
                    <div class="text-muted small fw-600">Admin/Manager</div>
                    <div class="fw-800 fs-5">5</div> <%-- Placeholder --%>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="stat-card">
                <div class="stat-icon bg-danger bg-opacity-10 text-danger"><i class="fas fa-user-slash"></i></div>
                <div>
                    <div class="text-muted small fw-600">Bị khóa</div>
                    <div class="fw-800 fs-5">3</div> <%-- Placeholder --%>
                </div>
            </div>
        </div>
    </div>

    <!-- Filters -->
    <div class="filter-section shadow-sm">
        <form action="users" method="get" class="row g-3 align-items-center">
            <div class="col-md-4">
                <div class="search-container">
                    <i class="fas fa-search"></i>
                    <input type="text" name="search" class="form-control search-input" placeholder="Tìm theo tên hoặc email..." value="${param.search}">
                </div>
            </div>
            <div class="col-md-3">
                <select name="roleId" class="form-select border-0 bg-light" style="border-radius: 10px; padding: 0.6rem 1rem;">
                    <option value="">Tất cả vai trò</option>
                    <option value="1" ${param.roleId == '1' ? 'selected' : ''}>Quản trị viên (Admin)</option>
                    <option value="2" ${param.roleId == '2' ? 'selected' : ''}>Quản lý (Manager)</option>
                    <option value="3" ${param.roleId == '3' ? 'selected' : ''}>Nhân viên (Staff)</option>
                    <option value="5" ${param.roleId == '5' ? 'selected' : ''}>Khách hàng (Customer)</option>
                </select>
            </div>
            <div class="col-md-2">
                <select name="status" class="form-select border-0 bg-light" style="border-radius: 10px; padding: 0.6rem 1rem;">
                    <option value="">Trạng thái</option>
                    <option value="true" ${param.status == 'true' ? 'selected' : ''}>Active</option>
                    <option value="false" ${param.status == 'false' ? 'selected' : ''}>Banned</option>
                </select>
            </div>
            <div class="col-md-3 d-flex gap-2">
                <button type="submit" class="btn btn-brand flex-grow-1"><i class="fas fa-filter"></i> Lọc</button>
                <a href="users" class="btn btn-light"><i class="fas fa-redo"></i></a>
            </div>
            <input type="hidden" name="sortBy" value="${param.sortBy != null ? param.sortBy : 'accountId'}">
            <input type="hidden" name="sortDir" value="${param.sortDir != null ? param.sortDir : 'ASC'}">
        </form>
    </div>

    <!-- User Table -->
    <div class="user-table-card shadow-sm">
        <div class="table-responsive">
            <table class="table mb-0">
                <thead>
                    <tr>
                        <th width="80">
                            <a href="users?search=${param.search}&roleId=${param.roleId}&status=${param.status}&sortBy=accountId&sortDir=${param.sortDir == 'ASC' ? 'DESC' : 'ASC'}" class="text-decoration-none text-muted">
                                ID <i class="fas fa-sort ms-1"></i>
                            </a>
                        </th>
                        <th>Người dùng</th>
                        <th>Email</th>
                        <th>Vai trò</th>
                        <th>Trạng thái</th>
                        <th class="text-center" width="120">Hành động</th>
                    </tr>
                </thead>
                <tbody>
                <c:forEach var="u" items="${users}">
                    <tr>
                        <td><span class="text-muted small">#${u.accountId}</span></td>
                        <td>
                            <div class="d-flex align-items-center">
                                <div class="avatar-circle me-3" style="background: linear-gradient(135deg, #E3000F, #ffc107); width: 36px; height: 36px; font-size: 0.75rem;">
                                    ${u.fullName.substring(0,1).toUpperCase()}
                                </div>
                                <div class="fw-700">${u.fullName}</div>
                            </div>
                        </td>
                        <td><span class="text-muted fs-7">${u.email}</span></td>
                        <td>
                            <c:choose>
                                <c:when test="${u.roleId == 1}"><span class="badge-pill badge-role bg-dark text-white">Admin</span></c:when>
                                <c:when test="${u.roleId == 2}"><span class="badge-pill badge-role bg-info border-0 text-white">Manager</span></c:when>
                                <c:when test="${u.roleId == 3}"><span class="badge-pill badge-role bg-primary border-0 text-white">Staff</span></c:when>
                                <c:otherwise><span class="badge-pill badge-role">Customer</span></c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <span class="badge-pill ${u.status ? 'badge-active' : 'badge-banned'}">
                                <i class="fas fa-circle me-1" style="font-size: 0.5rem;"></i> ${u.status ? 'Active' : 'Banned'}
                            </span>
                        </td>
                        <td class="text-center">
                            <div class="d-flex justify-content-center gap-2">
                                <a href="edit?id=${u.accountId}" class="btn-action btn-action-edit" title="Sửa">
                                    <i class="fas fa-pen"></i>
                                </a>
                                <c:if test="${u.roleId != 1}">
                                    <form action="update-status" method="post" class="m-0">
                                        <input type="hidden" name="id" value="${u.accountId}">
                                        <input type="hidden" name="status" value="${u.status}">
                                        <button type="submit" class="btn-action" title="${u.status ? 'Khóa' : 'Mở khóa'}"
                                                onclick="return confirm('Mày có chắc muốn ${u.status ? 'Ban' : 'Unban'} user này?')">
                                            <i class="fas ${u.status ? 'fa-user-slash text-danger' : 'fa-user-check text-success'}"></i>
                                        </button>
                                    </form>
                                </c:if>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>

    <nav class="d-flex justify-content-between align-items-center mt-4">
        <div class="text-muted small fw-semibold">
            Hiển thị trang ${currentPage} / ${totalPages > 0 ? totalPages : 1} (Tổng: ${totalRecords} người dùng)
        </div>
        <c:if test="${totalPages > 1}">
            <ul class="pagination mb-0 shadow-sm">
                <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                    <a class="page-link" href="users?page=${currentPage - 1}&search=${param.search}&roleId=${param.roleId}&status=${param.status}&sortBy=${param.sortBy}&sortDir=${param.sortDir}">
                        <i class="fas fa-chevron-left"></i>
                    </a>
                </li>
                <c:forEach begin="1" end="${totalPages}" var="i">
                    <li class="page-item ${currentPage == i ? 'active' : ''}">
                        <a class="page-link" href="users?page=${i}&search=${param.search}&roleId=${param.roleId}&status=${param.status}&sortBy=${param.sortBy}&sortDir=${param.sortDir}">${i}</a>
                    </li>
                </c:forEach>
                <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                    <a class="page-link" href="users?page=${currentPage + 1}&search=${param.search}&roleId=${param.roleId}&status=${param.status}&sortBy=${param.sortBy}&sortDir=${param.sortDir}">
                        <i class="fas fa-chevron-right"></i>
                    </a>
                </li>
            </ul>
        </c:if>
    </nav>

</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>