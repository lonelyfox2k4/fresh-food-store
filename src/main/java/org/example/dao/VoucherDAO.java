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
}