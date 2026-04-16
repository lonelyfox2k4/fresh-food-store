<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Quản lý người dùng</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        .table-dark th a { color: white; text-decoration: none; display: block; width: 100%; }
        .table-dark th a:hover { background-color: rgba(255,255,255,0.1); }
        .badge { min-width: 80px; }
    </style>
</head>
<body class="bg-light">
<jsp:include page="../components/admin-nav.jsp">
    <jsp:param name="active" value="users"/>
</jsp:include>
<div class="container py-4">

<div class="d-flex justify-content-between align-items-center mb-4">
    <h2><i class="fas fa-users-cog"></i> Quản lý người dùng</h2>
    <a href="${pageContext.request.contextPath}/admin/assign" class="btn btn-primary">
        <i class="fas fa-user-plus"></i> Cấp tài khoản mới
    </a>
</div>

<div class="card mb-4 shadow-sm border-0 bg-light">
    <div class="card-body">
        <form action="users" method="get" class="row g-3">
            <div class="col-md-3">
                <label class="small fw-bold">Tìm kiếm</label>
                <input type="text" name="search" class="form-control" placeholder="Tên hoặc email..." value="${param.search}">
            </div>

            <div class="col-md-3">
                <label class="small fw-bold">Quyền hạn</label>
                <select name="roleId" class="form-select">
                    <option value="">-- Tất cả quyền --</option>
                    <option value="1" ${param.roleId == '1' ? 'selected' : ''}>Admin</option>
                    <option value="2" ${param.roleId == '2' ? 'selected' : ''}>Manager</option>
                    <option value="3" ${param.roleId == '3' ? 'selected' : ''}>Staff</option>
                    <option value="4" ${param.roleId == '4' ? 'selected' : ''}>Shipper</option>
                    <option value="5" ${param.roleId == '5' ? 'selected' : ''}>Customer</option>
                </select>
            </div>

            <div class="col-md-2">
                <label class="small fw-bold">Trạng thái</label>
                <select name="status" class="form-select">
                    <option value="">-- Tất cả --</option>
                    <option value="true" ${param.status == 'true' ? 'selected' : ''}>Active</option>
                    <option value="false" ${param.status == 'false' ? 'selected' : ''}>Banned</option>
                </select>
            </div>

            <%-- Giữ trạng thái Sort hiện tại khi bấm Lọc --%>
            <input type="hidden" name="sortBy" value="${param.sortBy != null ? param.sortBy : 'accountId'}">
            <input type="hidden" name="sortDir" value="${param.sortDir != null ? param.sortDir : 'ASC'}">

            <div class="col-md-4 d-flex align-items-end gap-2">
                <button type="submit" class="btn btn-success flex-grow-1"><i class="fas fa-filter"></i> Lọc dữ liệu</button>
                <a href="users" class="btn btn-outline-secondary"><i class="fas fa-undo"></i> Reset</a>
            </div>
        </form>
    </div>
</div>

<table class="table table-hover table-bordered shadow-sm bg-white">
    <thead class="table-dark">
    <tr>
        <th>
            <a href="users?search=${param.search}&roleId=${param.roleId}&status=${param.status}&sortBy=accountId&sortDir=${param.sortDir == 'ASC' ? 'DESC' : 'ASC'}">
                ID <i class="fas fa-sort-numeric-${param.sortDir == 'ASC' ? 'down' : 'up'}"></i>
            </a>
        </th>
        <th>
            <a href="users?search=${param.search}&roleId=${param.roleId}&status=${param.status}&sortBy=email&sortDir=${param.sortDir == 'ASC' ? 'DESC' : 'ASC'}">
                Email <i class="fas fa-sort-alpha-${param.sortDir == 'ASC' ? 'down' : 'up'}"></i>
            </a>
        </th>
        <th>
            <a href="users?search=${param.search}&roleId=${param.roleId}&status=${param.status}&sortBy=fullName&sortDir=${param.sortDir == 'ASC' ? 'DESC' : 'ASC'}">
                Họ tên <i class="fas fa-sort-alpha-${param.sortDir == 'ASC' ? 'down' : 'up'}"></i>
            </a>
        </th>
        <th>Role</th>
        <th>Trạng thái</th>
        <th class="text-center">Thao tác</th>
    </tr>
    </thead>
    <tbody>
    <c:forEach var="u" items="${users}">
        <tr>
            <td>${u.accountId}</td>
            <td><strong>${u.email}</strong></td>
            <td>${u.fullName}</td>
            <td>
                    <%-- Phần mày hỏi: Hiển thị Badge dựa trên Role ID --%>
                <c:choose>
                    <c:when test="${u.roleId == 1}"><span class="badge bg-dark">Admin</span></c:when>
                    <c:when test="${u.roleId == 2}"><span class="badge bg-info">Manager</span></c:when>
                    <c:when test="${u.roleId == 3}"><span class="badge bg-primary">Staff</span></c:when>
                    <c:when test="${u.roleId == 4}"><span class="badge bg-warning text-dark">Shipper</span></c:when>
                    <c:otherwise><span class="badge bg-secondary">Customer</span></c:otherwise>
                </c:choose>
            </td>
            <td>
                <span class="badge ${u.status ? 'bg-success' : 'bg-danger'}">
                        ${u.status ? 'Active' : 'Banned'}
                </span>
            </td>
            <td class="text-center">
                <div class="d-flex justify-content-center gap-2">
                    <form action="update-status" method="post" class="m-0">
                        <input type="hidden" name="id" value="${u.accountId}">
                        <input type="hidden" name="status" value="${u.status}">
                        <button class="btn btn-sm ${u.status ? 'btn-outline-danger' : 'btn-outline-success'}"
                                onclick="return confirm('Mày có chắc muốn ${u.status ? 'Ban' : 'Unban'} tài khoản này không?')">
                            <i class="fas ${u.status ? 'fa-user-slash' : 'fa-user-check'}"></i> ${u.status ? 'Ban' : 'Unban'}
                        </button>
                    </form>
                    <a href="edit?id=${u.accountId}" class="btn btn-sm btn-outline-primary">
                        <i class="fas fa-edit"></i> Sửa
                    </a>
                </div>
            </td>
        </tr>
    </c:forEach>
    </tbody>
</table>

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
</body>
</html>