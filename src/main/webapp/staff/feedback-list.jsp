<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Quản lý Phản hồi | Fresh Food</title>
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
        .star-rating {
            color: #fbbf24;
            font-size: 0.9rem;
        }
    </style>
</head>
<body>
<jsp:include page="../components/admin-nav.jsp">
    <jsp:param name="active" value="partners" />
</jsp:include>

<div class="page-header mt-n2 mb-4">
    <div class="container d-flex justify-content-between align-items-center">
        <div>
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb mb-1">
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/staff/feedback">Đối tác & CSKH</a></li>
                    <li class="breadcrumb-item active">Phản hồi khách hàng</li>
                </ol>
            </nav>
            <h2 class="fw-800 mb-0">Hồi đáp đánh giá sản phẩm</h2>
            <p class="text-white-50 small mb-0 mt-1">Quản lý và giải đáp các thắc mắc, phản hồi từ khách hàng.</p>
        </div>
    </div>
</div>

<div class="container pb-5">

    <div class="user-table-card">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead>
                <tr>
                    <th class="ps-4">Mã ĐH & Người đánh giá</th>
                    <th>Nội dung đánh giá</th>
                    <th class="text-center">Số sao</th>
                    <th>Trạng thái hồi đáp</th>
                    <th class="text-end pe-4">Thao tác</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${feedbackList}" var="f">
                    <tr>
                        <td class="ps-4">
                            <div class="fw-bold text-brand mb-1">
                                <a href="${pageContext.request.contextPath}/staff/orders?action=detail&id=${f.orderId}&from=feedback" class="text-decoration-none text-brand">
                                    <i class="fas fa-shopping-bag me-1 opacity-75"></i> #REV-${f.reviewId} (ĐH)
                                </a>
                            </div>
                            <div class="fw-semibold text-dark">${f.subject}</div>
                        </td>
                        <td>
                            <div class="text-truncate-2 small text-muted" style="max-width: 350px;" title="${f.content}">
                                <i class="fas fa-quote-left opacity-25 me-1"></i>${f.content}
                            </div>
                        </td>
                        <td class="text-center star-rating">
                            <c:forEach begin="1" end="${f.rating}"><i class="fas fa-star"></i></c:forEach><c:forEach begin="1" end="${5 - f.rating}"><i class="far fa-star text-black-50"></i></c:forEach>
                        </td>
                    <td>
                        <c:choose>
                            <c:when test="${f.status == 1}">
                                <span class="badge-pill badge-active"><i class="fas fa-check-circle me-1"></i>Đã phản hồi</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge-pill badge-role"><i class="fas fa-clock me-1 text-warning"></i>Chờ xử lý</span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td class="text-end pe-4">
                        <button class="btn btn-outline-brand rounded-pill btn-sm px-3 shadow-none fw-medium" data-bs-toggle="modal" data-bs-target="#replyModal${f.reviewId}">
                            <i class="fas fa-reply me-1"></i> ${f.status == 1 ? 'Sửa Hồi đáp' : 'Hồi đáp'}
                        </button>
                    </td>
                </tr>
                </c:forEach>
                <c:if test="${empty feedbackList}">
                    <tr><td colspan="5" class="text-center py-5 text-muted">Chưa có phản hồi nào.</td></tr>
                </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>

<c:forEach items="${feedbackList}" var="f">
    <div class="modal fade" id="replyModal${f.reviewId}" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow">
                <form action="feedback" method="POST">
                    <div class="modal-header bg-brand text-white border-0">
                        <h5 class="modal-title fw-bold"><i class="fas fa-reply me-2"></i>Hồi đáp Đánh giá #${f.reviewId}</h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body p-4">
                        <input type="hidden" name="reviewId" value="${f.reviewId}">
                        <div class="mb-4">
                            <label class="form-label fw-bold text-muted small mb-2"><i class="fas fa-user-circle me-1"></i> NỘI DUNG ĐÁNH GIÁ CỦA KHÁCH:</label>
                            <div class="p-3 rounded bg-slate-50 border border-slate-200 text-slate-700 fst-italic">
                                <i class="fas fa-quote-left text-muted opacity-50 me-2" style="font-size: 0.8rem"></i>${f.content}
                            </div>
                        </div>
                        <div class="mb-2">
                            <label class="form-label fw-bold small text-brand"><i class="fas fa-store me-1"></i> NỘI DUNG PHẢN HỒI CỦA SHOP CỦA SHOP:</label>
                            <textarea name="responseText" class="form-control" rows="5" placeholder="Nhập lời cảm ơn hoặc giải thích cho khách hàng..." required style="border-radius: 0.75rem;">${f.response}</textarea>
                        </div>
                    </div>
                    <div class="modal-footer border-0 p-4 pt-2">
                        <button type="button" class="btn btn-light rounded-pill px-4 fw-medium" data-bs-dismiss="modal">Đóng</button>
                        <button type="submit" class="btn btn-brand rounded-pill px-4 fw-bold shadow-sm"><i class="fas fa-paper-plane me-2"></i>Gửi phản hồi</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</c:forEach>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>