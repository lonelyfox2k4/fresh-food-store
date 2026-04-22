<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Danh sách yêu thích</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body class="bg-light d-flex flex-column min-vh-100">
<jsp:include page="/components/header.jsp" />

<main class="container py-5 flex-grow-1">
    <h2 class="mb-4">Danh sách yêu thích</h2>

    <c:if test="${not empty wishlistSuccessMsg}">
        <div class="alert alert-success">${wishlistSuccessMsg}</div>
    </c:if>
    <c:if test="${not empty wishlistErrorMsg}">
        <div class="alert alert-danger">${wishlistErrorMsg}</div>
    </c:if>
    <c:if test="${not empty cartSuccessMsg}">
        <div class="alert alert-success">${cartSuccessMsg}</div>
    </c:if>
    <c:if test="${not empty cartErrorMsg}">
        <div class="alert alert-danger">${cartErrorMsg}</div>
    </c:if>

    <c:choose>
        <c:when test="${empty wishlistItems}">
            <div class="alert alert-info">Danh sách yêu thích đang trống.</div>
            <a href="${pageContext.request.contextPath}/home" class="btn btn-primary">Quay lại mua sắm</a>
        </c:when>
        <c:otherwise>
            <div class="table-responsive bg-white rounded-3 shadow-sm">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light">
                    <tr>
                        <th>Sản phẩm</th>
                        <th>Giá hiện tại</th>
                        <th>Ngày thêm</th>
                        <th></th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="item" items="${wishlistItems}">
                        <tr>
                            <td>
                                <div class="d-flex align-items-center gap-3">
                                    <img src="${not empty item.imageUrl ? item.imageUrl : 'https://via.placeholder.com/80x80?text=Food'}"
                                         alt="${item.productName}" width="60" height="60" class="rounded-2" style="object-fit: cover;">
                                    <div>
                                        <div class="fw-semibold">${item.productName}</div>
                                        <small class="text-muted">${item.priceBaseWeightGram}g</small>
                                    </div>
                                </div>
                            </td>
                            <td><fmt:formatNumber value="${item.currentPrice}" pattern="###,###"/> ₫</td>
                            <td>${item.createdAt}</td>
                            <td class="text-end">
                                <div class="d-flex justify-content-end gap-2">
                                    <form method="post" action="${pageContext.request.contextPath}/cart/add">
                                        <input type="hidden" name="productId" value="${item.productId}">
                                        <input type="hidden" name="quantity" value="1">
                                        <input type="hidden" name="returnUrl" value="${pageContext.request.contextPath}/wishlist">
                                        <button type="submit" class="btn btn-outline-success btn-sm">
                                            <i class="fa-solid fa-cart-plus me-1"></i> Thêm giỏ
                                        </button>
                                    </form>
                                    <form method="post" action="${pageContext.request.contextPath}/wishlist/remove">
                                        <input type="hidden" name="productId" value="${item.productId}">
                                        <input type="hidden" name="returnUrl" value="${pageContext.request.contextPath}/wishlist">
                                        <button type="submit" class="btn btn-outline-danger btn-sm">
                                            <i class="fa-solid fa-heart-crack me-1"></i> Bỏ thích
                                        </button>
                                    </form>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </c:otherwise>
    </c:choose>
</main>

<jsp:include page="/components/footer.jsp" />
</body>
</html>
