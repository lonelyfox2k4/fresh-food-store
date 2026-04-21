<style>
    body { font-family: 'Be Vietnam Pro', sans-serif; background: #f8fafc; color: #1e293b; min-height: 100vh; overflow-x: hidden; }

    /* Page Header */
    .page-header { background: #fff; padding: 2rem 0; border-bottom: 1px solid #e2e8f0; margin-bottom: 2rem; }
    .breadcrumb-item a { color: var(--primary); text-decoration: none; font-weight: 500; }
    
    /* Stat Cards */
    .stat-card {
        background: #fff; border-radius: 16px; padding: 1.5rem; border: 1px solid #e2e8f0;
        transition: all 0.3s ease; display: flex; align-items: center; gap: 1rem; position: relative; overflow: hidden;
    }
    .stat-card:hover { transform: translateY(-3px); box-shadow: 0 10px 20px rgba(0,0,0,0.05); }
    .stat-icon { width: 48px; height: 48px; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 1.25rem; }
    
    /* Tables and Filters */
    .filter-section { background: #fff; border-radius: 16px; padding: 1.5rem; border: 1px solid #e2e8f0; margin-bottom: 2rem; }
    .user-table-card { background: #fff; border-radius: 16px; border: 1px solid #e2e8f0; overflow: hidden; box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05); }
    .table thead th { 
        background: #f8fafc; color: #64748b; font-weight: 600; text-transform: uppercase; 
        font-size: 0.75rem; letter-spacing: 0.5px; padding: 1rem 1.5rem; border-bottom: 1px solid #e2e8f0;
    }
    .table tbody td { padding: 1rem 1.5rem; vertical-align: middle; border-bottom: 1px solid #f1f5f9; }
    
    /* Badges */
    .badge-pill { padding: 0.35rem 0.75rem; border-radius: 30px; font-weight: 600; font-size: 0.75rem; display: inline-block; }
    .badge-active { background: #dcfce7; color: #166534; }
    .badge-banned { background: #fee2e2; color: #991b1b; }
    .badge-pending { background: #fef9c3; color: #854d0e; }
    .badge-role { background: #f1f5f9; color: #475569; border: 1px solid #e2e8f0; }

    /* Buttons */
    .btn-action { width: 32px; height: 32px; border-radius: 8px; display: flex; align-items: center; justify-content: center; transition: all 0.2s; border: none; background: #f1f5f9; color: #64748b; text-decoration: none; }
    .btn-action:hover { background: var(--primary); color: #fff; }
    .btn-action-edit:hover { background: #0ea5e9; color: #fff; }
    .btn-action-delete:hover { background: #ef4444; color: #fff; }

    /* Inputs */
    .search-input { border-radius: 10px; border: 1px solid #e2e8f0; padding: 0.6rem 1rem 0.6rem 2.5rem; }
    .search-container { position: relative; }
    .search-container i { position: absolute; left: 1rem; top: 50%; transform: translateY(-50%); color: #94a3b8; }
    .form-control, .form-select { border-radius: 10px; border: 1px solid #e2e8f0; padding: 0.6rem 1rem; }
    .form-control:focus, .form-select:focus { border-color: var(--primary); box-shadow: 0 0 0 0.25rem rgba(227, 0, 15, 0.1); }
</style>
