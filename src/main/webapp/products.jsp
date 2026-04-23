<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sản phẩm – Fresh Food Store</title>
    <meta name="description" content="Mua thịt tươi, rau củ sạch chuẩn VietGAP tại Fresh Food Store – giao hàng nhanh 2H tại TP.HCM">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>

<jsp:include page="components/header.jsp"/>

<div class="container my-5">
    <div class="row g-4">

        <%-- ══ Sidebar filter ══════════════════════════════════════════════ --%>
        <div class="col-lg-3">
            <div class="filter-sidebar sticky-top" style="top: 20px;">
                <h5 class="fw-bold mb-3"><i class="fas fa-filter me-2 text-brand"></i>Lọc sản phẩm</h5>

                <form method="GET" action="${pageContext.request.contextPath}/products" id="filterForm">
                    <%-- Hidden keyword from search bar --%>
                    <input type="hidden" name="keyword" value="${keyword}">

                    <p class="fw-semibold mb-2 text-muted small text-uppercase">Danh mục</p>
                    <div class="form-check mb-1">
                        <input class="form-check-input" type="radio" name="category" id="catAll"
                               value="" onchange="this.form.submit()"
                               ${selectedCatId == null ? 'checked' : ''}>
                        <label class="form-check-label" for="catAll">Tất cả</label>
                    </div>
                    <c:forEach var="cat" items="${categories}">
                        <div class="form-check mb-1">
                            <input class="form-check-input" type="radio" name="category"
                                   id="cat${cat.categoryId}" value="${cat.categoryId}"
                                   onchange="this.form.submit()"
                                   ${selectedCatId == cat.categoryId ? 'checked' : ''}>
                            <label class="form-check-label" for="cat${cat.categoryId}">
                                ${cat.categoryName}
                            </label>
                        </div>
                    </c:forEach>
                </form>

                <%-- Search inside sidebar --%>
                <hr>
                <p class="fw-semibold mb-2 text-muted small text-uppercase">Tìm kiếm</p>
                <form method="GET" action="${pageContext.request.contextPath}/products">
                    <c:if test="${selectedCatId != null}">
                        <input type="hidden" name="category" value="${selectedCatId}">
                    </c:if>
                    <div class="input-group input-group-sm">
                        <input type="text" name="keyword" class="form-control"
                               placeholder="Nhập tên sản phẩm..." value="${keyword}">
                        <button class="btn btn-brand" type="submit"><i class="fas fa-search"></i></button>
                    </div>
                </form>
            </div>
        </div>

        <%-- ══ Product grid ════════════════════════════════════════════════ --%>
        <div class="col-lg-9">
            <%-- Breadcrumb + result count --%>
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h1 class="h4 fw-bold mb-0">
                        <c:choose>
                            <c:when test="${not empty keyword}">Kết quả tìm kiếm: "${keyword}"</c:when>
                            <c:otherwise>Tất cả sản phẩm</c:otherwise>
                        </c:choose>
                    </h1>
                    <small class="text-muted">Tìm thấy ${totalCount} sản phẩm</small>
                </div>
            </div>

            <c:choose>
                <c:when test="${empty products}">
                    <div class="text-center py-5">
                        <i class="fas fa-box-open fa-4x text-muted mb-3"></i>
                        <p class="text-muted fs-5">Không tìm thấy sản phẩm phù hợp.</p>
                        <a href="${pageContext.request.contextPath}/products" class="btn btn-brand">
                            Xem tất cả sản phẩm
                        </a>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="row g-4">
                        <c:forEach var="p" items="${products}">
                            <div class="col-sm-6 col-xl-4">
                                <div class="card product-card h-100 position-relative">
                                    <%-- Flash badge --%>
                                    <c:if test="${p.expiryPricingPolicyId != null}">
                                        <span class="badge-flash position-absolute" style="left:0;top:0;z-index:10;">
                                            <i class="fas fa-bolt me-1"></i>Giá sốc
                                        </span>
                                    </c:if>

                                    <%-- Wishlist button --%>
                                    <c:if test="${not empty sessionScope.user}">
                                        <form action="${pageContext.request.contextPath}/wishlist/toggle" method="post"
                                              class="position-absolute" style="right:8px;top:8px;z-index:10;">
                                            <input type="hidden" name="productId" value="${p.productId}">
                                            <input type="hidden" name="redirect"
                                                   value="${pageContext.request.contextPath}/products?keyword=${keyword}&amp;category=${selectedCatId}&amp;page=${currentPage}">
                                            <button class="btn btn-sm btn-light rounded-circle shadow-sm border-0"
                                                    title="Yêu thích">
                                                <i class="fas fa-heart text-brand"></i>
                                            </button>
                                        </form>
                                    </c:if>

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
                                            <i class="fas fa-weight-hanging me-1"></i>
                                            Giá gốc / ${p.priceBaseWeightGram}g
                                        </small>
                                        <div class="mt-auto">
                                            <div class="price-main mb-2">
                                                <c:choose>
                                                    <c:when test="${not empty p.currentPrice and p.currentPrice lt p.basePriceAmount}">
                                                        <span class="text-danger fw-bold fs-5">
                                                            <fmt:formatNumber value="${p.currentPrice}" pattern="###,###"/> ₫
                                                        </span>
                                                        <span class="text-muted text-decoration-line-through small ms-1">
                                                            <fmt:formatNumber value="${p.basePriceAmount}" pattern="###,###"/> ₫
                                                        </span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="fw-bold fs-5">
                                                            <fmt:formatNumber value="${p.basePriceAmount}" pattern="###,###"/> ₫
                                                        </span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                            <a href="${pageContext.request.contextPath}/product-detail?id=${p.productId}"
                                               class="btn btn-brand w-100 fw-bold">
                                                <i class="fas fa-eye me-1"></i> Xem chi tiết
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>

                    <%-- Pagination --%>
                    <c:if test="${totalPages > 1}">
                        <nav class="mt-5 d-flex justify-content-center">
                            <ul class="pagination">
                                <c:if test="${currentPage > 1}">
                                    <li class="page-item">
                                        <a class="page-link" href="?keyword=${keyword}&category=${selectedCatId}&page=${currentPage-1}">
                                            <i class="fas fa-chevron-left"></i>
                                        </a>
                                    </li>
                                </c:if>
                                <c:forEach begin="1" end="${totalPages}" var="i">
                                    <li class="page-item ${i == currentPage ? 'active' : ''}">
                                        <a class="page-link" href="?keyword=${keyword}&category=${selectedCatId}&page=${i}">${i}</a>
                                    </li>
                                </c:forEach>
                                <c:if test="${currentPage < totalPages}">
                                    <li class="page-item">
                                        <a class="page-link" href="?keyword=${keyword}&category=${selectedCatId}&page=${currentPage+1}">
                                            <i class="fas fa-chevron-right"></i>
                                        </a>
                                    </li>
                                </c:if>
                            </ul>
                        </nav>
                    </c:if>
                </c:otherwise>
            </c:choose>
        </div><%-- /col --%>
    </div><%-- /row --%>
</div><%-- /container --%>

<jsp:include page="components/footer.jsp"/>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
