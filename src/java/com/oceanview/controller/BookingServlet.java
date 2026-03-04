package com.oceanview.controller;

import com.oceanview.dao.BookingDAO;
import com.oceanview.model.Booking;
import com.oceanview.model.User;

import java.io.IOException;
import java.sql.Date;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/BookingServlet")
public class BookingServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User loggedUser = (session != null) ? (User) session.getAttribute("loggedUser") : null;

        if (loggedUser == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        try {
            String reservationNumber = val(request.getParameter("reservationNumber"));
            String roomType          = val(request.getParameter("roomType"));
            String guestName         = val(request.getParameter("guestName"));
            String contactNumber     = val(request.getParameter("contactNumber"));
            String address           = val(request.getParameter("address"));

            String checkInStr  = request.getParameter("checkIn");
            String checkOutStr = request.getParameter("checkOut");
            String totalStr    = request.getParameter("totalAmount");

            if (reservationNumber.isEmpty() || roomType.isEmpty() || guestName.isEmpty()
                    || contactNumber.isEmpty() || address.isEmpty()
                    || checkInStr == null || checkOutStr == null
                    || totalStr == null || totalStr.isBlank()) {

                session.setAttribute("errorMessage", "All fields are required!");
                response.sendRedirect(request.getContextPath() + "/user/booking.jsp");
                return;
            }

            Date checkIn  = Date.valueOf(checkInStr);
            Date checkOut = Date.valueOf(checkOutStr);

            double totalAmount;
            try {
                totalAmount = Double.parseDouble(totalStr.trim());
            } catch (NumberFormatException ex) {
                session.setAttribute("errorMessage", "Invalid total amount!");
                response.sendRedirect(request.getContextPath() + "/user/booking.jsp");
                return;
            }

            Booking b = new Booking();
            b.setReservationNumber(reservationNumber);
            b.setRoomType(roomType);
            b.setGuestName(guestName);
            b.setContactNumber(contactNumber);
            b.setAddress(address);
            b.setCheckIn(checkIn);
            b.setCheckOut(checkOut);
            b.setTotalAmount(totalAmount);

            // ✅ user booking
            b.setUserId(loggedUser.getId());
            b.setCreatedBy("user");
            b.setStatus("CONFIRMED"); // (DAO also forces CONFIRMED)

            BookingDAO dao = new BookingDAO();
            boolean ok = dao.addBooking(b);

            if (ok) {
                session.setAttribute("successMessage", "Booking confirmed successfully!");
                session.removeAttribute("errorMessage");
            } else {
                session.setAttribute("errorMessage", "Booking failed!");
                session.removeAttribute("successMessage");
            }

            response.sendRedirect(request.getContextPath() + "/user/booking.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Server error: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/user/booking.jsp");
        }
    }

    private String val(String s) {
        return (s == null) ? "" : s.trim();
    }
}