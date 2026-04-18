<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${product.productName} – Fresh Food Store</title>
    <meta name="description" content="${product.description}">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
<jsp:include page="components/header.jsp"/>

<div class="container my-5">
    <%-- Breadcrumb --%>
    <nav aria-label="breadcrumb" class="mb-4">
        <ol class="breadcrumb">
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/home" class="text-brand">Trang chủ</a></li>
            <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/products" class="text-brand">Sản phẩm</a></li>
            <li class="breadcrumb-item active">${product.productName}</li>
        </ol>
    </nav>

    <div class="row g-5">

        <%-- ══ Product image ═══════════════════════════════════════════════ --%>
        <div class="col-lg-5">
            <div class="rounded-3 overflow-hidden shadow">
                <img src="${not empty product.imageUrl ? product.imageUrl : 'https://via.placeholder.com/600x500/fdf2f2/E3000F?text=Fresh+Food'}"
                     class="img-fluid w-100" style="max-height:480px;object-fit:cover;"
                     alt="${product.productName}" id="mainProductImg">
            </div>
            <c:if test="${product.expiryPricingPolicyId != null}">
                <div class="alert alert-danger d-flex align-items-center gap-2 mt-3 py-2" role="alert">
                    <i class="fas fa-bolt text-warning"></i>
                    <small><strong>Giá sốc hôm nay!</strong> Sản phẩm này đang được giảm giá theo hạn sử dụng.</small>
                </div>
            </c:if>
        </div>

        <%-- ══ Product info ════════════════════════════════════════════════ --%>
        <div class="col-lg-7">
            <h1 class="fw-bold fs-2 mb-2">${product.productName}</h1>

            <%-- Rating summary --%>
            <div class="d-flex align-items-center gap-3 mb-3">
                <div class="stars-display">
                    <c:forEach begin="1" end="5" var="s">
                        <c:choose>
                            <c:when test="${s <= avgRating}"><i class="fas fa-star"></i></c:when>
                            <c:when test="${s - 0.5 <= avgRating}"><i class="fas fa-star-half-alt"></i></c:when>
                            <c:otherwise><i class="far fa-star"></i></c:otherwise>
                        </c:choose>
                    </c:forEach>
                </div>
                <span class="text-muted small">${reviewCount} đánh giá</span>
                <span class="text-muted">|</span>
                <span class="text-muted small"><i class="fas fa-check-circle text-success me-1"></i>100% Thịt tươi sạch</span>
            </div>

            <%-- Price display --%>
            <div class="bg-light rounded-3 p-3 mb-4">
                <p class="text-muted small mb-1">Giá niêm yết / <strong>${product.priceBaseWeightGram}g</strong></p>
                <div class="price-main fs-1 fw-bold" id="priceDisplay">
                    <fmt:formatNumber value="${product.basePriceAmount}" pattern="###,###"/> ₫
                </div>
                <p class="text-muted small mb-0" id="priceNote">Chọn gói để xem giá chính xác</p>
            </div>

            <%-- Pack selector --%>
            <c:if test="${not empty packs}">
                <div class="mb-4">
                    <p class="fw-semibold mb-2">Chọn gói khối lượng:</p>
                    <div class="d-flex flex-wrap gap-2" id="packSelector">
                        <c:forEach var="pk" items="${packs}" varStatus="s">
                            <label class="pack-option border rounded-3 px-3 py-2 d-flex align-items-center gap-2
                                         ${pk.availableStock == 0 ? 'opacity-50' : ''}"
                                   style="cursor:${pk.availableStock == 0 ? 'not-allowed' : 'pointer'};"
                                   for="pack${pk.productPackId}">
                                <input type="radio" class="form-check-input m-0" name="selectedPack"
                                       id="pack${pk.productPackId}"
                                       value="${pk.productPackId}"
                                       data-weight="${pk.packWeightGram}"
                                       data-base="${product.basePriceAmount}"
                                       data-base-weight="${product.priceBaseWeightGram}"
                                       data-stock="${pk.availableStock}"
                                       ${s.first ? 'checked' : ''}
                                       ${pk.availableStock == 0 ? 'disabled' : ''}>
                                <div>
                                    <span class="fw-semibold">${pk.packWeightGram}g</span>
                                    <c:choose>
                                        <c:when test="${pk.availableStock == 0}">
                                            <span class="badge bg-secondary ms-1" style="font-size:.7rem;">Hết hàng</span>
                                        </c:when>
                                        <c:when test="${pk.availableStock <= 10}">
                                            <span class="badge bg-warning text-dark ms-1" style="font-size:.7rem;">Còn ${pk.availableStock}</span>
                                        </c:when>
                                    </c:choose>
                                </div>
                            </label>
                        </c:forEach>
                    </div>
                </div>
            </c:if>

            <%-- Add to cart form --%>
            <c:choose>
                <c:when test="${not empty packs}">
                    <%-- Tìm pack đầu tiên còn hàng để đặt làm default --%>
                    <c:set var="firstValidPack" value="${null}"/>
                    <c:forEach var="pk" items="${packs}">
                        <c:if test="${pk.availableStock > 0 && firstValidPack == null}">
                            <c:set var="firstValidPack" value="${pk}"/>
                        </c:if>
                    </c:forEach>

                    <%-- Quantity stepper (outside both forms, controls hidden input via JS) --%>
                    <div class="d-flex gap-3 align-items-center mb-3">
                        <div class="qty-box">
                            <button type="button" class="btn btn-outline-secondary" onclick="changeQty(-1)">
                                <i class="fas fa-minus"></i>
                            </button>
                            <input type="number" id="qtyInput" class="form-control" value="1" min="1" max="99"
                                   oninput="syncQty(this.value)">
                            <button type="button" class="btn btn-outline-secondary" onclick="changeQty(1)">
                                <i class="fas fa-plus"></i>
                            </button>
                        </div>
                        <span class="text-muted small" id="stockNote"></span>
                    </div>

                    <%-- Two sibling forms (NOT nested) --%>
                    <div class="d-flex gap-3">
                        <%-- Cart form --%>
                        <form action="${pageContext.request.contextPath}/cart/add" method="post"
                              id="addToCartForm" class="flex-grow-1">
                            <input type="hidden" name="productPackId" id="selectedPackId"
                                   value="${not empty firstValidPack ? firstValidPack.productPackId : packs[0].productPackId}">
                            <input type="hidden" name="quantity" id="hiddenQty" value="1">
                            <button type="submit" id="addToCartBtn" class="btn btn-brand fw-bold w-100 py-2">
                                <i class="fas fa-cart-plus me-2"></i>Thêm vào giỏ hàng
                            </button>
                        </form>

                        <%-- Wishlist form (sibling, NOT nested) --%>
                        <c:if test="${not empty sessionScope.user}">
                            <form action="${pageContext.request.contextPath}/wishlist/add" method="post">
                                <input type="hidden" name="productId" value="${product.productId}">
                                <input type="hidden" name="redirect"
                                       value="${pageContext.request.contextPath}/product-detail?id=${product.productId}">
                                <button type="submit"
                                        class="btn ${inWishlist ? 'btn-brand' : 'btn-outline-danger'} px-3 py-2"
                                        title="${inWishlist ? 'Bỏ yêu thích' : 'Thêm vào yêu thích'}">
                                    <i class="fas fa-heart"></i>
                                </button>
                            </form>
                        </c:if>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="alert alert-info border-0">
                        <i class="fas fa-info-circle me-2"></i>
                        <strong>Sản phẩm này chưa có gói bán.</strong>
                        Nhà cung cấp đang cập nhật — vui lòng quay lại sau hoặc
                        <a href="${pageContext.request.contextPath}/products" class="alert-link">xem sản phẩm khác</a>.
                    </div>
                </c:otherwise>
            </c:choose>

            <%-- Description --%>
            <c:if test="${not empty product.description}">
                <hr>
                <p class="text-muted mb-0">${product.description}</p>
            </c:if>

            <%-- Trust badges --%>
            <div class="row g-2 mt-3">
                <div class="col-4 text-center">
                    <i class="fas fa-leaf text-success fs-4 mb-1"></i>
                    <p class="small text-muted mb-0">100% VietGAP</p>
                </div>
                <div class="col-4 text-center">
                    <i class="fas fa-shipping-fast text-brand fs-4 mb-1"></i>
                    <p class="small text-muted mb-0">Giao 2H</p>
                </div>
                <div class="col-4 text-center">
                    <i class="fas fa-exchange-alt text-primary fs-4 mb-1"></i>
                    <p class="small text-muted mb-0">Đổi 1-1</p>
                </div>
            </div>
        </div>
    </div>

    <%-- ══ Reviews section ════════════════════════════════════════════════ --%>
    <div class="mt-5 pt-4">
        <h3 class="fw-bold mb-4"><i class="fas fa-star me-2 text-warning"></i>Đánh giá sản phẩm</h3>

        <%-- Flash messages from session --%>
        <c:if test="${not empty sessionScope.reviewSuccess}">
            <div class="alert alert-success alert-dismissible">
                <i class="fas fa-check-circle me-2"></i>${sessionScope.reviewSuccess}
                <button class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <c:remove var="reviewSuccess" scope="session"/>
        </c:if>
        <c:if test="${not empty sessionScope.reviewError}">
            <div class="alert alert-danger alert-dismissible">
                <i class="fas fa-exclamation-circle me-2"></i>${sessionScope.reviewError}
                <button class="btn-close" data-bs-dismiss="alert"></button>
            </div>
            <c:remove var="reviewError" scope="session"/>
        </c:if>

        <div class="row g-4">
            <%-- Write review form --%>
            <div class="col-lg-4">
                <div class="card border-0 shadow-sm p-3">
                    <h6 class="fw-bold mb-3">Viết đánh giá của bạn</h6>
                    <c:choose>
                        <c:when test="${not empty sessionScope.user}">
                            <c:choose>
                                <c:when test="${canReview}">
                                    <form action="${pageContext.request.contextPath}/review/add" method="post">
                                        <input type="hidden" name="productId" value="${product.productId}">
                                        <input type="hidden" name="redirect"
                                               value="${pageContext.request.contextPath}/product-detail?id=${product.productId}">
                                        <%-- Star rating input (CSS-only trick, RTL) --%>
                                        <div class="stars-input mb-3" id="starRating">
                                            <c:forEach begin="1" end="5" var="i">
                                                <c:set var="s" value="${6 - i}"/>
                                                <input type="radio" name="rating" id="star${s}" value="${s}" required>
                                                <label for="star${s}" title="${s} sao"><i class="fas fa-star"></i></label>
                                            </c:forEach>
                                        </div>
                                        <textarea name="comment" class="form-control mb-3" rows="4"
                                                  placeholder="Chia sẻ cảm nhận của bạn về sản phẩm này..." required></textarea>
                                        <button type="submit" class="btn btn-brand w-100 fw-bold">
                                            <i class="fas fa-paper-plane me-2"></i>Gửi đánh giá
                                        </button>
                                    </form>
                                </c:when>
                                <c:otherwise>
                                    <div class="alert alert-warning small px-3 py-2 mb-0 border-0 text-center">
                                        <i class="fas fa-lock me-1"></i>Bạn chỉ có thể đánh giá sản phẩm sau khi đã mua và nhận hàng thành công!
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </c:when>
                        <c:otherwise>
                            <p class="text-muted small">
                                <a href="${pageContext.request.contextPath}/login" class="text-brand fw-bold">Đăng nhập</a>
                                để viết đánh giá!
                            </p>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <%-- Review list --%>
            <div class="col-lg-8">
                <c:choose>
                    <c:when test="${empty reviews}">
                        <div class="text-center py-4 text-muted">
                            <i class="far fa-comment-dots fa-3x mb-2"></i>
                            <p>Chưa có đánh giá nào. Hãy là người đầu tiên!</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="rv" items="${reviews}">
                            <div class="card border-0 shadow-sm mb-3 p-3">
                                <div class="d-flex justify-content-between align-items-start">
                                    <div class="d-flex align-items-center gap-2">
                                        <div class="rounded-circle bg-brand d-flex align-items-center justify-content-center"
                                             style="width:38px;height:38px;font-weight:700;color:#fff;">
                                            ${rv.reviewerName.substring(0,1).toUpperCase()}
                                        </div>
                                        <div>
                                            <strong class="d-block">${rv.reviewerName}</strong>
                                            <div class="stars-display" style="font-size:.85rem;">
                                                <c:forEach begin="1" end="${rv.rating}" var="s">
                                                    <i class="fas fa-star"></i>
                                                </c:forEach>
                                                <c:forEach begin="${rv.rating+1}" end="5" var="s">
                                                    <i class="far fa-star text-muted"></i>
                                                </c:forEach>
                                            </div>
                                        </div>
                                    </div>
                                    <small class="text-muted">${rv.createdAt}</small>
                                </div>
                                <p class="mb-0 mt-2 text-muted">${rv.comment}</p>
                                
                                <%-- Shop reply display --%>
                                <c:if test="${not empty rv.shopReply}">
                                    <div class="mt-3 p-3 bg-light border-start border-4 border-brand rounded-end shadow-sm">
                                        <div class="d-flex align-items-center gap-2 mb-2">
                                            <i class="fas fa-store text-brand"></i>
                                            <strong class="text-brand small text-uppercase fw-bold">Phản hồi từ cửa hàng</strong>
                                            <small class="text-muted ms-auto">${rv.repliedAt}</small>
                                        </div>
                                        <p class="mb-0 small text-dark">${rv.shopReply}</p>
                                    </div>
                                </c:if>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

