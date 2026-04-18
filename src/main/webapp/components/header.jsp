<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%-- Styles are moved to assets/css/style.css --%>
<c:set var="uri" value="${pageContext.request.servletPath}" />
<c:set var="isAuthPage" value="${uri.contains('login') || uri.contains('register') || uri.contains('forgot-password') || uri.contains('resend-otp') || uri.contains('verify-register')}" />


<%-- Top info bar --%>
<c:if test="${!isAuthPage}">
<div class="bg-light py-1 border-bottom">
    <div class="container d-flex justify-content-between align-items-center">
        <small class="text-muted"><i class="fas fa-phone-alt me-1"></i> Hotline: 1900 1234</small>
        <div class="d-flex align-items-center gap-3">
            <c:choose>
                <c:when test="${not empty sessionScope.user}">
                    <small class="text-muted">
                        <i class="fas fa-user-circle me-1"></i>
                        Xin chào, <strong>${sessionScope.user.fullName}</strong>
                    </small>
                    <c:if test="${sessionScope.user.roleId == 1}">
                        <a href="${pageContext.request.contextPath}/admin/dashboard" class="text-decoration-none text-danger fw-bold small">
                            <i class="fas fa-cogs"></i> Quản trị
                        </a>
                    </c:if>
                    <a href="${pageContext.request.contextPath}/orders" class="text-decoration-none text-muted small">Đơn hàng</a>
                    <a href="${pageContext.request.contextPath}/logout" class="text-decoration-none text-muted small">Đăng xuất</a>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/login"    class="text-decoration-none text-muted small">Đăng nhập</a>
                    <a href="${pageContext.request.contextPath}/register"  class="text-decoration-none text-muted small">Đăng ký</a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>
</c:if>


<%-- Main navbar --%>
<nav class="navbar navbar-expand-lg navbar-dark bg-brand py-3">
    <div class="container">
        <a class="navbar-brand fw-bold fs-3" href="${pageContext.request.contextPath}/home">
            <i class="fas fa-leaf me-2"></i>FRESH FOOD
        </a>

        <c:if test="${!isAuthPage}">
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#mainMenu"
                aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="mainMenu">
            <%-- Search bar --%>
            <form class="d-flex mx-auto w-50 my-2 my-lg-0" action="${pageContext.request.contextPath}/products" method="GET">
                <div class="input-group">
                    <input class="form-control border-0" type="search" name="keyword"
                           placeholder="Hôm nay bạn muốn ăn gì?"
                           value="${param.keyword}">
                    <button class="btn btn-warning fw-bold px-4" type="submit">
                        <i class="fas fa-search"></i>
                    </button>
                </div>
            </form>

            <%-- Right nav items --%>
            <ul class="navbar-nav ms-auto mb-2 mb-lg-0 align-items-center gap-2">
                <%-- Wishlist --%>
                <c:if test="${not empty sessionScope.user}">
                    <li class="nav-item">
                        <a class="btn btn-outline-light border-0" href="${pageContext.request.contextPath}/wishlist"
                           title="Yêu thích">
                            <i class="fas fa-heart fs-5"></i>
                        </a>
                    </li>
                </c:if>

                <%-- Cart --%>
                <li class="nav-item">
                    <a class="btn btn-outline-light position-relative border-0"
                       href="${pageContext.request.contextPath}/cart" title="Giỏ hàng">
                        <i class="fas fa-shopping-cart fs-5"></i>
                        <c:if test="${sessionScope.cartCount > 0}">
                            <span class="cart-badge-pill">${sessionScope.cartCount}</span>
                        </c:if>
                    </a>
                </li>
            </ul>
        </div>
        </c:if>

    </div>
</nav>