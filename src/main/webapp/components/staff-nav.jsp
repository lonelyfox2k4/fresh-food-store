<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<style>
    :root {
        --staff-primary: #0d6efd;
        --staff-primary-light: #e8f0fe;
        --text-muted: #64748b;
        --card-bg: #FFFFFF;
    }
    .staff-navbar {
        background-color: var(--card-bg);
        box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.07);
        padding: 0.75rem 1rem;
        margin-bottom: 2rem;
    }
    .staff-navbar .navbar-brand {
        font-weight: 700;
        color: var(--staff-primary);
        font-size: 1.4rem;
        letter-spacing: -0.5px;
    }
    .staff-navbar .nav-link {
        font-weight: 500;
        color: var(--text-muted);
        transition: all 0.3s ease;
        padding: 0.5rem 0.8rem !important;
        font-size: 0.9rem;
        border-radius: 0.5rem;
        margin: 0 0.1rem;
        white-space: nowrap;
    }
    .staff-navbar .nav-link:hover,
    .staff-navbar .nav-link.active {
        color: var(--staff-primary);
        background-color: var(--staff-primary-light);
    }
    .role-badge {
        font-size: 0.72rem;
        font-weight: 700;
        padding: 0.25rem 0.6rem;
        border-radius: 20px;
        background: var(--staff-primary-light);
        color: var(--staff-primary);
        letter-spacing: 0.5px;
        text-transform: uppercase;
    }
</style>
<nav class="navbar navbar-expand-lg staff-navbar sticky-top">
    <div class="container-fluid px-4">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/staff/voucher">
            <i class="fas fa-leaf text-success me-2"></i>FFS Staff
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#staffNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="staffNav">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                <li class="nav-item">
                    <a class="nav-link ${param.active == 'voucher' ? 'active' : ''}"
                       href="${pageContext.request.contextPath}/staff/voucher">
                        <i class="fas fa-ticket-alt me-1"></i> Mã giảm giá
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${param.active == 'news' ? 'active' : ''}"
                       href="${pageContext.request.contextPath}/staff/news">
                        <i class="fas fa-newspaper me-1"></i> Tin tức
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link ${param.active == 'feedback' ? 'active' : ''}"
                       href="${pageContext.request.contextPath}/staff/feedback">
                        <i class="fas fa-comments me-1"></i> Phản hồi
                    </a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/home">
                        <i class="fas fa-home me-1"></i> Cửa hàng
                    </a>
                </li>
            </ul>
            <div class="d-flex align-items-center gap-2">
                <span class="role-badge">
                    <i class="fas fa-user-tag me-1"></i>
                    <c:choose>
                        <c:when test="${sessionScope.user.roleId == 2}">Manager</c:when>
                        <c:otherwise>Staff</c:otherwise>
                    </c:choose>
                </span>
                <div class="dropdown ms-2">
                    <a class="nav-link dropdown-toggle d-flex align-items-center" href="#"
                       role="button" data-bs-toggle="dropdown">
                        <img src="https://ui-avatars.com/api/?name=${sessionScope.user.fullName}&background=0d6efd&color=fff"
                             alt="User" class="rounded-circle me-1" width="32" height="32">
                        <span class="fw-semibold d-none d-xl-inline" style="color: #1e293b;">
                            ${sessionScope.user.fullName}
                        </span>
                    </a>
                    <ul class="dropdown-menu dropdown-menu-end shadow-sm border-0 mt-2">
                        <li>
                            <a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/logout">
                                <i class="fas fa-sign-out-alt me-2"></i> Đăng xuất
                            </a>
                        </li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</nav>
