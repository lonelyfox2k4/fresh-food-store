<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
            <!DOCTYPE html>
            <html lang="vi">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Quản lý Sản phẩm | FoodStore Admin</title>
                <!-- Google Fonts -->
                <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
                <!-- Bootstrap 5 -->
                <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
                <jsp:include page="../components/admin-style.jsp" />



             <style>
                 .product-img { width: 48px; height: 48px; object-fit: cover; border-radius: 0.75rem; border: 2px solid #e2e8f0; }
             </style>
             </head>

            <body>
                <jsp:include page="../components/admin-nav.jsp">
                    <jsp:param name="active" value="products" />
                </jsp:include>

                <div class="page-header mt-n2">
                    <div class="container d-flex justify-content-between align-items-center">
                        <div>
                            <nav aria-label="breadcrumb">
                                <ol class="breadcrumb mb-1">
                                    <li class="breadcrumb-item"><a href="dashboard">Bán hàng</a></li>
                                    <li class="breadcrumb-item active">Sản phẩm</li>
                                </ol>
                            </nav>
                            <h2 class="fw-800 mb-0">Quản lý Sản phẩm</h2>
                        </div>
                        <c:if test="${sessionScope.user.roleId != 1}">
                            <a href="products?action=new"
                                class="btn btn-brand rounded-pill shadow-sm">
                                <i class="fas fa-plus-circle me-2"></i>Thêm sản phẩm mới
                            </a>
                        </c:if>
                    </div>
                </div>

                <div class="container pb-5">
                    <!-- Thanh tìm kiếm & Bộ lọc -->
                    <div class="filter-section shadow-sm mb-4">
                        <form class="row g-3">
                            <div class="col-md-4">
                                <div class="search-container">
                                    <i class="fas fa-search text-muted"></i>
                                    <input type="text" id="searchInput" class="form-control search-input" placeholder="Tìm tên sản phẩm...">
                                </div>
                            </div>
                            <div class="col-md-3">
                                <select id="supplierFilter" class="form-select border-0 bg-light" style="border-radius: 10px; padding: 0.6rem 1rem;">
                                    <option value="">-- Tất cả Đối tác --</option>
                                    <c:forEach var="p" items="${products}">
                                        <c:if test="${not empty p.supplierName}">
                                            <option value="${p.supplierName}">${p.supplierName}</option>
                                        </c:if>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <select id="statusFilter" class="form-select border-0 bg-light" style="border-radius: 10px; padding: 0.6rem 1rem;">
                                    <option value="">-- Tất cả trạng thái --</option>
                                    <option value="Đang bán">Đang bán</option>
                                    <option value="Tạm dừng">Tạm dừng</option>
                                    <option value="Chưa nhập kho">Chưa nhập kho</option>
                                </select>
                            </div>
                            <div class="col-md-2">
                                <button type="button" onclick="resetFilters()" class="btn btn-outline-secondary w-100" style="border-radius: 10px; padding: 0.6rem;">Xóa lọc</button>
                            </div>
                        </form>
                    </div>

                    <div class="user-table-card">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0">
                                <thead>
                                    <tr>
                                        <th>Ảnh</th>
                                        <th>Thông tin sản phẩm</th>
                                        <th>Đối tác (Mã ID)</th>
                                        <th>Giá niêm yết</th>
                                        <th>Ngày nhập & Hạn dùng</th>
                                        <th>Trạng thái</th>
                                        <c:if test="${sessionScope.user.roleId != 1}">
                                            <th class="text-end">Thao tác</th>
                                        </c:if>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="p" items="${products}">
                                        <tr>
                                            <td>
                                                <img src="${p.imageUrl}" class="product-img"
                                                    onerror="this.src='https://placehold.co/48x48/f1f5f9/475569?text=Food'">
                                            </td>
                                            <td>
                                                <div class="fw-bold fs-6">${p.productName}</div>
                                                <div class="badge-pill bg-light text-primary border border-primary-subtle px-2 mt-1" style="font-size: 0.65rem;">CAT-${p.categoryId}</div>
                                                <c:if test="${not empty p.expiryPricingPolicyId}">
                                                    <div class="badge-pill bg-info-subtle text-info border border-info-subtle px-2 mt-1" style="font-size: 0.65rem;">Policy #${p.expiryPricingPolicyId}</div>
                                                </c:if>
                                            </td>
                                            <td>
                                                <div class="fw-bold text-secondary small">${not empty p.supplierName ? p.supplierName : 'Chưa có đối tác'}</div>
                                                <small class="text-muted" style="font-size: 0.75rem;">Mã ID: #${p.productId}</small>
                                            </td>
                                            <td>
                                                <div class="fw-bold text-slate-900 fs-5">
                                                    <fmt:formatNumber value="${p.currentPrice}" pattern="#,###" />đ
                                                </div>
                                                <c:if test="${p.discountPercent < 100}">
                                                    <div class="small text-muted text-decoration-line-through">
                                                        <fmt:formatNumber value="${p.basePriceAmount}" pattern="#,###" />đ
                                                    </div>
                                                    <span class="badge bg-danger pe-none" style="font-size: 0.65rem;">
                                                        GIẢM ${100 - p.discountPercent.intValue()}%
                                                    </span>
                                                </c:if>
                                                <div class="text-muted small">${p.priceBaseWeightGram}g</div>
                                            </td>
                                            <td>
                                                <div class="small">
                                                    <span class="text-muted text-primary">Nhập lúc:</span> 
                                                    <span class="fw-medium">${not empty p.createdDate ? p.createdDate : '--'}</span>
                                                </div>
                                                <c:choose>
                                                    <c:when test="${not empty p.expiryDate}">
                                                        <div class="small mt-1">
                                                            <span class="text-muted">Hết hạn:</span> <span class="fw-medium text-dark">${p.expiryDate}</span>
                                                        </div>
                                                        <div class="small fw-bold mt-1">
                                                            <c:choose>
                                                                <c:when test="${p.daysRemaining < 0}">
                                                                    <span class="text-danger"><i class="fas fa-exclamation-triangle"></i> Hết hạn</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="${p.daysRemaining <= 3 ? 'text-danger fw-bold' : 'text-warning'}">
                                                                        <i class="fas fa-hourglass-half"></i> Còn ${p.daysRemaining} ngày
                                                                    </span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </div>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <div class="small text-muted fst-italic mt-1">
                                                            <i class="fas fa-info-circle"></i> Chưa nhập kho
                                                        </div>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${p.status}">
                                                        <span class="badge-pill badge-active"><i
                                                                class="fas fa-check-circle me-1"></i>Đang bán</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge-pill badge-role"><i
                                                                class="fas fa-minus-circle me-1"></i>Tạm dừng</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <c:if test="${sessionScope.user.roleId != 1}">
                                                <td class="text-end pe-4">
                                                    <a href="products?action=edit&id=${p.productId}"
                                                        class="btn-action btn-action-edit d-inline-flex" title="Chỉnh sửa">
                                                        <i class="fas fa-edit"></i>
                                                    </a>
                                                </td>
                                            </c:if>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
                <script>
                    const searchInput = document.getElementById('searchInput');
                    const supplierFilter = document.getElementById('supplierFilter');
                    const statusFilter = document.getElementById('statusFilter');
                    const tableRows = document.querySelectorAll('tbody tr');

                    function filterTable() {
                        const searchTerm = searchInput.value.toLowerCase();
                        const supplierTerm = supplierFilter.value;
                        const statusTerm = statusFilter.value;

                        tableRows.forEach(row => {
                            const name = row.querySelector('td:nth-child(2) div:first-child').textContent.toLowerCase();
                            const supplier = row.querySelector('td:nth-child(3) div').textContent;
                            const status = row.querySelector('td:nth-child(6)').textContent.trim();
                            const stockInfo = row.querySelector('td:nth-child(5)').textContent;

                            let show = name.includes(searchTerm);
                            if (supplierTerm && !supplier.includes(supplierTerm)) show = false;
                            
                            if (statusTerm) {
                                if (statusTerm === 'Chưa nhập kho') {
                                    if (!stockInfo.includes('Chưa nhập kho')) show = false;
                                } else if (!status.includes(statusTerm)) {
                                    show = false;
                                }
                            }

                            row.style.display = show ? '' : 'none';
                        });
                    }

                    function resetFilters() {
                        searchInput.value = '';
                        supplierFilter.value = '';
                        statusFilter.value = '';
                        filterTable();
                    }

                    searchInput.addEventListener('input', filterTable);
                    supplierFilter.addEventListener('change', filterTable);
                    statusFilter.addEventListener('change', filterTable);
                </script>
            </body>

            </html>