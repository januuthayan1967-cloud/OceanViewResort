package com.oceanview.controller;

import com.oceanview.dao.NotificationDAO;
import com.oceanview.dao.ReservationDAO;
import com.oceanview.model.Reservation;
import com.oceanview.model.User;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/UpdateReservationStatus")
public class UpdateReservationStatusServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User loggedUser = (session != null) ? (User) session.getAttribute("loggedUser") : null;

        if (loggedUser == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String role = (loggedUser.getRole() == null) ? "" : loggedUser.getRole().toUpperCase();

        String resNo = request.getParameter("resNo");
        String action = request.getParameter("action"); // CONFIRM / CANCEL

        if (resNo == null || action == null) {
            response.sendRedirect(request.getContextPath() + "/ViewReservations");
            return;
        }

        ReservationDAO resDao = new ReservationDAO();
        NotificationDAO notiDao = new NotificationDAO();

        // ✅ get reservation details
        Reservation res = resDao.getReservationByNumber(resNo);
        if (res == null) {
            response.sendRedirect(request.getContextPath() + "/ViewReservations");
            return;
        }

        // ✅ USER can only cancel OWN reservation
        if ("USER".equals(role)) {
            if (!"CANCEL".equalsIgnoreCase(action)) {
                response.sendRedirect(request.getContextPath() + "/ViewReservations");
                return;
            }
            if (res.getUserId() == null || res.getUserId() != loggedUser.getId()) {
                // not his reservation
                response.sendRedirect(request.getContextPath() + "/ViewReservations");
                return;
            }
        }

        // ✅ STAFF/ADMIN can confirm or cancel
        if (!"ADMIN".equals(role) && !"STAFF".equals(role) && !"USER".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // ✅ status mapping
        String newStatus = "PENDING";
        if ("CONFIRM".equalsIgnoreCase(action)) newStatus = "CONFIRMED";
        if ("CANCEL".equalsIgnoreCase(action)) newStatus = "CANCELLED";

        boolean ok = resDao.updateReservationStatus(resNo, newStatus);

        if (ok) {
            // ================= NOTIFICATIONS =================

            // 1) STAFF/ADMIN confirms → notify USER
            if (("ADMIN".equals(role) || "STAFF".equals(role)) && "CONFIRMED".equals(newStatus)) {
                if (res.getUserId() != null) {
                    String msg = "✅ Your booking is CONFIRMED. Reservation: " + resNo +
                            " (" + res.getRoomType() + "), Check-in: " + res.getCheckIn() +
                            ", Check-out: " + res.getCheckOut() + ".";
                    notiDao.addToUser(res.getUserId(), msg);
                }
            }

            // 2) STAFF/ADMIN cancels → notify USER
            if (("ADMIN".equals(role) || "STAFF".equals(role)) && "CANCELLED".equals(newStatus)) {
                if (res.getUserId() != null) {
                    String msg = "❌ Your booking was CANCELLED by " + role +
                            ". Reservation: " + resNo + " (" + res.getRoomType() + ").";
                    notiDao.addToUser(res.getUserId(), msg);
                }
            }

            // 3) USER cancels → notify STAFF + ADMIN
            if ("USER".equals(role) && "CANCELLED".equals(newStatus)) {
                String msg = "⚠ User cancelled reservation: " + resNo +
                        " | UserID: " + loggedUser.getId() +
                        " | Guest: " + res.getGuestName() +
                        " | Room: " + res.getRoomType() +
                        " | " + res.getCheckIn() + " to " + res.getCheckOut();
                notiDao.addToRole("STAFF", msg);
                notiDao.addToRole("ADMIN", msg);
            }
        }

        response.sendRedirect(request.getContextPath() + "/ViewReservations");
    }
}