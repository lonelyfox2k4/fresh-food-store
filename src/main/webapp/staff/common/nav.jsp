<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<nav class="navbar navbar-expand-lg navbar-dark bg-dark shadow-sm mb-4">
    <div class="container-fluid px-4">
        <a class="navbar-brand fw-bold text-success" href="${pageContext.request.contextPath}/staff/orders">
            <i class="bi bi-leaf me-1"></i> FRESH FOOD <span class="badge bg-success ms-1 small">Staff Area</span>
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#staffNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="staffNav">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                <li class="nav-item">
                    <a class="nav-link ${requestScope['javax.servlet.forward.servlet_path'] == '/staff/orders' ? 'active fw-bold text-white' : ''}" 
                       href="${pageContext.request.contextPath}/staff/orders">
                       <i class="bi bi-box-seam me-1"></i> Đơn hàng
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${requestScope['javax.servlet.forward.servlet_path'] == '/staff/voucher' ? 'active fw-bold text-white' : ''}" 
                       href="${pageContext.request.contextPath}/staff/voucher">
                       <i class="bi bi-ticket-perforated me-1"></i> Voucher
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${requestScope['javax.servlet.forward.servlet_path'] == '/staff/news' ? 'active fw-bold text-white' : ''}" 
                       href="${pageContext.request.contextPath}/staff/news">
                       <i class="bi bi-newspaper me-1"></i> Tin tức
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${requestScope['javax.servlet.forward.servlet_path'] == '/staff/feedback' ? 'active fw-bold text-white' : ''}" 
                       href="${pageContext.request.contextPath}/staff/feedback">
                       <i class="bi bi-chat-dots me-1"></i> Phản hồi
                    </a>
                </li>
            </ul>
            <div class="d-flex align-items-center">
                <span class="text-light me-3 small">
                    <i class="bi bi-person-circle me-1"></i> ${sessionScope.user.fullName}
                </span>
                <a href="${pageContext.request.contextPath}/home" class="btn btn-outline-light btn-sm me-2"> 
                    <i class="bi bi-house"></i> Về trang chủ
                </a>
                <a href="${pageContext.request.contextPath}/logout" class="btn btn-danger btn-sm">
                    <i class="bi bi-box-arrow-right"></i> Đăng xuất
                </a>
            </div>
        </div>
    </div>
</nav>
