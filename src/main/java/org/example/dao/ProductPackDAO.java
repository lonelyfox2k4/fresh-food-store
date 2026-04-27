package org.example.dao;

import org.example.model.catalog.ProductPack;
import org.example.utils.DBConnection;
import java.sql.*;
import java.util.*;

public class ProductPackDAO {

    public List<ProductPack> getPacksByProductId(long productId) {
        List<ProductPack> list = new ArrayList<>();
        String sql = "SELECT p.*, " +
                     "       ISNULL(SUM(ib.quantityOnHand - ib.quantityReserved), 0) AS availableStock " +
                     "FROM dbo.ProductPacks p " +
                     "LEFT JOIN dbo.GoodsReceiptItems gri ON p.productPackId = gri.productPackId " +
                     "LEFT JOIN dbo.InventoryBatches ib ON gri.receiptItemId = ib.receiptItemId And ib.status = 1 AND gri.expiryDate >= CAST(GETDATE() AS DATE) " +
                     "WHERE p.productId = ? AND p.status = 1 " +
                     "GROUP BY p.productPackId, p.productId, p.packWeightGram, p.sku, p.status, p.createdAt, p.updatedAt " +
                     "ORDER BY p.packWeightGram ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, productId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRowWithStock(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    private ProductPack mapRow(ResultSet rs) throws SQLException {
        ProductPack p = new ProductPack();
        p.setProductPackId(rs.getLong("productPackId"));
        p.setProductId(rs.getLong("productId"));
        p.setPackWeightGram(rs.getInt("packWeightGram"));
        p.setSku(rs.getString("sku"));
        p.setStatus(rs.getBoolean("status"));
        return p;
    }

    private ProductPack mapRowWithStock(ResultSet rs) throws SQLException {
        ProductPack p = mapRow(rs);
        p.setAvailableStock(rs.getInt("availableStock"));
        return p;
    }
}
