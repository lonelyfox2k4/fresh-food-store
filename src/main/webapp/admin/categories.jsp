<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Loại sản phẩm | FoodStore Admin</title>
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <!-- Bootstrap 5 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css">
    
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

        .glass-nav {
            background: rgba(15, 23, 42, 0.9);
            backdrop-filter: blur(12px);
            border-bottom: 1px solid rgba(255,255,255,0.1);
        }

        .header-section {
            background: linear-gradient(135deg, var(--slate-900) 0%, var(--slate-800) 100%);
            color: white;
            padding: 4rem 0 6rem 0;
            margin-bottom: -4rem;
        }

        .main-card {
            background: white;
            border: none;
            border-radius: 1.25rem;
            box-shadow: 0 10px 25px -5px rgba(0,0,0,0.05), 0 8px 10px -6px rgba(0,0,0,0.05);
            overflow: hidden;
        }

        .table thead th {
            background-color: var(--slate-50);
            border-bottom: 2px solid var(--slate-100);
            text-transform: uppercase;
            font-size: 0.7rem;
            font-weight: 700;
            color: var(--slate-500);
            letter-spacing: 0.05em;
            padding: 1.25rem 1.5rem;
        }

        .table tbody td {
            padding: 1.25rem 1.5rem;
            border-bottom: 1px solid var(--slate-100);
            vertical-align: middle;
        }

        .status-badge {
            padding: 0.35rem 0.75rem;
            border-radius: 9999px;
            font-size: 0.75rem;
            font-weight: 600;
        }

        .status-active { background: #dcfce7; color: #166534; }
        .status-inactive { background: #f1f5f9; color: #475569; }

        .action-btn {
            width: 32px;
            height: 32px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            border-radius: 0.5rem;
            transition: all 0.2s;
            border: 1px solid var(--slate-200);
            background: white;
            color: var(--slate-600);
        }

        .action-btn:hover {
            border-color: var(--primary);
            color: var(--primary);
            background: #eef2ff;
        }

        .modal-content {
            border: none;
            border-radius: 1rem;
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.25);
        }
    </style>
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark glass-nav sticky-top">
        <div class="container">
            <a class="navbar-brand d-flex align-items-center" href="../home">
                <i class="bi bi-shield-check text-primary me-2 fs-3"></i>
                <span class="fw-bold tracking-tight">FOODSTORE <span class="text-primary-light">ADMIN</span></span>
            </a>
            <div class="navbar-nav ms-auto">
                <a class="nav-link px-3" href="products">Hàng hóa</a>
                <a class="nav-link px-3 active" href="categories">Phân phối</a>
                <a class="nav-link px-3" href="suppliers">Đối tác</a>
                <a class="nav-link px-3" href="inventory-pricing">Giá & Hạn dùng</a>
            </div>
        </div>
    </nav>

    <header class="header-section">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-md-8">
                    <h1 class="display-6 fw-bold mb-2">Quản lý Phân loại</h1>
                    <p class="text-white-50 lead fs-6 mb-0">Thiết lập các danh mục sản phẩm để tối ưu hóa việc phân phối và hiển thị hàng hóa.</p>
                </div>
                <div class="col-md-4 text-md-end mt-4 mt-md-0">
                    <c:if test="${sessionScope.user.roleId != 1}">
                        <button type="button" class="btn btn-primary rounded-pill px-4 py-2 fw-semibold shadow-lg" data-bs-toggle="modal" data-bs-target="#categoryModal">
                            <i class="bi bi-plus-lg me-2"></i>Thêm phân loại mới
                        </button>
                    </c:if>
                </div>
            </div>
        </div>
    </header>

    <main class="container mb-5">
        <div class="main-card">
            <div class="table-responsive">
                <table class="table table-hover align-middle">
                    <thead>
                        <tr>
                            <th style="width: 100px;">Mã số</th>
                            <th>Tên phân loại</th>
                            <th>Trạng thái hiển thị</th>
                            <c:if test="${sessionScope.user.roleId != 1}">
                                <th class="text-end">Hành động</th>
                            </c:if>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="c" items="${categories}">
                            <tr>
                                <td class="text-muted fw-medium">#CAT-${c.categoryId}</td>
                                <td>
                                    <div class="fw-bold text-dark fs-6">${c.categoryName}</div>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${c.status}"><span class="status-badge status-active"><i class="bi bi-eye-fill me-1"></i>Đang hiển thị</span></c:when>
                                        <c:otherwise><span class="status-badge status-inactive"><i class="bi bi-eye-slash-fill me-1"></i>Đã ẩn</span></c:otherwise>
                                    </c:choose>
                                </td>
                                <c:if test="${sessionScope.user.roleId != 1}">
                                    <td class="text-end">
                                        <button class="action-btn me-1" onclick="editCategory(${c.categoryId}, '${c.categoryName}', ${c.status})" title="Chỉnh sửa">
                                            <i class="bi bi-pencil-square"></i>
                                        </button>
                                        <a href="categories?action=delete&id=${c.categoryId}" class="action-btn delete" title="Ẩn phân loại" onclick="return confirm('Bạn có muốn ẩn phân loại này khỏi danh mục bán hàng?')">
                                            <i class="bi bi-trash"></i>
                                        </a>
                                    </td>
                                </c:if>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </main>

    <c:if test="${sessionScope.user.roleId != 1}">
        <!-- Modal -->
        <div class="modal fade" id="categoryModal" tabindex="-1">
            <div class="modal-dialog modal-dialog-centered">
                <form action="categories" method="POST" class="modal-content">
                    <div class="modal-header border-0 pb-0">
                        <h5 class="fw-bold">Thông tin phân loại</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body p-4">
                        <input type="hidden" name="id" id="catId">
                        <div class="mb-4">
                            <label class="form-label fw-semibold small text-muted text-uppercase">Tên phân loại</label>
                            <input type="text" name="categoryName" id="catName" class="form-control form-control-lg bg-light border-0" placeholder="VD: Thực phẩm đông lạnh" required>
                        </div>
                        <div class="form-check form-switch d-flex align-items-center p-0">
                            <label class="form-check-label fw-semibold me-3">Trạng thái hiển thị công khai</label>
                            <input class="form-check-input ms-auto" type="checkbox" name="status" id="catStatus" checked style="width: 3rem; height: 1.5rem;">
                        </div>
                    </div>
                    <div class="modal-footer border-0 pt-0">
                        <button type="button" class="btn btn-light rounded-pill px-4" data-bs-dismiss="modal">Hủy bỏ</button>
                        <button type="submit" class="btn btn-primary rounded-pill px-4">Lưu thông tin</button>
                    </div>
                </form>
            </div>
        </div>

        <script>
            function editCategory(id, name, status) {
                document.getElementById('catId').value = id;
                document.getElementById('catName').value = name;
                document.getElementById('catStatus').checked = status;
                new bootstrap.Modal(document.getElementById('categoryModal')).show();
            }
        </script>
    </c:if>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
