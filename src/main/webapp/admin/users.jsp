<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="container py-4">
<div class="d-flex justify-content-between mb-4">
    <h2>Quản lý người dùng</h2>
    <a href="assign" class="btn btn-primary">Cấp tài khoản mới</a>
</div>
<table class="table table-bordered">
    <thead class="table-dark">
    <tr>
        <th>ID</th><th>Email</th><th>Họ tên</th><th>Role</th><th>Trạng thái</th><th>Hành động</th>
    </tr>
    </thead>
    <tbody>
    <c:forEach var="u" items="${users}">
        <tr>
            <td>${u.accountId}</td>
            <td>${u.email}</td>
            <td>${u.fullName}</td>
            <td>${u.roleId}</td>
            <td><span class="badge ${u.status ? 'bg-success' : 'bg-danger'}">${u.status ? 'Active' : 'Banned'}</span></td>
            <td>
                <form action="update-status" method="post">
                    <input type="hidden" name="id" value="${u.accountId}">
                    <input type="hidden" name="status" value="${u.status}">
                    <button class="btn btn-sm ${u.status ? 'btn-warning' : 'btn-info'}">${u.status ? 'Ban' : 'Unban'}</button>
                </form>
            </td>
        </tr>
    </c:forEach>
    </tbody>
</table>
</body>
</html>