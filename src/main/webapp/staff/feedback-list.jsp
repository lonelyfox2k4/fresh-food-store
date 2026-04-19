<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<html>
<head>
    <title>Quản lý Phản hồi | Staff</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <style>
        .stars       { color: #f59e0b; letter-spacing: 2px; }
        .stars-empty { color: #dee2e6; letter-spacing: 2px; }
        .review-cell { max-width: 260px; }
        .product-cell{ max-width: 160px; }
        .response-preview {
            background: #f0fdf4;
            border-left: 3px solid #22c55e;
            padding: 6px 10px;
            border-radius: 4px;
            font-size: 0.8rem;
            color: #166534;
            max-width: 260px;
        }
        .text-truncate-2 {
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }
        .avatar {
            width: 36px; height: 36px; font-size: 0.85rem;
            border-radius: 50%;
            background: #0d6efd;
            color: #fff;
            display: flex; align-items: center; justify-content: center;
            flex-shrink: 0;
        }
        .filter-tab        { cursor: pointer; transition: .15s; }
        .filter-tab.active { background: #198754 !important; color: #fff !important; border-color: #198754 !important; }
    </style>
</head>
<body class="bg-light">
<c:import url="/staff/common/nav.jsp" />

<div class="container-fluid py-3 px-4">

    <%-- ===== HEADER ===== --%>
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h3 class="fw-bold"><i class="bi bi-chat-square-text me-2"></i>Quản lý Phản hồi</h3>
            <p class="text-muted small mb-0">Hồi đáp các đánh giá sản phẩm từ khách hàng.</p>
        </div>
        <a href="feedback" class="btn btn-outline-secondary shadow-sm">
            <i class="bi bi-arrow-clockwise"></i> Làm mới
        </a>
    </div>

    <%-- ===== ALERT ===== --%>
    <c:if test="${not empty param.msg}">
        <div class="alert alert-success border-0 shadow-sm alert-dismissible fade show">
            <i class="bi bi-check-circle-fill me-2"></i>
            <c:choose>
                <c:when test="${param.msg == 'replied'}">Đã gửi / cập nhật phản hồi thành công!</c:when>
                <c:otherwise>Thao tác thành công!</c:otherwise>
            </c:choose>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>
    <c:if test="${not empty param.error}">
        <div class="alert alert-danger border-0 shadow-sm alert-dismissible fade show">
            <i class="bi bi-exclamation-triangle-fill me-2"></i>
            <c:choose>
                <c:when test="${param.error == 'missing_id'}">Thiếu thông tin review.</c:when>
                <c:when test="${param.error == 'failed'}">Gửi phản hồi thất bại, vui lòng thử lại.</c:when>
                <c:otherwise>Lỗi: ${param.error}</c:otherwise>
            </c:choose>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <%-- ===== SUMMARY CARDS ===== --%>
    <c:set var="totalCount"   value="${feedbackList.size()}" />
    <c:set var="repliedCount" value="0" />
    <c:forEach items="${feedbackList}" var="fx">
        <c:if test="${fx.status == 1}">
            <c:set var="repliedCount" value="${repliedCount + 1}" />
        </c:if>
    </c:forEach>
    <c:set var="pendingCount" value="${totalCount - repliedCount}" />

    <div class="row g-3 mb-4">
        <div class="col-md-4">
            <div class="card border-0 shadow-sm text-center py-3">
                <div class="fs-2 fw-bold text-primary">${totalCount}</div>
                <div class="text-muted small">Tổng đánh giá</div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card border-0 shadow-sm text-center py-3">
                <div class="fs-2 fw-bold text-success">${repliedCount}</div>
                <div class="text-muted small">Đã phản hồi</div>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card border-0 shadow-sm text-center py-3">
                <div class="fs-2 fw-bold text-warning">${pendingCount}</div>
                <div class="text-muted small">Chờ xử lý</div>
            </div>
        </div>
    </div>

    <%-- ===== MAIN TABLE ===== --%>
    <div class="card border-0 shadow-sm">

        <%-- Filter tabs --%>
        <div class="card-header bg-white border-bottom d-flex gap-2 flex-wrap">
            <span class="badge rounded-pill border filter-tab fs-6 px-3 py-2 text-dark active"
                  id="tab-all" onclick="filterTable('all')">
                <i class="bi bi-list-ul me-1"></i> Tất cả &nbsp;<span class="badge bg-secondary rounded-pill">${totalCount}</span>
            </span>
            <span class="badge rounded-pill border filter-tab fs-6 px-3 py-2 text-warning"
                  id="tab-pending" onclick="filterTable('pending')">
                <i class="bi bi-clock me-1"></i> Chờ xử lý &nbsp;<span class="badge bg-warning text-dark rounded-pill">${pendingCount}</span>
            </span>
            <span class="badge rounded-pill border filter-tab fs-6 px-3 py-2 text-success"
                  id="tab-replied" onclick="filterTable('replied')">
                <i class="bi bi-check-circle me-1"></i> Đã phản hồi &nbsp;<span class="badge bg-success rounded-pill">${repliedCount}</span>
            </span>
        </div>

        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0" id="feedbackTable">
                    <thead class="table-success">
                    <tr>
                        <th class="ps-4" style="width:55px;">#</th>
                        <th style="min-width:150px;">Khách hàng</th>
                        <th style="min-width:140px;">Sản phẩm</th>
                        <th style="min-width:220px;">Nội dung đánh giá</th>
                        <th style="width:115px;">Xếp hạng</th>
                        <th style="width:115px;">Ngày đánh giá</th>
                        <th style="min-width:220px;">Phản hồi của shop</th>
                        <th style="width:125px;">Trạng thái</th>
                        <th class="text-center" style="width:110px;">Thao tác</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach items="${feedbackList}" var="f">
                        <tr class="feedback-row" data-status="${f.status == 1 ? 'replied' : 'pending'}">

                            <%-- # reviewId --%>
                            <td class="ps-4 text-muted small">#${f.reviewId}</td>

                            <%-- Khách hàng --%>
                            <td>
                                <div class="d-flex align-items-center gap-2">
                                    <div class="avatar">
                                        ${not empty f.subject ? f.subject.substring(0,1).toUpperCase() : '?'}
                                    </div>
                                    <div class="fw-semibold small">${f.subject}</div>
                                </div>
                            </td>

                            <%-- Sản phẩm --%>
                            <td class="product-cell">
                                <div class="small text-truncate-2 text-dark fw-semibold" title="${f.productName}">
                                    <i class="bi bi-bag-fill text-success me-1"></i>${f.productName}
                                </div>
                            </td>

                            <%-- Nội dung đánh giá --%>
                            <td class="review-cell">
                                <div class="small text-muted fst-italic text-truncate-2" title="${f.content}">
                                    "${f.content}"
                                </div>
                            </td>

                            <%-- Xếp hạng --%>
                            <td>
                                <div>
                                    <span class="stars">
                                        <c:forEach begin="1" end="${f.rating}">★</c:forEach>
                                    </span><span class="stars-empty">
                                        <c:forEach begin="1" end="${5 - f.rating}">★</c:forEach>
                                    </span>
                                </div>
                                <small class="text-muted">${f.rating}/5</small>
                            </td>

                            <%-- Ngày đánh giá --%>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty f.createdAt}">
                                        <div class="small">${f.createdAt.toString().replace('T',' ').substring(0,16)}</div>
                                    </c:when>
                                    <c:otherwise><span class="text-muted">—</span></c:otherwise>
                                </c:choose>
                            </td>

                            <%-- Phản hồi của shop --%>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty f.response}">
                                        <div class="response-preview text-truncate-2" title="${f.response}">
                                            <i class="bi bi-shop me-1"></i>${f.response}
                                        </div>
                                        <c:if test="${not empty f.respondedAt}">
                                            <small class="text-muted d-block mt-1">
                                                <i class="bi bi-clock-history me-1"></i>${f.respondedAt.toString().replace('T',' ').substring(0,16)}
                                            </small>
                                        </c:if>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="text-muted small fst-italic">
                                            <i class="bi bi-dash-circle me-1"></i>Chưa có phản hồi
                                        </span>
                                    </c:otherwise>
                                </c:choose>
                            </td>

                            <%-- Trạng thái --%>
                            <td>
                                <c:choose>
                                    <c:when test="${f.status == 1}">
                                        <span class="badge rounded-pill bg-success fw-normal px-3 py-2">
                                            <i class="bi bi-check-circle-fill me-1"></i>Đã phản hồi
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge rounded-pill bg-warning text-dark fw-normal px-3 py-2">
                                            <i class="bi bi-clock-fill me-1"></i>Chờ xử lý
                                        </span>
                                    </c:otherwise>
                                </c:choose>
                            </td>

                            <%-- Thao tác --%>
                            <td class="text-center">
                                <button class="btn btn-sm ${f.status == 1 ? 'btn-outline-primary' : 'btn-primary'} rounded-pill px-3"
                                        data-bs-toggle="modal"
                                        data-bs-target="#replyModal${f.reviewId}">
                                    <c:choose>
                                        <c:when test="${f.status == 1}">
                                            <i class="bi bi-pencil-fill me-1"></i>Sửa
                                        </c:when>
                                        <c:otherwise>
                                            <i class="bi bi-reply-fill me-1"></i>Trả lời
                                        </c:otherwise>
                                    </c:choose>
                                </button>
                            </td>
                        </tr>
                    </c:forEach>

                    <c:if test="${empty feedbackList}">
                        <tr>
                            <td colspan="9" class="text-center py-5 text-muted">
                                <i class="bi bi-chat-square-dots fs-2 d-block mb-2 opacity-50"></i>
                                Chưa có đánh giá nào từ khách hàng.
                            </td>
                        </tr>
                    </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<%-- ===== MODALS ===== --%>
<c:forEach items="${feedbackList}" var="f">
    <div class="modal fade" id="replyModal${f.reviewId}" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content border-0 shadow">
                <form action="feedback" method="POST">
                    <div class="modal-header bg-primary text-white">
                        <h5 class="modal-title">
                            <i class="bi bi-reply-fill me-2"></i>
                            Phản hồi đánh giá
                            <span class="badge bg-white text-primary ms-1 small">#${f.reviewId}</span>
                        </h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body p-4">
                        <input type="hidden" name="reviewId" value="${f.reviewId}">

                        <%-- Thông tin review --%>
                        <div class="mb-4 p-3 bg-light rounded border">
                            <div class="d-flex justify-content-between align-items-start mb-2">
                                <div>
                                    <div class="fw-semibold">
                                        <i class="bi bi-person-circle text-primary me-1"></i>${f.subject}
                                    </div>
                                    <div class="small text-muted">
                                        <i class="bi bi-bag-fill text-success me-1"></i>${f.productName}
                                    </div>
                                </div>
                                <div class="text-end">
                                    <div>
                                        <span class="stars fs-5">
                                            <c:forEach begin="1" end="${f.rating}">★</c:forEach>
                                        </span><span class="stars-empty fs-5">
                                            <c:forEach begin="1" end="${5 - f.rating}">★</c:forEach>
                                        </span>
                                    </div>
                                    <small class="text-muted">${f.rating}/5</small>
                                </div>
                            </div>
                            <div class="border-start border-primary border-3 ps-3 fst-italic small text-dark">
                                "${f.content}"
                            </div>
                            <c:if test="${not empty f.createdAt}">
                                <small class="text-muted mt-2 d-block">
                                    <i class="bi bi-calendar3 me-1"></i>
                                    Đánh giá lúc: ${f.createdAt.toString().replace('T',' ').substring(0,16)}
                                </small>
                            </c:if>
                        </div>

                        <%-- Phản hồi hiện tại (nếu đã có) --%>
                        <c:if test="${f.status == 1 and not empty f.response}">
                            <div class="mb-3 p-3 rounded border border-success bg-success bg-opacity-10">
                                <div class="small fw-bold text-success mb-1">
                                    <i class="bi bi-shop me-1"></i>Phản hồi hiện tại của shop:
                                </div>
                                <div class="text-dark small">${f.response}</div>
                                <c:if test="${not empty f.respondedAt}">
                                    <small class="text-muted mt-1 d-block">
                                        <i class="bi bi-clock-history me-1"></i>
                                        Phản hồi lúc: ${f.respondedAt.toString().replace('T',' ').substring(0,16)}
                                    </small>
                                </c:if>
                            </div>
                        </c:if>

                        <%-- Textarea --%>
                        <div>
                            <label class="form-label fw-bold text-primary small">
                                <i class="bi bi-pencil me-1"></i>
                                <c:choose>
                                    <c:when test="${f.status == 1}">CHỈNH SỬA PHẢN HỒI CỦA SHOP:</c:when>
                                    <c:otherwise>NỘI DUNG PHẢN HỒI CỦA SHOP:</c:otherwise>
                                </c:choose>
                            </label>
                            <textarea name="responseText"
                                      class="form-control"
                                      rows="4"
                                      placeholder="Nhập lời cảm ơn hoặc giải thích cho khách hàng..."
                                      required>${f.response}</textarea>
                        </div>
                    </div>
                    <div class="modal-footer bg-light border-0">
                        <button type="button" class="btn btn-outline-secondary rounded-pill px-4" data-bs-dismiss="modal">
                            <i class="bi bi-x me-1"></i>Đóng
                        </button>
                        <button type="submit" class="btn btn-primary rounded-pill px-4 fw-bold">
                            <i class="bi bi-send-fill me-1"></i>
                            <c:choose>
                                <c:when test="${f.status == 1}">Cập nhật phản hồi</c:when>
                                <c:otherwise>Gửi phản hồi</c:otherwise>
                            </c:choose>
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</c:forEach>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
function filterTable(type) {
    document.querySelectorAll('.filter-tab').forEach(t => t.classList.remove('active'));
    document.getElementById('tab-' + type).classList.add('active');
    document.querySelectorAll('.feedback-row').forEach(row => {
        row.style.display = (type === 'all' || row.dataset.status === type) ? '' : 'none';
    });
}
</script>
</body>
</html>