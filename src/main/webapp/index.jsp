<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Fresh Food Store - Chuẩn Thịt Sạch</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <style>
        .category-item { transition: transform 0.2s; cursor: pointer; }
        .category-item:hover { transform: scale(1.05); }
        .category-icon-box { width: 80px; height: 80px; background-color: #fdf2f2; border-radius: 50%; display: flex; align-items: center; justify-content: center; margin: 0 auto; color: var(--brand-color); }
        .flash-sale-box { border: 2px solid #E3000F; border-radius: 10px; padding: 20px; background-color: #fff9f9; }
    </style>
</head>
<body class="bg-light">

    <jsp:include page="components/header.jsp" />

    <div class="container-fluid p-0">
        <img src="https://via.placeholder.com/1920x450/fdf2f2/E3000F?text=THIT+MAT+CHUAN+CHAU+AU+-+GIAM+NGAY+20%25" class="w-100 img-fluid" alt="Khuyến mãi lớn">
    </div>

    <div class="bg-white py-3 border-bottom shadow-sm mb-5">
        <div class="container">
            <div class="row text-center">
                <div class="col-md-6 mb-2 mb-md-0">
                    <h6 class="fw-bold m-0"><i class="fas fa-check-circle text-success fs-5 me-2 align-middle"></i>100% Sạch - Chuẩn VietGAP</h6>
                </div>
                <div class="col-md-6 border-start">
                    <h6 class="fw-bold m-0"><i class="fas fa-shipping-fast text-brand fs-5 me-2 align-middle"></i>Giao Hàng Thần Tốc 2H</h6>
                </div>
            </div>
        </div>
    </div>
<nav class="navbar navbar-expand-lg bg-brand shadow-sm">
    <div class="container">
        <ul class="navbar-nav mx-auto">
            <c:forEach var="c" items="${categories}">
                <li class="nav-item">
                    <a class="nav-link text-white" href="products?category=${c.categoryId}">
                        ${c.categoryName}
                    </a>
                </li>
            </c:forEach>
        </ul>
    </div>
</nav>


        <div class="flash-sale-box mb-5 shadow-sm">
            <div class="d-flex justify-content-between align-items-end mb-4 border-bottom border-danger pb-2">
                <h3 class="text-brand text-uppercase fw-bold m-0">
                    <i class="fas fa-bolt text-warning me-2"></i>Giá Sốc Hôm Nay
                </h3>
                <span class="badge bg-danger fs-6 heartbeat">Tiết kiệm tới 50%</span>
            </div>

            <div class="row g-4">
                <c:forEach var="p" items="${flashSaleProducts}">
                    <div class="col-6 col-md-4 col-lg-3">
                        <div class="card product-card h-100 bg-white position-relative">
                            <span class="position-absolute top-0 start-0 bg-danger text-white px-2 py-1 fw-bold" style="border-radius: 8px 0 8px 0; z-index: 10;">-40%</span>
                            <img src="${p.imageUrl}" class="card-img-top product-img" alt="${p.productName}">
                            <div class="card-body d-flex flex-column">
                                <h6 class="card-title fw-bold text-dark text-truncate" title="${p.productName}">${p.productName}</h6>
                                <p class="text-danger small fw-bold mb-2"><i class="fas fa-clock me-1"></i> Giao ngay trong ngày</p>
                                <div class="mt-auto mb-3">
                                    <h5 class="text-brand fw-bold mb-0">
                                        <fmt:formatNumber value="${p.basePriceAmount}" pattern="###,###" /> ₫
                                    </h5>
                                    <span class="old-price">
                                        <fmt:formatNumber value="${p.basePriceAmount * 1.66}" pattern="###,###" /> ₫
                                    </span>
                                </div>
                                <form action="" method="post">
                                    <input type="hidden" name="productId" value="${p.productId}">
                                    <button class="btn btn-brand w-100 fw-bold"><i class="fas fa-cart-plus me-1"></i> Mua ngay</button>
                                </form>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>

        <div class="d-flex justify-content-between align-items-end mb-4 border-bottom pb-2">
            <h3 class="text-uppercase fw-bold m-0">Thịt Tươi Bán Chạy</h3>
            <a href="products?type=best-seller" class="text-decoration-none text-muted fw-bold">Xem tất cả ></a>
        </div>

        <div class="row g-4">
            <c:forEach var="p" items="${bestSellerProducts}">
                <div class="col-6 col-md-4 col-lg-3">
                    <div class="card product-card h-100 bg-white">
                        <img src="${p.imageUrl}" class="card-img-top product-img" alt="${p.productName}">
                        <div class="card-body d-flex flex-column">
                            <h6 class="card-title fw-bold text-dark text-truncate" title="${p.productName}">${p.productName}</h6>
                            <p class="text-muted small mb-2"><i class="fas fa-weight-hanging me-1"></i> Khay ${p.priceBaseWeightGram}g</p>
                            <div class="mt-auto mb-3">
                                <h5 class="fw-bold mb-0 text-dark">
                                    <fmt:formatNumber value="${p.basePriceAmount}" pattern="###,###" /> ₫
                                </h5>
                            </div>
                            <form action="" method="post">
                                <input type="hidden" name="productId" value="${p.productId}">
                                <button class="btn btn-outline-danger w-100 fw-bold"><i class="fas fa-cart-plus me-1"></i> Thêm giỏ</button>
                            </form>
                        </div>
                    </div>
                </div>
            </c:forEach>
        </div>

        <!-- News Section -->
        <div class="mt-5 mb-5">
            <div class="d-flex justify-content-between align-items-end mb-4 border-bottom pb-2">
                <h3 class="text-uppercase fw-bold m-0"><i class="far fa-newspaper me-2 text-success"></i>Cảm hứng vào bếp</h3>
                <span class="text-muted small">Mẹo vặt & Tin tức mới nhất</span>
            </div>
            
            <div class="row g-4">
                <c:forEach var="n" items="${latestNews}">
                    <div class="col-md-6 col-lg-3">
                        <div class="card h-100 border-0 shadow-sm overflow-hidden news-card position-relative">
                            <div class="position-relative overflow-hidden">
                                <img src="${not empty n.imageUrl ? n.imageUrl : 'https://via.placeholder.com/400x250?text=Fresh+Food'}" 
                                     class="card-img-top news-img" alt="${n.title}" style="height: 180px; object-fit: cover;">
                                <div class="position-absolute bottom-0 start-0 bg-success text-white px-2 py-1 small" style="z-index: 2;">
                                    ${n.publishedAt.toLocalDate()}
                                </div>
                            </div>
                            <div class="card-body">
                                <h6 class="card-title fw-bold text-dark lh-base mb-2" style="display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; height: 2.8rem;">
                                    ${n.title}
                                </h6>
                                <p class="card-text text-muted small mb-3" style="display: -webkit-box; -webkit-line-clamp: 3; -webkit-box-orient: vertical; overflow: hidden; height: 3.2rem;">
                                    ${n.summary}
                                </p>
                                <a href="${pageContext.request.contextPath}/news?id=${n.newsId}" class="btn btn-link text-success p-0 fw-bold text-decoration-none small stretched-link">
                                    Xem chi tiết <i class="fas fa-arrow-right ms-1"></i>
                                </a>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>

    </div>

    <style>
        .news-card { transition: all 0.3s ease; border-radius: 12px; }
        .news-card:hover { transform: translateY(-5px); box-shadow: 0 10px 20px rgba(0,0,0,0.1) !important; }
        .news-img { transition: transform 0.5s ease; }
        .news-card:hover .news-img { transform: scale(1.1); }
        .bg-brand { background-color: #E3000F; }
        .text-brand { color: #E3000F; }
        .btn-brand { background-color: #E3000F; color: white; }
        .btn-brand:hover { background-color: #c2000d; color: white; }
    </style>

    <jsp:include page="components/footer.jsp" />

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>