package org.example.dao;

import org.example.model.order.Order;
import org.example.utils.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class OrderDAO {

    private Order extractOrderFromResultSet(ResultSet rs) throws Exception {
        Order o = new Order();
        o.setOrderId(rs.getLong("orderId"));
        o.setOrderCode(rs.getString("orderCode"));
        o.setAccountId(rs.getLong("accountId"));
        
        long shipperId = rs.getLong("shipperId");
        if (!rs.wasNull()) {
            o.setShipperId(shipperId);
        }
        
        o.setOrderStatus(rs.getByte("orderStatus"));
        o.setPaymentStatus(rs.getByte("paymentStatus"));
        
        byte shippingStatus = rs.getByte("shippingStatus");
        if (!rs.wasNull()) {
            o.setShippingStatus(shippingStatus);
        }
        
        o.setSubtotalAmount(rs.getBigDecimal("subtotalAmount"));
        o.setDiscountAmount(rs.getBigDecimal("discountAmount"));
        o.setShippingFee(rs.getBigDecimal("shippingFee"));
        o.setTotalAmount(rs.getBigDecimal("totalAmount"));
        
        o.setRecipientNameSnapshot(rs.getString("recipientNameSnapshot"));
        o.setRecipientPhoneSnapshot(rs.getString("recipientPhoneSnapshot"));
        o.setShippingAddressSnapshot(rs.getString("shippingAddressSnapshot"));
        o.setNote(rs.getString("note"));
        
        if (rs.getTimestamp("placedAt") != null) o.setPlacedAt(rs.getTimestamp("placedAt").toLocalDateTime());
        if (rs.getTimestamp("paidAt") != null) o.setPaidAt(rs.getTimestamp("paidAt").toLocalDateTime());
        if (rs.getTimestamp("cancelledAt") != null) o.setCancelledAt(rs.getTimestamp("cancelledAt").toLocalDateTime());
        
        o.setCancelledReason(rs.getString("cancelledReason"));
        
        return o;
    }

    public List<Order> getAllOrders() {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT * FROM dbo.Orders ORDER BY placedAt DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(extractOrderFromResultSet(rs));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public List<Order> getOrdersByShipper(long shipperId) {
        List<Order> list = new ArrayList<>();
        // Shipper only sees orders assigned to them and not cancelled 
        String sql = "SELECT * FROM dbo.Orders WHERE shipperId = ? ORDER BY placedAt DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, shipperId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(extractOrderFromResultSet(rs));
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public Order getOrderById(long orderId) {
        String sql = "SELECT * FROM dbo.Orders WHERE orderId = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return extractOrderFromResultSet(rs);
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }

    public boolean updateOrderStatus(long orderId, byte status) {
        String sql = "UPDATE dbo.Orders SET orderStatus = ? WHERE orderId = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setByte(1, status);
            ps.setLong(2, orderId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    public boolean updateShippingStatus(long orderId, byte status) {
        String sql = "UPDATE dbo.Orders SET shippingStatus = ? WHERE orderId = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setByte(1, status);
            ps.setLong(2, orderId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    public boolean assignShipper(long orderId, long shipperId) {
        String sql = "UPDATE dbo.Orders SET shipperId = ? WHERE orderId = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, shipperId);
            ps.setLong(2, orderId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    public boolean updatePaymentStatus(long orderId, byte paymentStatus) {
        // If paymentStatus changing to paid (e.g., 1), update paidAt
        String sql;
        if (paymentStatus == 1) { // Assuming 1 = Paid
            sql = "UPDATE dbo.Orders SET paymentStatus = ?, paidAt = SYSUTCDATETIME() WHERE orderId = ?";
        } else {
            sql = "UPDATE dbo.Orders SET paymentStatus = ? WHERE orderId = ?";
        }
        
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setByte(1, paymentStatus);
            ps.setLong(2, orderId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    public boolean updateOrderNote(long orderId, String note) {
        String sql = "UPDATE dbo.Orders SET note = ? WHERE orderId = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, note);
            ps.setLong(2, orderId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    // Atomic delivery success: updates shipping, order, and payment status
    public boolean updateDeliverySuccess(long orderId, boolean wasCod) {
        // Success means shippingStatus=3 (Delivered) AND orderStatus=3 (Completed)
        String sql = "UPDATE dbo.Orders SET shippingStatus = 3, orderStatus = 3" 
                   + (wasCod ? ", paymentStatus = 1, paidAt = GETDATE()" : "") 
                   + " WHERE orderId = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, orderId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    // Atomic start shipping: updates both shippingStatus and orderStatus
    public boolean updateStartShipping(long orderId) {
        // Start shipping means shippingStatus=2 (In Transit) AND orderStatus=2 (Shipping)
        String sql = "UPDATE dbo.Orders SET shippingStatus = 2, orderStatus = 2 WHERE orderId = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, orderId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    // Atomic delivery failure: updates shippingStatus and formally cancels the order
    public boolean updateDeliveryFailure(long orderId, String reason) {
        // Failure means shippingStatus=4. We also set orderStatus=4 (Cancelled)
        // and record the shipper feedback as the cancelledReason.
        String sql = "UPDATE dbo.Orders SET shippingStatus = 4, orderStatus = 4, "
                   + "cancelledAt = GETDATE(), cancelledReason = CONCAT('Shipper báo lỗi: ', ?), "
                   + "note = CONCAT(ISNULL(note, ''), ' | Giao thất bại: ', ?) WHERE orderId = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, reason);
            ps.setString(2, reason);
            ps.setLong(3, orderId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    // New: Staff-initiated cancellation with formal reason
    public boolean cancelOrder(long orderId, String reason) {
        String sql = "UPDATE dbo.Orders SET orderStatus = 4, cancelledAt = GETDATE(), cancelledReason = ? WHERE orderId = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, reason);
            ps.setLong(2, orderId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }
}
