<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<style>
    :root {
        --primary: #E3000F;
        --primary-light: #fff0f0;
        --text-muted: #64748b;
        --card-bg: #FFFFFF;
    }
    .admin-navbar {
        background-color: var(--card-bg);
        box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
        padding: 0.75rem 1rem;
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
        padding: 0.5rem 0.6rem !important;
        font-size: 0.9rem;
        border-radius: 0.5rem;
        margin: 0 0.1rem;
        white-space: nowrap;
    }
    .admin-navbar .nav-link:hover, .admin-navbar .nav-link.active {
        color: var(--primary);
        background-color: var(--primary-light);
    }
    .role-badge {
        font-size: 0.72rem;
        font-weight: 700;
        padding: 0.25rem 0.6rem;
        border-radius: 20px;
        letter-spacing: 0.5px;
        text-transform: uppercase;
    }
    .role-badge.admin   { background: #fee2e2; color: #E3000F; }
    .role-badge.manager { background: #e0f2fe; color: #0284c7; }
</style>
<nav class="navbar navbar-expand-lg admin-navbar sticky-top">
    <div class="container-fluid px-4">
        <a class="navbar-brand" href="${pageContext.request.contextPath}${sessionScope.user.roleId == 1 ? '/admin/dashboard' : '/manager/products'}">
            <i class="fas fa-leaf text-success me-2"></i>FFS ${sessionScope.user.roleId == 1 ? 'Admin' : 'Manager'}
        </a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#adminNav">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="adminNav">
            <ul class="navbar-nav me-auto mb-2 mb-lg-0">

                <%-- Dashboard & Nguoi dung: CHI Admin (roleId=1) --%>
                <c:if test="${sessionScope.user.roleId == 1}">
                    <li class="nav-item">
                        <a class="nav-link ${param.active == 'dashboard' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/dashboard">
                            <i class="fas fa-chart-line me-1"></i> Dashboard
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link ${param.active == 'users' ? 'active' : ''}" href="${pageContext.request.contextPath}/admin/users">
                            <i class="fas fa-users-cog me-1"></i> Nguoi dung
                        </a>
                    </li>
                </c:if>

                <%-- Ban Hang: Admin & Manager --%>
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">
                        <i class="fas fa-box-open me-1"></i> Bán hàng
                    </a>
                    <ul class="dropdown-menu border-0 shadow-sm">
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/manager/categories"><i class="fas fa-tags me-2 text-muted"></i> Danh mục</a></li>
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/manager/products"><i class="fas fa-boxes me-2 text-muted"></i> Sản phẩm</a></li>
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/manager/inventory-pricing"><i class="fas fa-money-bill-wave me-2 text-muted"></i> Bảng giá</a></li>
                    </ul>
                </li>

                <%-- Marketing: Admin & Manager --%>
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">
                        <i class="fas fa-bullhorn me-1"></i> Marketing
                    </a>
                    <ul class="dropdown-menu border-0 shadow-sm">
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/staff/news"><i class="fas fa-newspaper me-2 text-muted"></i> Tin tức</a></li>
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/staff/voucher"><i class="fas fa-ticket-alt me-2 text-muted"></i> Mã giảm giá</a></li>
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/manager/policies"><i class="fas fa-shield-alt me-2 text-muted"></i> Chính sách</a></li>
                    </ul>
                </li>

                <%-- Doi tac & CSKH: Admin & Manager --%>
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">
                        <i class="fas fa-handshake me-1"></i> Đối tác &amp; CSKH
                    </a>
                    <ul class="dropdown-menu border-0 shadow-sm">
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/manager/suppliers"><i class="fas fa-truck me-2 text-muted"></i> Nhà cung cấp</a></li>
                        <li><a class="dropdown-item" href="${pageContext.request.contextPath}/staff/feedback"><i class="fas fa-comments me-2 text-muted"></i> Phản hồi</a></li>
                    </ul>
                </li>

                <li class="nav-item">
                    <a class="nav-link" href="${pageContext.request.contextPath}/home">
                        <i class="fas fa-home me-1"></i> Cửa hàng
                    </a>
                </li>
            </ul>

            <div class="d-flex align-items-center gap-2">
                <%-- Badge vai tro --%>
                <c:choose>
                    <c:when test="${sessionScope.user.roleId == 1}">
                        <span class="role-badge admin"><i class="fas fa-crown me-1"></i>Admin</span>
                    </c:when>
                    <c:otherwise>
                        <span class="role-badge manager"><i class="fas fa-briefcase me-1"></i>Manager</span>
                    </c:otherwise>
                </c:choose>

                <div class="dropdown">
                    <a class="nav-link dropdown-toggle d-flex align-items-center" href="#" role="button" data-bs-toggle="dropdown">
                        <img src="https://ui-avatars.com/api/?name=${sessionScope.user.fullName}&background=E3000F&color=fff"
                             alt="User" class="rounded-circle me-1" width="32" height="32">
                        <span class="fw-semibold d-none d-xl-inline">${sessionScope.user.fullName}</span>
                    </a>
                    <ul class="dropdown-menu dropdown-menu-end shadow-sm border-0 mt-2">
                        <li><a class="dropdown-item text-danger" href="${pageContext.request.contextPath}/logout"><i class="fas fa-sign-out-alt me-2"></i> Đăng xuất</a></li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
</nav>
