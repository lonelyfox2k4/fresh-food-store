package org.example.dto;

import org.example.model.auth.Account;
import java.util.List;
import java.util.Map;

public class DashboardDTO {
    private int totalUsers;
    private int activeUsers;
    private int lockedUsers;
    private Map<String, Integer> roleDistribution;
    private List<Account> recentUsers;

    public DashboardDTO(int totalUsers, int activeUsers, int lockedUsers, Map<String, Integer> roleDistribution, List<Account> recentUsers) {
        this.totalUsers = totalUsers;
        this.activeUsers = activeUsers;
        this.lockedUsers = lockedUsers;
        this.roleDistribution = roleDistribution;
        this.recentUsers = recentUsers;
    }

    public int getTotalUsers() { return totalUsers; }
    public int getActiveUsers() { return activeUsers; }
    public int getLockedUsers() { return lockedUsers; }
    public Map<String, Integer> getRoleDistribution() { return roleDistribution; }
    public List<Account> getRecentUsers() { return recentUsers; }
}
