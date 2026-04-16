<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<style>
    .bg-brand { background-color: #E3000F !important; }
    .text-brand { color: #E3000F !important; }
    .nav-link { font-weight: 500; }
    .nav-link:hover { color: #f8d7da !important; }
</style>

<div class="bg-light py-1 border-bottom">
    <div class="container d-flex justify-content-between align-items-center">
        <small class="text-muted"><i class="fas fa-phone-alt me-1"></i> Hotline: 1900 1234</small>
        <div>
            <a href="login" class="text-decoration-none text-muted small me-3">Đăng nhập</a>
            <a href="register" class="text-decoration-none text-muted small">Đăng ký</a>
        </div>
    </div>
</div>

<nav class="navbar navbar-expand-lg navbar-dark bg-brand py-3">
    <div class="container">
        <a class="navbar-brand fw-bold fs-3" href="home">
            <i class="fas fa-leaf me-2"></i>FRESH FOOD
        </a>

        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#mainMenu">
            <span class="navbar-toggler-icon"></span>
        </button>

        <div class="collapse navbar-collapse" id="mainMenu">
            <form class="d-flex mx-auto w-50 my-2 my-lg-0" action="products" method="GET">
                <div class="input-group">
                    <input class="form-control border-0" type="search" name="keyword" placeholder="Hôm nay bạn muốn ăn gì?">
                    <button class="btn btn-warning fw-bold px-4" type="submit">
                        <i class="fas fa-search"></i>
                    </button>
                </div>
            </form>

            <ul class="navbar-nav ms-auto mb-2 mb-lg-0 align-items-center">
                <ul class="navbar-nav ms-auto mb-2 mb-lg-0 align-items-center">


                    <li class="nav-item ms-3">
                        ...
                    </li>
                </ul>
                <li class="nav-item ms-3">
                    <a class="btn btn-outline-light position-relative border-0" href="cart">
                        <i class="fas fa-shopping-cart fs-5"></i>
                        <span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-warning text-dark">
                            3
                        </span>
                    </a>
                </li>
            </ul>
        </div>
    </div>
</nav>