<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Giỏ hàng – Fresh Food Store</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
<jsp:include page="components/header.jsp"/>

<div class="container my-5">
    <h1 class="h3 fw-bold mb-4"><i class="fas fa-shopping-cart me-2 text-brand"></i>Giỏ hàng của bạn</h1>

    <c:choose>
        <c:when test="${empty cartItems}">
            <div class="text-center py-5">
                <i class="fas fa-shopping-cart fa-5x text-muted mb-4"></i>
                <h4 class="text-muted">Giỏ hàng đang trống!</h4>
                <p class="text-muted">Hãy thêm sản phẩm vào giỏ để tiến hành mua hàng.</p>
                <a href="${pageContext.request.contextPath}/products" class="btn btn-brand fw-bold px-5 mt-2">
                    <i class="fas fa-shopping-bag me-2"></i>Mua sắm ngay
                </a>
            </div>
        </c:when>
        <c:otherwise>
            <div class="row g-4">

                <%-- ══ Cart items table ════════════════════════════════════ --%>
                <div class="col-lg-8">
                    <div class="card border-0 shadow-sm">
                        <div class="card-body p-0">
                            <div class="table-responsive">
                                <table class="table align-middle mb-0">
                                    <thead class="table-light">
                                        <tr>
                                            <th class="py-3 ps-3">Sản phẩm</th>
                                            <th class="text-center">Đơn giá</th>
                                            <th class="text-center">Số lượng</th>
                                            <th class="text-center">Thành tiền</th>
                                            <th></th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="item" items="${cartItems}">
                                            <tr>
                                                <%-- Product info --%>
                                                <td class="ps-3">
                                                    <div class="d-flex align-items-center gap-3">
                                                        <a href="${pageContext.request.contextPath}/product-detail?id=${item.productId}">
                                                            <img src="${not empty item.imageUrl ? item.imageUrl : 'https://via.placeholder.com/80/fdf2f2/E3000F?text=FFS'}"
                                                                 class="cart-img" alt="${item.productName}">
                                                        </a>
                                                        <div>
                                                            <a href="${pageContext.request.contextPath}/product-detail?id=${item.productId}"
                                                               class="text-decoration-none text-dark fw-semibold d-block">
                                                                ${item.productName}
                                                            </a>
                                                            <small class="text-muted">
                                                                <i class="fas fa-weight-hanging me-1"></i>Khay ${item.packWeightGram}g
                                                            </small>
                                                        </div>
                                                    </div>
                                                </td>

                                                <%-- Unit price --%>
                                                <td class="text-center">
                                                    <span class="fw-semibold">
                                                        <fmt:formatNumber value="${item.computedPackBasePrice}" pattern="###,###"/> ₫
                                                    </span>
                                                </td>

                                                <%-- Quantity stepper --%>
                                                <td class="text-center">
                                                    <div class="qty-box justify-content-center">
                                                        <form action="${pageContext.request.contextPath}/cart/update" method="post" class="d-inline">
                                                            <input type="hidden" name="cartItemId" value="${item.cartItemId}">
                                                            <input type="hidden" name="quantity" value="${item.quantity - 1}">
                                                            <button class="btn btn-sm btn-outline-secondary" type="submit">
                                                                <i class="fas fa-minus"></i>
                                                            </button>
                                                        </form>
                                                        <span class="fw-bold px-2">${item.quantity}</span>
                                                        <form action="${pageContext.request.contextPath}/cart/update" method="post" class="d-inline">
                                                            <input type="hidden" name="cartItemId" value="${item.cartItemId}">
                                                            <input type="hidden" name="quantity" value="${item.quantity + 1}">
                                                            <button class="btn btn-sm btn-outline-secondary" type="submit">
                                                                <i class="fas fa-plus"></i>
                                                            </button>
                                                        </form>
                                                    </div>
                                                </td>

                                                <%-- Line total --%>
                                                <td class="text-center">
                                                    <span class="fw-bold text-brand">
                                                        <fmt:formatNumber value="${item.lineTotal}" pattern="###,###"/> ₫
                                                    </span>
                                                </td>

                                                <%-- Remove --%>
                                                <td class="text-center pe-3">
                                                    <form action="${pageContext.request.contextPath}/cart/remove" method="post">
                                                        <input type="hidden" name="cartItemId" value="${item.cartItemId}">
                                                        <button class="btn btn-sm btn-outline-danger border-0" type="submit"
                                                                title="Xóa">
                                                            <i class="fas fa-trash-alt"></i>
                                                        </button>
                                                    </form>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>

                    <a href="${pageContext.request.contextPath}/products"
                       class="btn btn-outline-secondary mt-3">
                        <i class="fas fa-arrow-left me-2"></i>Tiếp tục mua sắm
                    </a>
                </div>

                <%-- ══ Order summary ═══════════════════════════════════════ --%>
                <div class="col-lg-4">
                    <div class="checkout-card">
                        <h5 class="fw-bold mb-3"><i class="fas fa-receipt me-2"></i>Tóm tắt đơn hàng</h5>

                        <div class="d-flex justify-content-between mb-2">
                            <span class="text-muted">Tạm tính</span>
                            <strong>
                                <fmt:formatNumber value="${cartSubtotal}" pattern="###,###"/> ₫
                            </strong>
                        </div>
                        <div class="d-flex justify-content-between mb-3">
                            <span class="text-muted">Phí giao hàng</span>
                            <span class="text-muted">Tính ở bước tiếp theo</span>
                        </div>

                        <hr>
                        <p class="text-muted small mb-3">
                            <i class="fas fa-truck me-1 text-success"></i>
                            Miễn phí ship đơn từ <strong>500,000 ₫</strong>
                        </p>

                        <a href="${pageContext.request.contextPath}/checkout"
                           class="btn btn-brand fw-bold w-100 py-2">
                            <i class="fas fa-lock me-2"></i>Tiến hành thanh toán
                        </a>
                    </div>
                </div>

            </div>
        </c:otherwise>
    </c:choose>
</div>

<jsp:include page="components/footer.jsp"/>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
