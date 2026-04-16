<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Assign New Account</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<jsp:include page="../components/admin-nav.jsp">
    <jsp:param name="active" value="users"/>
</jsp:include>
<div class="container mt-5">
    <div class="row justify-content-center">
        <div class="col-md-6">
            <div class="card shadow">
                <div class="card-header bg-primary text-white">
                    <h4 class="mb-0">Cấp tài khoản mới (Assign)</h4>
                </div>
                <div class="card-body">
                    <form action="${pageContext.request.contextPath}/admin/assign" method="post">
                        <div class="mb-3">
                            <label class="form-label">Họ và tên</label>
                            <input type="text" name="name" class="form-control" required minlength="3">
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Email</label>
                            <input type="email" name="email" class="form-control" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Số điện thoại</label>
                            <input type="text" name="phone" class="form-control" pattern="[0-9]{10,11}" title="Vui lòng nhập 10-11 số">
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Vai trò (Role)</label>
                            <select name="roleId" class="form-select" required>
                                <option value="">-- Chọn Role --</option>
                                <option value="1">Admin</option>
                                <option value="2">Staff</option>
                                <option value="3">Customer</option>
                                <option value="4">Shipper</option>
                                <option value="5">Manager</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Mật khẩu mặc định</label>
                            <input type="password" name="password" class="form-control" value="123456" readonly>
                            <small class="text-muted">Mật khẩu mặc định cho tài khoản mới là 123456</small>
                        </div>
                        <div class="d-flex justify-content-between">
                            <a href="users" class="btn btn-secondary">Quay lại</a>
                            <button type="submit" class="btn btn-success">Xác nhận cấp</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>