<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %><html>
<head>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="bg-light d-flex align-items-center vh-100">
<div class="container card shadow-sm p-4" style="max-width: 400px;">
    <h3 class="text-center">Đăng nhập</h3>

    <c:if test="${not empty errorMsg}">
        <div class="alert alert-danger text-center p-2" style="font-size: 0.9rem;">
                ${errorMsg}
        </div>
    </c:if>

    <form action="login" method="post">
        <div class="mb-3">
            <input type="email" name="email" class="form-control" placeholder="Email"
                   required oninvalid="this.setCustomValidity('Email không được để trống và phải đúng định dạng!')"
                   oninput="this.setCustomValidity('')">
        </div>
        <div class="mb-3">
            <input type="password" name="password" class="form-control" placeholder="Mật khẩu"
                   required oninvalid="this.setCustomValidity('Vui lòng nhập mật khẩu!')"
                   oninput="this.setCustomValidity('')">
        </div>
        <button class="btn btn-primary w-100 mb-2">Đăng nhập</button>

        <div class="text-center mb-2">hoặc</div>
        <a href="https://accounts.google.com/o/oauth2/auth?scope=email%20profile&redirect_uri=http://localhost:8080/login-google&response_type=code&client_id=510783294208-jtmcvkh5n8hn5jn468ktejf5ufnucoqm.apps.googleusercontent.com"
           class="btn btn-danger w-100 mb-2">
            <i class="fab fa-google me-2"></i> Đăng nhập bằng Google
        </a>
        <a href="forgot-password" class="text-end d-block mb-3 text-decoration-none">Quên mật khẩu?</a>
        <a href="register" class="d-block text-center">Chưa có tài khoản? Đăng ký</a>
    </form>
</div>
</body>
</html>