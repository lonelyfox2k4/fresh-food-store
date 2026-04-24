<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Quản lý Tin tức | Fresh Food Store</title>
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <!-- Bootstrap 5 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- FontAwesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <jsp:include page="../components/admin-style.jsp" />
</head>
<body>
    <jsp:include page="../components/admin-nav.jsp">
        <jsp:param name="active" value="news" />
    </jsp:include>

    <div class="page-header mt-n2 mb-4">
        <div class="container-fluid px-4 d-flex justify-content-between align-items-center">
            <div>
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb mb-1">
                        <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/staff/news">Marketing</a></li>
                        <li class="breadcrumb-item active">Tin tức</li>
                    </ol>
                </nav>
                <h2 class="fw-800 mb-0">Quản lý Bài viết & Tin tức</h2>
                <p class="text-white-50 small mb-0 mt-1">Đăng tin khuyến mãi và cập nhật xu hướng thực phẩm sạch.</p>
            </div>
            <div class="d-flex gap-2">
                <a href="${pageContext.request.contextPath}/staff/news" class="btn btn-brand-outline shadow-sm rounded-pill bg-white text-dark">
                    <i class="fas fa-sync-alt"></i> Làm mới
                </a>
                <a href="${pageContext.request.contextPath}/staff/news?action=create" class="btn btn-brand shadow-sm rounded-pill">
                    <i class="fas fa-plus-circle me-2"></i> Soạn bài mới
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
                            <th class="ps-4">ID / Ảnh</th>
                            <th>Tiêu đề & Tóm tắt</th>
                            <th>Trạng thái</th>
                            <th>Ngày cập nhật</th>
                            <th class="text-end pe-4">Thao tác</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach items="${newsList}" var="n">
                            <tr>
                                <td class="ps-4">
                                    <div class="text-muted small mb-1">#${n.newsId}</div>
                                    <c:choose>
                                        <c:when test="${not empty n.imageUrl}">
                                            <img src="${n.imageUrl}" class="rounded-3 shadow-sm" style="width: 60px; height: 60px; object-fit: cover;">
                                        </c:when>
                                        <c:otherwise>
                                            <div class="bg-light rounded-3 d-flex align-items-center justify-content-center border" style="width: 60px; height: 60px;">
                                                <i class="bi bi-image text-muted opacity-50"></i>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <div class="fw-bold text-dark fs-6 mb-1">${n.title}</div>
                                    <div class="text-muted small text-truncate" style="max-width: 450px;">${n.summary}</div>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${n.status == 2}">
                                            <span class="badge rounded-pill bg-success-subtle text-success border border-success px-3">
                                                <i class="fas fa-check-circle me-1"></i> Đã đăng
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge rounded-pill bg-secondary-subtle text-secondary border border-secondary px-3">
                                                <i class="fas fa-edit me-1"></i> Bản nháp
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="small text-muted">
                                    <i class="far fa-calendar-alt me-1"></i> ${n.createdAt}
                                </td>
                                <td class="text-end pe-4">
                                    <div class="btn-group shadow-sm rounded-pill overflow-hidden">
                                        <a href="news?action=edit&newsId=${n.newsId}" class="btn btn-light btn-sm text-primary border-0" title="Chỉnh sửa">
                                            <i class="bi bi-pencil-square"></i>
                                        </a>
                                        <form action="news" method="POST" class="d-inline m-0" onsubmit="return confirm('Bạn có chắc muốn XÓA VĨNH VIỄN bài này?')">
                                            <input type="hidden" name="action" value="delete">
                                            <input type="hidden" name="newsId" value="${n.newsId}">
                                            <button type="submit" class="btn btn-light btn-sm text-danger border-0" title="Xóa">
                                                <i class="bi bi-trash"></i>
                                            </button>
                                        </form>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty newsList}">
                            <tr>
                                <td colspan="5" class="text-center py-5 text-muted">
                                    <i class="bi bi-newspaper fs-1 d-block mb-3 opacity-25"></i>
                                    Chưa có bài viết nào.
                                </td>
                            </tr>
                        </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>