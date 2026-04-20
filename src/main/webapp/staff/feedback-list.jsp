<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Quản lý Phản hồi</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="bg-light">
<c:choose>
    <c:when test="${sessionScope.user.roleId == 1 || sessionScope.user.roleId == 2}">
        <jsp:include page="../components/admin-nav.jsp">
            <jsp:param name="active" value="feedback" />
        </jsp:include>
    </c:when>
    <c:otherwise>
        <jsp:include page="../components/staff-nav.jsp">
            <jsp:param name="active" value="feedback" />
        </jsp:include>
    </c:otherwise>
</c:choose>

<div class="container pb-5">
    <h2 class="mb-4">Hồi đáp đánh giá sản phẩm</h2>

    <div class="card shadow-sm">
        <table class="table table-striped align-middle mb-0">
            <thead class="table-dark">
            <tr>
                <th>ID Review</th>
                <th>Khách hàng</th>
                <th>Nội dung đánh giá</th>
                <th>Số sao</th>
                <th>Trạng thái hồi đáp</th>
                <th>Thao tác</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach items="${feedbackList}" var="f">
                <tr>
                    <td>#REV-${f.reviewId}</td>
                    <td><strong>${f.subject}</strong></td>
                    <td><small class="text-truncate d-inline-block" style="max-width: 300px;">${f.content}</small></td>
                    <td class="text-warning">
                        <c:forEach begin="1" end="${f.rating}">★</c:forEach>
                    </td>
                    <td>
                        <c:choose>
                            <c:when test="${f.status == 1}">
                                <span class="badge bg-success"><i class="bi bi-check-circle me-1"></i>Đã phản hồi</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge bg-warning"><i class="bi bi-clock me-1"></i>Chờ xử lý</span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <button class="btn btn-primary btn-sm rounded-pill px-3" data-bs-toggle="modal" data-bs-target="#replyModal${f.reviewId}">
                            <i class="bi bi-reply-fill me-1"></i>Trả lời
                        </button>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
</div>

<c:forEach items="${feedbackList}" var="f">
    <div class="modal fade" id="replyModal${f.reviewId}" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow">
                <form action="feedback" method="POST">
                    <div class="modal-header bg-primary text-white">
                        <h5 class="modal-title">Hồi đáp Review #${f.reviewId}</h5>
                        <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body p-4">
                        <input type="hidden" name="reviewId" value="${f.reviewId}">
                        <div class="mb-3">
                            <label class="form-label fw-bold text-muted small">NỘI DUNG ĐÁNH GIÁ CỦA KHÁCH:</label>
                            <div class="bg-light p-3 rounded italic">"${f.content}"</div>
                        </div>
                        <hr>
                        <div class="mb-0">
                            <label class="form-label fw-bold small text-primary">NỘI DUNG PHẢN HỒI CỦA SHOP:</label>
                            <textarea name="responseText" class="form-control" rows="5" placeholder="Nhập lời cảm ơn hoặc giải thích cho khách hàng..." required>${f.response}</textarea>
                        </div>
                    </div>
                    <div class="modal-footer bg-light">
                        <button type="button" class="btn btn-secondary rounded-pill px-4" data-bs-dismiss="modal">Đóng</button>
                        <button type="submit" class="btn btn-primary rounded-pill px-4 fw-bold">Gửi phản hồi ngay</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</c:forEach>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>