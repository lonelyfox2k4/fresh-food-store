<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Xác thực đăng ký</title>
    <style>
        body { font-family: Arial, sans-serif; display: flex; justify-content: center; align-items: center; height: 100vh; background-color: #f4f4f4; }
        .container { background: white; padding: 30px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); width: 350px; text-align: center; }
        input[type="text"] { width: 100%; padding: 12px; margin: 15px 0; border: 1px solid #ddd; border-radius: 4px; box-sizing: border-box; font-size: 18px; text-align: center; letter-spacing: 5px; }
        .btn-submit { width: 100%; padding: 12px; background-color: #28a745; border: none; color: white; border-radius: 4px; cursor: pointer; font-size: 16px; }
        .btn-submit:hover { background-color: #218838; }
        .msg { color: #28a745; margin-bottom: 10px; font-size: 14px; border: 1px solid #28a745; padding: 5px; border-radius: 4px; background: #e9f7ef; }
        .error { color: #dc3545; margin-bottom: 10px; font-size: 14px; border: 1px solid #dc3545; padding: 5px; border-radius: 4px; background: #fdf2f2; }

        /* Style cho nút gửi lại */
        .resend-btn { background: none; border: none; color: #007bff; cursor: pointer; padding: 0; text-decoration: underline; font-size: 12px; }
        .resend-btn:disabled { color: #ccc; cursor: not-allowed; text-decoration: none; }
    </style>
</head>
<body>
<div class="container">
    <h2>Xác thực Email</h2>
    <p style="font-size: 13px; color: #666;">Vui lòng nhập mã OTP đã được gửi đến email của bạn.</p>

    <%-- Hiển thị thông báo lỗi hoặc thành công --%>
    <% if (request.getAttribute("errorMsg") != null) { %>
    <div class="error"><%= request.getAttribute("errorMsg") %></div>
    <% } %>
    <% if (request.getAttribute("msg") != null) { %>
    <div class="msg"><%= request.getAttribute("msg") %></div>
    <% } %>

    <%-- Form xác nhận OTP --%>
    <form action="${pageContext.request.contextPath}/verify-register" method="post">
        <input type="text" name="otp" placeholder="000000" maxlength="6" required autofocus>
        <button type="submit" class="btn-submit">Xác nhận đăng ký</button>
    </form>

    <p style="margin-top: 15px; font-size: 12px;">
        Không nhận được mã?
        <%-- Form gửi lại OTP (Chạy ngầm để không mất dữ liệu Session) --%>
    <form action="${pageContext.request.contextPath}/resend-otp" method="post" style="display: inline;" id="resendForm">
        <button type="submit" class="resend-btn" id="resendBtn">Gửi lại mã</button>
    </form>
    </p>

    <a href="register" style="display: block; margin-top: 10px; font-size: 11px; color: #999; text-decoration: none;">Quay lại trang Đăng ký</a>
</div>

<script>
    // Script chống spam nút gửi lại
    const resendBtn = document.getElementById('resendBtn');
    const resendForm = document.getElementById('resendForm');

    resendForm.onsubmit = function() {
        resendBtn.disabled = true;
        resendBtn.innerText = "Đang gửi lại...";
        return true;
    };
</script>
</body>
</html>