<head>
    <meta charset="UTF-8">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Be+Vietnam+Pro:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <style>
        body { 
            font-family: 'Be Vietnam Pro', sans-serif; 
            background: radial-gradient(circle at top left, #fff5f5, #f0f2f5);
            min-height: 100vh;
        }
        .premium-card { 
            background: rgba(255, 255, 255, 0.9);
            backdrop-filter: blur(15px);
            border: 1px solid rgba(255, 255, 255, 0.4);
            border-radius: 24px;
            box-shadow: 0 20px 50px rgba(0,0,0,0.08);
            overflow: hidden;
        }
        .premium-header { 
            background: linear-gradient(135deg, var(--brand), #b5000c);
            color: white;
            padding: 2rem 1.5rem;
            text-align: center;
        }
        .form-label { font-weight: 700; color: #1a1a2e; font-size: 0.8rem; text-transform: uppercase; letter-spacing: 0.5px; margin-bottom: 0.5rem; }
        .form-control, .form-select { 
            border-radius: 12px; 
            padding: 0.75rem 1rem; 
            border: 1px solid rgba(0,0,0,0.08); 
            background: rgba(255,255,255,0.5);
            transition: all 0.3s;
        }
        .form-control:focus, .form-select:focus { 
            border-color: var(--brand); 
            box-shadow: 0 0 0 4px rgba(227, 0, 15, 0.1);
            background: #fff;
        }
        .btn-brand { 
            border-radius: 12px; 
            padding: 0.8rem 2rem; 
            font-weight: 700; 
            transition: all 0.3s;
        }
        .btn-brand:hover { transform: translateY(-2px); box-shadow: 0 10px 20px rgba(227, 0, 15, 0.3); }
    </style>
</head>
<body class="bg-light">
<jsp:include page="../components/admin-nav.jsp">
    <jsp:param name="active" value="users"/>
</jsp:include>
<div class="container mt-5">
    <div class="row justify-content-center">
        <div class="col-md-6 col-lg-5">
            <div class="mb-4">
                <a href="users" class="text-decoration-none text-muted fw-600 small">
                    <i class="fas fa-chevron-left me-1"></i> Quay lại danh sách
                </a>
            </div>
            <div class="premium-card">
                <div class="premium-header">
                    <h3 class="mb-0 fw-800"><i class="fas fa-user-plus me-2"></i>Cấp tài khoản mới</h3>
                    <p class="text-white-50 small mb-0 mt-1">Phân quyền người dùng vào hệ thống Fresh Food Store</p>
                </div>
                <div class="card-body p-4 p-md-5">
                    <form action="${pageContext.request.contextPath}/admin/assign" method="post">
                        <div class="mb-3">
                            <label class="form-label">Họ và tên</label>
                            <input type="text" name="name" class="form-control" required minlength="3">
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Email</label>
                            <input type="email" name="email" class="form-control" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Số điện thoại</label>
                            <input type="text" name="phone" class="form-control" pattern="[0-9]{10,11}" title="Vui lòng nhập 10-11 số">
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Vai trò (Role)</label>
                            <select name="roleId" class="form-select" required>
                                <option value="">-- Chọn Role --</option>
                                <option value="1">Admin</option>
                                <option value="2">Staff</option>
                                <option value="3">Customer</option>
                                <option value="4">Shipper</option>
                                <option value="5">Manager</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Mật khẩu mặc định</label>
                            <input type="password" name="password" class="form-control" value="123456" readonly>
                            <small class="text-muted">Mật khẩu mặc định cho tài khoản mới là 123456</small>
                        </div>
                        <div class="d-flex justify-content-between">
                            <a href="users" class="btn btn-outline-secondary px-4">Quay lại</a>
                            <button type="submit" class="btn btn-brand px-4">Xác nhận cấp</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>