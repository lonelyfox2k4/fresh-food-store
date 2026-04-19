<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Giỏ hàng</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body class="bg-light d-flex flex-column min-vh-100">
<jsp:include page="/components/header.jsp" />

<main class="container py-5 flex-grow-1">
    <h2 class="mb-4">Giỏ hàng của bạn</h2>

    <c:if test="${not empty cartSuccessMsg}">
        <div class="alert alert-success">${cartSuccessMsg}</div>
    </c:if>
    <c:if test="${not empty cartErrorMsg}">
        <div class="alert alert-danger">${cartErrorMsg}</div>
    </c:if>

    <c:choose>
        <c:when test="${empty cartItems}">
            <div class="alert alert-info">Giỏ hàng đang trống.</div>
            <a href="${pageContext.request.contextPath}/home" class="btn btn-primary">Tiếp tục mua sắm</a>
        </c:when>
        <c:otherwise>
            <div class="table-responsive bg-white rounded-3 shadow-sm">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-light">
                    <tr>
                        <th>Sản phẩm</th>
                        <th>Đơn giá</th>
                        <th>Số lượng</th>
                        <th>Thành tiền</th>
                        <th></th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach var="item" items="${cartItems}">
                        <tr>
                            <td>
                                <div class="d-flex align-items-center gap-3">
                                    <img src="${not empty item.imageUrl ? item.imageUrl : 'https://via.placeholder.com/80x80?text=Food'}"
                                         alt="${item.productName}" width="60" height="60" class="rounded-2" style="object-fit: cover;">
                                    <div>
                                        <div class="fw-semibold">${item.productName}</div>
                                        <small class="text-muted">${item.packWeightGram}g</small>
                                    </div>
                                </div>
                            </td>
                            <td>
                                <fmt:formatNumber value="${item.unitPrice}" pattern="###,###"/> ₫
                            </td>
                            <td>
                                <form method="post" action="${pageContext.request.contextPath}/cart/update" class="d-flex gap-2">
                                    <input type="hidden" name="cartItemId" value="${item.cartItemId}">
                                    <input type="number" name="quantity" value="${item.quantity}" min="0" class="form-control" style="max-width: 90px;">
                                    <button class="btn btn-outline-primary btn-sm" type="submit">Cập nhật</button>
                                </form>
                            </td>
                            <td class="fw-semibold">
                                <fmt:formatNumber value="${item.lineTotal}" pattern="###,###"/> ₫
                            </td>
                            <td class="text-end">
                                <form method="post" action="${pageContext.request.contextPath}/cart/remove">
                                    <input type="hidden" name="cartItemId" value="${item.cartItemId}">
                                    <button type="submit" class="btn btn-outline-danger btn-sm">
                                        <i class="fa-solid fa-trash"></i> Xóa
                                    </button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>

            <div class="card border-0 shadow-sm mt-4">
                <div class="card-body d-flex justify-content-between align-items-center">
                    <strong>Tổng tiền:</strong>
                    <strong class="text-brand fs-5">
                        <fmt:formatNumber value="${cartTotal}" pattern="###,###"/> ₫
                    </strong>
                </div>
            </div>

            <div class="d-flex justify-content-between flex-wrap gap-2 mt-3">
                <a href="${pageContext.request.contextPath}/home" class="btn btn-outline-secondary">
                    <i class="fa-solid fa-arrow-left me-1"></i> Quay lại mua sắm
                </a>
                <a href="${pageContext.request.contextPath}/checkout" class="btn btn-success">
                    <i class="fa-solid fa-credit-card me-1"></i> Thanh toán
                </a>
            </div>
        </c:otherwise>
    </c:choose>
</main>

<jsp:include page="/components/footer.jsp" />
</body>
</html>
