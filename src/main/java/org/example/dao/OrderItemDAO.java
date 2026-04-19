package org.example.dao;

import org.example.model.order.OrderItem;
import org.example.utils.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class OrderItemDAO {

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
                    if (!rs.wasNull()) {
                        item.setProductPackId(packId);
                    }
                    
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
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
