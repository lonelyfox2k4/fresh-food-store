<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Fresh Food Store – Thịt Tươi Chuẩn VietGAP, Giao 2H</title>
    <meta name="description" content="Mua thịt tươi, rau củ sạch chuẩn VietGAP tại Fresh Food Store – giao hàng thần tốc 2H tại TP.HCM, đổi trả 1-1 nếu không tươi.">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <style>
        /* Hero banner */
        .hero-banner {
            background: linear-gradient(135deg, #E3000F 0%, #7b0007 100%);
            color: #fff;
            padding: 72px 0;
        }
        .hero-banner h1 { font-size: 2.8rem; font-weight: 800; line-height: 1.2; }
        .hero-banner .highlight { color: #ffc107; }

        /* Category nav pills */
        .cat-nav { background: #fff; border-bottom: 2px solid #f0f0f0; }
        .cat-nav .nav-link { color: #333; font-weight: 600; padding: 10px 18px; border-radius: 0; }
        .cat-nav .nav-link:hover { color: #E3000F; border-bottom: 2px solid #E3000F; }

        /* Flash sale section */
        .flash-sale-section { background: linear-gradient(135deg, #fff9f9, #fff); }
        .flash-header { border-left: 5px solid #E3000F; padding-left: 12px; }

        /* Trust bar */
        .trust-bar { background: #E3000F; color: #fff; }
        .trust-bar .trust-item { padding: 16px 0; }
        .trust-bar i { font-size: 1.5rem; }
    </style>
</head>
<body>
<jsp:include page="components/header.jsp"/>
<div class="container mt-3">
    <c:if test="${not empty cartSuccessMsg}">
        <div class="alert alert-success mb-0">${cartSuccessMsg}</div>
    </c:if>
    <c:if test="${not empty cartErrorMsg}">
        <div class="alert alert-danger mb-0">${cartErrorMsg}</div>
    </c:if>
    <c:if test="${not empty wishlistSuccessMsg}">
        <div class="alert alert-success mb-0 mt-2">${wishlistSuccessMsg}</div>
    </c:if>
    <c:if test="${not empty wishlistErrorMsg}">
        <div class="alert alert-danger mb-0 mt-2">${wishlistErrorMsg}</div>
    </c:if>
</div>

<%-- ══ Hero Banner ══════════════════════════════════════════════════════ --%>
<section class="hero-banner">
    <div class="container">
        <div class="row align-items-center g-4">
            <div class="col-lg-6">
                <p class="text-warning fw-bold mb-2 text-uppercase small letter-spacing-2">
                    <i class="fas fa-leaf me-1"></i> 100% tươi ngon – chuẩn VietGAP
                </p>
                <h1>Thịt Tươi Sạch <br><span class="highlight">Giá Tốt Mỗi Ngày</span></h1>
                <p class="mt-3 mb-4 fs-5" style="opacity:.9;">
                    Giao hàng thần tốc 2 giờ. Kiểm tra hàng trước khi trả tiền.
                </p>
                <div class="d-flex gap-3 flex-wrap">
                    <a href="${pageContext.request.contextPath}/products"
                       class="btn btn-warning btn-lg fw-bold px-4">
                        <i class="fas fa-shopping-bag me-2"></i>Mua sắm ngay
                    </a>
                    <a href="${pageContext.request.contextPath}/products"
                       class="btn btn-outline-light btn-lg fw-bold px-4">
                        Xem tất cả sản phẩm
                    </a>
                </div>
            </div>
            <div class="col-lg-6 text-center d-none d-lg-block">
                <img src="https://via.placeholder.com/520x320/fff/E3000F?text=🥩+Fresh+Food+Store"
                     class="img-fluid rounded-4 shadow-lg" alt="Fresh Food">
            </div>
        </div>
    </div>
</section>

<%-- ══ Trust bar ════════════════════════════════════════════════════════ --%>
<div class="trust-bar">
    <div class="container">
        <div class="row text-center">
            <div class="col-4 trust-item">
                <i class="fas fa-check-circle d-block mb-1"></i>
                <span class="fw-semibold small">100% Sạch VietGAP</span>
            </div>
            <div class="col-4 trust-item border-start border-end" style="border-color:rgba(255,255,255,.3)!important;">
                <i class="fas fa-shipping-fast d-block mb-1"></i>
                <span class="fw-semibold small">Giao Hàng 2H</span>
            </div>
            <div class="col-4 trust-item">
                <i class="fas fa-exchange-alt d-block mb-1"></i>
                <span class="fw-semibold small">Đổi Trả 1-1</span>
            </div>
        </div>
    </div>
</div>

<%-- ══ Category quick nav ═══════════════════════════════════════════════ --%>
<c:if test="${not empty categories}">
    <nav class="cat-nav shadow-sm">
        <div class="container">
            <ul class="nav justify-content-center flex-wrap">
                <li class="nav-item">
                    <a class="nav-link fw-bold" href="${pageContext.request.contextPath}/products">
                        <i class="fas fa-th-large me-1"></i>Tất cả
                    </a>
                </li>
                <c:forEach var="cat" items="${categories}">
                    <li class="nav-item">
                        <a class="nav-link"
                           href="${pageContext.request.contextPath}/products?category=${cat.categoryId}">
                            ${cat.categoryName}
                        </a>
                    </li>
                </c:forEach>
            </ul>
        </div>
    </nav>
</c:if>

<%-- ══ Flash Sale section ════════════════════════════════════════════════ --%>
<c:if test="${not empty flashSaleProducts}">
    <section class="flash-sale-section py-5">
        <div class="container">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div class="flash-header">
                    <h2 class="fw-bold text-brand mb-0">
                        <i class="fas fa-bolt text-warning me-2"></i>Giá Sốc Hôm Nay
                    </h2>
                    <small class="text-muted">Hàng giảm giá theo hạn sử dụng — còn tươi, giá tốt!</small>
                </div>
                <a href="${pageContext.request.contextPath}/products"
                   class="btn btn-outline-danger fw-bold">
                    Xem tất cả <i class="fas fa-chevron-right ms-1"></i>
                </a>
            </div>

            <div class="row g-4">
                <c:forEach var="p" items="${flashSaleProducts}">
                    <div class="col-6 col-md-4 col-lg-3">
                        <div class="card product-card h-100 position-relative">
                            <span class="badge-flash position-absolute" style="left:0;top:0;z-index:10;">
                                <i class="fas fa-bolt me-1"></i>Giá sốc
                            </span>
                            <a href="${pageContext.request.contextPath}/product-detail?id=${p.productId}">
                                <img src="${not empty p.imageUrl ? p.imageUrl : 'https://via.placeholder.com/400x300/fdf2f2/E3000F?text=Fresh+Food'}"
                                     class="card-img-top product-img" alt="${p.productName}">
                            </a>
                            <div class="card-body d-flex flex-column">
                                <a href="${pageContext.request.contextPath}/product-detail?id=${p.productId}"
                                   class="text-decoration-none text-dark">
                                    <h6 class="card-title fw-bold text-truncate mb-1"
                                        title="${p.productName}">${p.productName}</h6>
                                </a>
                                <small class="text-muted mb-2">
                                    <i class="fas fa-clock me-1 text-danger"></i>Giao ngay trong ngày
                                </small>
                                <div class="mt-auto">
                                    <div class="price-main mb-1">
                                        <fmt:formatNumber value="${p.basePriceAmount}" pattern="###,###"/> ₫
                                    </div>
                                    <div class="d-grid gap-2">
                                        <a href="${pageContext.request.contextPath}/product-detail?id=${p.productId}"
                                           class="btn btn-outline-secondary w-100 fw-bold">
                                            <i class="fas fa-eye me-1"></i>Xem chi tiết
                                        </a>
                                        <form method="post" action="${pageContext.request.contextPath}/cart/add">
                                            <input type="hidden" name="productId" value="${p.productId}">
                                            <input type="hidden" name="quantity" value="1">
                                            <input type="hidden" name="returnUrl" value="${pageContext.request.contextPath}/home">
                                            <button type="submit" class="btn btn-brand w-100 fw-bold">
                                                <i class="fas fa-cart-plus me-1"></i>Thêm giỏ
                                            </button>
                                        </form>
                                        <form method="post" action="${pageContext.request.contextPath}/wishlist/add">
                                            <input type="hidden" name="productId" value="${p.productId}">
                                            <input type="hidden" name="returnUrl" value="${pageContext.request.contextPath}/home">
                                            <button type="submit" class="btn w-100 fw-bold ${not empty wishedProductIds and wishedProductIds.contains(p.productId) ? 'btn-danger' : 'btn-outline-danger'}">
                                                <i class="fas fa-heart me-1"></i>
                                                ${not empty wishedProductIds and wishedProductIds.contains(p.productId) ? 'Bỏ thích' : 'Yêu thích'}
                                            </button>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </section>
</c:if>

<%-- ══ Best Sellers ══════════════════════════════════════════════════════ --%>
<c:if test="${not empty bestSellerProducts}">
    <section class="py-5 bg-white">
        <div class="container">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div class="flash-header">
                    <h2 class="fw-bold mb-0">
                        <i class="fas fa-fire text-brand me-2"></i>Thịt Tươi Bán Chạy
                    </h2>
                    <small class="text-muted">Được khách hàng tin dùng nhiều nhất</small>
                </div>
                <a href="${pageContext.request.contextPath}/products"
                   class="btn btn-outline-secondary fw-bold">
                    Xem tất cả <i class="fas fa-chevron-right ms-1"></i>
                </a>
            </div>

            <div class="row g-4">
                <c:forEach var="p" items="${bestSellerProducts}">
                    <div class="col-6 col-md-4 col-lg-3">
                        <div class="card product-card h-100">
                            <a href="${pageContext.request.contextPath}/product-detail?id=${p.productId}">
                                <img src="${not empty p.imageUrl ? p.imageUrl : 'https://via.placeholder.com/400x300/fdf2f2/E3000F?text=Fresh+Food'}"
                                     class="card-img-top product-img" alt="${p.productName}">
                            </a>
                            <div class="card-body d-flex flex-column">
                                <a href="${pageContext.request.contextPath}/product-detail?id=${p.productId}"
                                   class="text-decoration-none text-dark">
                                    <h6 class="card-title fw-bold text-truncate mb-1"
                                        title="${p.productName}">${p.productName}</h6>
                                </a>
                                <small class="text-muted mb-2">
                                    <i class="fas fa-weight-hanging me-1"></i>Giá / ${p.priceBaseWeightGram}g
                                </small>
                                <div class="mt-auto">
                                    <div class="price-main mb-1">
                                        <fmt:formatNumber value="${p.basePriceAmount}" pattern="###,###"/> ₫
                                    </div>
                                    <div class="d-grid gap-2">
                                        <form method="post" action="${pageContext.request.contextPath}/cart/add">
                                            <input type="hidden" name="productId" value="${p.productId}">
                                            <input type="hidden" name="quantity" value="1">
                                            <input type="hidden" name="returnUrl" value="${pageContext.request.contextPath}/home">
                                            <button type="submit" class="btn btn-outline-danger w-100 fw-bold">
                                                <i class="fas fa-cart-plus me-1"></i>Thêm giỏ
                                            </button>
                                        </form>
                                        <form method="post" action="${pageContext.request.contextPath}/wishlist/add">
                                            <input type="hidden" name="productId" value="${p.productId}">
                                            <input type="hidden" name="returnUrl" value="${pageContext.request.contextPath}/home">
                                            <button type="submit" class="btn w-100 fw-bold ${not empty wishedProductIds and wishedProductIds.contains(p.productId) ? 'btn-danger' : 'btn-outline-danger'}">
                                                <i class="fas fa-heart me-1"></i>
                                                ${not empty wishedProductIds and wishedProductIds.contains(p.productId) ? 'Bỏ thích' : 'Yêu thích'}
                                            </button>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </section>
</c:if>

<%-- ══ Why choose us ════════════════════════════════════════════════════ --%>
<section class="py-5 bg-light">
    <div class="container text-center">
        <h2 class="fw-bold mb-4">Tại sao chọn <span class="text-brand">Fresh Food?</span></h2>
        <div class="row g-4">
            <div class="col-md-3">
                <div class="p-4 bg-white rounded-3 shadow-sm h-100">
                    <i class="fas fa-leaf fa-2x text-success mb-3"></i>
                    <h6 class="fw-bold">100% Thịt Sạch</h6>
                    <p class="text-muted small mb-0">Kiểm định chất lượng nghiêm ngặt, đạt chuẩn VietGAP & GlobalGAP.</p>
                </div>
            </div>
            <div class="col-md-3">
                <div class="p-4 bg-white rounded-3 shadow-sm h-100">
                    <i class="fas fa-thermometer-half fa-2x text-brand mb-3"></i>
                    <h6 class="fw-bold">Bảo Quản Lạnh</h6>
                    <p class="text-muted small mb-0">Vận chuyển với xe lạnh 0–4°C, đảm bảo độ tươi ngon tới tay bạn.</p>
                </div>
            </div>
            <div class="col-md-3">
                <div class="p-4 bg-white rounded-3 shadow-sm h-100">
                    <i class="fas fa-bolt fa-2x text-warning mb-3"></i>
                    <h6 class="fw-bold">Giá Sốc Hàng Ngày</h6>
                    <p class="text-muted small mb-0">Sản phẩm sắp HSD giảm giá sâu — ăn tiết kiệm mà vẫn tươi ngon.</p>
                </div>
            </div>
            <div class="col-md-3">
                <div class="p-4 bg-white rounded-3 shadow-sm h-100">
                    <i class="fas fa-headset fa-2x text-primary mb-3"></i>
                    <h6 class="fw-bold">Hỗ Trợ 24/7</h6>
                    <p class="text-muted small mb-0">Đội ngũ CSKH luôn sẵn sàng hỗ trợ bạn qua hotline 1900 1234.</p>
                </div>
            </div>
        </div>
    </div>
</section>

<jsp:include page="components/footer.jsp"/>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
