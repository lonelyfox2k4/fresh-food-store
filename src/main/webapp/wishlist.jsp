<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sản phẩm yêu thích – Fresh Food Store</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
<jsp:include page="components/header.jsp"/>

<div class="container my-5">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h1 class="h3 fw-bold mb-0">
            <i class="fas fa-heart me-2 text-brand"></i>Sản phẩm yêu thích
        </h1>
        <a href="${pageContext.request.contextPath}/products" class="btn btn-outline-secondary btn-sm">
            <i class="fas fa-shopping-bag me-1"></i>Xem thêm sản phẩm
        </a>
    </div>

    <c:choose>
        <c:when test="${empty wishlist}">
            <div class="text-center py-5">
                <i class="far fa-heart fa-5x text-muted mb-4"></i>
                <h4 class="text-muted">Danh sách yêu thích trống!</h4>
                <p class="text-muted">Hãy thêm sản phẩm bạn thích để theo dõi dễ hơn.</p>
                <a href="${pageContext.request.contextPath}/products" class="btn btn-brand px-5 mt-2">
                    Khám phá sản phẩm
                </a>
            </div>
        </c:when>
        <c:otherwise>
            <div class="row g-4">
                <c:forEach var="p" items="${wishlist}">
                    <div class="col-sm-6 col-lg-4 col-xl-3">
                        <div class="card product-card h-100 position-relative">
                            <%-- Flash badge --%>
                            <c:if test="${p.expiryPricingPolicyId != null}">
                                <span class="badge-flash position-absolute" style="left:0;top:0;z-index:10;">
                                    <i class="fas fa-bolt me-1"></i>Giá sốc
                                </span>
                            </c:if>

                            <%-- Remove from wishlist --%>
                            <form action="${pageContext.request.contextPath}/wishlist/toggle" method="post"
                                  class="position-absolute" style="right:8px;top:8px;z-index:10;">
                                <input type="hidden" name="productId" value="${p.productId}">
                                <input type="hidden" name="redirect"
                                       value="${pageContext.request.contextPath}/wishlist">
                                <button type="submit"
                                        class="btn btn-sm btn-brand rounded-circle shadow-sm border-0"
                                        title="Xóa khỏi yêu thích">
                                    <i class="fas fa-heart"></i>
                                </button>
                            </form>

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
                                    <i class="fas fa-weight-hanging me-1"></i>${p.priceBaseWeightGram}g
                                </small>
                                <div class="mt-auto">
                                    <div class="price-main mb-2">
                                        <fmt:formatNumber value="${p.basePriceAmount}" pattern="###,###"/> ₫
                                    </div>
                                    <a href="${pageContext.request.contextPath}/product-detail?id=${p.productId}"
                                       class="btn btn-brand w-100 fw-bold">
                                        <i class="fas fa-eye me-1"></i> Xem & Mua
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<jsp:include page="components/footer.jsp"/>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
