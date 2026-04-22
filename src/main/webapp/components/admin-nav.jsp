<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<style>
    :root {
        --primary: #E3000F;
        --secondary: #FDB022; /* Vibrant Orange for active indicators */
        --primary-light: #FFF1F2;
        --text-main: #1E293B;
        --text-muted: #64748B;
        --card-bg: #FFFFFF;
        --nav-height: 72px;
    }

    .admin-navbar {
        background-color: var(--card-bg);
        box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.05), 0 1px 2px 0 rgba(0, 0, 0, 0.03);
        min-height: var(--nav-height);
        padding: 0 1.5rem;
        border-bottom: 1px solid #F1F5F9;
    }

    .admin-navbar .navbar-brand {
        display: flex;
        align-items: center;
        font-weight: 800;
        color: var(--primary);
        font-size: 1.3rem;
        letter-spacing: -0.5px;
        margin-right: 0.75rem;
    }

    .admin-navbar .nav-link {
        position: relative;
        font-weight: 600;
        color: var(--text-muted);
        font-size: 0.875rem;
        padding: 0.5rem 0.5rem !important;
        margin: 0;
        display: flex;
        align-items: center;
        gap: 0.35rem;
        transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);
        min-height: var(--nav-height);
        white-space: nowrap;
    }

    .admin-navbar .nav-link:hover {
        color: var(--primary);
        background-color: var(--primary-light);
    }

    .admin-navbar .nav-link.active {
        color: var(--secondary) !important;
        background-color: var(--primary-light);
    }

    .admin-navbar .nav-link.active::after {
        content: '';
        position: absolute;
        bottom: 8px;
        left: 50%;
        transform: translateX(-50%);
        width: 24px;
        height: 3px;
        background-color: var(--secondary);
        border-radius: 4px;
    }

    .admin-navbar .nav-link i {
        font-size: 1rem;
    }

    .admin-navbar .dropdown-toggle::after {
        display: none; /* Hide default caret */
    }

    .dropdown-arrow {
        font-size: 0.65rem;
        color: var(--secondary);
        margin-left: 0.25rem;
        margin-top: 2px;
    }

    .role-badge {
        font-size: 0.7rem;
        font-weight: 700;
        padding: 0.35rem 0.75rem;
        border-radius: 9999px;
        letter-spacing: 0.5px;
        text-transform: uppercase;
        display: flex;
        align-items: center;
        gap: 0.35rem;
    }

    .role-badge.admin   { background: #FEE2E2; color: #E3000F; }
    .role-badge.manager { background: #E0F2FE; color: #0284C7; }
    .role-badge.staff   { background: #DCFCE7; color: #16A34A; }

    .user-profile {
        display: flex;
        align-items: center;
        gap: 0.75rem;
        padding: 0.5rem;
        border-radius: 0.75rem;
        transition: background-color 0.2s;
        cursor: pointer;
        text-decoration: none;
    }

    .user-profile:hover {
        background-color: #F8FAFC;
    }

    .user-avatar {
        width: 36px;
        height: 36px;
        border-radius: 50%;
        object-fit: cover;
        border: 2px solid #F1F5F9;
    }

    .user-name {
        color: var(--text-main);
        font-weight: 600;
        font-size: 0.85rem;
        max-width: 130px;
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
    }
</style>

<nav class="navbar navbar-expand-lg admin-navbar sticky-top">
    <div class="container-fluid px-lg-0 px-xl-2">
        <a class="navbar-brand" href="${pageContext.request.contextPath}${sessionScope.user.roleId == 1 ? '/admin/dashboard' : (sessionScope.user.roleId == 2 ? '/manager/products' : '/staff/orders')}">
            <i class="fas fa-leaf text-success me-2"></i>
            <span>FFS 
                <c:choose>
                    <c:when test="${sessionScope.user.roleId == 1}">Admin</c:when>
                    <c:when test="${sessionScope.user.roleId == 2}">Manager</c:when>
                    <c:when test="${sessionScope.user.roleId == 3}">Staff</c:when>
                    <c:otherwise>Employee</c:otherwise>
                </c:choose>
            </span>
        </a>
        
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#adminNav">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="adminNav">
            <ul class="navbar-nav me-auto align-items-center">
                <%-- Dashboard & Nguoi dung: CHI Admin (roleId=1) --%>
                <c:if test="${sessionScope.user.roleId == 1}">
                    <li class="nav-item">
                        <a class="nav-link ${param.active == 'dashboard' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/dashboard">
                            <i class="fas fa-chart-line"></i> Dashboard
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link ${param.active == 'users' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/users">
                            <i class="fas fa-users-cog"></i> Người dùng
                        </a>
                    </li>
                </c:if>

                <%-- Ban Hang: Admin, Manager, Staff --%>
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle ${param.active == 'sales' || param.active == 'orders' ? 'active' : ''}" href="#" role="button" data-bs-toggle="dropdown">
                        <i class="fas fa-box-open"></i> Bán hàng <i class="fas fa-chevron-down dropdown-arrow"></i>
                    </a>
                    <ul class="dropdown-menu border-0 shadow-lg mt-0">
                        <c:if test="${sessionScope.user.roleId == 1 || sessionScope.user.roleId == 2}">
                            <li><a class="dropdown-item py-2" href="${pageContext.request.contextPath}/manager/categories"><i class="fas fa-tags me-2 text-muted"></i> Danh mục</a></li>
                            <li><a class="dropdown-item py-2" href="${pageContext.request.contextPath}/manager/products"><i class="fas fa-boxes me-2 text-muted"></i> Sản phẩm</a></li>
                            <li><a class="dropdown-item py-2" href="${pageContext.request.contextPath}/manager/inventory-pricing"><i class="fas fa-money-bill-wave me-2 text-muted"></i> Bảng giá</a></li>
                            <li><hr class="dropdown-divider"></li>
                        </c:if>
                        <li><a class="dropdown-item py-2" href="${pageContext.request.contextPath}/staff/orders"><i class="fas fa-shopping-cart me-2 text-muted"></i> Đơn hàng</a></li>
                    </ul>
                </li>

                <%-- Marketing: Admin, Manager, Staff --%>
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle ${param.active == 'marketing' || param.active == 'news' || param.active == 'voucher' ? 'active' : ''}" href="#" role="button" data-bs-toggle="dropdown">
                        <i class="fas fa-bullhorn"></i> Marketing <i class="fas fa-chevron-down dropdown-arrow"></i>
                    </a>
                    <ul class="dropdown-menu border-0 shadow-lg mt-0">
                        <li><a class="dropdown-item py-2" href="${pageContext.request.contextPath}/staff/news"><i class="fas fa-newspaper me-2 text-muted"></i> Tin tức</a></li>
                        <li><a class="dropdown-item py-2" href="${pageContext.request.contextPath}/staff/voucher"><i class="fas fa-ticket-alt me-2 text-muted"></i> Voucher</a></li>
                        <c:if test="${sessionScope.user.roleId == 1 || sessionScope.user.roleId == 2}">
                            <li><a class="dropdown-item py-2" href="${pageContext.request.contextPath}/manager/voucher-requests"><i class="fas fa-check-double me-2 text-muted"></i> Duyệt Voucher</a></li>
                            <li><a class="dropdown-item py-2" href="${pageContext.request.contextPath}/manager/policies"><i class="fas fa-shield-alt me-2 text-muted"></i> Chính sách</a></li>
                        </c:if>
                    </ul>
                </li>

                <%-- Doi tac & CSKH: Admin, Manager, Staff --%>
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle ${param.active == 'partners' || param.active == 'suppliers' || param.active == 'feedback' ? 'active' : ''}" href="#" role="button" data-bs-toggle="dropdown">
                        <i class="fas fa-handshake"></i> Đối tác & CSKH <i class="fas fa-chevron-down dropdown-arrow"></i>
                    </a>
                    <ul class="dropdown-menu border-0 shadow-lg mt-0">
                        <c:if test="${sessionScope.user.roleId == 1 || sessionScope.user.roleId == 2}">
                            <li><a class="dropdown-item py-2" href="${pageContext.request.contextPath}/manager/suppliers"><i class="fas fa-truck me-2 text-muted"></i> Nhà cung cấp</a></li>
                        </c:if>
                        <li><a class="dropdown-item py-2" href="${pageContext.request.contextPath}/staff/feedback"><i class="fas fa-comments me-2 text-muted"></i> Phản hồi</a></li>
                    </ul>
                </li>



                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/home">
                        <i class="fas fa-home"></i> Cửa hàng
                    </a>
                </li>
            </ul>

            <div class="d-flex align-items-center gap-2">
                <%-- Role Badge --%>
                <c:choose>
                    <c:when test="${sessionScope.user.roleId == 1}">
                        <span class="role-badge admin"><i class="fas fa-crown"></i> ADMIN</span>
                    </c:when>
                    <c:when test="${sessionScope.user.roleId == 2}">
                        <span class="role-badge manager"><i class="fas fa-user-tie"></i> MGR</span>
                    </c:when>
                    <c:when test="${sessionScope.user.roleId == 3}">
                        <span class="role-badge staff"><i class="fas fa-user-shield"></i> STAFF</span>
                    </c:when>
                </c:choose>

                <%-- Profile Dropdown --%>
                <div class="dropdown">
                    <a class="user-profile dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">
                        <img src="https://ui-avatars.com/api/?name=${sessionScope.user.fullName}&background=E3000F&color=fff"
                             alt="User" class="user-avatar">
                        <span class="user-name d-none d-xxl-inline">${sessionScope.user.fullName}</span>
                    </a>
                    <ul class="dropdown-menu dropdown-menu-end shadow-lg border-0 mt-2">
                        <li><a class="dropdown-item py-2" href="${pageContext.request.contextPath}/profile"><i class="fas fa-user-circle me-2 text-muted"></i> Trang cá nhân</a></li>
                        <li><hr class="dropdown-divider"></li>
                        <li><a class="dropdown-item py-2 text-danger" href="${pageContext.request.contextPath}/logout"><i class="fas fa-sign-out-alt me-2"></i> Đăng xuất</a></li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</nav>
