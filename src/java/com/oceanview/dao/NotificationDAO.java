package com.oceanview.dao;

import com.oceanview.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class NotificationDAO {

    // ---------- helper ----------
    private String normRole(String role) {
        return (role == null) ? null : role.trim().toUpperCase();
    }

    // ================= INSERT =================

    // Insert for a specific USER
    public boolean addToUser(int userId, String message) {

        String sql = "INSERT INTO notification (targetUserId, targetRole, message, isRead, createdAt) " +
                     "VALUES (?, NULL, ?, 0, NOW())";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setString(2, message);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // Insert for ROLE (ADMIN / STAFF)
    public boolean addToRole(String role, String message) {

        String sql = "INSERT INTO notification (targetUserId, targetRole, message, isRead, createdAt) " +
                     "VALUES (NULL, ?, ?, 0, NOW())";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, normRole(role)); // ✅ normalize role
            ps.setString(2, message);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    // ================= COUNT =================

    public int countUnreadForUser(int userId) {
        String sql = "SELECT COUNT(*) FROM notification WHERE targetUserId=? AND isRead=0";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }

    public int countUnreadForRole(String role) {
        String sql = "SELECT COUNT(*) FROM notification " +
                     "WHERE UPPER(TRIM(targetRole)) = UPPER(TRIM(?)) AND isRead=0";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, normRole(role));

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }

    // ================= LOAD LATEST =================

    public List<String> getLatestForUser(int userId, int limit) {

        List<String> list = new ArrayList<>();

        String sql = "SELECT message FROM notification " +
                     "WHERE targetUserId=? ORDER BY createdAt DESC LIMIT ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setInt(2, limit);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(rs.getString("message"));
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public List<String> getLatestForRole(String role, int limit) {

        List<String> list = new ArrayList<>();

        String sql = "SELECT message FROM notification " +
                     "WHERE UPPER(TRIM(targetRole)) = UPPER(TRIM(?)) " +
                     "ORDER BY createdAt DESC LIMIT ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, normRole(role));
            ps.setInt(2, limit);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(rs.getString("message"));
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // ================= LOAD ALL (View All Page) =================

    public List<String> getNotificationsForUser(int userId) {

        List<String> list = new ArrayList<>();

        String sql = "SELECT message FROM notification " +
                     "WHERE targetUserId=? ORDER BY createdAt DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(rs.getString("message"));
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public List<String> getNotificationsForRole(String role) {

        List<String> list = new ArrayList<>();

        String sql = "SELECT message FROM notification " +
                     "WHERE UPPER(TRIM(targetRole)) = UPPER(TRIM(?)) " +
                     "ORDER BY createdAt DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, normRole(role));

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(rs.getString("message"));
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // ================= CLEAR / MARK AS READ =================

    public void clearForUser(int userId) {

        String sql = "UPDATE notification SET isRead=1 WHERE targetUserId=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void clearForRole(String role) {

        String sql = "UPDATE notification SET isRead=1 " +
                     "WHERE UPPER(TRIM(targetRole)) = UPPER(TRIM(?))";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, normRole(role));
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}