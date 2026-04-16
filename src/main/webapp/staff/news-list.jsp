<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Góc Biên Tập | Staff</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
</head>
<body class="bg-light">

<div class="container py-5">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h2 class="fw-bold text-primary">📰 Quản lý bài viết của tôi</h2>
            <p class="text-muted">Chào mừng Staff! Hãy soạn thảo và gửi duyệt bài viết tại đây.</p>
        </div>
        <a href="${pageContext.request.contextPath}/staff/news?action=create" class="btn btn-primary shadow-sm">
            <i class="bi bi-pencil-plus"></i> Viết bài mới
        </a>
    </div>

    <c:if test="${not empty param.msg}">
        <div class="alert alert-success border-0 shadow-sm alert-dismissible fade show">
            <i class="bi bi-check-circle-fill me-2"></i> ${param.msg}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <div class="card border-0 shadow-sm">
        <div class="card-body p-0">
            <table class="table table-hover align-middle mb-0">
                <thead class="table-light">
                <tr>
                    <th class="ps-4">ID</th>
                    <th>Tiêu đề</th>
                    <th>Trạng thái</th>
                    <th>Ngày tạo</th>
                    <th class="text-center">Thao tác</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${newsList}" var="news">
                    <tr>
                        <td class="ps-4 text-muted">#${news.newsId}</td>
                        <td>
                            <div class="fw-bold">${news.title}</div>
                            <small class="text-muted text-truncate d-block" style="max-width: 350px;">${news.summary}</small>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${news.status == 0}"><span class="badge bg-secondary">Bản nháp</span></c:when>
                                <c:when test="${news.status == 1}"><span class="badge bg-warning text-dark">Đang chờ duyệt</span></c:when>
                                <c:when test="${news.status == 2}"><span class="badge bg-success">Đã đăng</span></c:when>
                            </c:choose>
                        </td>
                        <td class="small">${news.createdAt}</td>
                        <td class="text-center">
                            <c:if test="${news.status == 0}">
                                <form action="${pageContext.request.contextPath}/staff/news" method="POST" class="d-inline">
                                    <input type="hidden" name="action" value="submit">
                                    <input type="hidden" name="newsId" value="${news.newsId}">
                                    <button type="submit" class="btn btn-sm btn-info text-white">Gửi duyệt</button>
                                </form>
                                <a href="${pageContext.request.contextPath}/staff/news?action=edit&newsId=${news.newsId}" class="btn btn-sm btn-outline-primary ms-1">Sửa</a>
                            </c:if>
                            <c:if test="${news.status != 0}">
                                <span class="text-muted small">Đã gửi bài</span>
                            </c:if>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty newsList}">
                    <tr><td colspan="5" class="text-center py-4 text-muted">Chưa có bài viết nào trong hệ thống.</td></tr>
                </c:if>
                </tbody>
            </table>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>