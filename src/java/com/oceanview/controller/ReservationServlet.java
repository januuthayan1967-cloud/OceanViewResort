package com.oceanview.controller;

import com.oceanview.dao.ReservationDAO;
import com.oceanview.model.Reservation;
import com.oceanview.model.User;

import java.io.IOException;
import java.sql.Date;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/ReservationServlet")
public class ReservationServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User loggedUser = (session != null) ? (User) session.getAttribute("loggedUser") : null;

        if (loggedUser == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // role
        String role = (loggedUser.getRole() == null) ? "" : loggedUser.getRole().toUpperCase();

        try {
            // ✅ Read inputs safely (trim)
            String reservationNumber = val(request.getParameter("reservationNumber"));
            String roomType          = val(request.getParameter("roomType"));
            String guestName         = val(request.getParameter("guestName"));
            String contactNumber     = val(request.getParameter("contactNumber"));
            String address           = val(request.getParameter("address"));

            String checkInStr  = request.getParameter("checkIn");
            String checkOutStr = request.getParameter("checkOut");
            String totalStr    = request.getParameter("totalAmount");

            // ✅ Basic validation
            if (reservationNumber.isEmpty() || roomType.isEmpty() || guestName.isEmpty()
                    || contactNumber.isEmpty() || address.isEmpty()
                    || checkInStr == null || checkOutStr == null
                    || totalStr == null || totalStr.isBlank()) {

                session.setAttribute("errorMessage", "All fields are required!");
                session.removeAttribute("successMessage");
                redirectByRole(role, request, response);
                return;
            }

            Date checkIn  = Date.valueOf(checkInStr);
            Date checkOut = Date.valueOf(checkOutStr);

            double totalAmount;
            try {
                totalAmount = Double.parseDouble(totalStr);
            } catch (NumberFormatException nfe) {
                session.setAttribute("errorMessage", "Invalid total amount!");
                session.removeAttribute("successMessage");
                redirectByRole(role, request, response);
                return;
            }

            // ✅ createdBy from role
            String createdBy = role.equals("ADMIN") ? "admin"
                    : role.equals("STAFF") ? "staff" : "user";

            // ✅ userId logic
            Integer userId = null;
            if ("USER".equals(role)) {
                userId = loggedUser.getId();
            } else {
                String userIdStr = request.getParameter("userId");
                if (userIdStr != null && !userIdStr.isBlank()) {
                    userId = Integer.parseInt(userIdStr);
                }
            }

            // ✅ Build Reservation object
            Reservation r = new Reservation();
            r.setReservationNumber(reservationNumber);
            r.setRoomType(roomType);
            r.setGuestName(guestName);
            r.setContactNumber(contactNumber);
            r.setAddress(address);
            r.setCheckIn(checkIn);
            r.setCheckOut(checkOut);
            r.setTotalAmount(totalAmount);
            r.setUserId(userId);
            r.setCreatedBy(createdBy);

            // ✅ Save
            ReservationDAO dao = new ReservationDAO();
            boolean ok = dao.addReservation(r);

            if (ok) {
                session.setAttribute("successMessage", "Reservation saved successfully!");
                session.removeAttribute("errorMessage");
            } else {
                session.setAttribute("errorMessage", "Reservation save failed!");
                session.removeAttribute("successMessage");
            }

            // ✅ redirect back by role
            redirectByRole(role, request, response);

        } catch (Exception e) {
            e.printStackTrace();

            // For unexpected errors, also use session so redirect works
            session.setAttribute("errorMessage", "Server error: " + e.getMessage());
            session.removeAttribute("successMessage");
            redirectByRole(role, request, response);
        }
    }

    // helper: avoid null strings
    private String val(String s) {
        return (s == null) ? "" : s.trim();
    }

    // helper: redirect based on role
    private void redirectByRole(String role, HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        if ("ADMIN".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/admin/addReservation.jsp");
        } else if ("STAFF".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/staff/addReservation.jsp");
        } else {
            response.sendRedirect(request.getContextPath() + "/user/addReservation.jsp");
        }
    }
}