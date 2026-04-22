package org.example.dao;

import org.example.model.marketing.Voucher;
import org.example.utils.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class VoucherDAO {

    // 1. Lấy danh sách tất cả Voucher
    public List<Voucher> getAllVouchers() {
        List<Voucher> list = new ArrayList<>();
        String sql = "SELECT * FROM Vouchers ORDER BY createdAt DESC";
        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Voucher v = new Voucher();
                v.setVoucherId(rs.getLong("voucherId"));
                v.setVoucherCode(rs.getString("voucherCode"));
                v.setVoucherName(rs.getString("voucherName"));
                v.setDiscountType(rs.getByte("discountType"));
                v.setDiscountValue(rs.getBigDecimal("discountValue"));
                v.setMinOrderAmount(rs.getBigDecimal("minOrderAmount"));
                v.setMaxDiscountAmount(rs.getBigDecimal("maxDiscountAmount"));
                v.setUsageLimit(rs.getObject("usageLimit") != null ? rs.getInt("usageLimit") : null);
                v.setUsedCount(rs.getInt("usedCount"));

                // Chuyển đổi Timestamp từ SQL sang LocalDateTime cho Model
                if (rs.getTimestamp("startAt") != null)
                    v.setStartAt(rs.getTimestamp("startAt").toLocalDateTime());
                if (rs.getTimestamp("endAt") != null)
                    v.setEndAt(rs.getTimestamp("endAt").toLocalDateTime());

                v.setStatus(rs.getByte("status"));
                v.setCreatedByAccountId(rs.getLong("createdByAccountId"));
                list.add(v);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // 2. Thêm mới Voucher
    public boolean createVoucherWithRequest(Voucher v, String requestNote) {
        String sqlVoucher = "INSERT INTO Vouchers (voucherCode, voucherName, discountType, discountValue, " +
                "minOrderAmount, maxDiscountAmount, usageLimit, usedCount, startAt, endAt, " +
                "status, createdByAccountId, createdAt) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,GETDATE())";

        String sqlRequest = "INSERT INTO VoucherRequests (voucherId, accountId, requestStatus, requestNote, requestedAt) " +
                "VALUES (?, ?, 0, ?, GETDATE())";

        Connection conn = null;
        try {
            conn = new DBConnection().getConnection();
            conn.setAutoCommit(false); // Chặn tự động lưu để bắt đầu Transaction

            // 1. Chèn Voucher và lấy ID tự tăng
            PreparedStatement psV = conn.prepareStatement(sqlVoucher, Statement.RETURN_GENERATED_KEYS);
            psV.setString(1, v.getVoucherCode());
            psV.setString(2, v.getVoucherName());
            psV.setByte(3, v.getDiscountType());
            psV.setBigDecimal(4, v.getDiscountValue());
            psV.setBigDecimal(5, v.getMinOrderAmount());
            psV.setBigDecimal(6, v.getMaxDiscountAmount());
            if (v.getUsageLimit() != null) psV.setInt(7, v.getUsageLimit()); else psV.setNull(7, Types.INTEGER);
            psV.setInt(8, v.getUsedCount());
            psV.setTimestamp(9, Timestamp.valueOf(v.getStartAt()));
            psV.setTimestamp(10, Timestamp.valueOf(v.getEndAt()));
            psV.setByte(11, v.getStatus());
            psV.setLong(12, v.getCreatedByAccountId());

            psV.executeUpdate();

            // Lấy voucherId vừa được SQL Server tạo ra
            ResultSet rs = psV.getGeneratedKeys();
            long generatedVoucherId = 0;
            if (rs.next()) {
                generatedVoucherId = rs.getLong(1);
            }

            // 2. Chèn vào bảng VoucherRequests
            PreparedStatement psR = conn.prepareStatement(sqlRequest);
            psR.setLong(1, generatedVoucherId);
            psR.setLong(2, v.getCreatedByAccountId());
            psR.setString(3, requestNote); // Lời nhắn từ Staff gửi Admin
            psR.executeUpdate();

            conn.commit(); // Mọi thứ OK thì lưu vĩnh viễn
            return true;
        } catch (Exception e) {
            if (conn != null) try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            e.printStackTrace();
            return false;
        } finally {
            if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }

    // 3. Xóa Voucher
    public boolean deleteVoucher(long id) {
        String sql = "DELETE FROM Vouchers WHERE voucherId = ?";
        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // 4. Lấy chi tiết 1 Voucher (Dùng cho chức năng Edit)
    public Voucher getVoucherById(long id) {
        String sql = "SELECT * FROM Vouchers WHERE voucherId = ?";
        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Voucher v = new Voucher();
                v.setVoucherId(rs.getLong("voucherId"));
                v.setVoucherCode(rs.getString("voucherCode"));
                v.setVoucherName(rs.getString("voucherName"));
                v.setDiscountType(rs.getByte("discountType"));
                v.setDiscountValue(rs.getBigDecimal("discountValue"));
                v.setMinOrderAmount(rs.getBigDecimal("minOrderAmount"));
                v.setMaxDiscountAmount(rs.getBigDecimal("maxDiscountAmount"));
                v.setUsageLimit(rs.getObject("usageLimit") != null ? rs.getInt("usageLimit") : null);
                v.setStartAt(rs.getTimestamp("startAt").toLocalDateTime());
                v.setEndAt(rs.getTimestamp("endAt").toLocalDateTime());
                v.setStatus(rs.getByte("status"));
                return v;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // ==================== CUSTOMER METHODS ====================
    public Voucher getValidVoucherByCode(String code, java.math.BigDecimal orderAmount) {
        String sql = "SELECT * FROM dbo.Vouchers " +
                     "WHERE voucherCode = ? AND status = 1 " +
                     "AND startAt <= SYSUTCDATETIME() AND endAt >= SYSUTCDATETIME() " +
                     "AND (usageLimit IS NULL OR usedCount < usageLimit) " +
                     "AND minOrderAmount <= ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, code.trim().toUpperCase());
            ps.setBigDecimal(2, orderAmount);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public java.math.BigDecimal calculateDiscount(Voucher voucher, java.math.BigDecimal orderAmount) {
        if (voucher == null) return java.math.BigDecimal.ZERO;
        java.math.BigDecimal discount;
        if (voucher.getDiscountType() == 1) {
            discount = orderAmount.multiply(voucher.getDiscountValue())
                                  .divide(java.math.BigDecimal.valueOf(100), 2, java.math.RoundingMode.HALF_UP);
        } else {
            discount = voucher.getDiscountValue();
        }
        if (voucher.getMaxDiscountAmount() != null) {
            discount = discount.min(voucher.getMaxDiscountAmount());
        }
        return discount.min(orderAmount);
    }

    private Voucher mapRow(ResultSet rs) throws SQLException {
        Voucher v = new Voucher();
        v.setVoucherId(rs.getLong("voucherId"));
        v.setVoucherCode(rs.getString("voucherCode"));
        v.setVoucherName(rs.getString("voucherName"));
        v.setDiscountType(rs.getByte("discountType"));
        v.setDiscountValue(rs.getBigDecimal("discountValue"));
        v.setMinOrderAmount(rs.getBigDecimal("minOrderAmount"));
        v.setMaxDiscountAmount(rs.getBigDecimal("maxDiscountAmount"));
        int usageLimit = rs.getInt("usageLimit");
        v.setUsageLimit(rs.wasNull() ? null : usageLimit);
        v.setUsedCount(rs.getInt("usedCount"));
        v.setStatus(rs.getByte("status"));
        if (rs.getTimestamp("startAt") != null) v.setStartAt(rs.getTimestamp("startAt").toLocalDateTime());
        if (rs.getTimestamp("endAt") != null) v.setEndAt(rs.getTimestamp("endAt").toLocalDateTime());
        return v;
    }

    // ==================== MANAGER METHODS ====================

    public List<org.example.model.marketing.VoucherRequest> getPendingVoucherRequests() {
        List<org.example.model.marketing.VoucherRequest> list = new ArrayList<>();
        String sql = "SELECT vr.*, v.*, a.fullName as requesterName " +
                     "FROM VoucherRequests vr " +
                     "JOIN Vouchers v ON vr.voucherId = v.voucherId " +
                     "JOIN Accounts a ON vr.accountId = a.accountId " +
                     "WHERE vr.requestStatus = 0 " + // 0 = Pending
                     "ORDER BY vr.requestedAt DESC";
        try (Connection conn = new DBConnection().getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                org.example.model.marketing.VoucherRequest vr = new org.example.model.marketing.VoucherRequest();
                vr.setVoucherRequestId(rs.getLong("voucherRequestId"));
                vr.setVoucherId(rs.getLong("voucherId"));
                vr.setAccountId(rs.getLong("accountId"));
                vr.setRequestStatus(rs.getByte("requestStatus"));
                vr.setRequestNote(rs.getString("requestNote"));
                if (rs.getTimestamp("requestedAt") != null)
                    vr.setRequestedAt(rs.getTimestamp("requestedAt").toLocalDateTime());
                
                vr.setRequesterName(rs.getString("requesterName"));
                vr.setVoucher(mapRow(rs));
                
                list.add(vr);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean handleVoucherRequest(long requestId, int newStatus, long managerId) {
        String sqlUpdateReq = "UPDATE VoucherRequests SET requestStatus = ?, reviewedByAccountId = ?, reviewedAt = GETDATE() WHERE voucherRequestId = ?";
        String sqlUpdateVoucher = "UPDATE Vouchers SET status = ? WHERE voucherId = (SELECT voucherId FROM VoucherRequests WHERE voucherRequestId = ?)";
        
        Connection conn = null;
        try {
            conn = new DBConnection().getConnection();
            conn.setAutoCommit(false);

            // 1. Update Request Status
            PreparedStatement ps1 = conn.prepareStatement(sqlUpdateReq);
            ps1.setInt(1, newStatus);
            ps1.setLong(2, managerId);
            ps1.setLong(3, requestId);
            ps1.executeUpdate();

            // 2. Update Voucher Status (If approved (1), set voucher to 1. If rejected (2), set voucher to 2 or keep 0)
            PreparedStatement ps2 = conn.prepareStatement(sqlUpdateVoucher);
            if (newStatus == 1) {
                ps2.setInt(1, 1); // Active
            } else {
                ps2.setInt(1, 2); // Rejected/Inactive
            }
            ps2.setLong(2, requestId);
            ps2.executeUpdate();

            conn.commit();
            return true;
        } catch (Exception e) {
            if (conn != null) try { conn.rollback(); } catch (SQLException ex) { ex.printStackTrace(); }
            e.printStackTrace();
            return false;
        } finally {
            if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }
}