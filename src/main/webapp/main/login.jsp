<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập | Fresh Food Store</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
<jsp:include page="../components/header.jsp"/>

<section class="auth-section">
    <div class="container d-flex justify-content-center">
        <div class="auth-card">
            <h3 class="text-center">Đăng nhập</h3>

            <c:if test="${not empty errorMsg}">
                <div class="alert alert-danger text-center p-2 mb-3" style="font-size: 0.9rem; border-radius: 8px;">
                    <i class="fas fa-exclamation-circle me-2"></i>${errorMsg}
                </div>
            </c:if>

            <c:if test="${not empty successMsg}">
                <div class="alert alert-success text-center p-2 mb-3" style="font-size: 0.9rem; border-radius: 8px;">
                    <i class="fas fa-check-circle me-2"></i>${successMsg}
                </div>
            </c:if>

            <form action="login" method="post">
                <div class="mb-3">
                    <label class="form-label">Email của bạn</label>
                    <div class="input-group">
                        <span class="input-group-text bg-light border-end-0"><i class="fas fa-envelope text-muted"></i></span>
                        <input type="email" name="email" class="form-control border-start-0" placeholder="example@gmail.com"
                               required oninvalid="this.setCustomValidity('Email không được để trống và phải đúng định dạng!')"
                               oninput="this.setCustomValidity('')">
                    </div>
                </div>
                <div class="mb-4">
                    <label class="form-label">Mật khẩu</label>
                    <div class="input-group">
                        <span class="input-group-text bg-light border-end-0"><i class="fas fa-lock text-muted"></i></span>
                        <input type="password" name="password" class="form-control border-start-0" placeholder="••••••••"
                               required oninvalid="this.setCustomValidity('Vui lòng nhập mật khẩu!')"
                               oninput="this.setCustomValidity('')">
                    </div>
                    <div class="text-end mt-2">
                        <a href="forgot-password" class="text-decoration-none small fw-bold">Quên mật khẩu?</a>
                    </div>
                </div>
                
                <button type="submit" class="btn btn-brand w-100 py-2 fw-bold mb-3 shadow-sm">
                    Đăng nhập ngay <i class="fas fa-sign-in-alt ms-1"></i>
                </button>

                <div class="text-center mb-3 text-muted small position-relative">
                    <span class="bg-white px-2 position-relative" style="z-index: 2;">Hoặc đăng nhập với</span>
                    <hr class="position-absolute w-100" style="top: 50%; margin: 0; z-index: 1;">
                </div>

                <a href="https://accounts.google.com/o/oauth2/auth?scope=email%20profile&redirect_uri=http://localhost:8080/login-google&response_type=code&client_id=510783294208-jtmcvkh5n8hn5jn468ktejf5ufnucoqm.apps.googleusercontent.com"
                   class="btn btn-google w-100 py-2 mb-4 d-flex align-items-center justify-content-center">
                    <img src="https://www.gstatic.com/firebasejs/ui/2.0.0/images/auth/google.svg" alt="Google" width="18" class="me-2">
                    Tiếp tục với Google
                </a>

                <div class="text-center small">
                    Chưa có tài khoản? <a href="register" class="fw-bold text-decoration-none">Đăng ký thành viên</a>
                </div>
            </form>
        </div>
    </div>
</section>

<jsp:include page="../components/footer.jsp"/>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>