package com.oceanview.dao;

import com.oceanview.model.Reservation;
import com.oceanview.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ReservationDAO {

    // =========================================================
    // INSERT RESERVATION
    // =========================================================
    public boolean addReservation(Reservation r) {

        String sql = "INSERT INTO reservation " +
                "(reservationNumber, roomType, guestName, contactNumber, address, " +
                "checkIn, checkOut, totalAmount, userId, createdBy, createdAt, status) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW(), ?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, r.getReservationNumber());
            ps.setString(2, r.getRoomType());
            ps.setString(3, r.getGuestName());
            ps.setString(4, r.getContactNumber());
            ps.setString(5, r.getAddress());
            ps.setDate(6, r.getCheckIn());
            ps.setDate(7, r.getCheckOut());
            ps.setDouble(8, r.getTotalAmount());

            if (r.getUserId() == null) ps.setNull(9, Types.INTEGER);
            else ps.setInt(9, r.getUserId());

            ps.setString(10, r.getCreatedBy());

            // status param index = 11
            ps.setString(11, (r.getStatus() == null ? "PENDING" : r.getStatus()));

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // =========================================================
    // MAP RESULTSET → RESERVATION OBJECT
    // =========================================================
    private Reservation map(ResultSet rs) throws SQLException {

        Reservation r = new Reservation();

        r.setId(rs.getInt("id"));
        r.setReservationNumber(rs.getString("reservationNumber"));
        r.setRoomType(rs.getString("roomType"));
        r.setGuestName(rs.getString("guestName"));
        r.setContactNumber(rs.getString("contactNumber"));
        r.setAddress(rs.getString("address"));
        r.setCheckIn(rs.getDate("checkIn"));
        r.setCheckOut(rs.getDate("checkOut"));
        r.setTotalAmount(rs.getDouble("totalAmount"));

        int uid = rs.getInt("userId");
        r.setUserId(rs.wasNull() ? null : uid);

        r.setCreatedBy(rs.getString("createdBy"));
        r.setCreatedAt(rs.getTimestamp("createdAt"));
        r.setStatus(rs.getString("status"));

        return r;
    }

    // =========================================================
    // ADMIN - VIEW ALL RESERVATIONS
    // =========================================================
    public List<Reservation> getAllReservations() {

        List<Reservation> list = new ArrayList<>();
        String sql = "SELECT * FROM reservation ORDER BY createdAt DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) list.add(map(rs));

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // =========================================================
    // USER - VIEW OWN RESERVATIONS
    // =========================================================
    public List<Reservation> getReservationsByUserId(int userId) {

        List<Reservation> list = new ArrayList<>();
        String sql = "SELECT * FROM reservation WHERE userId=? ORDER BY createdAt DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(map(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // =========================================================
    // STAFF - VIEW ALL (same as admin)
    // =========================================================
    public List<Reservation> getReservationsForStaff() {
        return getAllReservations();
    }

    // =========================================================
    // GET RESERVATION BY RESERVATION NUMBER
    // =========================================================
    public Reservation getReservationByNumber(String resNo) {

        String sql = "SELECT * FROM reservation WHERE reservationNumber = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, resNo);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return map(rs);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    // =========================================================
    // UPDATE RESERVATION STATUS
    // =========================================================
    public boolean updateReservationStatus(String resNo, String newStatus) {

        String sql = "UPDATE reservation SET status=? WHERE reservationNumber=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, newStatus);
            ps.setString(2, resNo);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }

    // =========================================================
    // GET USER ID BY RESERVATION NUMBER (for notifications)
    // =========================================================
    public Integer getUserIdByResNo(String resNo) {

        String sql = "SELECT userId FROM reservation WHERE reservationNumber=?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, resNo);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    int uid = rs.getInt("userId");
                    return rs.wasNull() ? null : uid;
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    // =========================================================
    // ✅ CONFIRMED BILL METHODS (NEW)
    // Bills = Reservations, but ONLY status='CONFIRMED'
    // =========================================================

    // ADMIN: all confirmed
    public List<Reservation> getConfirmedBillsForAdmin() {
        List<Reservation> list = new ArrayList<>();
        String sql = "SELECT * FROM reservation WHERE status='CONFIRMED' ORDER BY createdAt DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) list.add(map(rs));

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // STAFF: all confirmed (same as admin)
    public List<Reservation> getConfirmedBillsForStaff() {
        return getConfirmedBillsForAdmin();
    }

    // USER: only own confirmed
    public List<Reservation> getConfirmedBillsForUser(int userId) {
        List<Reservation> list = new ArrayList<>();
        String sql = "SELECT * FROM reservation WHERE userId=? AND status='CONFIRMED' ORDER BY createdAt DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(map(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    // =========================================================
    // (Optional) Old BILL METHODS - keep if other code uses them
    // =========================================================
    public List<Reservation> getAllBills() {
        return getAllReservations();
    }

    public List<Reservation> getBillsForStaff() {
        return getAllReservations();
    }

    public List<Reservation> getBillsForUser(int userId) {
        return getReservationsByUserId(userId);
    }
}