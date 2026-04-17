package org.example.dao;

import org.example.model.inventory.Supplier;
import org.example.utils.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class SupplierDAO {

    public List<Supplier> getAllSuppliers() {
        List<Supplier> list = new ArrayList<>();
        String sql = "SELECT * FROM dbo.Suppliers ORDER BY supplierId DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapRowToSupplier(rs));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public List<Supplier> getActiveSuppliers() {
        List<Supplier> list = new ArrayList<>();
        String sql = "SELECT * FROM dbo.Suppliers WHERE status = 1 ORDER BY supplierName ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapRowToSupplier(rs));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public Supplier getSupplierById(long id) {
        String sql = "SELECT * FROM dbo.Suppliers WHERE supplierId = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setLong(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRowToSupplier(rs);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }

    public boolean insertSupplier(Supplier s) {
        String sql = "INSERT INTO dbo.Suppliers (supplierName, phone, email, address, status, note) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setNString(1, s.getSupplierName());
            ps.setString(2, s.getPhone());
            ps.setNString(3, s.getEmail());
            ps.setNString(4, s.getAddress());
            ps.setBoolean(5, s.isStatus());
            ps.setNString(6, s.getNote());
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    public boolean updateSupplier(Supplier s) {
        String sql = "UPDATE dbo.Suppliers SET supplierName = ?, phone = ?, email = ?, address = ?, status = ?, note = ? WHERE supplierId = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setNString(1, s.getSupplierName());
            ps.setString(2, s.getPhone());
            ps.setNString(3, s.getEmail());
            ps.setNString(4, s.getAddress());
            ps.setBoolean(5, s.isStatus());
            ps.setNString(6, s.getNote());
            ps.setLong(7, s.getSupplierId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    public boolean updateStatus(long id, boolean status) {
        String sql = "UPDATE dbo.Suppliers SET status = ? WHERE supplierId = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, status ? 1 : 0);
            ps.setLong(2, id);
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    private Supplier mapRowToSupplier(ResultSet rs) throws Exception {
        Supplier s = new Supplier();
        s.setSupplierId(rs.getLong("supplierId"));
        s.setSupplierName(rs.getString("supplierName"));
        s.setPhone(rs.getString("phone"));
        s.setEmail(rs.getString("email"));
        s.setAddress(rs.getString("address"));
        s.setStatus(rs.getBoolean("status"));
        s.setNote(rs.getString("note"));
        if (rs.getTimestamp("createdAt") != null) {
            s.setCreatedAt(rs.getTimestamp("createdAt").toLocalDateTime());
        }
        return s;
    }
}
