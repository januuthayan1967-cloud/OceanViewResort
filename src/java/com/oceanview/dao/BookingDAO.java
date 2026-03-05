package com.oceanview.dao;

import com.oceanview.model.Booking;
import com.oceanview.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BookingDAO {

    // =========================================================
    // ✅ INSERT BOOKING (SAVES INTO reservation TABLE)
    // status ALWAYS 'CONFIRMED'
    // =========================================================
    public boolean addBooking(Booking b) {

        String sql = "INSERT INTO reservation " +
                "(reservationNumber, roomType, guestName, contactNumber, address, " +
                "checkIn, checkOut, totalAmount, userId, createdBy, createdAt, status) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW(), 'CONFIRMED')";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, b.getReservationNumber());
            ps.setString(2, b.getRoomType());
            ps.setString(3, b.getGuestName());
            ps.setString(4, b.getContactNumber());
            ps.setString(5, b.getAddress());

            ps.setDate(6, b.getCheckIn());
            ps.setDate(7, b.getCheckOut());

            ps.setDouble(8, b.getTotalAmount());

            if (b.getUserId() == null) ps.setNull(9, Types.INTEGER);
            else ps.setInt(9, b.getUserId());

            ps.setString(10, (b.getCreatedBy() == null || b.getCreatedBy().isBlank()) ? "user" : b.getCreatedBy());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // =========================================================
    // ✅ GET CONFIRMED BOOKINGS FOR USER
    // =========================================================
    public List<Booking> getBookingsByUserId(int userId) {

        List<Booking> list = new ArrayList<>();
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
    // ✅ COUNT CONFIRMED BOOKINGS FOR USER  (Dashboard)
    // =========================================================
    public int countConfirmedBookings(int userId) {

        String sql = "SELECT COUNT(*) FROM reservation WHERE userId=? AND status='CONFIRMED'";

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

    // =========================================================
    // (OPTIONAL) ✅ GET ALL CONFIRMED BOOKINGS (Admin / Staff)
    // =========================================================
    public List<Booking> getAllConfirmedBookings() {

        List<Booking> list = new ArrayList<>();
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

    // =========================================================
    // MAP RESULTSET -> BOOKING
    // =========================================================
    private Booking map(ResultSet rs) throws SQLException {

        Booking b = new Booking();

        b.setId(rs.getInt("id"));
        b.setReservationNumber(rs.getString("reservationNumber"));
        b.setRoomType(rs.getString("roomType"));
        b.setGuestName(rs.getString("guestName"));
        b.setContactNumber(rs.getString("contactNumber"));
        b.setAddress(rs.getString("address"));
        b.setCheckIn(rs.getDate("checkIn"));
        b.setCheckOut(rs.getDate("checkOut"));
        b.setTotalAmount(rs.getDouble("totalAmount"));

        int uid = rs.getInt("userId");
        b.setUserId(rs.wasNull() ? null : uid);

        b.setCreatedBy(rs.getString("createdBy"));
        b.setCreatedAt(rs.getTimestamp("createdAt"));
        b.setStatus(rs.getString("status")); // should be CONFIRMED

        return b;
    }
}