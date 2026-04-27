package org.example.dao;

import org.example.dto.CartItemDTO;
import org.example.model.marketing.Voucher;
import org.example.model.order.Order;
import org.example.model.order.OrderItem;
import org.example.utils.DBConnection;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;


public class OrderDAO {

    // ─── Inner class ────────────────────────────────────────────────────────
    private static class BatchInfo {
        long   batchId;
        int    quantityOnHand;
        int    quantityReserved;
        Date   expiryDate;
        String batchCode;
    }


    /**
     * Place an order from the cart contents.
     *
     * @param accountId      buyer's account
     * @param recipientName  shipping name
     * @param recipientPhone shipping phone
     * @param shippingAddress shipping address
     * @param note           optional note
     * @param cartItems      items from CartDAO.getCartItems (must NOT be empty)
     * @param voucher        nullable – validated voucher to apply
     * @param cartId         cart to clear after success
     * @param shouldClearCart whether to clear the cart after success
     * @return orderId on success
     * @throws Exception with a Vietnamese user-facing message on any failure
     */
    public long createOrder(long accountId,
                            String recipientName, String recipientPhone,
                            String shippingAddress, String note,
                            List<CartItemDTO> cartItems,
                            Voucher voucher, long cartId, String paymentMethod,
                            boolean shouldClearCart) throws Exception {

        if (cartItems == null || cartItems.isEmpty()) {
            throw new Exception("Giỏ hàng trống!");
        }

        Connection conn = DBConnection.getConnection();
        if (conn == null) throw new Exception("Không thể kết nối cơ sở dữ liệu!");

        try {
            conn.setAutoCommit(false);

            // ── 1. Calculate base subtotal (at full pack price) ─────────────
            BigDecimal subtotalAmount = cartItems.stream()
                    .map(CartItemDTO::getLineTotal)
                    .reduce(BigDecimal.ZERO, BigDecimal::add);

            // ── 2. Voucher discount ──────────────────────────────────────────
            BigDecimal voucherDiscount = BigDecimal.ZERO;
            if (voucher != null) {
                if (voucher.getDiscountType() == 1) {           // percentage
                    voucherDiscount = subtotalAmount
                            .multiply(voucher.getDiscountValue())
                            .divide(BigDecimal.valueOf(100), 2, RoundingMode.HALF_UP);
                } else {                                        // fixed amount
                    voucherDiscount = voucher.getDiscountValue();
                }
                if (voucher.getMaxDiscountAmount() != null) {
                    voucherDiscount = voucherDiscount.min(voucher.getMaxDiscountAmount());
                }
                voucherDiscount = voucherDiscount.min(subtotalAmount);
            }

            // ── 3. Shipping fee: free when subtotal >= 500,000 ₫ ────────────
            BigDecimal shippingFee = subtotalAmount.compareTo(new BigDecimal("500000")) >= 0
                    ? BigDecimal.ZERO : new BigDecimal("30000");

            // ── 4. Insert Order row (totals corrected later after expiry calc) ─
            String orderCode = "ORD" + System.currentTimeMillis() + (int)(Math.random() * 1000);
            long orderId = insertOrder(conn, orderCode, accountId,
                    subtotalAmount, voucherDiscount, shippingFee,
                    recipientName, recipientPhone, shippingAddress, note, (byte) 0);

            // ── 5. FEFO allocation loop ──────────────────────────────────────
            BigDecimal totalExpiryDiscount = BigDecimal.ZERO;

            for (CartItemDTO item : cartItems) {
                int needed = item.getQuantity();
                List<BatchInfo> batches = getAvailableBatches(conn, item.getProductPackId());

                if (batches.isEmpty()) {
                    conn.rollback();
                    throw new Exception("Sản phẩm '" + item.getProductName() +
                            "' hiện không có hàng trong kho. Vui lòng xóa khỏi giỏ và thử lại.");
                }

                // Plan allocations without touching DB yet
                List<Object[]> allocPlan = new ArrayList<>(); // [BatchInfo, qty, sellPercent, finalPrice, lineTotal]
                int remaining = needed;
                for (BatchInfo batch : batches) {
                    if (remaining <= 0) break;
                    int available = batch.quantityOnHand - batch.quantityReserved;
                    int toAllocate = Math.min(remaining, available);

                    BigDecimal sellPercent = getSellPricePercent(
                            conn, item.getExpiryPricingPolicyId(), batch.expiryDate);
                    BigDecimal finalPackPrice = item.getComputedPackBasePrice()
                            .multiply(sellPercent)
                            .divide(BigDecimal.valueOf(100), 2, RoundingMode.HALF_UP);
                    BigDecimal allocLineTotal = finalPackPrice.multiply(BigDecimal.valueOf(toAllocate));

                    allocPlan.add(new Object[]{batch, toAllocate, sellPercent, finalPackPrice, allocLineTotal});
                    remaining -= toAllocate;
                }

                if (remaining > 0) {
                    conn.rollback();
                    throw new Exception("Không đủ hàng cho '" + item.getProductName() +
                            "'. Cần " + needed + ", chỉ còn " + (needed - remaining) + " trong kho.");
                }

                // Compute OrderItem totals
                BigDecimal lineSubtotal = item.getComputedPackBasePrice()
                        .multiply(BigDecimal.valueOf(needed));
                BigDecimal lineTotal = allocPlan.stream()
                        .map(a -> (BigDecimal) a[4])
                        .reduce(BigDecimal.ZERO, BigDecimal::add);
                BigDecimal lineDiscount = lineSubtotal.subtract(lineTotal);
                totalExpiryDiscount = totalExpiryDiscount.add(lineDiscount);

                // Insert OrderItem
                long orderItemId = insertOrderItem(conn, orderId, item,
                        lineSubtotal, lineDiscount, lineTotal);

                // Apply allocations
                for (Object[] alloc : allocPlan) {
                    BatchInfo batch   = (BatchInfo) alloc[0];
                    int       qty     = (int)       alloc[1];
                    BigDecimal sell   = (BigDecimal) alloc[2];
                    BigDecimal fp     = (BigDecimal) alloc[3];
                    BigDecimal lt     = (BigDecimal) alloc[4];

                    updateBatchReserved(conn, batch.batchId, qty);
                    insertAllocation(conn, orderItemId, batch, qty,
                            item.getComputedPackBasePrice(), sell, fp, lt);
                    insertInventoryTransaction(conn, batch.batchId, 2, qty,
                            "ORDER", orderId, accountId);
                }
            }

            // ── 6. Update final totals on the Order row ──────────────────────
            BigDecimal totalDiscountAmount = voucherDiscount.add(totalExpiryDiscount);
            BigDecimal totalAmount = subtotalAmount
                    .subtract(totalDiscountAmount)
                    .add(shippingFee)
                    .max(BigDecimal.ZERO);
            updateOrderAmounts(conn, orderId, totalDiscountAmount, totalAmount);

            // ── 7. Insert Payment record ─────────────────────────────────────
            insertPayment(conn, orderId, totalAmount, paymentMethod);

            // ── 8. Record voucher usage ──────────────────────────────────────
            if (voucher != null && voucherDiscount.compareTo(BigDecimal.ZERO) > 0) {
                insertOrderVoucher(conn, orderId, voucher.getVoucherId(),
                        voucher.getVoucherCode(), voucherDiscount);
                incrementVoucherUsage(conn, voucher.getVoucherId());
            }

            // ── 9. Clear cart ────────────────────────────────────────────────
            if (shouldClearCart) {
                clearCartItems(conn, cartId);
            }

            conn.commit();
            return orderId;

        } catch (Exception e) {
            try { conn.rollback(); } catch (Exception ignored) {}
            throw e;
        } finally {
            try { conn.setAutoCommit(true); conn.close(); } catch (Exception ignored) {}
        }
    }

