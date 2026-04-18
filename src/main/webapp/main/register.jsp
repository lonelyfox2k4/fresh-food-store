<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng ký thành viên | Fresh Food Store</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
<jsp:include page="../components/header.jsp"/>

<section class="auth-section">
    <div class="container d-flex justify-content-center">
        <div class="auth-card">
            <h3 class="text-center">Đăng ký thành viên</h3>

            <c:if test="${not empty errorMsg}">
                <div class="alert alert-danger p-2 text-center mb-3" style="font-size: 0.9rem; border-radius: 8px;">
                    <i class="fas fa-exclamation-triangle me-2"></i>${errorMsg}
                </div>
            </c:if>

            <form action="register" method="post">
                <div class="mb-3">
                    <label class="form-label">Họ và tên</label>
                    <div class="input-group">
                        <span class="input-group-text bg-light border-end-0"><i class="fas fa-user text-muted"></i></span>
                        <input type="text" name="name" class="form-control border-start-0" placeholder="Nguyễn Văn A" value="${param.name}" required>
                    </div>
                </div>
                <div class="mb-3">
                    <label class="form-label">Email</label>
                    <div class="input-group">
                        <span class="input-group-text bg-light border-end-0"><i class="fas fa-envelope text-muted"></i></span>
                        <input type="email" name="email" class="form-control border-start-0" placeholder="example@gmail.com" value="${param.email}" required>
                    </div>
                </div>
                <div class="mb-3">
                    <label class="form-label">Số điện thoại</label>
                    <div class="input-group">
                        <span class="input-group-text bg-light border-end-0"><i class="fas fa-phone text-muted"></i></span>
                        <input type="text" name="phone" class="form-control border-start-0" placeholder="09xxxxxxxx" value="${param.phone}" pattern="[0-9]{10}" title="Vui lòng nhập đúng 10 số">
                    </div>
                </div>
                <div class="mb-4">
                    <label class="form-label">Mật khẩu</label>
                    <div class="input-group">
                        <span class="input-group-text bg-light border-end-0"><i class="fas fa-lock text-muted"></i></span>
                        <input type="password" name="password" class="form-control border-start-0" placeholder="Tối thiểu 6 ký tự" required minlength="6">
                    </div>
                </div>
                
                <button type="submit" class="btn btn-brand w-100 py-2 fw-bold mb-3 shadow-sm">
                    Đăng ký ngay <i class="fas fa-user-plus ms-1"></i>
                </button>
                
                <div class="text-center small">
                    Đã có tài khoản? <a href="login" class="fw-bold text-decoration-none">Đăng nhập tại đây</a>
                </div>
            </form>
        </div>
    </div>
</section>

<jsp:include page="../components/footer.jsp"/>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>