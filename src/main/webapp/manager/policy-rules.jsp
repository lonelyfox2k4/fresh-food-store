<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cấu hình Quy tắc | Fresh Food</title>
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

        .rule-row {
            background-color: white;
            border-bottom: 1px solid var(--slate-100);
            transition: all 0.2s;
            padding: 1.5rem;
        }

        .rule-row:hover {
            background-color: var(--slate-50);
        }

        .form-label {
            font-size: 0.75rem;
            font-weight: 700;
            color: var(--slate-500);
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }

        .form-control-premium {
            background-color: var(--slate-50);
            border: 2px solid transparent;
            border-radius: 0.75rem;
            padding: 0.75rem 1rem;
            font-weight: 500;
            transition: all 0.2s;
        }

        .form-control-premium:focus {
            background-color: white;
            border-color: var(--primary-light);
            box-shadow: 0 0 0 4px rgba(79, 70, 229, 0.1);
        }

        .input-group-text-premium {
            background-color: var(--slate-200);
            border: none;
            border-radius: 0 0.75rem 0.75rem 0;
            padding: 0 1rem;
            font-weight: 600;
            color: var(--slate-700);
        }

        .btn-remove {
            width: 42px;
            height: 42px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            border-radius: 0.75rem;
            color: #ef4444;
            background: #fef2f2;
            border: 1px solid #fee2e2;
            transition: all 0.2s;
        }

        .btn-remove:hover {
            background: #fee2e2;
            color: #dc2626;
        }

        .guide-alert {
            border: none;
            border-left: 4px solid var(--primary);
            background: white;
            border-radius: 0.75rem;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
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
                <a class="nav-link px-3" href="policies">Quay lại danh sách</a>
            </div>
        </div>
    </nav>

    <header class="header-section">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-md-9">
                    <h1 class="display-6 fw-bold mb-2">Cấu hình Quy tắc Giảm giá</h1>
                    <p class="text-white-50 lead fs-6 mb-0">Thiết lập mốc thời gian và tỷ lệ phần trăm giá bán cho chính sách: <span class="text-white fw-semibold">${policy.policyName}</span></p>
                </div>
                <div class="col text-md-end mt-4 mt-md-0">
                    <c:if test="${sessionScope.user.roleId != 1}">
                        <button type="button" class="btn btn-outline-light rounded-pill px-4" onclick="addRow()">
                            <i class="bi bi-plus-lg me-2"></i>Thêm mốc mới
                        </button>
                    </c:if>
                </div>
            </div>
        </div>
    </header>

    <main class="container mb-5">
        <div class="main-card mb-4">
            <form action="policies" method="post" id="rulesForm">
                <input type="hidden" name="action" value="save-rules">
                <input type="hidden" name="policyId" value="${policy.policyId}">

                <div id="rulesContainer">
                    <c:forEach var="rule" items="${rules}">
                        <div class="rule-row row align-items-end g-3">
                            <div class="col-md-5">
                                <label class="form-label">Min Days Remaining (Số ngày tối thiểu)</label>
                                <input type="number" name="minDaysRemaining" class="form-control form-control-premium" value="${rule.minDaysRemaining}" required placeholder="VD: 8" ${sessionScope.user.roleId == 1 ? 'readonly' : ''}>
                                <div class="form-text small mt-2">Áp dụng khi sản phẩm còn ≤ <strong>${rule.minDaysRemaining}</strong> ngày.</div>
                            </div>
                            <div class="col-md-5">
                                <label class="form-label">Sell Price Percent (Bán với giá %)</label>
                                <div class="input-group">
                                    <input type="number" name="sellPricePercent" class="form-control form-control-premium" value="${rule.sellPricePercent}" required min="0" max="100" placeholder="VD: 80" ${sessionScope.user.roleId == 1 ? 'readonly' : ''}>
                                    <span class="input-group-text input-group-text-premium">%</span>
                                </div>
                                <div class="form-text small mt-2">Nhập 80 để giảm 20% (Giá mới = 80 % giá gốc).</div>
                            </div>
                            <div class="col-md-2 text-end">
                                <c:if test="${sessionScope.user.roleId != 1}">
                                    <button type="button" class="btn btn-remove" onclick="removeRow(this)">
                                        <i class="bi bi-trash3-fill"></i>
                                    </button>
                                </c:if>
                            </div>
                        </div>
                    </c:forEach>
                    <c:if test="${empty rules}">
                        <div class="p-5 text-center text-muted">
                            <i class="bi bi-calendar-x fs-1 mb-3 d-block"></i>
                            Chưa có quy tắc nào được thiết lập. Hãy thêm mốc đầu tiên!
                        </div>
                    </c:if>
                </div>

                <div class="p-4 bg-light border-top d-flex justify-content-between align-items-center">
                    <a href="policies" class="text-secondary text-decoration-none fw-medium"><i class="bi bi-arrow-left me-1"></i> Quay lại</a>
                    <c:if test="${sessionScope.user.roleId != 1}">
                        <button type="submit" class="btn btn-primary px-4 py-2 fw-bold">Lưu cấu hình</button>
                    </c:if>
                </div>
            </form>
        </div>

        <div class="guide-alert alert p-4 border-0">
            <h5 class="fw-bold mb-3"><i class="bi bi-lightbulb-fill text-warning me-2"></i>Hướng dẫn vận hành chính sách:</h5>
            <div class="row">
                <div class="col-md-7">
                    <ul class="mb-0 text-secondary" style="font-size: 0.95rem;">
                        <li class="mb-2">Hệ thống luôn chọn mốc <strong>Số ngày lớn nhất</strong> mà vẫn nhỏ hơn hoặc bằng số ngày thực tế.</li>
                        <li class="mb-2">Số ngày càng nhỏ thì ưu tiên giảm giá càng cao (Càng gần hết hạn càng rẻ).</li>
                        <li>Nếu một sản phẩm không khớp mốc nào, hệ thống sẽ bán đúng <strong>100% giá gốc</strong>.</li>
                    </ul>
                </div>
                <div class="col-md-5 border-start">
                    <div class="small fw-bold text-uppercase text-muted mb-2">Ví dụ thực tế:</div>
                    <div class="bg-light rounded p-2 small">
                        <div class="mb-1">1. <strong>8 ngày - 80%</strong> (Giảm 20%)</div>
                        <div class="mb-1">2. <strong>4 ngày - 50%</strong> (Giảm 50% - Xả hàng)</div>
                        <div>3. <strong>1 ngày - 20%</strong> (Giảm 80% - Thanh lý)</div>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <script>
        function addRow() {
            const container = document.getElementById('rulesContainer');
            // Remove empty message if exists
            const emptyMsg = container.querySelector('.text-center');
            if (emptyMsg) emptyMsg.remove();

            const newRow = document.createElement('div');
            newRow.className = 'rule-row row align-items-end g-3';
            newRow.innerHTML = `
                <div class="col-md-5">
                    <label class="form-label">Min Days Remaining (Số ngày tối thiểu)</label>
                    <input type="number" name="minDaysRemaining" class="form-control form-control-premium" required placeholder="VD: 8">
                </div>
                <div class="col-md-5">
                    <label class="form-label">Sell Price Percent (Bán với giá %)</label>
                    <div class="input-group">
                        <input type="number" name="sellPricePercent" class="form-control form-control-premium" required min="0" max="100" placeholder="VD: 80">
                        <span class="input-group-text input-group-text-premium">%</span>
                    </div>
                </div>
                <div class="col-md-2 text-end">
                    <button type="button" class="btn btn-remove" onclick="removeRow(this)">
                        <i class="bi bi-trash3-fill"></i>
                    </button>
                </div>
            `;
            container.appendChild(newRow);
        }

        function removeRow(btn) {
            btn.closest('.rule-row').remove();
        }
    </script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