    // ────────────────────────────────────────────────────────────────────────
    // CANCEL ORDER
    // ────────────────────────────────────────────────────────────────────────

    public boolean cancelOrder(long orderId, long accountId) {
        String checkSql = "SELECT orderId FROM dbo.Orders " +
                "WHERE orderId = ? AND accountId = ? AND orderStatus = 1";
        try (Connection conn = DBConnection.getConnection()) {
            try (PreparedStatement ps = conn.prepareStatement(checkSql)) {
                ps.setLong(1, orderId);
                ps.setLong(2, accountId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (!rs.next()) return false; // not found or not cancellable
                }
            }

            conn.setAutoCommit(false);
            try {
                // Mark order as cancelled (status 6)
                try (PreparedStatement ps = conn.prepareStatement(
                        "UPDATE dbo.Orders SET orderStatus = 6, cancelledAt = SYSUTCDATETIME(), " +
                        "cancelledReason = N'Kh\u00e1ch h\u00e0ng h\u1ee7y \u0111\u01a1n' WHERE orderId = ?")) {
                    ps.setLong(1, orderId);
                    ps.executeUpdate();
                }

                // Fetch allocations to release
                String allocSql = "SELECT oia.batchId, oia.quantity " +
                        "FROM dbo.OrderItemAllocations oia " +
                        "JOIN dbo.OrderItems oi ON oia.orderItemId = oi.orderItemId " +
                        "WHERE oi.orderId = ?";
                List<long[]> allocations = new ArrayList<>();
                try (PreparedStatement ps = conn.prepareStatement(allocSql)) {
                    ps.setLong(1, orderId);
                    try (ResultSet rs = ps.executeQuery()) {
                        while (rs.next()) {
                            allocations.add(new long[]{rs.getLong("batchId"), rs.getLong("quantity")});
                        }
                    }
                }

                for (long[] alloc : allocations) {
                    long batchId = alloc[0];
                    int  qty     = (int) alloc[1];

                    // Release reserved stock
                    try (PreparedStatement ps = conn.prepareStatement(
                            "UPDATE dbo.InventoryBatches " +
                            "SET quantityReserved = quantityReserved - ?, updatedAt = SYSUTCDATETIME() " +
                            "WHERE batchId = ?")) {
                        ps.setInt(1, qty);
                        ps.setLong(2, batchId);
                        ps.executeUpdate();
                    }

                    // Inventory transaction type 3 = RELEASE
                    insertInventoryTransaction(conn, batchId, 3, qty, "ORDER", orderId, accountId);
                }

                conn.commit();
                return true;
            } catch (Exception e) {
                try { conn.rollback(); } catch (Exception ignored) {}
                e.printStackTrace();
                return false;
            } finally {
                conn.setAutoCommit(true);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // ────────────────────────────────────────────────────────────────────────
    // QUERY METHODS
    // ────────────────────────────────────────────────────────────────────────

    public List<Order> getOrdersByAccountPaginated(long accountId, int offset, int limit) {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT * FROM dbo.Orders WHERE accountId = ? " +
                     "ORDER BY placedAt DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, accountId);
            ps.setInt(2, offset);
            ps.setInt(3, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapOrder(rs));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public int countOrdersByAccount(long accountId) {
        String sql = "SELECT COUNT(*) FROM dbo.Orders WHERE accountId = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, accountId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    /** Returns the order only if it belongs to the given accountId (ownership check). */
    public Order getOrderById(long orderId, long accountId) {
        String sql = "SELECT * FROM dbo.Orders WHERE orderId = ? AND accountId = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, orderId);
            ps.setLong(2, accountId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapOrder(rs);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }

    public List<OrderItem> getOrderItemsByOrderId(long orderId) {
        List<OrderItem> list = new ArrayList<>();
        String sql = "SELECT * FROM dbo.OrderItems WHERE orderId = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    OrderItem item = new OrderItem();
                    item.setOrderItemId(rs.getLong("orderItemId"));
                    item.setOrderId(rs.getLong("orderId"));
                    item.setProductId(rs.getLong("productId"));
                    long packId = rs.getLong("productPackId");
                    item.setProductPackId(rs.wasNull() ? null : packId);
                    item.setProductNameSnapshot(rs.getString("productNameSnapshot"));
                    item.setPackWeightGramSnapshot(rs.getInt("packWeightGramSnapshot"));
                    item.setImageUrlSnapshot(rs.getString("imageUrlSnapshot"));
                    item.setComputedPackBasePriceSnapshot(rs.getBigDecimal("computedPackBasePriceSnapshot"));
                    item.setOrderedQuantity(rs.getInt("orderedQuantity"));
                    item.setLineSubtotalSnapshot(rs.getBigDecimal("lineSubtotalSnapshot"));
                    item.setLineDiscountSnapshot(rs.getBigDecimal("lineDiscountSnapshot"));
                    item.setLineTotalSnapshot(rs.getBigDecimal("lineTotalSnapshot"));
                    list.add(item);
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    // ────────────────────────────────────────────────────────────────────────
    // PRIVATE HELPERS
    // ────────────────────────────────────────────────────────────────────────

    /** Query available inventory batches for a pack, ordered by expiry (FEFO). */
    private List<BatchInfo> getAvailableBatches(Connection conn, long productPackId) throws SQLException {
        List<BatchInfo> batches = new ArrayList<>();
        String sql = "SELECT ib.batchId, ib.quantityOnHand, ib.quantityReserved, " +
                "gri.expiryDate, gri.batchCode " +
                "FROM dbo.InventoryBatches ib " +
                "JOIN dbo.GoodsReceiptItems gri ON ib.receiptItemId = gri.receiptItemId " +
                "WHERE gri.productPackId = ? AND ib.status = 1 " +
                "AND (ib.quantityOnHand - ib.quantityReserved) > 0 " +
                "ORDER BY gri.expiryDate ASC";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, productPackId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    BatchInfo b = new BatchInfo();
                    b.batchId           = rs.getLong("batchId");
                    b.quantityOnHand    = rs.getInt("quantityOnHand");
                    b.quantityReserved  = rs.getInt("quantityReserved");
                    b.expiryDate        = rs.getDate("expiryDate");
                    b.batchCode         = rs.getString("batchCode");
                    batches.add(b);
                }
            }
        }
        return batches;
    }

    /**
     * Determine the sell price percentage from the expiry pricing policy rules.
     * Finds the rule with the highest minDaysRemaining that is still <= daysUntilExpiry.
     * Returns 100 when no policy is set or no rule applies.
     */
    private BigDecimal getSellPricePercent(Connection conn,
                                            Integer expiryPricingPolicyId,
                                            Date expiryDate) throws SQLException {
        if (expiryPricingPolicyId == null) return BigDecimal.valueOf(100);
        String sql = "SELECT TOP 1 sellPricePercent FROM dbo.ExpiryPricingPolicyRules " +
                "WHERE policyId = ? AND minDaysRemaining <= DATEDIFF(day, GETUTCDATE(), ?) " +
                "ORDER BY minDaysRemaining DESC";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, expiryPricingPolicyId);
            ps.setDate(2, expiryDate);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getBigDecimal("sellPricePercent");
            }
        }
        return BigDecimal.valueOf(100);
    }

    private long insertOrder(Connection conn, String orderCode, long accountId,
                              BigDecimal subtotal, BigDecimal discount, BigDecimal shippingFee,
                              String name, String phone, String address, String note, byte paymentStatus) throws SQLException {
        String sql = "INSERT INTO dbo.Orders " +
                "(orderCode, accountId, orderStatus, paymentStatus, " +
                " subtotalAmount, discountAmount, shippingFee, totalAmount, " +
                " recipientNameSnapshot, recipientPhoneSnapshot, shippingAddressSnapshot, note) " +
                "VALUES (?, ?, 1, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        BigDecimal preliminary = subtotal.subtract(discount).add(shippingFee).max(BigDecimal.ZERO);
        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, orderCode);
            ps.setLong(2, accountId);
            ps.setByte(3, paymentStatus);
            ps.setBigDecimal(4, subtotal);
            ps.setBigDecimal(5, discount);   // updated later
            ps.setBigDecimal(6, shippingFee);
            ps.setBigDecimal(7, preliminary); // updated later
            ps.setNString(8, name);
            ps.setNString(9, phone);
            ps.setNString(10, address);
            ps.setNString(11, note);
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) return rs.getLong(1);
            }
        }
        throw new SQLException("Failed to insert order row");
    }

    private void updateOrderAmounts(Connection conn, long orderId,
                                     BigDecimal discount, BigDecimal total) throws SQLException {
        try (PreparedStatement ps = conn.prepareStatement(
                "UPDATE dbo.Orders SET discountAmount = ?, totalAmount = ? WHERE orderId = ?")) {
            ps.setBigDecimal(1, discount);
            ps.setBigDecimal(2, total);
            ps.setLong(3, orderId);
            ps.executeUpdate();
        }
    }

    private long insertOrderItem(Connection conn, long orderId, CartItemDTO item,
                                  BigDecimal lineSubtotal, BigDecimal lineDiscount,
                                  BigDecimal lineTotal) throws SQLException {
        String sql = "INSERT INTO dbo.OrderItems " +
                "(orderId, productId, productPackId, productNameSnapshot, packWeightGramSnapshot, " +
                " imageUrlSnapshot, computedPackBasePriceSnapshot, orderedQuantity, " +
                " lineSubtotalSnapshot, lineDiscountSnapshot, lineTotalSnapshot) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setLong(1, orderId);
            ps.setLong(2, item.getProductId());
            ps.setLong(3, item.getProductPackId());
            ps.setString(4, item.getProductName());
            ps.setInt(5, item.getPackWeightGram());
            ps.setString(6, item.getImageUrl());
            ps.setBigDecimal(7, item.getComputedPackBasePrice());
            ps.setInt(8, item.getQuantity());
            ps.setBigDecimal(9, lineSubtotal);
            ps.setBigDecimal(10, lineDiscount);
            ps.setBigDecimal(11, lineTotal);
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) return rs.getLong(1);
            }
        }
        throw new SQLException("Failed to insert order item");
    }

    private void updateBatchReserved(Connection conn, long batchId, int qty) throws SQLException {
        try (PreparedStatement ps = conn.prepareStatement(
                "UPDATE dbo.InventoryBatches " +
                "SET quantityReserved = quantityReserved + ?, updatedAt = SYSUTCDATETIME() " +
                "WHERE batchId = ?")) {
            ps.setInt(1, qty);
            ps.setLong(2, batchId);
            ps.executeUpdate();
        }
    }

    private void insertAllocation(Connection conn, long orderItemId, BatchInfo batch, int qty,
                                   BigDecimal basePrice, BigDecimal sellPercent,
                                   BigDecimal finalPrice, BigDecimal lineTotal) throws SQLException {
        String sql = "INSERT INTO dbo.OrderItemAllocations " +
                "(orderItemId, batchId, batchCodeSnapshot, expiryDateSnapshot, quantity, " +
                " basePackPriceSnapshot, sellPricePercentSnapshot, finalPackPriceSnapshot, lineTotalSnapshot) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, orderItemId);
            ps.setLong(2, batch.batchId);
            ps.setString(3, batch.batchCode);
            ps.setDate(4, batch.expiryDate);
            ps.setInt(5, qty);
            ps.setBigDecimal(6, basePrice);
            ps.setBigDecimal(7, sellPercent);
            ps.setBigDecimal(8, finalPrice);
            ps.setBigDecimal(9, lineTotal);
            ps.executeUpdate();
        }
    }

    private void insertInventoryTransaction(Connection conn, long batchId, int type, int qty,
                                             String refType, long refId, long accountId) throws SQLException {
        String sql = "INSERT INTO dbo.InventoryTransactions " +
                "(batchId, transactionType, quantity, referenceType, referenceId, performedByAccountId) " +
                "VALUES (?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, batchId);
            ps.setInt(2, type);
            ps.setInt(3, qty);
            ps.setString(4, refType);
            ps.setLong(5, refId);
            ps.setLong(6, accountId);
            ps.executeUpdate();
        }
    }

    private void insertPayment(Connection conn, long orderId, BigDecimal amount, String provider) throws SQLException {
        try (PreparedStatement ps = conn.prepareStatement(
                "INSERT INTO dbo.Payments (orderId, provider, amount, paymentStatus) " +
                "VALUES (?, ?, ?, 0)")) {
            ps.setLong(1, orderId);
            ps.setString(2, provider);
            ps.setBigDecimal(3, amount);
            ps.executeUpdate();
        }
    }

    public boolean updatePaymentStatus(long orderId, byte paymentStatus, byte orderStatus) {
        String sql = "UPDATE dbo.Orders SET paymentStatus = ?, orderStatus = ?, "
                   + "paidAt = CASE WHEN ? IN (1, 2) THEN SYSUTCDATETIME() ELSE paidAt END "
                   + "WHERE orderId = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setByte(1, paymentStatus);
            ps.setByte(2, orderStatus);
            ps.setByte(3, paymentStatus);
            ps.setLong(4, orderId);

            int affected = ps.executeUpdate();
            
            // Also update the Payments table
            updatePaymentRecord(orderId, paymentStatus);

            return affected > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    private void updatePaymentRecord(long orderId, byte status) throws SQLException {
        String sql = "UPDATE dbo.Payments SET paymentStatus = ?, "
                   + "paidAt = CASE WHEN ? IN (1, 2) THEN SYSUTCDATETIME() ELSE paidAt END "
                   + "WHERE orderId = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setByte(1, status);
            ps.setByte(2, status);
            ps.setLong(3, orderId);
            ps.executeUpdate();
        }
    }

    public void updatePaymentTransaction(long orderId, String transactionNo) {
        String sql = "UPDATE dbo.Payments SET gatewayTransactionId = ? WHERE orderId = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, transactionNo);
            ps.setLong(2, orderId);
            ps.executeUpdate();
        } catch (Exception e) { e.printStackTrace(); }
    }

    private void insertOrderVoucher(Connection conn, long orderId, long voucherId,
                                     String voucherCode, BigDecimal discount) throws SQLException {
        try (PreparedStatement ps = conn.prepareStatement(
                "INSERT INTO dbo.OrderVouchers " +
                "(orderId, voucherId, voucherCodeSnapshot, discountAmountSnapshot) " +
                "VALUES (?, ?, ?, ?)")) {
            ps.setLong(1, orderId);
            ps.setLong(2, voucherId);
            ps.setString(3, voucherCode);
            ps.setBigDecimal(4, discount);
            ps.executeUpdate();
        }
    }

    private void incrementVoucherUsage(Connection conn, long voucherId) throws SQLException {
        try (PreparedStatement ps = conn.prepareStatement(
                "UPDATE dbo.Vouchers SET usedCount = usedCount + 1 WHERE voucherId = ?")) {
            ps.setLong(1, voucherId);
            ps.executeUpdate();
        }
    }

    private void clearCartItems(Connection conn, long cartId) throws SQLException {
        try (PreparedStatement ps = conn.prepareStatement(
                "DELETE FROM dbo.CartItems WHERE cartId = ?")) {
            ps.setLong(1, cartId);
            ps.executeUpdate();
        }
    }

    public List<Order> searchOrders(String query) {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT * FROM dbo.Orders WHERE orderCode LIKE ? OR recipientNameSnapshot LIKE ? ORDER BY placedAt DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            String searchTerm = "%" + query + "%";
            ps.setString(1, searchTerm);
            ps.setString(2, searchTerm);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapOrder(rs));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public List<Order> getAllOrdersPaginated(int offset, int limit) {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT * FROM dbo.Orders ORDER BY placedAt DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, offset);
            ps.setInt(2, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapOrder(rs));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public int countAllOrders() {
        String sql = "SELECT COUNT(*) FROM dbo.Orders";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    public List<Order> searchOrdersPaginated(String query, int offset, int limit) {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT * FROM dbo.Orders WHERE orderCode LIKE ? OR recipientNameSnapshot LIKE ? " +
                     "ORDER BY placedAt DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            String searchTerm = "%" + query + "%";
            ps.setString(1, searchTerm);
            ps.setString(2, searchTerm);
            ps.setInt(3, offset);
            ps.setInt(4, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapOrder(rs));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public int countSearchOrders(String query) {
        String sql = "SELECT COUNT(*) FROM dbo.Orders WHERE orderCode LIKE ? OR recipientNameSnapshot LIKE ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            String searchTerm = "%" + query + "%";
            ps.setString(1, searchTerm);
            ps.setString(2, searchTerm);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    // ────────────────────────────────────────────────────────────────────────
    // MAPPING
    // ────────────────────────────────────────────────────────────────────────

    private Order mapOrder(ResultSet rs) throws SQLException {
        Order o = new Order();
        o.setOrderId(rs.getLong("orderId"));
        o.setOrderCode(rs.getString("orderCode"));
        o.setAccountId(rs.getLong("accountId"));
        long shipperId = rs.getLong("shipperId");
        o.setShipperId(rs.wasNull() ? null : shipperId);
        o.setOrderStatus(rs.getByte("orderStatus"));
        o.setPaymentStatus(rs.getByte("paymentStatus"));
        byte shippingStatus = rs.getByte("shippingStatus");
        o.setShippingStatus(rs.wasNull() ? null : shippingStatus);
        o.setSubtotalAmount(rs.getBigDecimal("subtotalAmount"));
        o.setDiscountAmount(rs.getBigDecimal("discountAmount"));
        o.setShippingFee(rs.getBigDecimal("shippingFee"));
        o.setTotalAmount(rs.getBigDecimal("totalAmount"));
        o.setRecipientNameSnapshot(rs.getString("recipientNameSnapshot"));
        o.setRecipientPhoneSnapshot(rs.getString("recipientPhoneSnapshot"));
        o.setShippingAddressSnapshot(rs.getString("shippingAddressSnapshot"));
        o.setNote(rs.getString("note"));
        if (rs.getTimestamp("placedAt") != null)
            o.setPlacedAt(rs.getTimestamp("placedAt").toLocalDateTime());
        if (rs.getTimestamp("paidAt") != null)
            o.setPaidAt(rs.getTimestamp("paidAt").toLocalDateTime());
        if (rs.getTimestamp("cancelledAt") != null)
            o.setCancelledAt(rs.getTimestamp("cancelledAt").toLocalDateTime());
        o.setCancelledReason(rs.getString("cancelledReason"));
        return o;
    }

    // ────────────────────────────────────────────────────────────────────────
    // EXTENDED ORDER MANAGEMENT (STAFF & SHIPPER)
    // ────────────────────────────────────────────────────────────────────────

    public List<Order> getAllOrders() {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT * FROM dbo.Orders ORDER BY placedAt DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapOrder(rs));
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public List<Order> getOrdersByDateRange(String startDate, String endDate) {
        List<Order> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM dbo.Orders WHERE 1=1 ");
        
        if (startDate != null && !startDate.isEmpty()) {
            sql.append(" AND placedAt >= ? ");
        }
        if (endDate != null && !endDate.isEmpty()) {
            sql.append(" AND placedAt <= ? ");
        }
        sql.append(" ORDER BY placedAt DESC");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            int paramIndex = 1;
            if (startDate != null && !startDate.isEmpty()) {
                ps.setTimestamp(paramIndex++, java.sql.Timestamp.valueOf(startDate + " 00:00:00"));
            }
            if (endDate != null && !endDate.isEmpty()) {
                ps.setTimestamp(paramIndex++, java.sql.Timestamp.valueOf(endDate + " 23:59:59"));
            }
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapOrder(rs));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public List<Order> getOrdersByShipper(long shipperId) {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT * FROM dbo.Orders WHERE shipperId = ? ORDER BY placedAt DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, shipperId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapOrder(rs));
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
                if (rs.next()) return mapOrder(rs);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }

    public boolean updateOrderStatus(long orderId, byte status) {
        String sql = "UPDATE dbo.Orders SET orderStatus = ? WHERE orderId = ?";
        
        // Trạng thái 3: Đóng gói xong -> Sẵn sàng để các Shipper nhận đơn (để trống shipperId)
        if (status == 3) {
            sql = "UPDATE dbo.Orders SET orderStatus = ?, shipperId = NULL, shippingStatus = 1 WHERE orderId = ?";
        }

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setByte(1, status);
            ps.setLong(2, orderId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    public boolean assignShipper(long orderId, long shipperId) {
        // Kiểm tra xem shipper có đang bận giao đơn nào không (shippingStatus = 2)
        if (isShipperBusy(shipperId)) return false;

        String sql = "UPDATE dbo.Orders SET shipperId = ?, shippingStatus = 1 WHERE orderId = ? AND shipperId IS NULL";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, shipperId);
            ps.setLong(2, orderId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    public boolean isShipperBusy(long shipperId) {
        // Bận nếu có đơn đang ở trạng thái 1 (Vừa nhận/Chờ lấy) hoặc 2 (Đang đi giao)
        String sql = "SELECT COUNT(*) FROM dbo.Orders WHERE shipperId = ? AND shippingStatus IN (1, 2)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, shipperId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1) > 0;
            }
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    public List<Order> getAvailableOrders() {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT * FROM dbo.Orders WHERE orderStatus = 3 AND shippingStatus = 1 AND shipperId IS NULL ORDER BY placedAt ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapOrder(rs));
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public List<Order> getShipperTasks(long shipperId) {
        List<Order> list = new ArrayList<>();
        // Lấy các đơn của shipper này, sắp xếp đơn ĐANG GIAO lên đầu
        String sql = "SELECT * FROM dbo.Orders WHERE shipperId = ? " +
                     "ORDER BY CASE WHEN shippingStatus = 2 THEN 0 ELSE 1 END, placedAt DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, shipperId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapOrder(rs));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public boolean updatePaymentStatus(long orderId, byte paymentStatus) {
        String sql = "UPDATE dbo.Orders SET paymentStatus = ?, "
                   + "paidAt = CASE WHEN ? IN (1, 2) THEN SYSUTCDATETIME() ELSE paidAt END "
                   + "WHERE orderId = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setByte(1, paymentStatus);
            ps.setByte(2, paymentStatus);
            ps.setLong(3, orderId);
            
            int rows = ps.executeUpdate();
            if (rows > 0) {
                updatePaymentRecord(orderId, paymentStatus);
            }
            return rows > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    public boolean updateDeliverySuccess(long orderId) {
        String sql = "UPDATE dbo.Orders SET shippingStatus = 3, orderStatus = 5, "
                   + "paymentStatus = CASE WHEN paymentStatus = 1 THEN 1 ELSE 2 END, "
                   + "paidAt = CASE WHEN paidAt IS NULL THEN SYSUTCDATETIME() ELSE paidAt END "
                   + "WHERE orderId = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, orderId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    public boolean updateStartShipping(long orderId) {
        String sql = "UPDATE dbo.Orders SET shippingStatus = 2, orderStatus = 4 WHERE orderId = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, orderId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    public boolean updateDeliveryFailure(long orderId, String reason) {
        // Chỉ cập nhật lý do hủy vào cancelledReason, không làm rối cột note
        String sql = "UPDATE dbo.Orders SET shippingStatus = 4, orderStatus = 6, "
                   + "cancelledAt = SYSUTCDATETIME(), cancelledReason = CONCAT(N'Shipper b\u00e1o l\u1ed7i: ', ?) "
                   + "WHERE orderId = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setNString(1, reason);
            ps.setLong(2, orderId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    public java.util.Map<String, Object> getShipperStats(long shipperId) {
        java.util.Map<String, Object> stats = new java.util.HashMap<>();
        stats.put("totalOrders", 0);
        stats.put("successOrders", 0);
        stats.put("totalEarnings", java.math.BigDecimal.ZERO);
        stats.put("totalIncome", java.math.BigDecimal.ZERO);
        stats.put("totalRemitted", java.math.BigDecimal.ZERO);
        stats.put("activeOrders", 0);

        String sql = "SELECT " +
                     "  COUNT(*) AS totalOrders, " +
                     "  SUM(CASE WHEN shippingStatus = 3 THEN 1 ELSE 0 END) AS successOrders, " +
                     "  SUM(CASE WHEN shippingStatus = 3 AND paymentStatus = 2 THEN totalAmount ELSE 0 END) AS totalEarnings, " +
                     "  SUM(CASE WHEN shippingStatus = 3 THEN shippingFee ELSE 0 END) AS totalIncome, " +
                     "  SUM(CASE WHEN shippingStatus = 3 AND paymentStatus = 3 THEN totalAmount ELSE 0 END) AS totalRemitted, " +
                     "  SUM(CASE WHEN shippingStatus IN (1, 2) THEN 1 ELSE 0 END) AS activeOrders " +
                     "FROM dbo.Orders WHERE shipperId = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, shipperId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    stats.put("totalOrders", rs.getInt("totalOrders"));
                    stats.put("successOrders", rs.getInt("successOrders"));
                    java.math.BigDecimal earnings = rs.getBigDecimal("totalEarnings");
                    stats.put("totalEarnings", earnings != null ? earnings : java.math.BigDecimal.ZERO);
                    java.math.BigDecimal income = rs.getBigDecimal("totalIncome");
                    stats.put("totalIncome", income != null ? income : java.math.BigDecimal.ZERO);
                    java.math.BigDecimal remitted = rs.getBigDecimal("totalRemitted");
                    stats.put("totalRemitted", remitted != null ? remitted : java.math.BigDecimal.ZERO);
                    stats.put("activeOrders", rs.getInt("activeOrders"));
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return stats;
    }

    public boolean remitCOD(long shipperId) {
        String sql = "UPDATE dbo.Orders SET paymentStatus = 3 WHERE shipperId = ? AND shippingStatus = 3 AND paymentStatus = 2";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, shipperId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    public List<Order> getLatestOrdersByAccount(long accountId, int limit) {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT TOP (?) * FROM dbo.Orders WHERE accountId = ? ORDER BY placedAt DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            ps.setLong(2, accountId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapOrder(rs));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }
}
