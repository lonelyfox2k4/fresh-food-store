<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Xác thực Email | Fresh Food Store</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
<jsp:include page="../components/header.jsp"/>

<section class="auth-section">
    <div class="container d-flex justify-content-center">
        <div class="auth-card text-center">
            <div class="mb-4">
                <i class="fas fa-envelope-open-text fa-3x text-brand mb-2"></i>
                <h3 class="fw-bold mb-1">Xác thực Email</h3>
                <p class="text-muted small">Vui lòng nhập mã OTP đã được gửi đến email của bạn</p>
            </div>

            <c:if test="${not empty errorMsg}">
                <div class="alert alert-danger text-center p-2 mb-3" style="font-size: 0.9rem; border-radius: 8px;">
                    <i class="fas fa-exclamation-circle me-2"></i>${errorMsg}
                </div>
            </c:if>
            <c:if test="${not empty msg}">
                <div class="alert alert-success text-center p-2 mb-3" style="font-size: 0.9rem; border-radius: 8px;">
                    <i class="fas fa-check-circle me-2"></i>${msg}
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/verify-register" method="post">
                <div class="mb-4">
                    <input type="text" name="otp" class="form-control text-center fw-bold rounded-3 py-3" 
                           placeholder="000000" maxlength="6" required autofocus
                           style="font-size: 24px; letter-spacing: 10px; border: 2px solid #eee;">
                </div>
                
                <button type="submit" class="btn btn-brand w-100 py-2 fw-bold mb-3 shadow-sm">
                    Xác nhận đăng ký <i class="fas fa-check-circle ms-1"></i>
                </button>
            </form>

            <p class="small text-muted mb-2">Không nhận được mã?</p>
            <form action="${pageContext.request.contextPath}/resend-otp" method="post" id="resendForm">
                <button type="submit" class="btn btn-link btn-sm text-decoration-none fw-bold" id="resendBtn">
                    <i class="fas fa-sync-alt me-1"></i> Gửi lại mã
                </button>
            </form>

            <div class="mt-4 pt-3 border-top">
                <a href="register" class="text-decoration-none small text-muted">
                    <i class="fas fa-arrow-left me-1"></i> Quay lại trang Đăng ký
                </a>
            </div>
        </div>
    </div>
</section>

<jsp:include page="../components/footer.jsp"/>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

<%
    // Lấy thời gian gửi OTP cuối cùng từ Session để tính toán bộ đếm ngược
    Long lastSent = (Long) session.getAttribute("lastOtpSentTime");
    long remainingSeconds = 0;
    if (lastSent != null) {
        long elapsed = System.currentTimeMillis() - lastSent;
        if (elapsed < 60000) { // Cooldown 60 giây
            remainingSeconds = (60000 - elapsed) / 1000;
        }
    }
%>

<script>
    const resendBtn = document.getElementById('resendBtn');
    const resendForm = document.getElementById('resendForm');
    let timer;

    function startTimer(seconds) {
        let countdown = seconds;
        resendBtn.disabled = true;
        resendBtn.classList.add('disabled');
        resendBtn.style.cursor = "not-allowed";
        
        // Cập nhật giao diện ngay lập tức
        resendBtn.innerHTML = `<i class="fas fa-sync-alt me-1 shadow-none"></i> Gửi lại mã (<b class="text-danger">` + countdown + `s</b>)`;
        
        timer = setInterval(() => {
            countdown--;
            resendBtn.innerHTML = `<i class="fas fa-sync-alt me-1 shadow-none"></i> Gửi lại mã (<b class="text-danger">` + countdown + `s</b>)`;
            
            if (countdown <= 0) {
                clearInterval(timer);
                resendBtn.disabled = false;
                resendBtn.classList.remove('disabled');
                resendBtn.style.cursor = "pointer";
                resendBtn.innerHTML = `<i class="fas fa-sync-alt me-1 shadow-none"></i> Gửi lại mã`;
            }
        }, 1000);
    }

    resendForm.onsubmit = function() {
        if (resendBtn.disabled) return false;
        return true;
    };

    window.onload = function() {
        // Tự động kích hoạt bộ đếm nếu vẫn còn trong thời gian chờ
        let initialRemaining = <%= remainingSeconds %>;
        if (initialRemaining > 0) {
            startTimer(initialRemaining);
        }
    };
</script>
</body>
</html>