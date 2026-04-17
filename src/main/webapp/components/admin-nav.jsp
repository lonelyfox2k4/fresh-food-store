<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<style>
    :root {
        --primary: #4F46E5;
        --text-muted: #6B7280;
        --card-bg: #FFFFFF;
    }
    .admin-navbar {
        background-color: var(--card-bg);
        box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
        padding: 1rem 2rem;
        margin-bottom: 2rem;
    }
    .admin-navbar .navbar-brand {
        font-weight: 700;
        color: var(--primary);
        font-size: 1.5rem;
        letter-spacing: -0.5px;
    }
    .admin-navbar .nav-link {
        font-weight: 500;
        color: var(--text-muted);
        transition: all 0.3s ease;
        padding: 0.5rem 1rem !important;
        border-radius: 0.5rem;
        margin: 0 0.25rem;
        white-space: nowrap;
    }
    .admin-navbar .nav-link:hover, .admin-navbar .nav-link.active {
        color: var(--primary);
        background-color: #EEF2FF;
    }
</style>
<nav class="navbar navbar-expand-lg admin-navbar sticky-top">
    <div class="container-fluid">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/admin/dashboard">
            <i class="fas fa-leaf text-success me-2"></i>FFS Admin
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#adminNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="adminNav">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                <li class="nav-item">
                    <a class="nav-link ${param.active == 'dashboard' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/dashboard">
                        <i class="fas fa-chart-line me-1"></i> Dashboard
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${param.active == 'users' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/users">
                        <i class="fas fa-users-cog me-1"></i> Quản lý người dùng
                    </a>
                </li>
                
                <!-- Bán Hàng -->
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">
                        <i class="fas fa-box-open me-1"></i> Bán hàng
                    </a>
                    <ul class="dropdown-menu border-0 shadow-sm">
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/categories"><i class="fas fa-tags me-2 text-muted"></i> Danh mục</a></li>
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/products"><i class="fas fa-boxes me-2 text-muted"></i> Sản phẩm</a></li>
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/inventory-pricing"><i class="fas fa-money-bill-wave me-2 text-muted"></i> Bảng giá</a></li>
                    </ul>
                </li>

                <!-- Nội dung & Marketing -->
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">
                        <i class="fas fa-bullhorn me-1"></i> Marketing
                    </a>
                    <ul class="dropdown-menu border-0 shadow-sm">
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/staff/news"><i class="fas fa-newspaper me-2 text-muted"></i> Tin tức</a></li>
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/staff/voucher"><i class="fas fa-ticket-alt me-2 text-muted"></i> Mã giảm giá</a></li>
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/policies"><i class="fas fa-shield-alt me-2 text-muted"></i> Chính sách</a></li>
                    </ul>
                </li>

                <!-- Đối tác & CSKH -->
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">
                        <i class="fas fa-handshake me-1"></i> Đối tác & CSKH
                    </a>
                    <ul class="dropdown-menu border-0 shadow-sm">
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/admin/suppliers"><i class="fas fa-truck me-2 text-muted"></i> Nhà cung cấp</a></li>
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/staff/feedback"><i class="fas fa-comments me-2 text-muted"></i> Phản hồi</a></li>
                    </ul>
                </li>

                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/home">
                        <i class="fas fa-home me-1"></i> Cửa hàng
                    </a>
                </li>
            </ul>
            <div class="d-flex align-items-center">
                <div class="dropdown">
                    <a class="nav-link dropdown-toggle d-flex align-items-center" href="#" role="button" data-bs-toggle="dropdown">
                        <img src="https://ui-avatars.com/api/?name=Admin&background=4F46E5&color=fff" alt="Admin" class="rounded-circle me-2" width="32" height="32">
                        <span class="fw-semibold">Administrator</span>
                    </a>
                    <ul class="dropdown-menu dropdown-menu-end shadow-sm border-0 mt-2">
                        <li><a class="dropdown-item" href="#"><i class="fas fa-user-circle me-2"></i> Hồ sơ</a></li>
                        <li><a class="dropdown-item" href="#"><i class="fas fa-cog me-2"></i> Cài đặt</a></li>
                        <li><hr class="dropdown-divider"></li>
                        <li><a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/auth/logout"><i class="fas fa-sign-out-alt me-2"></i> Đăng xuất</a></li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</nav>
