package org.example.dao;

import org.example.dto.inventory.GoodsReceiptForm;
import org.example.dto.inventory.GoodsReceiptItemView;
import org.example.dto.inventory.GoodsReceiptLineForm;
import org.example.dto.inventory.GoodsReceiptView;
import org.example.dto.inventory.InventoryBatchView;
import org.example.dto.inventory.InventoryTransactionView;
import org.example.dto.inventory.ProductPackOption;
import org.example.utils.DBConnection;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

public class InventoryDAO {
    private static final int TRANSACTION_TYPE_RECEIPT = 1;
    private static final int EXPIRING_SOON_DAYS = 3;

    public List<ProductPackOption> getActiveProductPackOptions() {
        List<ProductPackOption> options = new ArrayList<>();
        String sql = "SELECT pp.productPackId, pp.productId, p.productName, pp.packWeightGram " +
                "FROM dbo.ProductPacks pp " +
                "JOIN dbo.Products p ON pp.productId = p.productId " +
                "WHERE pp.status = 1 AND p.status = 1 " +
                "ORDER BY p.productName ASC, pp.packWeightGram ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                ProductPackOption option = new ProductPackOption();
                option.setProductPackId(rs.getLong("productPackId"));
                option.setProductId(rs.getLong("productId"));
                option.setProductName(rs.getString("productName"));
                option.setPackWeightGram(rs.getInt("packWeightGram"));
                option.setDisplayName(option.getProductName() + " - " + option.getPackWeightGram() + "g");
                options.add(option);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return options;
    }

