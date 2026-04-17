<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chính sách Giảm giá | Fresh Food</title>
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
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 0.5rem 1rem;
            border-radius: 0.5rem;
            transition: all 0.2s;
            border: 1px solid var(--slate-200);
            background: white;
            color: var(--slate-600);
            font-size: 0.85rem;
            font-weight: 500;
            text-decoration: none;
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
                <a class="nav-link px-3" href="categories">Phân phối</a>
                <a class="nav-link px-3" href="suppliers">Đối tác</a>
                <a class="nav-link px-3" href="inventory-pricing">Giá & Hạn dùng</a>
                <a class="nav-link px-3 active" href="policies">Chính sách</a>
            </div>
        </div>
    </nav>

    <header class="header-section">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-md-8">
                    <h1 class="display-6 fw-bold mb-2">Chính sách Giảm giá</h1>
                    <p class="text-white-50 lead fs-6 mb-0">Thiết lập các quy tắc giảm giá tự động dựa trên thời gian bảo quản và mức độ tươi của từng lô hàng.</p>
                </div>
                <div class="col-md-4 text-md-end mt-4 mt-md-0">
                    <button type="button" class="btn btn-primary rounded-pill px-4 py-2 fw-semibold shadow-lg" data-bs-toggle="modal" data-bs-target="#addPolicyModal">
                        <i class="bi bi-plus-lg me-2"></i>Tạo chính sách mới
                    </button>
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
                            <th style="width: 80px;">ID</th>
                            <th>Tên chính sách</th>
                            <th>Mô tả / Ghi chú</th>
                            <th>Trạng thái hoạt động</th>
                            <th class="text-end">Cấu hình & Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="p" items="${policies}">
                            <tr>
                                <td class="text-muted fw-medium">#POL-${p.policyId}</td>
                                <td>
                                    <div class="fw-bold text-dark fs-6">${p.policyName}</div>
                                </td>
                                <td>
                                    <div class="small text-secondary">${p.note}</div>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${p.status}"><span class="status-badge status-active"><i class="bi bi-check-circle-fill me-1"></i>Đang áp dụng</span></c:when>
                                        <c:otherwise><span class="status-badge status-inactive"><i class="bi bi-pause-circle-fill me-1"></i>Tạm dừng</span></c:otherwise>
                                    </c:choose>
                                </td>
                                <td class="text-end">
                                    <a href="policies?action=edit-rules&id=${p.policyId}" class="action-btn me-1 shadow-sm">
                                        <i class="bi bi-sliders me-1"></i> Cấu hình %
                                    </a>
                                    <button class="action-btn" onclick="editPolicy(${p.policyId}, '${p.policyName}', '${p.note}', ${p.status})" title="Sửa chính sách">
                                        <i class="bi bi-pencil-square"></i>
                                    </button>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </main>

    <!-- Modal Thêm/Sửa Policy -->
    <div class="modal fade" id="addPolicyModal" tabindex="-1">
        <div class="modal-dialog modal-dialog-centered">
            <form action="policies" method="post" class="modal-content">
                <div class="modal-header border-0 pb-0 p-4">
                    <h5 class="fw-bold" id="modalTitle">Thông tin Chính sách</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body p-4">
                    <input type="hidden" name="id" id="policyId">
                    <div class="mb-4">
                        <label class="form-label fw-semibold small text-muted text-uppercase">Tên chính sách</label>
                        <input type="text" name="policyName" id="policyName" class="form-control form-control-lg bg-light border-0" placeholder="VD: Giảm giá hàng rau củ" required>
                    </div>
                    <div class="mb-4">
                        <label class="form-label fw-semibold small text-muted text-uppercase">Mô tả / Ghi chú</label>
                        <textarea name="note" id="policyNote" class="form-control bg-light border-0" rows="3" placeholder="Ghi chú về mục đích của chính sách này..."></textarea>
                    </div>
                    <div class="form-check form-switch d-flex align-items-center p-0">
                        <label class="form-check-label fw-semibold me-3">Kích hoạt áp dụng ngay</label>
                        <input class="form-check-input ms-auto" type="checkbox" name="status" id="policyStatus" checked style="width: 3rem; height: 1.5rem;">
                    </div>
                </div>
                <div class="modal-footer border-0 pt-0 p-4">
                    <button type="button" class="btn btn-light rounded-pill px-4" data-bs-dismiss="modal">Đóng</button>
                    <button type="submit" class="btn btn-primary rounded-pill px-5 fw-bold">Lưu thay đổi</button>
                </div>
            </form>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function editPolicy(id, name, note, status) {
            document.getElementById('modalTitle').innerText = 'Chỉnh sửa chính sách';
            document.getElementById('policyId').value = id;
            document.getElementById('policyName').value = name;
            document.getElementById('policyNote').value = note;
            document.getElementById('policyStatus').checked = status;
            new bootstrap.Modal(document.getElementById('addPolicyModal')).show();
        }
    </script>
</body>
</html>
