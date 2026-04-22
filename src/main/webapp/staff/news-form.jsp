<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
    <title>${news != null ? 'Chỉnh sửa' : 'Tạo mới'} bài viết | Fresh Food</title>
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
        .form-label { font-weight: bold; color: #495057; }
        .card { border-radius: 15px; border: none; box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.1); }
    </style>
</head>
<body>
<jsp:include page="../components/admin-nav.jsp">
    <jsp:param name="active" value="news" />
</jsp:include>

<div class="container py-3">
    <div class="row justify-content-center">
        <div class="col-lg-10">
            <div class="card p-4 p-md-5">
                <h2 class="fw-bold mb-4 text-primary">
                    <i class="bi ${news != null ? 'bi-pencil-square' : 'bi-plus-circle-dotted'}"></i>
                    ${news != null ? 'Chỉnh sửa bài viết' : 'Soạn bài mới'}
                </h2>

                <form action="news" method="POST">
                    <input type="hidden" name="action" value="${news != null ? 'update' : 'create'}">

                    <c:if test="${news != null}">
                        <input type="hidden" name="newsId" value="${news.newsId}">
                    </c:if>

                    <div class="mb-4">
                        <label class="form-label">Tiêu đề <span class="text-danger">*</span></label>
                        <input type="text" name="title" class="form-control form-control-lg"
                               value="<c:out value='${news.title}'/>" required>
                    </div>

                    <div class="mb-4">
                        <label class="form-label">Tóm tắt ngắn <span class="text-danger">*</span></label>
                        <textarea name="summary" class="form-control" rows="2" required><c:out value='${news.summary}'/></textarea>
                    </div>

                    <div class="mb-4">
                        <label class="form-label">Link ảnh đại diện</label>
                        <input type="text" name="imageUrl" class="form-control"
                               value="<c:out value='${news.imageUrl}'/>" placeholder="https://...">
                    </div>

                    <div class="mb-4">
                        <label class="form-label">Nội dung chi tiết <span class="text-danger">*</span></label>
                        <textarea name="content" class="form-control" rows="12" required><c:out value='${news.content}'/></textarea>
                    </div>

                    <hr class="my-4">

                    <div class="d-flex justify-content-between align-items-center">
                        <a href="news?action=list" class="btn btn-outline-secondary px-4"
                           onclick="return confirm('Mọi dữ liệu chưa lưu sẽ mất. Thoát?')">
                            <i class="bi bi-arrow-left"></i> Quay lại
                        </a>

                        <div class="btn-group">
                            <button type="submit" name="submitBtn" value="draft" class="btn btn-outline-primary px-4">
                                <i class="bi bi-bookmark"></i> Lưu nháp
                            </button>
                            <button type="submit" name="submitBtn" value="publish" class="btn btn-success px-4">
                                <i class="bi bi-send-check"></i> Đăng ngay
                            </button>
                        </div>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
</body>
</html>