<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.util.Collections" prefix="fn" %>
<div class="col-auto col-md-3 col-xl-2 px-sm-2 px-0 bg-white shadow-sm sidebar" style="min-height: 100vh;">
    <div class="d-flex flex-column align-items-center align-items-sm-start px-3 pt-2 text-white min-vh-100 sticky-top">
        <a href="${pageContext.request.contextPath}/shipper/orders" class="d-flex align-items-center pb-4 mb-md-0 me-md-auto text-decoration-none border-bottom w-100 mt-3">
            <span class="fs-5 d-none d-sm-inline fw-bold text-success"><i class="bi bi-leaf me-2"></i>Shipper Panel</span>
        </a>
        <ul class="nav nav-pills flex-column mb-sm-auto mb-0 align-items-center align-items-sm-start w-100 mt-4" id="menu">
            <li class="nav-item w-100 mb-2">
                <a href="${pageContext.request.contextPath}/shipper/orders" class="nav-link align-middle px-3 py-2 rounded-3 ${param.active == 'dashboard' ? 'active bg-success' : 'text-dark hover-bg-light'}">
                    <i class="fs-4 bi bi-speedometer2"></i> <span class="ms-2 d-none d-sm-inline fw-medium">Bảng điều khiển</span>
                </a>
            </li>
            <li class="nav-item w-100 mb-2">
                <a href="${pageContext.request.contextPath}/shipper/orders?action=list" class="nav-link px-3 py-2 rounded-3 ${param.active == 'orders' ? 'active bg-success' : 'text-dark hover-bg-light'}">
                    <i class="fs-4 bi bi-box-seam"></i> <span class="ms-2 d-none d-sm-inline fw-medium">Đơn hàng hiện có</span>
                </a>
            </li>
            <li class="nav-item w-100 mb-2">
                <a href="${pageContext.request.contextPath}/profile" class="nav-link px-3 py-2 rounded-3 ${param.active == 'profile' ? 'active bg-success' : 'text-dark hover-bg-light'}">
                    <i class="fs-4 bi bi-person-badge"></i> <span class="ms-2 d-none d-sm-inline fw-medium">Cá nhân</span>
                </a>
            </li>
            <li class="nav-item w-100 mb-2">
                <a href="${pageContext.request.contextPath}/logout" class="nav-link px-3 py-2 rounded-3 text-danger hover-bg-danger-light">
                    <i class="fs-4 bi bi-box-arrow-right"></i> <span class="ms-2 d-none d-sm-inline fw-medium">Đăng xuất</span>
                </a>
            </li>
        </ul>
        <hr>
        <div class="dropdown pb-4 w-100 border-top pt-4">
            <a href="#" class="d-flex align-items-center text-dark text-decoration-none dropdown-toggle" id="dropdownUser1" data-bs-toggle="dropdown" aria-expanded="false">
                <img src="https://ui-avatars.com/api/?name=${sessionScope.user.fullName}&background=198754&color=fff" alt="hugenerd" width="30" height="30" class="rounded-circle">
                <span class="d-none d-sm-inline mx-1 ms-2 fw-semibold">${sessionScope.user.fullName}</span>
            </a>
            <ul class="dropdown-menu dropdown-menu-light text-small shadow" aria-labelledby="dropdownUser1">
                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/profile">Hồ sơ</a></li>
                <li><hr class="dropdown-divider"></li>
                <li><a class="dropdown-item" href="${pageContext.request.contextPath}/logout">Đăng xuất</a></li>
            </ul>
        </div>
    </div>
</div>

<style>
    .hover-bg-light:hover { background-color: #f8f9fa; }
    .hover-bg-danger-light:hover { background-color: #fff5f5; }
    .nav-link.active { box-shadow: 0 4px 12px rgba(25, 135, 84, 0.2); }
    .sidebar { border-right: 1px solid #dee2e6; }
</style>
