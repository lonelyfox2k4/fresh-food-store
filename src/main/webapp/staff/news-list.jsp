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

<div class="container-fluid py-3 px-4">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h3 class="fw-bold"><i class="bi bi-newspaper me-2"></i>Quản lý Bài viết</h3>
            <p class="text-muted small">Đăng tin tức và khuyến mãi lên website.</p>
        </div>
        <a href="news?action=create" class="btn btn-primary shadow-sm"><i class="bi bi-plus-circle"></i> Viết bài mới</a>
    </div>

    <div class="card border-0 shadow-sm">
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead class="table-dark">
                <tr>
                    <th class="ps-4">ID</th>
                    <th>Tiêu đề & Tóm tắt</th>
                    <th>Trạng thái</th>
                    <th>Ngày tạo</th>
                    <th class="text-end pe-4">Thao tác</th>
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
                                <c:when test="${n.status == 2}"><span class="badge bg-success">Đã đăng</span></c:when>
                                <c:otherwise><span class="badge bg-secondary">Bản nháp</span></c:otherwise>
                            </c:choose>
                        </td>
                        <td class="small text-muted">${n.createdAt}</td>
                        <td class="text-end pe-4">
                            <div class="btn-group">
                                <a href="news?action=edit&newsId=${n.newsId}" class="btn btn-sm btn-outline-primary" title="Chỉnh sửa">
                                    <i class="bi bi-pencil"></i>
                                </a>

                                <c:if test="${n.status == 0}">
                                    <form action="news" method="POST" class="d-inline ms-1">
                                        <input type="hidden" name="action" value="changeStatus">
                                        <input type="hidden" name="newsId" value="${n.newsId}">
                                        <input type="hidden" name="status" value="2">
                                        <button type="submit" class="btn btn-sm btn-success" title="Đăng bài">
                                            <i class="bi bi-cloud-arrow-up"></i>
                                        </button>
                                    </form>
                                </c:if>

                                <c:if test="${n.status == 2}">
                                    <form action="news" method="POST" class="d-inline ms-1">
                                        <input type="hidden" name="action" value="changeStatus">
                                        <input type="hidden" name="newsId" value="${n.newsId}">
                                        <input type="hidden" name="status" value="0">
                                        <button type="submit" class="btn btn-sm btn-warning text-white" title="Gỡ bài">
                                            <i class="bi bi-cloud-arrow-down"></i>
                                        </button>
                                    </form>
                                </c:if>

                                <form action="news" method="POST" class="d-inline ms-1" onsubmit="return confirm('Bạn có chắc muốn XÓA VĨNH VIỄN bài này?')">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="newsId" value="${n.newsId}">
                                    <button type="submit" class="btn btn-sm btn-outline-danger">
                                        <i class="bi bi-trash"></i>
                                    </button>
                                </form>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>
</body>
</html>