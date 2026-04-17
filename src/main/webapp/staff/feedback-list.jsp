<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Quản lý Phản hồi</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
</head>
<body class="bg-light">

<div class="container py-5">
    <h2 class="mb-4">Phản hồi khách hàng</h2>

    <div class="card shadow-sm">
        <table class="table table-striped align-middle mb-0">
            <thead class="table-dark">
            <tr>
                <th>ID</th>
                <th>Khách hàng</th>
                <th>Nội dung</th>
                <th>Đánh giá</th>
                <th>Trạng thái</th>
                <th>Thao tác</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach items="${feedbackList}" var="f">
                <tr>
                    <td>#${f.feedbackId}</td>
                    <td><strong>${f.customerName}</strong></td>
                    <td>${f.content}</td>
                    <td class="text-warning">
                        <c:forEach begin="1" end="${f.rating}">★</c:forEach>
                    </td>
                    <td>
                        <c:if test="${f.status == 0}">
                            <span class="badge bg-warning">Chưa trả lời</span>
                        </c:if>
                        <c:if test="${f.status == 1}">
                            <span class="badge bg-success">Đã xong</span>
                        </c:if>
                    </td>
                    <td>
                        <button class="btn btn-primary btn-sm" data-bs-toggle="modal" data-bs-target="#replyModal${f.feedbackId}">
                            Trả lời
                        </button>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>
</div>

<c:forEach items="${feedbackList}" var="f">
    <div class="modal fade" id="replyModal${f.feedbackId}" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <form action="feedback" method="POST">
                    <div class="modal-header">
                        <h5 class="modal-title">Trả lời #${f.feedbackId}</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <input type="hidden" name="feedbackId" value="${f.feedbackId}">
                        <p><strong>Khách viết:</strong> <i>"${f.content}"</i></p>
                        <hr>
                        <div class="mb-3">
                            <label class="form-label">Nội dung phản hồi:</label>
                            <textarea name="responseText" class="form-control" rows="4" required>${f.response}</textarea>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                        <button type="submit" class="btn btn-success">Gửi phản hồi</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</c:forEach>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>