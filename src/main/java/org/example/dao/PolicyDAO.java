package org.example.dao;

import org.example.model.catalog.ExpiryPricingPolicy;
import org.example.model.catalog.ExpiryPricingPolicyRule;
import org.example.utils.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class PolicyDAO {

    public List<ExpiryPricingPolicy> getAllPolicies() {
        List<ExpiryPricingPolicy> list = new ArrayList<>();
        String sql = "SELECT * FROM dbo.ExpiryPricingPolicies ORDER BY policyId DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapRowToPolicy(rs));
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public ExpiryPricingPolicy getPolicyById(int id) {
        String sql = "SELECT * FROM dbo.ExpiryPricingPolicies WHERE policyId = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRowToPolicy(rs);
            }
        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }

    public List<ExpiryPricingPolicyRule> getRulesByPolicyId(int policyId) {
        List<ExpiryPricingPolicyRule> list = new ArrayList<>();
        String sql = "SELECT * FROM dbo.ExpiryPricingPolicyRules WHERE policyId = ? ORDER BY minDaysRemaining ASC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, policyId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(mapRowToRule(rs));
                }
            }
        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    public boolean insertPolicy(ExpiryPricingPolicy p) {
        String sql = "INSERT INTO dbo.ExpiryPricingPolicies (policyName, status, note) VALUES (?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setNString(1, p.getPolicyName());
            ps.setBoolean(2, p.isStatus());
            ps.setNString(3, p.getNote());
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    public boolean updatePolicy(ExpiryPricingPolicy p) {
        String sql = "UPDATE dbo.ExpiryPricingPolicies SET policyName = ?, status = ?, note = ? WHERE policyId = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setNString(1, p.getPolicyName());
            ps.setBoolean(2, p.isStatus());
            ps.setNString(3, p.getNote());
            ps.setInt(4, p.getPolicyId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    public void saveRules(int policyId, List<ExpiryPricingPolicyRule> rules) {
        String deleteSql = "DELETE FROM dbo.ExpiryPricingPolicyRules WHERE policyId = ?";
        String insertSql = "INSERT INTO dbo.ExpiryPricingPolicyRules (policyId, minDaysRemaining, sellPricePercent) VALUES (?, ?, ?)";
        
        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);
            try {
                // Clear old rules
                try (PreparedStatement ps = conn.prepareStatement(deleteSql)) {
                    ps.setInt(1, policyId);
                    ps.executeUpdate();
                }
                
                // Add new rules
                try (PreparedStatement ps = conn.prepareStatement(insertSql)) {
                    for (ExpiryPricingPolicyRule rule : rules) {
                        ps.setInt(1, policyId);
                        ps.setInt(2, rule.getMinDaysRemaining());
                        ps.setBigDecimal(3, rule.getSellPricePercent());
                        ps.addBatch();
                    }
                    ps.executeBatch();
                }
                
                conn.commit();
            } catch (Exception ex) {
                conn.rollback();
                ex.printStackTrace();
            }
        } catch (Exception e) { e.printStackTrace(); }
    }

    private ExpiryPricingPolicy mapRowToPolicy(ResultSet rs) throws Exception {
        ExpiryPricingPolicy p = new ExpiryPricingPolicy();
        p.setPolicyId(rs.getInt("policyId"));
        p.setPolicyName(rs.getString("policyName"));
        p.setStatus(rs.getBoolean("status"));
        p.setNote(rs.getString("note"));
        if (rs.getTimestamp("createdAt") != null) p.setCreatedAt(rs.getTimestamp("createdAt").toLocalDateTime());
        return p;
    }

    private ExpiryPricingPolicyRule mapRowToRule(ResultSet rs) throws Exception {
        ExpiryPricingPolicyRule r = new ExpiryPricingPolicyRule();
        r.setRuleId(rs.getInt("ruleId"));
        r.setPolicyId(rs.getInt("policyId"));
        r.setMinDaysRemaining(rs.getInt("minDaysRemaining"));
        r.setSellPricePercent(rs.getBigDecimal("sellPricePercent"));
        return r;
    }
}
