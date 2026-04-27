<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Quản lý Phản hồi | Fresh Food Store</title>
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <!-- Bootstrap 5 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- FontAwesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <jsp:include page="../components/admin-style.jsp" />
    <style>
        .feedback-content-box { 
            background: #f8f9fa; 
            border-left: 4px solid #00b894; 
            border-radius: 8px;
            font-style: italic;
        }
        .rating-stars i { color: #f1c40f; font-size: 0.9rem; }
    </style>
</head>
<body class="bg-light">
    <jsp:include page="../components/admin-nav.jsp">
        <jsp:param name="active" value="feedback" />
    </jsp:include>

    <div class="page-header mt-n2 mb-4">
        <div class="container-fluid px-4 d-flex justify-content-between align-items-center">
            <div>
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb mb-1">
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/staff/news">Marketing</a></li>
                        <li class="breadcrumb-item active">Phản hồi</li>
                    </ol>
                </nav>
                <h2 class="fw-800 mb-0">Chăm sóc Khách hàng</h2>
                <p class="text-white-50 small mb-0 mt-1">Lắng nghe ý kiến và giải đáp thắc mắc từ khách hàng.</p>
            </div>
            <div class="d-flex gap-2">
                <a href="feedback" class="btn btn-brand-outline shadow-sm rounded-pill bg-white text-dark">
                    <i class="fas fa-sync-alt"></i> Làm mới
                </a>
            </div>
        </div>
    </div>

    <div class="container-fluid px-4 pb-5">
        <div class="user-table-card">
            <div class="card-body p-0">
                <div class="table-responsive">
                    <table class="table table-hover align-middle mb-0">
                        <thead>
                        <tr>
                            <th class="ps-4">Khách hàng</th>
                            <th>Đơn hàng</th>
                            <th>Nội dung đánh giá</th>
                            <th>Xếp hạng</th>
                            <th>Trạng thái</th>
                            <th class="text-end pe-4">Thao tác</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach items="${feedbackList}" var="f">
                            <tr>
                                <td class="ps-4">
                                    <div class="fw-bold text-dark fs-6 mb-1">${f.customerName}</div>
                                    <div class="d-flex align-items-center gap-2">
                                        <small class="text-muted"><i class="far fa-clock me-1"></i> ${f.createdAt.toString().replace('T', ' ').substring(0, 16)}</small>
                                        <c:choose>
                                            <c:when test="${not empty f.reviewId}">
                                                <span class="badge bg-info-subtle text-info border border-info-subtle extra-small py-0 px-2" style="font-size: 0.65rem;">Đánh giá SP</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-secondary-subtle text-secondary border border-secondary-subtle extra-small py-0 px-2" style="font-size: 0.65rem;">Góp ý chung</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${not empty f.orderCode}">
                                            <a href="orders?action=detail&id=${f.orderId}&from=feedback" class="badge bg-primary-subtle text-primary text-decoration-none py-2 px-3 border border-primary-subtle">
                                                <i class="fas fa-receipt me-1"></i> #${f.orderCode}
                                            </a>
                                        </c:when>
                                        <c:otherwise><span class="text-muted small">Khách vãng lai</span></c:otherwise>
                                    </c:choose>
                                </td>
                                <td style="max-width: 350px;">
                                    <div class="text-truncate-2 small text-dark fw-500" title="${f.content}">
                                        ${f.content}
                                    </div>
                                </td>
                                <td>
                                    <div class="rating-stars">
                                        <c:forEach begin="1" end="${f.rating}"><i class="fas fa-star me-1"></i></c:forEach>
                                        <c:forEach begin="${f.rating + 1}" end="5"><i class="far fa-star me-1 opacity-25"></i></c:forEach>
                                    </div>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${f.status == 0}">
                                            <span class="badge rounded-pill bg-warning-subtle text-warning border border-warning px-3 small">
                                                <i class="fas fa-hourglass-half me-1"></i> Chờ trả lời
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge rounded-pill bg-success-subtle text-success border border-success px-3 small">
                                                <i class="fas fa-check-circle me-1"></i> Đã phản hồi
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="text-end pe-4">
                                    <button class="btn btn-brand btn-sm rounded-pill px-4 shadow-sm" data-bs-toggle="modal" data-bs-target="#replyModal${f.feedbackId > 0 ? f.feedbackId : 'rv'.concat(f.reviewId)}">
                                        <i class="fas fa-reply me-2"></i> ${f.status == 0 ? 'Phản hồi' : 'Xem lại'}
                                    </button>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty feedbackList}">
                            <tr>
                                <td colspan="6" class="text-center py-5 text-muted">
                                    <i class="bi bi-chat-left-dots fs-1 d-block mb-3 opacity-25"></i>
                                    Chưa có phản hồi nào từ khách hàng.
                                </td>
                            </tr>
                        </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!-- Modals -->
    <c:forEach items="${feedbackList}" var="f">
        <div class="modal fade" id="replyModal${f.feedbackId > 0 ? f.feedbackId : 'rv'.concat(f.reviewId)}" tabindex="-1">
            <div class="modal-dialog modal-dialog-centered modal-lg">
                <div class="modal-content border-0 shadow-lg rounded-4 overflow-hidden">
                    <form action="feedback" method="POST">
                        <div class="modal-header bg-brand text-white py-3 border-0">
                            <h5 class="modal-title fw-bold">
                                <i class="fas fa-comment-dots me-2"></i>
                                <c:choose>
                                    <c:when test="${f.feedbackId > 0}">Chi tiết Phản hồi #${f.feedbackId}</c:when>
                                    <c:otherwise>Phản hồi Đánh giá SP #${f.reviewId}</c:otherwise>
                                </c:choose>
                            </h5>
                            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                        </div>
                        <div class="modal-body p-4">
                            <input type="hidden" name="feedbackId" value="${f.feedbackId}">
                            <input type="hidden" name="reviewId" value="${f.reviewId}">
                            
                            <div class="row mb-4">
                                <div class="col-md-6 border-end">
                                    <label class="form-label fw-bold text-secondary text-uppercase small">Nội dung khách hàng gửi</label>
                                    <div class="p-3 feedback-content-box mb-3 border">
                                        "${f.content}"
                                    </div>
                                    <div class="small text-muted">
                                        <strong>Khách hàng:</strong> ${f.customerName} <br>
                                        <strong>Ngày gửi:</strong> ${f.createdAt}
                                    </div>
                                </div>
                                <div class="col-md-6 ps-md-4">
                                    <c:if test="${not empty f.itemList}">
                                        <label class="form-label fw-bold text-secondary text-uppercase small">Sản phẩm đánh giá</label>
                                        <div class="list-group list-group-flush mb-3 border rounded">
                                            <c:forEach items="${f.itemList}" var="item">
                                                <div class="list-group-item bg-light-subtle d-flex justify-content-between align-items-center py-2 px-3 small">
                                                    <div>
                                                        <span class="fw-bold">${item.productNameSnapshot}</span>
                                                        <div class="text-muted x-small">${item.packWeightGramSnapshot}g</div>
                                                    </div>
                                                    <span class="badge rounded-pill bg-brand-outline text-dark border">x${item.orderedQuantity}</span>
                                                </div>
                                            </c:forEach>
                                        </div>
                                    </c:if>
                                </div>
                            </div>
                            
                            <div class="mb-0">
                                <label class="form-label fw-bold text-secondary text-uppercase small">Nội dung phản hồi (Staff)</label>
                                <textarea name="responseText" class="form-control border-2 shadow-none" rows="6" 
                                          placeholder="Nhập lời cảm ơn hoặc giải đáp thắc mắc tại đây..." 
                                          required style="border-radius: 12px;">${f.response}</textarea>
                                <div class="mt-2 text-muted x-small">
                                    <i class="fas fa-info-circle me-1"></i> Phản hồi sẽ được gửi qua email cho khách hàng và hiển thị trên web.
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer border-top-0 p-4 pt-0">
                            <button type="button" class="btn btn-light px-4 rounded-pill" data-bs-dismiss="modal">Đóng</button>
                            <button type="submit" class="btn btn-brand px-5 rounded-pill shadow">
                                <i class="fas fa-paper-plane me-2"></i>Gửi phản hồi ngay
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </c:forEach>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>