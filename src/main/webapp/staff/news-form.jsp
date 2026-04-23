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
<body class="bg-light">
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

                            <c:if test="${not empty error}">
                                <div class="alert alert-danger alert-dismissible fade show border-0 shadow-sm rounded-4 mb-4" role="alert">
                                    <div class="d-flex align-items-center">
                                        <i class="bi bi-exclamation-triangle-fill fs-4 me-3"></i>
                                        <div>
                                            <div class="fw-bold">Lỗi nhập liệu</div>
                                            ${error}
                                        </div>
                                    </div>
                                    <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                                </div>
                            </c:if>

                            <form action="news" method="POST">
                                <input type="hidden" name="action" value="${news != null ? 'update' : 'create'}">

                                <c:if test="${news != null}">
                                    <input type="hidden" name="newsId" value="${news.newsId}">
                                </c:if>

                                <div class="mb-4">
                                    <label class="form-label">Tiêu đề <span class="text-danger">*</span></label>
                                    <input type="text" name="title" class="form-control form-control-lg"
                                        value="<c:out value='${news.title}'/>" 
                                        maxlength="150" required placeholder="Nhập tiêu đề (5 - 150 ký tự)">
                                    <div class="form-text">Tiêu đề nên súc tích để không bị tràn dòng trên di động.</div>
                                </div>

                                <div class="mb-4">
                                    <label class="form-label">Tóm tắt ngắn <span class="text-danger">*</span></label>
                                    <textarea name="summary" class="form-control" rows="2"
                                        maxlength="300" required placeholder="Mô tả ngắn gọn nội dung bài viết..."><c:out value='${news.summary}'/></textarea>
                                    <div class="form-text">Tối đa 300 ký tự.</div>
                                </div>

                                <div class="mb-4">
                                    <label class="form-label">Link ảnh đại diện</label>
                                    <input type="text" name="imageUrl" class="form-control"
                                        value="<c:out value='${news.imageUrl}'/>" placeholder="https://...">
                                </div>

                                <div class="mb-4">
                                    <label class="form-label">Nội dung chi tiết <span
                                            class="text-danger">*</span></label>
                                    <textarea name="content" id="newsContent" class="form-control" rows="12"><c:out value='${news.content}'/></textarea>
                                </div>

                                <hr class="my-4">

                                <div class="d-flex justify-content-between align-items-center">
                                    <a href="news?action=list" class="btn btn-light shadow-sm text-secondary px-4 py-2 rounded-pill fw-bold"
                                        onclick="return confirm('Mọi dữ liệu chưa lưu sẽ mất. Thoát?')">
                                        <i class="bi bi-arrow-left me-2"></i> Quay lại
                                    </a>

                                    <div class="btn-group shadow-lg rounded-pill overflow-hidden">
                                        <button type="submit" name="submitBtn" value="draft"
                                            class="btn btn-outline-primary bg-white px-4 py-2">
                                            <i class="bi bi-bookmark-plus me-2"></i> Lưu nháp
                                        </button>
                                        <button type="submit" name="submitBtn" value="publish"
                                            class="btn btn-success px-5 py-2 fw-bold">
                                            <i class="bi bi-send-check me-2"></i> Đăng ngay
                                        </button>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
            <!-- TinyMCE Rich Text Editor -->
            <script src="https://cdn.tiny.cloud/1/no-api-key/tinymce/6/tinymce.min.js" referrerpolicy="origin"></script>
            <script>
                tinymce.init({
                    selector: '#newsContent',
                    plugins: 'advlist autolink lists link image charmap preview anchor searchreplace visualblocks code fullscreen insertdatetime media table help wordcount',
                    toolbar: 'undo redo | formatselect | bold italic backcolor | alignleft aligncenter alignright alignjustify | bullist numlist outdent indent | removeformat | help',
                    height: 500,
                    menubar: false,
                    branding: false
                });

                // Validation Script
                document.querySelector('form').addEventListener('submit', function(e) {
                    const title = this.title.value.trim();
                    const summary = this.summary.value.trim();
                    const content = tinymce.get('newsContent').getContent().trim();

                    if (title.length < 5 || title.length > 150) {
                        alert("Tiêu đề phải từ 5 đến 150 ký tự!");
                        e.preventDefault();
                        return;
                    }
                    if (summary.length < 10 || summary.length > 300) {
                        alert("Tóm tắt phải từ 10 đến 300 ký tự!");
                        e.preventDefault();
                        return;
                    }
                    if (content === "") {
                        alert("Nội dung bài viết không được để trống!");
                        e.preventDefault();
                        return;
                    }
                });
            </script>
        </body>
        </html>