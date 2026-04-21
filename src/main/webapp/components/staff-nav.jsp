<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<style>
    :root {
        --primary: #E3000F;
        --secondary: #FDB022;
        --primary-light: #FFF1F2;
        --text-main: #1E293B;
        --text-muted: #64748B;
        --card-bg: #FFFFFF;
        --nav-height: 72px;
    }

    .staff-navbar {
        background-color: var(--card-bg);
        box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.05), 0 1px 2px 0 rgba(0, 0, 0, 0.03);
        min-height: var(--nav-height);
        padding: 0 1.5rem;
        border-bottom: 1px solid #F1F5F9;
    }

    .staff-navbar .navbar-brand {
        display: flex;
        align-items: center;
        font-weight: 800;
        color: var(--primary);
        font-size: 1.3rem;
        letter-spacing: -0.5px;
        margin-right: 0.75rem;
    }

    .staff-navbar .nav-link {
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

    .staff-navbar .nav-link:hover {
        color: var(--primary);
        background-color: var(--primary-light);
    }

    .staff-navbar .nav-link.active {
        color: var(--secondary) !important;
        background-color: var(--primary-light);
    }

    .staff-navbar .nav-link.active::after {
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

    .staff-navbar .nav-link i {
        font-size: 1rem;
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
        background: #DCFCE7;
        color: #16A34A;
    }

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

<nav class="navbar navbar-expand-lg staff-navbar sticky-top">
    <div class="container-fluid px-lg-0 px-xl-2">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/staff/voucher">
            <i class="fas fa-leaf text-success me-2"></i>
            <span>FFS Staff</span>
        </a>
        
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#staffNav">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="staffNav">
            <ul class="navbar-nav me-auto align-items-center">
                <li class="nav-item">
                    <a class="nav-link ${param.active == 'orders' ? 'active' : ''}"
                       href="${pageContext.request.contextPath}/staff/orders">
                        <i class="fas fa-shopping-cart"></i> Đơn hàng
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${param.active == 'voucher' ? 'active' : ''}"
                       href="${pageContext.request.contextPath}/staff/voucher">
                        <i class="fas fa-ticket-alt"></i> Voucher
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${param.active == 'news' ? 'active' : ''}"
                       href="${pageContext.request.contextPath}/staff/news">
                        <i class="fas fa-newspaper"></i> Tin tức
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${param.active == 'feedback' ? 'active' : ''}"
                       href="${pageContext.request.contextPath}/staff/feedback">
                        <i class="fas fa-comments"></i> Phản hồi
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/home">
                        <i class="fas fa-home"></i> Cửa hàng
                    </a>
                </li>
            </ul>
            
            <div class="d-flex align-items-center gap-2">
                <span class="role-badge">
                    <i class="fas fa-user-shield"></i>
                    <c:choose>
                        <c:when test="${sessionScope.user.roleId == 2}">MGR</c:when>
                        <c:otherwise>STAFF</c:otherwise>
                    </c:choose>
                </span>

                <div class="dropdown">
                    <a class="user-profile dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">
                        <img src="https://ui-avatars.com/api/?name=${sessionScope.user.fullName}&background=E3000F&color=fff"
                             alt="User" class="user-avatar">
                        <span class="user-name d-none d-xxl-inline">${sessionScope.user.fullName}</span>
                    </a>
                    <ul class="dropdown-menu dropdown-menu-end shadow-lg border-0 mt-2">
                        <li><a class="dropdown-item py-2" href="${pageContext.request.contextPath}/profile"><i class="fas fa-user-circle me-2 text-muted"></i> Trang cá nhân</a></li>
                        <li><hr class="dropdown-divider"></li>
                        <li><a class="dropdown-item py-2 text-danger" href="${pageContext.request.contextPath}/logout">
                            <i class="fas fa-sign-out-alt me-2"></i> Đăng xuất
                        </a></li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</nav>
