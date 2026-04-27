<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<style>
    :root {
        --shipper-primary: #0d6efd;
        --nav-height: 70px;
    }
    .shipper-navbar {
        background-color: var(--shipper-primary);
        box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
        min-height: var(--nav-height);
    }
    .shipper-navbar .navbar-brand {
        display: flex;
        align-items: center;
        font-weight: 800;
        color: #ffffff;
        font-size: 1.3rem;
        letter-spacing: -0.5px;
    }
    .shipper-navbar .navbar-brand:hover {
        color: #f8f9fa;
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
    .role-badge.shipper { 
        background: rgba(255, 255, 255, 0.2); 
        color: #ffffff; 
        border: 1px solid rgba(255,255,255,0.3); 
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
        color: #ffffff;
    }
    .user-profile:hover {
        background-color: rgba(255, 255, 255, 0.1);
        color: #ffffff;
    }
    .user-profile::after {
        display: none !important; /* Hide dropdown toggle arrow */
    }
    .user-avatar {
        width: 36px;
        height: 36px;
        border-radius: 50%;
        object-fit: cover;
        border: 2px solid rgba(255, 255, 255, 0.8);
    }
    .user-name {
        font-weight: 600;
        font-size: 0.9rem;
        max-width: 140px;
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
    }
    .dropdown-menu {
        border-radius: 0.5rem;
    }
</style>

<nav class="navbar navbar-expand-lg shipper-navbar sticky-top mb-4 z-3">
    <div class="container d-flex align-items-center">
        <a class="navbar-brand me-4" href="${pageContext.request.contextPath}/shipper/orders">
            <i class="bi bi-truck me-2"></i>Shipper Panel
        </a>
        
        <c:if test="${param.showBack == 'true'}">
            <a href="${pageContext.request.contextPath}/shipper/orders" class="btn btn-sm btn-outline-light rounded-pill px-3 fw-medium">
                <i class="bi bi-chevron-left"></i> Quay lại
            </a>
        </c:if>
        
        <div class="d-flex align-items-center gap-3 ms-auto">
            <span class="role-badge shipper d-none d-sm-flex"><i class="bi bi-box-seam"></i> SHIPPER</span>

            <div class="dropdown">
                <a class="user-profile dropdown-toggle" href="javascript:void(0)" id="shipperProfileDrop" role="button" data-bs-toggle="dropdown" aria-expanded="false">
                    <img src="https://ui-avatars.com/api/?name=${sessionScope.user.fullName}&background=ffffff&color=0d6efd"
                         alt="User" class="user-avatar">
                    <span class="user-name d-none d-sm-inline">${sessionScope.user.fullName}</span>
                </a>
                <ul class="dropdown-menu dropdown-menu-end shadow-lg border-0 mt-2" aria-labelledby="shipperProfileDrop">
                    <li>
                        <a class="dropdown-item py-2" href="${pageContext.request.contextPath}/profile">
                            <i class="bi bi-person-circle me-2 text-muted"></i> Trang cá nhân
                        </a>
                    </li>
                    <li><hr class="dropdown-divider"></li>
                    <li>
                        <a class="dropdown-item py-2 text-danger fw-medium" href="${pageContext.request.contextPath}/logout">
                            <i class="bi bi-box-arrow-right me-2"></i> Đăng xuất
                        </a>
                    </li>
                </ul>
            </div>
        </div>
    </div>
</nav>
<jsp:include page="toast-notifier.jsp" />