</div>
<jsp:include page="components/footer.jsp"/>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
// ── Pack selector: update price display and hidden input ─────────────
const packRadios = document.querySelectorAll('input[name="selectedPack"]');
const priceDisplay = document.getElementById('priceDisplay');
const priceNote    = document.getElementById('priceNote');
const packIdInput  = document.getElementById('selectedPackId');
const addToCartBtn = document.getElementById('addToCartBtn');
const stockNote    = document.getElementById('stockNote');

function updatePrice() {
    let selected = document.querySelector('input[name="selectedPack"]:checked:not([disabled])');
    if (!selected) selected = document.querySelector('input[name="selectedPack"]:not([disabled])');
    if (!selected) selected = document.querySelector('input[name="selectedPack"]');
    if (!selected) return;

    const weight     = parseInt(selected.dataset.weight);
    const base       = parseFloat(selected.dataset.base);
    const baseWeight = parseInt(selected.dataset.baseWeight);
    const stock      = parseInt(selected.dataset.stock || '0');
    const packPrice  = Math.round(base * weight / baseWeight);
    priceDisplay.textContent = packPrice.toLocaleString('vi-VN') + ' ₫';
    priceNote.textContent    = 'Khay ' + weight + 'g';
    if (packIdInput) packIdInput.value = selected.value;

    // Cập nhật nút mua và stock note
    if (addToCartBtn) {
        if (stock === 0) {
            addToCartBtn.disabled = true;
            addToCartBtn.innerHTML = '<i class="fas fa-times-circle me-2"></i>Hết hàng';
            addToCartBtn.classList.replace('btn-brand', 'btn-secondary');
        } else {
            addToCartBtn.disabled = false;
            addToCartBtn.innerHTML = '<i class="fas fa-cart-plus me-2"></i>Thêm vào giỏ hàng';
            addToCartBtn.classList.replace('btn-secondary', 'btn-brand');
        }
    }
    if (stockNote) {
        if (stock === 0) {
            stockNote.innerHTML = '<span class="badge bg-danger">Hết hàng</span>';
        } else if (stock <= 10) {
            stockNote.innerHTML = '<span class="text-warning fw-semibold"><i class="fas fa-exclamation-triangle me-1"></i>Còn ' + stock + ' gói</span>';
        } else {
            stockNote.innerHTML = '<span class="text-success"><i class="fas fa-check-circle me-1"></i>Còn hàng</span>';
        }
        const qtyIn = document.getElementById('qtyInput');
        if (stock > 0 && qtyIn) qtyIn.max = stock;
    }

    // highlight selected
    document.querySelectorAll('.pack-option').forEach(el => {
        el.classList.remove('bg-brand', 'text-white', 'border-brand');
    });
    if (selected.closest('.pack-option')) {
        selected.closest('.pack-option').classList.add('bg-brand', 'text-white', 'border-brand');
    }
}

packRadios.forEach(r => r.addEventListener('change', updatePrice));
updatePrice(); // init

// ── Quantity stepper ─────────────────────────────────────────────────
function syncQty(val) {
    const input = document.getElementById('qtyInput');
    const maxStock = parseInt(input.max) || 99;
    const v = Math.max(1, Math.min(maxStock, parseInt(val) || 1));
    input.value = v;
    const h = document.getElementById('hiddenQty');
    if (h) h.value = v;
}
function changeQty(delta) {
    const input = document.getElementById('qtyInput');
    syncQty(parseInt(input.value) + delta);
}
</script>
</body>
</html>
