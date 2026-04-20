<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>Quản lý Tin tức | Staff</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    <style>
        .text-truncate-2 {
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
            max-width: 420px;
        }
    </style>
</head>
<body class="bg-light">
<c:import url="/staff/common/nav.jsp" />

<div class="container-fluid py-3 px-4">

    <%-- Header --%>
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h3 class="fw-bold"><i class="bi bi-newspaper me-2"></i>Quản lý Tin tức</h3>
            <p class="text-muted small mb-0">Đăng và quản lý các bài viết của cửa hàng.</p>
        </div>
        <div class="d-flex gap-2">
            <a href="${pageContext.request.contextPath}/staff/news" class="btn btn-outline-secondary shadow-sm">
                <i class="bi bi-arrow-clockwise"></i> Làm mới
            </a>
            <a href="${pageContext.request.contextPath}/staff/news?action=create" class="btn btn-primary shadow-sm">
                <i class="bi bi-plus-circle me-1"></i> Viết bài mới
            </a>
        </div>
    </div>

    <%-- Alert --%>
    <c:if test="${not empty param.msg}">
        <div class="alert alert-success border-0 shadow-sm alert-dismissible fade show">
            <i class="bi bi-check-circle-fill me-2"></i>
            <c:choose>
                <c:when test="${param.msg == 'created'}">Đã tạo bài viết thành công!</c:when>
                <c:when test="${param.msg == 'updated'}">Đã cập nhật bài viết thành công!</c:when>
                <c:when test="${param.msg == 'deleted'}">Đã xóa bài viết thành công!</c:when>
                <c:when test="${param.msg == 'published'}">Bài viết đã được đăng lên!</c:when>
                <c:when test="${param.msg == 'unpublished'}">Bài viết đã được gỡ xuống!</c:when>
                <c:otherwise>Thao tác thành công!</c:otherwise>
            </c:choose>
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <%-- Table --%>
    <div class="card border-0 shadow-sm">
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-success">
                    <tr>
                        <th class="ps-4" style="width:60px;">#</th>
                        <th>Tiêu đề & Tóm tắt</th>
                        <th style="width:110px;">Trạng thái</th>
                        <th style="width:130px;">Ngày tạo</th>
                        <th class="text-center" style="width:150px;">Thao tác</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach items="${newsList}" var="n">
                        <tr>
                            <td class="ps-4 text-muted small">#${n.newsId}</td>
                            <td>
                                <div class="fw-semibold text-dark">${n.title}</div>
                                <div class="text-muted small text-truncate-2">${n.summary}</div>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${n.status == 2}">
                                        <span class="badge bg-success rounded-pill px-3 py-2">
                                            <i class="bi bi-cloud-check me-1"></i>Đã đăng
                                        </span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-secondary rounded-pill px-3 py-2">
                                            <i class="bi bi-file-earmark me-1"></i>Bản nháp
                                        </span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td class="small text-muted">
                                <c:if test="${not empty n.createdAt}">
                                    ${n.createdAt.toString().replace('T',' ').substring(0,16)}
                                </c:if>
                            </td>
                            <td class="text-center">
                                <div class="d-flex gap-1 justify-content-center flex-wrap">
                                    <%-- Nút sửa --%>
                                    <a href="${pageContext.request.contextPath}/staff/news?action=edit&newsId=${n.newsId}"
                                       class="btn btn-sm btn-outline-primary rounded-pill px-2"
                                       title="Chỉnh sửa">
                                        <i class="bi bi-pencil"></i>
                                    </a>

                                    <%-- Nút đăng / gỡ --%>
                                    <c:choose>
                                        <c:when test="${n.status != 2}">
                                            <form action="${pageContext.request.contextPath}/staff/news" method="POST" class="d-inline">
                                                <input type="hidden" name="action" value="changeStatus">
                                                <input type="hidden" name="newsId" value="${n.newsId}">
                                                <input type="hidden" name="status" value="2">
                                                <button type="submit" class="btn btn-sm btn-success rounded-pill px-2" title="Đăng bài">
                                                    <i class="bi bi-cloud-arrow-up"></i>
                                                </button>
                                            </form>
                                        </c:when>
                                        <c:otherwise>
                                            <form action="${pageContext.request.contextPath}/staff/news" method="POST" class="d-inline">
                                                <input type="hidden" name="action" value="changeStatus">
                                                <input type="hidden" name="newsId" value="${n.newsId}">
                                                <input type="hidden" name="status" value="0">
                                                <button type="submit" class="btn btn-sm btn-warning rounded-pill px-2" title="Gỡ bài">
                                                    <i class="bi bi-cloud-arrow-down"></i>
                                                </button>
                                            </form>
                                        </c:otherwise>
                                    </c:choose>

                                    <%-- Nút xóa --%>
                                    <form action="${pageContext.request.contextPath}/staff/news" method="POST" class="d-inline"
                                          onsubmit="return confirm('Bạn có chắc muốn XÓA VĨNH VIỄN bài này?')">
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="newsId" value="${n.newsId}">
                                        <button type="submit" class="btn btn-sm btn-outline-danger rounded-pill px-2" title="Xóa">
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
                                <i class="bi bi-newspaper fs-2 d-block mb-2 opacity-50"></i>
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