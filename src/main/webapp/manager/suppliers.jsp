<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Đối tác | FoodStore Admin</title>
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
            --slate-500: #64748b;
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

        .contact-item { font-size: 0.85rem; color: var(--slate-600); }
        .contact-item i { color: var(--primary-light); width: 20px; }

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
                <span class="fw-bold tracking-tight">Fresh <span class="text-primary-light">Fresh Food</span></span>
            </a>
            <div class="navbar-nav ms-auto">
                <a class="nav-link px-3" href="products">Hàng hóa</a>
                <a class="nav-link px-3" href="categories">Phân phối</a>
                <a class="nav-link px-3 active" href="suppliers">Đối tác</a>
                <a class="nav-link px-3" href="inventory-pricing">Giá & Hạn dùng</a>
            </div>
        </div>
    </nav>

    <header class="header-section">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-md-8">
                    <h1 class="display-6 fw-bold mb-2">Quản lý Đối tác Cung ứng</h1>
                    <p class="text-white-50 lead fs-6 mb-0">Thiết lập mạng lưới nhà cung cấp uy tín để đảm bảo nguồn hàng luôn tươi sạch và ổn định.</p>
                </div>
                <div class="col-md-4 text-md-end mt-4 mt-md-0">
                    <c:if test="${sessionScope.user.roleId != 1}">
                        <button type="button" class="btn btn-primary rounded-pill px-4 py-2 fw-semibold shadow-lg" data-bs-toggle="modal" data-bs-target="#supplierModal">
                            <i class="bi bi-plus-lg me-2"></i>Ký kết đối tác mới
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
                            <th>Tên đối tác</th>
                            <th>Thông tin liên hệ</th>
                            <th>Địa chỉ kho hàng</th>
                            <th>Trạng thái hợp tác</th>
                            <c:if test="${sessionScope.user.roleId != 1}">
                                <th class="text-end">Hành động</th>
                            </c:if>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="s" items="${suppliers}">
                            <tr>
                                <td>
                                    <div class="d-flex align-items-center">
                                        <div class="bg-primary-subtle text-primary rounded-3 p-2 me-3">
                                            <i class="bi bi-shop fs-5"></i>
                                        </div>
                                        <div class="fw-bold text-dark fs-6">${s.supplierName}</div>
                                    </div>
                                </td>
                                <td>
                                    <div class="contact-item"><i class="bi bi-telephone"></i> ${s.phone}</div>
                                    <div class="contact-item"><i class="bi bi-envelope"></i> ${s.email}</div>
                                </td>
                                <td>
                                    <div class="small text-secondary"><i class="bi bi-geo-alt me-1"></i> ${s.address}</div>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${s.status}"><span class="status-badge status-active"><i class="bi bi-check-circle-fill me-1"></i>Đang hợp tác</span></c:when>
                                        <c:otherwise><span class="status-badge status-inactive"><i class="bi bi-slash-circle me-1"></i>Tạm dừng</span></c:otherwise>
                                    </c:choose>
                                </td>
                                <c:if test="${sessionScope.user.roleId != 1}">
                                    <td class="text-end">
                                        <button class="action-btn me-1" onclick='editSupplier(${s.supplierId}, "${s.supplierName}", "${s.phone}", "${s.email}", "${s.address}", ${s.status})' title="Cập nhật thông tin">
                                            <i class="bi bi-pencil-square"></i>
                                        </button>
                                        <c:choose>
                                            <c:when test="${s.status}">
                                                <a href="suppliers?action=toggle-status&id=${s.supplierId}&status=false" class="action-btn text-danger border-danger-subtle" title="Ngừng hợp tác" onclick="return confirm('Bạn có chắc muốn tạm dừng hợp tác với đơn vị này?')">
                                                    <i class="bi bi-eye-slash"></i>
                                                </a>
                                            </c:when>
                                            <c:otherwise>
                                                <a href="suppliers?action=toggle-status&id=${s.supplierId}&status=true" class="action-btn text-success border-success-subtle" title="Kích hoạt lại" onclick="return confirm('Bạn có muốn kích hoạt lại hợp tác với đơn vị này?')">
                                                    <i class="bi bi-eye"></i>
                                                </a>
                                            </c:otherwise>
                                        </c:choose>
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
        <div class="modal fade" id="supplierModal" tabindex="-1">
            <div class="modal-dialog modal-dialog-centered modal-lg">
                <form action="suppliers" method="POST" class="modal-content">
                    <div class="modal-header border-0 pb-0 p-4">
                        <h5 class="fw-bold">Thông tin chi tiết Đối tác</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body p-4">
                        <input type="hidden" name="id" id="supId">
                        <div class="mb-4">
                            <label class="form-label fw-semibold small text-muted text-uppercase">Tên nhà cung cấp / Công ty</label>
                            <input type="text" name="supplierName" id="supName" class="form-control form-control-lg bg-light border-0" placeholder="VD: Công ty TNHH Thực phẩm Sạch" required>
                        </div>
                        <div class="row g-4 mb-4">
                            <div class="col-md-6">
                                <label class="form-label fw-semibold small text-muted text-uppercase">Số điện thoại liên hệ</label>
                                <input type="text" name="phone" id="supPhone" class="form-control bg-light border-0" placeholder="090x.xxx.xxx">
                            </div>
                            <div class="col-md-6">
                                <label class="form-label fw-semibold small text-muted text-uppercase">Địa chỉ Email</label>
                                <input type="email" name="email" id="supEmail" class="form-control bg-light border-0" placeholder="contact@supplier.com">
                            </div>
                        </div>
                        <div class="mb-4">
                            <label class="form-label fw-semibold small text-muted text-uppercase">Địa chỉ kho bãi / Trụ sở</label>
                            <input type="text" name="address" id="supAddress" class="form-control bg-light border-0" placeholder="Số nhà, Tên đường, Quận/Huyện, Tỉnh/TP">
                        </div>
                        <div class="form-check form-switch d-flex align-items-center p-0">
                            <label class="form-check-label fw-semibold me-3">Trạng thái hợp tác hiện tại</label>
                            <input class="form-check-input ms-auto" type="checkbox" name="status" id="supStatus" checked style="width: 3rem; height: 1.5rem;">
                        </div>
                    </div>
                    <div class="modal-footer border-0 pt-0 p-4">
                        <button type="button" class="btn btn-light rounded-pill px-4" data-bs-dismiss="modal">Đóng</button>
                        <button type="submit" class="btn btn-primary rounded-pill px-5 fw-bold">Xác nhận Lưu</button>
                    </div>
                </form>
            </div>
        </div>
        <script>
            function editSupplier(id, name, phone, email, address, status) {
                document.getElementById('supId').value = id;
                document.getElementById('supName').value = name;
                document.getElementById('supPhone').value = phone;
                document.getElementById('supEmail').value = email;
                document.getElementById('supAddress').value = address;
                document.getElementById('supStatus').checked = status;
                new bootstrap.Modal(document.getElementById('supplierModal')).show();
            }
        </script>
    </c:if>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
