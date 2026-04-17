<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Đăng ký thành viên</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light d-flex align-items-center vh-100">
<div class="container card shadow-sm p-4" style="max-width: 450px;">
    <h3 class="text-center mb-3">Đăng ký</h3>

    <c:if test="${not empty errorMsg}">
        <div class="alert alert-danger p-2 text-center" style="font-size: 0.9rem;">
                ${errorMsg}
        </div>
    </c:if>

    <form action="register" method="post">
        <div class="mb-3">
            <label class="form-label">Họ và tên</label>
            <input type="text" name="name" class="form-control" value="${param.name}" required>
        </div>
        <div class="mb-3">
            <label class="form-label">Email</label>
            <input type="email" name="email" class="form-control" value="${param.email}" required>
        </div>
        <div class="mb-3">
            <label class="form-label">Số điện thoại</label>
            <input type="text" name="phone" class="form-control" value="${param.phone}" pattern="[0-9]{10}" title="Vui lòng nhập đúng 10 số">
        </div>
        <div class="mb-3">
            <label class="form-label">Mật khẩu</label>
            <input type="password" name="password" class="form-control" required minlength="6">
        </div>
        <button class="btn btn-success w-100 mb-2">Đăng ký ngay</button>
        <a href="login" class="d-block text-center text-decoration-none">Đã có tài khoản? Đăng nhập</a>
    </form>
</div>
</body>
</html>