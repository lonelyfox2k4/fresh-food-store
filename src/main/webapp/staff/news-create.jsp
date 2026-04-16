<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Soạn thảo tin tức | Staff</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">

<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-lg-8">
            <div class="card border-0 shadow-sm">
                <div class="card-header bg-white py-3">
                    <h4 class="mb-0 fw-bold text-primary">✍️ Viết bài báo mới</h4>
                </div>
                <div class="card-body p-4">
                    <form action="${pageContext.request.contextPath}/staff/news" method="POST">
                        <input type="hidden" name="action" value="create">

                        <div class="mb-3">
                            <label class="form-label fw-bold">Tiêu đề bài viết <span class="text-danger">*</span></label>
                            <input type="text" name="title" class="form-control form-control-lg" placeholder="Nhập tiêu đề..." required>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-bold">Tóm tắt (Summary)</label>
                            <textarea name="summary" class="form-control" rows="2" placeholder="Hiển thị ngắn gọn ở trang chủ..."></textarea>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-bold">Nội dung chi tiết</label>
                            <textarea name="content" class="form-control" rows="8" placeholder="Viết toàn bộ nội dung tin tức tại đây..."></textarea>
                        </div>

                        <div class="mb-4">
                            <label class="form-label fw-bold">Link ảnh bìa (URL)</label>
                            <input type="text" name="imageUrl" class="form-control" placeholder="https://example.com/hinh-anh.jpg">
                        </div>

                        <div class="d-flex justify-content-between pt-3 border-top">
                            <a href="${pageContext.request.contextPath}/staff/news" class="btn btn-light px-4">Quay lại</a>
                            <button type="submit" class="btn btn-primary px-5 shadow-sm">Lưu bản nháp</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

</body>
</html>