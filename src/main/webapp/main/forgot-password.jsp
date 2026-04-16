<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Quên mật khẩu | Fresh Food Store</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="bg-light d-flex align-items-center vh-100">

<div class="container card shadow-sm p-4" style="max-width: 450px; border-radius: 15px; background: #fff;">
    <div class="text-center mb-4">
        <i class="fas fa-lock-open fa-3x text-primary mb-2"></i>
        <h3 class="fw-bold">Quên mật khẩu?</h3>
        <p class="text-muted small">Chúng tôi sẽ hỗ trợ bạn khôi phục lại tài khoản</p>
    </div>

    <c:if test="${not empty msg}">
        <div class="alert alert-success border-0 shadow-sm text-center p-2 mb-3" style="font-size: 0.9rem;">
            <i class="fas fa-check-circle me-2"></i>${msg}
        </div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="alert alert-danger border-0 shadow-sm text-center p-2 mb-3" style="font-size: 0.9rem;">
            <i class="fas fa-exclamation-triangle me-2"></i>${error}
        </div>
    </c:if>

    <form action="forgot-password" method="post">
        <c:choose>
            <%-- BƯỚC 2: NHẬP OTP --%>
            <c:when test="${step == 'verify-otp'}">
                <input type="hidden" name="action" value="verify-otp">
                <div class="mb-3">
                    <label class="form-label fw-semibold small">Nhập mã OTP 6 số:</label>
                    <div class="input-group">
                        <span class="input-group-text bg-white"><i class="fas fa-key text-muted"></i></span>
                        <input type="text" name="otp" class="form-control" placeholder="Mã OTP" required
                               pattern="\d{6}" title="Mã OTP gồm 6 chữ số">
                    </div>
                </div>
                <button class="btn btn-success w-100 fw-bold py-2 mb-3 shadow-sm">Xác nhận OTP</button>
            </c:when>

            <%-- BƯỚC 1: NHẬP EMAIL --%>
            <c:otherwise>
                <input type="hidden" name="action" value="send-otp">
                <div class="mb-3">
                    <label class="form-label fw-semibold small">Email đã đăng ký:</label>
                    <div class="input-group">
                        <span class="input-group-text bg-white"><i class="fas fa-envelope text-muted"></i></span>
                        <input type="email" name="email" class="form-control" placeholder="example@gmail.com" required>
                    </div>
                </div>
                <button class="btn btn-primary w-100 fw-bold py-2 mb-3 shadow-sm">Gửi mã OTP qua Mail</button>
            </c:otherwise>
        </c:choose>
    </form>

    <hr class="text-muted">
    <div class="text-center">
        <a href="login" class="text-decoration-none small fw-bold"><i class="fas fa-arrow-left me-1"></i> Quay lại Đăng nhập</a>
    </div>
</div>

</body>
</html>