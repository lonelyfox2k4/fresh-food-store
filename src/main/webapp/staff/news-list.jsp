<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Quản lý tin tức | Fresh Food</title>
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
<div class="container pb-5">
<div class="page-header mt-n2 mb-4">
    <div class="container d-flex justify-content-between align-items-center">
        <div>
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb mb-1">
                    <li class="breadcrumb-item"><a href="${pageContext.request.contextPath}/staff/news">Marketing</a></li>
                    <li class="breadcrumb-item active">Tin tức</li>
                </ol>
            </nav>
            <h2 class="fw-800 mb-0">Quản lý bài viết</h2>
            <p class="text-white-50 small mb-0 mt-1">Quản lý và đăng tải các bài viết tin tức.</p>
        </div>
        <c:if test="${sessionScope.user.roleId != 1}">
            <a href="news?action=create" class="btn btn-brand shadow-sm rounded-pill"><i class="fas fa-plus-circle me-1"></i> Viết bài mới</a>
        </c:if>
    </div>
</div>

<div class="container pb-5">

    <div class="user-table-card">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead>
                <tr>
                    <th class="ps-4">ID</th>
                    <th>Tiêu đề & Tóm tắt</th>
                    <th>Trạng thái</th>
                    <th>Ngày tạo</th>
                    <c:if test="${sessionScope.user.roleId != 1}">
                        <th class="text-end pe-4">Thao tác</th>
                    </c:if>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${newsList}" var="n">
                    <tr>
                        <td class="ps-4 text-muted">#${n.newsId}</td>
                        <td>
                            <div class="fw-bold text-dark">${n.title}</div>
                            <small class="text-muted d-block text-truncate" style="max-width: 400px;">${n.summary}</small>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${n.status == 2}"><span class="badge-pill badge-active"><i class="fas fa-check-circle me-1 text-success"></i>Đã đăng</span></c:when>
                                <c:otherwise><span class="badge-pill badge-role"><i class="fas fa-clock me-1 text-secondary"></i>Bản nháp</span></c:otherwise>
                            </c:choose>
                        </td>
                        <td class="small text-muted">${n.createdAt}</td>
                        <c:if test="${sessionScope.user.roleId != 1}">
                            <td class="text-end pe-4">
                                <div class="d-flex justify-content-end gap-1">
                                    <a href="news?action=edit&newsId=${n.newsId}" class="btn-action btn-action-edit" title="Chỉnh sửa">
                                        <i class="fas fa-edit"></i>
                                    </a>

                                    <c:if test="${n.status == 0}">
                                        <form action="news" method="POST" class="d-inline m-0">
                                            <input type="hidden" name="action" value="changeStatus">
                                            <input type="hidden" name="newsId" value="${n.newsId}">
                                            <input type="hidden" name="status" value="2">
                                            <button type="submit" class="btn-action btn-action-view text-success border-success" title="Đăng bài">
                                                <i class="fas fa-cloud-upload-alt"></i>
                                            </button>
                                        </form>
                                    </c:if>

                                    <c:if test="${n.status == 2}">
                                        <form action="news" method="POST" class="d-inline m-0">
                                            <input type="hidden" name="action" value="changeStatus">
                                            <input type="hidden" name="newsId" value="${n.newsId}">
                                            <input type="hidden" name="status" value="0">
                                            <button type="submit" class="btn-action btn-action-view text-warning border-warning" title="Gỡ bài">
                                                <i class="fas fa-cloud-download-alt"></i>
                                            </button>
                                        </form>
                                    </c:if>

                                    <form action="news" method="POST" class="d-inline m-0" onsubmit="return confirm('Bạn có chắc muốn XÓA VĨNH VIỄN bài này?')">
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="newsId" value="${n.newsId}">
                                        <button type="submit" class="btn-action btn-action-delete">
                                            <i class="fas fa-trash-alt"></i>
                                        </button>
                                    </form>
                                </div>
                            </td>
                        </c:if>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</div>
</body>
</html>