    public List<GoodsReceiptView> getGoodsReceiptList() {
        List<GoodsReceiptView> list = new ArrayList<>();
        String sql = "SELECT gr.receiptId, gr.receiptCode, gr.supplierId, s.supplierName, s.phone, gr.receivedAt, gr.status, gr.note, " +
                "(SELECT COUNT(*) FROM dbo.GoodsReceiptItems gri WHERE gri.receiptId = gr.receiptId) AS totalLines, " +
                "(SELECT ISNULL(SUM(gri.quantityReceived), 0) FROM dbo.GoodsReceiptItems gri WHERE gri.receiptId = gr.receiptId) AS totalQuantity, " +
                "CASE WHEN EXISTS ( " +
                "   SELECT 1 " +
                "   FROM dbo.GoodsReceiptItems gri " +
                "   JOIN dbo.InventoryBatches ib ON gri.receiptItemId = ib.receiptItemId " +
                "   WHERE gri.receiptId = gr.receiptId AND ( " +
                "       ib.quantityReserved > 0 OR " +
                "       EXISTS (SELECT 1 FROM dbo.OrderItemAllocations oia WHERE oia.batchId = ib.batchId) OR " +
                "       EXISTS (SELECT 1 FROM dbo.InventoryTransactions it WHERE it.batchId = ib.batchId AND (it.transactionType <> ? OR ISNULL(it.referenceType, '') <> 'RECEIPT')) " +
                "   ) " +
                ") THEN 0 ELSE 1 END AS editableFlag " +
                "FROM dbo.GoodsReceipts gr " +
                "JOIN dbo.Suppliers s ON gr.supplierId = s.supplierId " +
                "ORDER BY gr.receivedAt DESC, gr.receiptId DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, TRANSACTION_TYPE_RECEIPT);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    GoodsReceiptView view = new GoodsReceiptView();
                    view.setReceiptId(rs.getLong("receiptId"));
                    view.setReceiptCode(rs.getString("receiptCode"));
                    view.setSupplierId(rs.getLong("supplierId"));
                    view.setSupplierName(rs.getString("supplierName"));
                    view.setSupplierPhone(rs.getString("phone"));
                    Timestamp receivedAt = rs.getTimestamp("receivedAt");
                    if (receivedAt != null) {
                        view.setReceivedAt(receivedAt.toLocalDateTime());
                    }
                    view.setStatus(rs.getInt("status"));
                    view.setNote(rs.getString("note"));
                    view.setTotalLines(rs.getInt("totalLines"));
                    view.setTotalQuantity(rs.getInt("totalQuantity"));
                    view.setEditable(rs.getInt("editableFlag") == 1);
                    list.add(view);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public GoodsReceiptView getGoodsReceiptDetail(long receiptId) {
        String headerSql = "SELECT gr.receiptId, gr.receiptCode, gr.supplierId, s.supplierName, s.phone, gr.receivedAt, gr.status, gr.note " +
                "FROM dbo.GoodsReceipts gr " +
                "JOIN dbo.Suppliers s ON gr.supplierId = s.supplierId " +
                "WHERE gr.receiptId = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(headerSql)) {
            ps.setLong(1, receiptId);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) {
                    return null;
                }
                GoodsReceiptView view = new GoodsReceiptView();
                view.setReceiptId(rs.getLong("receiptId"));
                view.setReceiptCode(rs.getString("receiptCode"));
                view.setSupplierId(rs.getLong("supplierId"));
                view.setSupplierName(rs.getString("supplierName"));
                view.setSupplierPhone(rs.getString("phone"));
                Timestamp receivedAt = rs.getTimestamp("receivedAt");
                if (receivedAt != null) {
                    view.setReceivedAt(receivedAt.toLocalDateTime());
                }
                view.setStatus(rs.getInt("status"));
                view.setNote(rs.getString("note"));
                view.setItems(getReceiptItems(conn, receiptId));
                view.setTotalLines(view.getItems().size());
                int totalQty = 0;
                for (GoodsReceiptItemView item : view.getItems()) {
                    totalQty += item.getQuantityReceived();
                }
                view.setTotalQuantity(totalQty);
                view.setEditable(isReceiptEditable(conn, receiptId));
                return view;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public GoodsReceiptForm getReceiptForm(long receiptId) {
        GoodsReceiptView detail = getGoodsReceiptDetail(receiptId);
        if (detail == null) {
            return null;
        }
        GoodsReceiptForm form = new GoodsReceiptForm();
        form.setReceiptId(detail.getReceiptId());
        form.setReceiptCode(detail.getReceiptCode());
        form.setSupplierId(detail.getSupplierId());
        form.setReceivedAt(detail.getReceivedAt());
        form.setNote(detail.getNote());
        for (GoodsReceiptItemView item : detail.getItems()) {
            GoodsReceiptLineForm line = new GoodsReceiptLineForm();
            line.setReceiptItemId(item.getReceiptItemId());
            line.setProductPackId(item.getProductPackId());
            line.setBatchCode(item.getBatchCode());
            line.setManufactureDate(item.getManufactureDate());
            line.setExpiryDate(item.getExpiryDate());
            line.setQuantityReceived(item.getQuantityReceived());
            line.setUnitCost(item.getUnitCost());
            line.setNote(item.getNote());
            form.getLines().add(line);
        }
        return form;
    }

    public List<InventoryBatchView> getInventoryBatchList(boolean expiredOnly) {
        List<InventoryBatchView> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT ib.batchId, ib.receiptItemId, ib.quantityOnHand, ib.quantityReserved, ib.status, " +
                        "gri.receiptId, gri.productPackId, gri.batchCode, gri.manufactureDate, gri.expiryDate, gri.unitCost, gri.note, " +
                        "gr.receiptCode, gr.receivedAt, s.supplierId, s.supplierName, pp.productId, pp.packWeightGram, p.productName " +
                        "FROM dbo.InventoryBatches ib " +
                        "JOIN dbo.GoodsReceiptItems gri ON ib.receiptItemId = gri.receiptItemId " +
                        "JOIN dbo.GoodsReceipts gr ON gri.receiptId = gr.receiptId " +
                        "JOIN dbo.Suppliers s ON gr.supplierId = s.supplierId " +
                        "JOIN dbo.ProductPacks pp ON gri.productPackId = pp.productPackId " +
                        "JOIN dbo.Products p ON pp.productId = p.productId " +
                        "WHERE ib.status = 1 ");
        sql.append(expiredOnly ? "AND gri.expiryDate < CAST(GETDATE() AS DATE) " : "");
        if (!expiredOnly) {
            sql.append("AND ib.quantityOnHand > 0 AND gri.expiryDate >= CAST(GETDATE() AS DATE) ");
        }
        sql.append("ORDER BY gri.expiryDate ASC, gr.receivedAt DESC, ib.batchId DESC");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString());
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapBatchRow(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public InventoryBatchView getInventoryBatchDetail(long batchId) {
        String sql = "SELECT ib.batchId, ib.receiptItemId, ib.quantityOnHand, ib.quantityReserved, ib.status, " +
                "gri.receiptId, gri.productPackId, gri.batchCode, gri.manufactureDate, gri.expiryDate, gri.unitCost, gri.note, " +
                "gr.receiptCode, gr.receivedAt, s.supplierId, s.supplierName, pp.productId, pp.packWeightGram, p.productName " +
                "FROM dbo.InventoryBatches ib " +
                "JOIN dbo.GoodsReceiptItems gri ON ib.receiptItemId = gri.receiptItemId " +
                "JOIN dbo.GoodsReceipts gr ON gri.receiptId = gr.receiptId " +
                "JOIN dbo.Suppliers s ON gr.supplierId = s.supplierId " +
                "JOIN dbo.ProductPacks pp ON gri.productPackId = pp.productPackId " +
                "JOIN dbo.Products p ON pp.productId = p.productId " +
                "WHERE ib.batchId = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, batchId);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) {
                    return null;
                }
                InventoryBatchView view = mapBatchRow(rs);
                view.setTransactions(getBatchTransactions(conn, batchId));
                return view;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public long createReceipt(GoodsReceiptForm form, long accountId) throws Exception {
        validateForm(form);
        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                long receiptId = insertReceipt(conn, form, accountId);
                for (GoodsReceiptLineForm line : form.getLines()) {
                    long receiptItemId = insertReceiptItem(conn, receiptId, line);
                    long batchId = insertInventoryBatch(conn, receiptItemId, line.getQuantityReceived());
                    replaceReceiptTransaction(conn, batchId, receiptId, accountId, line.getQuantityReceived());
                }
                conn.commit();
                return receiptId;
            } catch (Exception e) {
                conn.rollback();
                throw e;
            } finally {
                conn.setAutoCommit(true);
            }
        }
    }

    public void updateReceipt(GoodsReceiptForm form, long accountId) throws Exception {
        if (form.getReceiptId() == null) {
            throw new IllegalArgumentException("Thiếu mã phiếu nhập.");
        }
        validateForm(form);
        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                if (!isReceiptEditable(conn, form.getReceiptId())) {
                    throw new IllegalStateException("Phiếu nhập này đã có phát sinh, không thể chỉnh sửa.");
                }
                updateReceiptHeader(conn, form);
                Map<Long, Long> batchByItem = getBatchIdByReceiptItem(conn, form.getReceiptId());
                Set<Long> submittedIds = new HashSet<>();
                for (GoodsReceiptLineForm line : form.getLines()) {
                    if (line.getReceiptItemId() != null) {
                        submittedIds.add(line.getReceiptItemId());
                        updateReceiptItem(conn, line);
                        Long batchId = batchByItem.get(line.getReceiptItemId());
                        if (batchId == null) {
                            throw new IllegalStateException("Thiếu batch của dòng nhập hiện có.");
                        }
                        updateInventoryBatch(conn, batchId, line.getQuantityReceived());
                        replaceReceiptTransaction(conn, batchId, form.getReceiptId(), accountId, line.getQuantityReceived());
                    } else {
                        long receiptItemId = insertReceiptItem(conn, form.getReceiptId(), line);
                        long batchId = insertInventoryBatch(conn, receiptItemId, line.getQuantityReceived());
                        replaceReceiptTransaction(conn, batchId, form.getReceiptId(), accountId, line.getQuantityReceived());
                    }
                }

                for (Map.Entry<Long, Long> entry : batchByItem.entrySet()) {
                    if (!submittedIds.contains(entry.getKey())) {
                        deleteReceiptTransaction(conn, entry.getValue(), form.getReceiptId());
                        deleteInventoryBatch(conn, entry.getValue());
                        deleteReceiptItem(conn, entry.getKey());
                    }
                }
                conn.commit();
            } catch (Exception e) {
                conn.rollback();
                throw e;
            } finally {
                conn.setAutoCommit(true);
            }
        }
    }

    private void validateForm(GoodsReceiptForm form) throws Exception {
        if (form.getSupplierId() == null || form.getSupplierId() <= 0) {
            throw new IllegalArgumentException("Vui lòng chọn nhà cung cấp.");
        }
        if (form.getReceivedAt() == null) {
            throw new IllegalArgumentException("Vui lòng nhập thời điểm nhận hàng.");
        }
        if (form.getLines() == null || form.getLines().isEmpty()) {
            throw new IllegalArgumentException("Phiếu nhập phải có ít nhất 1 dòng hàng.");
        }
        Set<String> batchCodes = new HashSet<>();
        for (GoodsReceiptLineForm line : form.getLines()) {
            if (line.getProductPackId() == null || line.getProductPackId() <= 0) {
                throw new IllegalArgumentException("Mỗi dòng nhập phải chọn gói sản phẩm.");
            }
            if (line.getBatchCode() == null || line.getBatchCode().trim().isEmpty()) {
                throw new IllegalArgumentException("Mỗi dòng nhập phải có mã batch.");
            }
            String normalized = line.getBatchCode().trim().toUpperCase();
            if (!batchCodes.add(normalized)) {
                throw new IllegalArgumentException("Mã batch trong cùng phiếu không được trùng nhau.");
            }
            if (line.getExpiryDate() == null) {
                throw new IllegalArgumentException("Mỗi dòng nhập phải có ngày hết hạn.");
            }
            if (line.getManufactureDate() != null && line.getExpiryDate().isBefore(line.getManufactureDate())) {
                throw new IllegalArgumentException("Ngày hết hạn không được nhỏ hơn ngày sản xuất.");
            }
            if (line.getQuantityReceived() == null || line.getQuantityReceived() <= 0) {
                throw new IllegalArgumentException("Số lượng nhập phải lớn hơn 0.");
            }
            if (line.getUnitCost() == null || line.getUnitCost().compareTo(BigDecimal.ZERO) < 0) {
                throw new IllegalArgumentException("Giá vốn không được âm.");
            }
        }
    }

    private List<GoodsReceiptItemView> getReceiptItems(Connection conn, long receiptId) throws SQLException {
        List<GoodsReceiptItemView> items = new ArrayList<>();
        String sql = "SELECT gri.receiptItemId, gri.productPackId, gri.batchCode, gri.manufactureDate, gri.expiryDate, gri.quantityReceived, gri.unitCost, gri.note, " +
                "ib.batchId, ib.quantityOnHand, ib.quantityReserved, pp.packWeightGram, p.productName " +
                "FROM dbo.GoodsReceiptItems gri " +
                "LEFT JOIN dbo.InventoryBatches ib ON gri.receiptItemId = ib.receiptItemId " +
                "JOIN dbo.ProductPacks pp ON gri.productPackId = pp.productPackId " +
                "JOIN dbo.Products p ON pp.productId = p.productId " +
                "WHERE gri.receiptId = ? " +
                "ORDER BY gri.expiryDate ASC, gri.receiptItemId ASC";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, receiptId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    GoodsReceiptItemView item = new GoodsReceiptItemView();
                    item.setReceiptItemId(rs.getLong("receiptItemId"));
                    item.setProductPackId(rs.getLong("productPackId"));
                    item.setBatchId(rs.getLong("batchId"));
                    item.setProductName(rs.getString("productName"));
                    item.setPackWeightGram(rs.getInt("packWeightGram"));
                    item.setBatchCode(rs.getString("batchCode"));
                    if (rs.getDate("manufactureDate") != null) {
                        item.setManufactureDate(rs.getDate("manufactureDate").toLocalDate());
                    }
                    if (rs.getDate("expiryDate") != null) {
                        item.setExpiryDate(rs.getDate("expiryDate").toLocalDate());
                    }
                    item.setQuantityReceived(rs.getInt("quantityReceived"));
                    item.setUnitCost(rs.getBigDecimal("unitCost"));
                    item.setQuantityOnHand(rs.getInt("quantityOnHand"));
                    item.setQuantityReserved(rs.getInt("quantityReserved"));
                    item.setAvailableStock(item.getQuantityOnHand() - item.getQuantityReserved());
                    applyExpiryStatus(item);
                    item.setNote(rs.getString("note"));
                    items.add(item);
                }
            }
        }
        return items;
    }

    private boolean isReceiptEditable(Connection conn, long receiptId) throws SQLException {
        String sql = "SELECT COUNT(*) " +
                "FROM dbo.GoodsReceiptItems gri " +
                "JOIN dbo.InventoryBatches ib ON gri.receiptItemId = ib.receiptItemId " +
                "WHERE gri.receiptId = ? AND (" +
                "ib.quantityReserved > 0 OR " +
                "EXISTS (SELECT 1 FROM dbo.OrderItemAllocations oia WHERE oia.batchId = ib.batchId) OR " +
                "EXISTS (SELECT 1 FROM dbo.InventoryTransactions it WHERE it.batchId = ib.batchId AND (it.transactionType <> ? OR ISNULL(it.referenceType, '') <> 'RECEIPT'))" +
                ")";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, receiptId);
            ps.setInt(2, TRANSACTION_TYPE_RECEIPT);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) == 0;
                }
            }
        }
        return false;
    }

    private InventoryBatchView mapBatchRow(ResultSet rs) throws SQLException {
        InventoryBatchView view = new InventoryBatchView();
        view.setBatchId(rs.getLong("batchId"));
        view.setReceiptItemId(rs.getLong("receiptItemId"));
        view.setQuantityOnHand(rs.getInt("quantityOnHand"));
        view.setQuantityReserved(rs.getInt("quantityReserved"));
        view.setAvailableStock(view.getQuantityOnHand() - view.getQuantityReserved());
        view.setStatus(rs.getInt("status"));
        view.setReceiptId(rs.getLong("receiptId"));
        view.setProductPackId(rs.getLong("productPackId"));
        view.setBatchCode(rs.getString("batchCode"));
        if (rs.getDate("manufactureDate") != null) {
            view.setManufactureDate(rs.getDate("manufactureDate").toLocalDate());
        }
        if (rs.getDate("expiryDate") != null) {
            view.setExpiryDate(rs.getDate("expiryDate").toLocalDate());
        }
        view.setUnitCost(rs.getBigDecimal("unitCost"));
        view.setNote(rs.getString("note"));
        view.setReceiptCode(rs.getString("receiptCode"));
        if (rs.getTimestamp("receivedAt") != null) {
            view.setReceivedAt(rs.getTimestamp("receivedAt").toLocalDateTime());
        }
        view.setSupplierId(rs.getLong("supplierId"));
        view.setSupplierName(rs.getString("supplierName"));
        view.setProductId(rs.getLong("productId"));
        view.setProductName(rs.getString("productName"));
        view.setPackWeightGram(rs.getInt("packWeightGram"));
        applyExpiryStatus(view);
        return view;
    }

    private List<InventoryTransactionView> getBatchTransactions(Connection conn, long batchId) throws SQLException {
        List<InventoryTransactionView> list = new ArrayList<>();
        String sql = "SELECT it.inventoryTransactionId, it.transactionType, it.quantity, it.referenceType, it.referenceId, it.performedByAccountId, it.note, it.transactionAt, a.fullName " +
                "FROM dbo.InventoryTransactions it " +
                "LEFT JOIN dbo.Accounts a ON it.performedByAccountId = a.accountId " +
                "WHERE it.batchId = ? " +
                "ORDER BY it.transactionAt DESC, it.inventoryTransactionId DESC";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, batchId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    InventoryTransactionView view = new InventoryTransactionView();
                    view.setInventoryTransactionId(rs.getLong("inventoryTransactionId"));
                    view.setTransactionType(rs.getInt("transactionType"));
                    view.setQuantity(rs.getInt("quantity"));
                    view.setReferenceType(rs.getString("referenceType"));
                    long referenceId = rs.getLong("referenceId");
                    view.setReferenceId(rs.wasNull() ? null : referenceId);
                    long performerId = rs.getLong("performedByAccountId");
                    view.setPerformedByAccountId(rs.wasNull() ? null : performerId);
                    view.setPerformerName(rs.getString("fullName"));
                    view.setNote(rs.getString("note"));
                    if (rs.getTimestamp("transactionAt") != null) {
                        view.setTransactionAt(rs.getTimestamp("transactionAt").toLocalDateTime());
                    }
                    list.add(view);
                }
            }
        }
        return list;
    }

    private long insertReceipt(Connection conn, GoodsReceiptForm form, long accountId) throws SQLException {
        String sql = "INSERT INTO dbo.GoodsReceipts (receiptCode, supplierId, receivedByAccountId, receivedAt, status, note) " +
                "VALUES (?, ?, ?, ?, 1, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, form.getReceiptCode());
            ps.setLong(2, form.getSupplierId());
            ps.setLong(3, accountId);
            ps.setTimestamp(4, Timestamp.valueOf(form.getReceivedAt()));
            ps.setNString(5, form.getNote());
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getLong(1);
                }
            }
        }
        throw new SQLException("Không thể tạo phiếu nhập.");
    }

    private long insertReceiptItem(Connection conn, long receiptId, GoodsReceiptLineForm line) throws SQLException {
        String sql = "INSERT INTO dbo.GoodsReceiptItems (receiptId, productPackId, batchCode, manufactureDate, expiryDate, quantityReceived, unitCost, note) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setLong(1, receiptId);
            ps.setLong(2, line.getProductPackId());
            ps.setString(3, line.getBatchCode().trim());
            if (line.getManufactureDate() != null) {
                ps.setDate(4, java.sql.Date.valueOf(line.getManufactureDate()));
            } else {
                ps.setNull(4, java.sql.Types.DATE);
            }
            ps.setDate(5, java.sql.Date.valueOf(line.getExpiryDate()));
            ps.setInt(6, line.getQuantityReceived());
            ps.setBigDecimal(7, line.getUnitCost());
            ps.setNString(8, line.getNote());
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getLong(1);
                }
            }
        }
        throw new SQLException("Không thể tạo dòng nhập.");
    }

    private long insertInventoryBatch(Connection conn, long receiptItemId, int quantityReceived) throws SQLException {
        String sql = "INSERT INTO dbo.InventoryBatches (receiptItemId, quantityOnHand, quantityReserved, status) VALUES (?, ?, 0, 1)";
        try (PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setLong(1, receiptItemId);
            ps.setInt(2, quantityReceived);
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getLong(1);
                }
            }
        }
        throw new SQLException("Không thể tạo batch tồn kho.");
    }

    private void replaceReceiptTransaction(Connection conn, long batchId, long receiptId, long accountId, int quantity) throws SQLException {
        deleteReceiptTransaction(conn, batchId, receiptId);
        String sql = "INSERT INTO dbo.InventoryTransactions (batchId, transactionType, quantity, referenceType, referenceId, performedByAccountId, note) " +
                "VALUES (?, ?, ?, 'RECEIPT', ?, ?, N'Nhập kho từ phiếu nhập')";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, batchId);
            ps.setInt(2, TRANSACTION_TYPE_RECEIPT);
            ps.setInt(3, quantity);
            ps.setLong(4, receiptId);
            ps.setLong(5, accountId);
            ps.executeUpdate();
        }
    }

    private void deleteReceiptTransaction(Connection conn, long batchId, long receiptId) throws SQLException {
        String sql = "DELETE FROM dbo.InventoryTransactions WHERE batchId = ? AND referenceType = 'RECEIPT' AND referenceId = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, batchId);
            ps.setLong(2, receiptId);
            ps.executeUpdate();
        }
    }

    private void updateReceiptHeader(Connection conn, GoodsReceiptForm form) throws SQLException {
        String sql = "UPDATE dbo.GoodsReceipts SET receiptCode = ?, supplierId = ?, receivedAt = ?, note = ? WHERE receiptId = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, form.getReceiptCode());
            ps.setLong(2, form.getSupplierId());
            ps.setTimestamp(3, Timestamp.valueOf(form.getReceivedAt()));
            ps.setNString(4, form.getNote());
            ps.setLong(5, form.getReceiptId());
            ps.executeUpdate();
        }
    }

    private Map<Long, Long> getBatchIdByReceiptItem(Connection conn, long receiptId) throws SQLException {
        Map<Long, Long> map = new HashMap<>();
        String sql = "SELECT gri.receiptItemId, ib.batchId FROM dbo.GoodsReceiptItems gri JOIN dbo.InventoryBatches ib ON gri.receiptItemId = ib.receiptItemId WHERE gri.receiptId = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, receiptId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    map.put(rs.getLong("receiptItemId"), rs.getLong("batchId"));
                }
            }
        }
        return map;
    }

    private void updateReceiptItem(Connection conn, GoodsReceiptLineForm line) throws SQLException {
        String sql = "UPDATE dbo.GoodsReceiptItems SET productPackId = ?, batchCode = ?, manufactureDate = ?, expiryDate = ?, quantityReceived = ?, unitCost = ?, note = ? WHERE receiptItemId = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, line.getProductPackId());
            ps.setString(2, line.getBatchCode().trim());
            if (line.getManufactureDate() != null) {
                ps.setDate(3, java.sql.Date.valueOf(line.getManufactureDate()));
            } else {
                ps.setNull(3, java.sql.Types.DATE);
            }
            ps.setDate(4, java.sql.Date.valueOf(line.getExpiryDate()));
            ps.setInt(5, line.getQuantityReceived());
            ps.setBigDecimal(6, line.getUnitCost());
            ps.setNString(7, line.getNote());
            ps.setLong(8, line.getReceiptItemId());
            ps.executeUpdate();
        }
    }

    private void updateInventoryBatch(Connection conn, long batchId, int quantityOnHand) throws SQLException {
        String sql = "UPDATE dbo.InventoryBatches SET quantityOnHand = ?, quantityReserved = 0, updatedAt = SYSUTCDATETIME() WHERE batchId = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, quantityOnHand);
            ps.setLong(2, batchId);
            ps.executeUpdate();
        }
    }

    private void deleteInventoryBatch(Connection conn, long batchId) throws SQLException {
        try (PreparedStatement ps = conn.prepareStatement("DELETE FROM dbo.InventoryBatches WHERE batchId = ?")) {
            ps.setLong(1, batchId);
            ps.executeUpdate();
        }
    }

    private void deleteReceiptItem(Connection conn, long receiptItemId) throws SQLException {
        try (PreparedStatement ps = conn.prepareStatement("DELETE FROM dbo.GoodsReceiptItems WHERE receiptItemId = ?")) {
            ps.setLong(1, receiptItemId);
            ps.executeUpdate();
        }
    }

    private void applyExpiryStatus(GoodsReceiptItemView item) {
        if (item.getExpiryDate() == null) {
            return;
        }
        long days = ChronoUnit.DAYS.between(LocalDate.now(), item.getExpiryDate());
        item.setDaysRemaining(days);
        item.setExpired(days < 0);
        item.setExpiringSoon(days >= 0 && days <= EXPIRING_SOON_DAYS);
    }

    private void applyExpiryStatus(InventoryBatchView item) {
        if (item.getExpiryDate() == null) {
            return;
        }
        long days = ChronoUnit.DAYS.between(LocalDate.now(), item.getExpiryDate());
        item.setDaysRemaining(days);
        item.setExpired(days < 0);
        item.setExpiringSoon(days >= 0 && days <= EXPIRING_SOON_DAYS);
    }
    public int getAvailableStockByPackId(long productPackId) {
        String sql = "SELECT SUM(ib.quantityOnHand - ib.quantityReserved) AS availableStock " +
                "FROM dbo.InventoryBatches ib " +
                "JOIN dbo.GoodsReceiptItems gri ON ib.receiptItemId = gri.receiptItemId " +
                "WHERE gri.productPackId = ? AND ib.status = 1 AND gri.expiryDate >= CAST(GETDATE() AS DATE)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, productPackId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int stock = rs.getInt("availableStock");
                    return Math.max(stock, 0);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
}
