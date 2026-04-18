<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quên mật khẩu | Fresh Food Store</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
<jsp:include page="../components/header.jsp"/>

<section class="auth-section">
    <div class="container d-flex justify-content-center">
        <div class="auth-card">
            <div class="text-center mb-4">
                <i class="fas fa-lock-open fa-3x text-brand mb-2"></i>
                <h3 class="fw-bold mb-1">Quên mật khẩu?</h3>
                <p class="text-muted small">Chúng tôi sẽ hỗ trợ bạn khôi phục lại tài khoản</p>
            </div>

            <c:if test="${not empty msg}">
                <div class="alert alert-success border-0 shadow-sm text-center p-2 mb-3" style="font-size: 0.9rem; border-radius: 8px;">
                    <i class="fas fa-check-circle me-2"></i>${msg}
                </div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="alert alert-danger border-0 shadow-sm text-center p-2 mb-3" style="font-size: 0.9rem; border-radius: 8px;">
                    <i class="fas fa-exclamation-triangle me-2"></i>${error}
                </div>
            </c:if>

            <form action="forgot-password" method="post" id="otpForm">
                <c:choose>
                    <%-- BƯỚC 2: NHẬP OTP --%>
                    <c:when test="${step == 'verify-otp'}">
                        <input type="hidden" name="action" value="verify-otp">
                        <div class="mb-3">
                            <label class="form-label">Nhập mã OTP 6 số:</label>
                            <div class="input-group">
                                <span class="input-group-text bg-light border-end-0"><i class="fas fa-key text-muted"></i></span>
                                <input type="text" name="otp" class="form-control border-start-0 text-center fw-bold" placeholder="000000" required
                                        pattern="\d{6}" title="Mã OTP gồm 6 chữ số" style="letter-spacing: 5px;">
                            </div>
                        </div>
                        <button type="submit" class="btn btn-brand w-100 fw-bold py-2 mb-3 shadow-sm">Xác nhận OTP</button>
                        
                        <div class="text-center">
                            <button type="button" id="resendBtn" class="btn btn-link btn-sm text-decoration-none fw-bold" onclick="resendOtp()">
                                <i class="fas fa-sync-alt me-1"></i> Gửi lại mã
                            </button>
                        </div>
                    </c:when>

                    <%-- BƯỚC 1: NHẬP EMAIL --%>
                    <c:otherwise>
                        <input type="hidden" name="action" value="send-otp">
                        <div class="mb-3">
                            <label class="form-label">Email đã đăng ký:</label>
                            <div class="input-group">
                                <span class="input-group-text bg-light border-end-0"><i class="fas fa-envelope text-muted"></i></span>
                                <input type="email" name="email" id="emailInput" class="form-control border-start-0" placeholder="example@gmail.com" required 
                                       value="${sessionScope.resetEmail}">
                            </div>
                        </div>
                        <button type="submit" id="sendBtn" class="btn btn-brand w-100 fw-bold py-2 mb-3 shadow-sm">Gửi mã OTP qua Mail</button>
                    </c:otherwise>
                </c:choose>
            </form>

            <hr class="text-muted">
            <div class="text-center">
                <a href="login" class="text-decoration-none small fw-bold"><i class="fas fa-arrow-left me-1"></i> Quay lại Đăng nhập</a>
            </div>
        </div>
    </div>
</section>

<form id="resendForm" action="forgot-password" method="post" style="display:none;">
    <input type="hidden" name="action" value="send-otp">
    <input type="hidden" name="email" value="${sessionScope.resetEmail}">
</form>

<jsp:include page="../components/footer.jsp"/>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

<script>
    const resendBtn = document.getElementById('resendBtn');
    const sendBtn = document.getElementById('sendBtn');
    let timer;

    function startTimer(btn) {
        if (!btn) return;
        let seconds = 60;
        btn.disabled = true;
        btn.classList.add('disabled');
        btn.style.cursor = "not-allowed";
        
        timer = setInterval(() => {
            seconds--;
            btn.innerHTML = `<i class="fas fa-sync-alt me-1 shadow-none"></i> Gửi lại mã (${seconds}s)`;
            if (btn === sendBtn) btn.innerText = `Gửi mã OTP qua Mail (${seconds}s)`;
            
            if (seconds <= 0) {
                clearInterval(timer);
                btn.disabled = false;
                btn.classList.remove('disabled');
                btn.style.cursor = "pointer";
                btn.innerHTML = (btn === sendBtn) ? "Gửi mã OTP qua Mail" : `<i class="fas fa-sync-alt me-1 shadow-none"></i> Gửi lại mã`;
            }
        }, 1000);
    }

    function resendOtp() {
        document.getElementById('resendForm').submit();
    }

    window.onload = function() {
        <% if (request.getAttribute("msg") != null) { %>
            if (resendBtn) startTimer(resendBtn);
            if (sendBtn) startTimer(sendBtn);
        <% } %>
    };
</script>
</body>
</html>
