<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html lang="vi">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>${product != null ? 'Sửa' : 'Thêm'} Sản phẩm | Fresh Food</title>
            <!-- Google Fonts -->
            <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap"
                rel="stylesheet">
            <!-- Bootstrap 5 -->
            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
            <!-- Bootstrap Icons -->
            <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
            <!-- Flatpickr Datepicker -->
            <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">

            <style>
                :root {
                    --primary: #4f46e5;
                    --primary-light: #818cf8;
                    --slate-50: #f8fafc;
                    --slate-100: #f1f5f9;
                    --slate-200: #e2e8f0;
                    --slate-700: #334155;
                    --slate-800: #1e293b;
                    --slate-900: #0f172a;
                }

                body {
                    font-family: 'Inter', sans-serif;
                    background-color: #f3f4f6;
                    color: var(--slate-800);
                    min-height: 100vh;
                }

                .main-card {
                    background: white;
                    border: none;
                    border-radius: 1.25rem;
                    box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 8px 10px -6px rgba(0, 0, 0, 0.1);
                }

                .form-label {
                    font-size: 0.75rem;
                    font-weight: 700;
                    color: var(--slate-500);
                    text-transform: uppercase;
                    letter-spacing: 0.05em;
                    margin-bottom: 0.5rem;
                }

                .form-control,
                .form-select {
                    border: 1px solid var(--slate-200);
                    border-radius: 0.75rem;
                    padding: 0.75rem 1rem;
                    background-color: var(--slate-50);
                    transition: all 0.2s;
                }

                .form-control:focus,
                .form-select:focus {
                    border-color: var(--primary-light);
                    background-color: white;
                    box-shadow: 0 0 0 4px rgba(79, 70, 229, 0.1);
                }

                .btn-premium {
                    padding: 0.75rem 1.5rem;
                    border-radius: 0.75rem;
                    font-weight: 600;
                    transition: all 0.2s;
                }
            </style>
        </head>

        <body class="py-5">
            <div class="container">
                <div class="row justify-content-center">
                    <div class="col-md-9 col-lg-8">
                        <a href="products" class="text-decoration-none text-muted mb-4 d-inline-block fw-medium">
                            <i class="bi bi-arrow-left me-2"></i>Quay lại danh sách
                        </a>

                        <div class="main-card p-4 p-md-5">
                            <div class="mb-5 text-center">
                                <div
                                    class="bg-primary-subtle text-primary d-inline-flex align-items-center justify-content-center rounded-4 p-3 mb-3">
                                    <i class="bi bi-box-seam fs-3"></i>
                                </div>
                                <h2 class="fw-bold fs-3 text-dark mb-1">${product != null ? 'Cập nhật' : 'Ký gửi'} Sản
                                    phẩm</h2>
                                <p class="text-secondary small">Vui lòng điền đầy đủ các trường thông tin bên dưới để
                                    quản lý hàng hóa hiệu quả.</p>
                            </div>

                            <form action="products" method="POST" enctype="multipart/form-data">
                                <c:if test="${not empty error}">
                                    <div class="alert alert-danger border-0 rounded-4 mb-4 d-flex align-items-center">
                                        <i class="bi bi-exclamation-triangle-fill me-2"></i>
                                        <div>${error}</div>
                                    </div>
                                </c:if>
                                <input type="hidden" name="id" value="${product.productId}">

                                <div class="mb-4">
                                    <label class="form-label">Tên mặt hàng sản phẩm</label>
                                    <input type="text" name="productName" class="form-control"
                                        value="${product.productName}" placeholder="VD: Thịt bò Wagyu Nhập khẩu"
                                        required>
                                </div>

                                <div class="mb-4">
                                    <label class="form-label">Danh mục Phân loại</label>
                                    <select name="categoryId" class="form-select" required>
                                        <option value="" disabled ${product==null ? 'selected' : '' }>-- Chọn loại hàng
                                            --</option>
                                        <c:forEach var="cat" items="${categories}">
                                            <option value="${cat.categoryId}" ${product.categoryId==cat.categoryId
                                                ? 'selected' : '' }>${cat.categoryName}</option>
                                        </c:forEach>
                                    </select>
                                </div>

                                <div class="mb-4">
                                    <label class="form-label">Đối tác cung cấp (Supplier) *</label>
                                    <select name="supplierId" class="form-select" required>
                                        <option value="" disabled ${batchInfo.supplierId == null ? 'selected' : ''}>-- Chọn đối tác cung cấp --</option>
                                        <c:forEach var="sup" items="${suppliers}">
                                            <option value="${sup.supplierId}" ${batchInfo.supplierId == sup.supplierId ? 'selected' : ''}>
                                                ${sup.supplierName} - ${sup.phone}
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>

                                <div class="row g-4 mb-4">
                                    <div class="col-md-6">
                                        <label class="form-label" for="manufactureDate">Ngày nhập hàng (Manufacture Date)</label>
                                        <input type="text" id="manufactureDate" name="manufactureDate" class="form-control" 
                                            value="${batchInfo.manufactureDate}">
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label" for="expiryDate">Ngày hết hạn (Expiry Date) *</label>
                                        <input type="text" id="expiryDate" name="expiryDate" class="form-control" 
                                            value="${batchInfo.expiryDate}" required>
                                    </div>
                                </div>

                                <div class="mb-4">
                                    <label class="form-label">Chính sách giá áp dụng (Policy)</label>
                                    <select name="expiryPricingPolicyId" class="form-select">
                                        <option value="0" ${product.expiryPricingPolicyId==null ? 'selected' : '' }>--
                                            Không áp dụng (Giá niêm yết cố định) --</option>
                                        <c:forEach var="pol" items="${policies}">
                                            <option value="${pol.policyId}"
                                                ${product.expiryPricingPolicyId==pol.policyId ? 'selected' : '' }>
                                                ${pol.policyName} - ${pol.note}
                                            </option>
                                        </c:forEach>
                                    </select>
                                    <small class="text-muted mt-2 d-block">Hệ thống sẽ dùng kịch bản này để tự động tính
                                        giá dựa trên ngày hết hạn.</small>
                                </div>

                                <div class="row g-4 mb-4">
                                    <div class="col-md-6">
                                        <label class="form-label">Giá niêm yết (VNĐ)</label>
                                        <div class="input-group">
                                            <input type="number" name="basePriceAmount" class="form-control"
                                                value="${product.basePriceAmount}" placeholder="0" required>
                                            <span
                                                class="input-group-text border-0 bg-transparent fw-bold text-muted">đ</span>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="form-label">Trọng lượng cơ bản (gram)</label>
                                        <div class="input-group">
                                            <input type="number" name="priceBaseWeightGram" class="form-control"
                                                value="${product.priceBaseWeightGram}" placeholder="0" required>
                                            <span
                                                class="input-group-text border-0 bg-transparent fw-bold text-muted">g</span>
                                        </div>
                                    </div>
                                </div>

                                <div class="mb-4">
                                    <label class="form-label">Tải lên hình ảnh sản phẩm</label>
                                    <div class="input-group">
                                        <span class="input-group-text bg-light border-0"><i
                                                class="bi bi-image text-muted"></i></span>
                                        <input type="file" name="imageFile" class="form-control" accept="image/*">
                                    </div>
                                    <c:if test="${not empty product.imageUrl}">
                                        <div class="mt-2 text-center">
                                            <img src="${product.imageUrl}" alt="Current Image"
                                                style="max-height: 120px; border-radius: 8px; border: 1px solid #ccc;">
                                            <p class="small text-muted mt-1 mb-0">Ảnh hiện tại</p>
                                        </div>
                                    </c:if>
                                    <input type="hidden" name="existingImageUrl" value="${product.imageUrl}">
                                </div>

                                <div class="mb-4">
                                    <label class="form-label">Mô tả sản phẩm & Ghi chú</label>
                                    <textarea name="description" class="form-control" rows="4"
                                        placeholder="Thông chi tiết về nguồn gốc, cách bảo quản...">${product.description}</textarea>
                                </div>

                                <div class="bg-light rounded-4 p-4 mb-5 border border-white">
                                    <div class="form-check form-switch d-flex align-items-center p-0">
                                        <div>
                                            <label class="fw-bold d-block text-dark mb-1">Trạng thái kinh doanh</label>
                                            <p class="text-muted small mb-0">Cho phép sản phẩm hiển thị trên các kênh
                                                bán hàng.</p>
                                        </div>
                                        <input class="form-check-input ms-auto" type="checkbox" name="status"
                                            id="status" ${product==null || product.status ? 'checked' : '' }
                                            style="width: 3rem; height: 1.5rem;">
                                    </div>
                                </div>

                                <div class="row g-3">
                                    <div class="col-md-4">
                                        <a href="products" class="btn btn-light w-100 btn-premium border-0">Hủy bỏ</a>
                                    </div>
                                    <div class="col-md-8">
                                        <button type="submit"
                                            class="btn btn-primary w-100 btn-premium shadow-lg fw-bold">
                                            <i class="bi bi-cloud-check me-2"></i>${product != null ? 'Cập nhật thay
                                            đổi' : 'Xác nhận Lưu sản phẩm'}
                                        </button>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>

            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
            <!-- Flatpickr JS -->
            <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
            <script src="https://cdn.jsdelivr.net/npm/flatpickr/dist/l10n/vn.js"></script>
            
            <script>
                // Khởi tạo Flatpickr cho ngày nhập hàng
                flatpickr("#manufactureDate", {
                    locale: "vn",
                    dateFormat: "Y-m-d",
                    maxDate: "today",
                    enableTime: false,
                    altInput: true,
                    altFormat: "d/m/Y",
                    allowInput: true,
                    placeholder: "Chọn ngày nhập hàng",
                    onChange: function(selectedDates, dateStr, instance) {
                        console.log("Manufacture date selected:", dateStr);
                    }
                });

                // Khởi tạo Flatpickr cho ngày hết hạn
                flatpickr("#expiryDate", {
                    locale: "vn",
                    dateFormat: "Y-m-d",
                    enableTime: false,
                    altInput: true,
                    altFormat: "d/m/Y",
                    allowInput: true,
                    placeholder: "Chọn ngày hết hạn",
                    minDate: "today",
                    onChange: function(selectedDates, dateStr, instance) {
                        console.log("Expiry date selected:", dateStr);
                    }
                });
            </script>
        </body>

        </html>