package com.oceanview.controller;

import com.oceanview.dao.ReservationDAO;
import com.oceanview.model.Reservation;
import com.oceanview.model.User;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/ViewReservations")
public class ViewReservationServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User loggedUser = (session != null) ? (User) session.getAttribute("loggedUser") : null;

        if (loggedUser == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String role = loggedUser.getRole() == null ? "" : loggedUser.getRole().toUpperCase();
        ReservationDAO dao = new ReservationDAO();

        List<Reservation> reservations;

        if ("ADMIN".equals(role)) {

            // 🔹 Admin → see ALL
            reservations = dao.getAllReservations();
            request.setAttribute("reservations", reservations);
            request.getRequestDispatcher("/admin/viewReservations.jsp").forward(request, response);

        } else if ("STAFF".equals(role)) {

            // 🔹 Staff → see USER + STAFF bookings
            reservations = dao.getReservationsForStaff(); // ✅ NO ID
            request.setAttribute("reservations", reservations);
            request.getRequestDispatcher("/staff/viewReservations.jsp").forward(request, response);

        } else {

            // 🔹 User → see ONLY own bookings
            reservations = dao.getReservationsByUserId(loggedUser.getId());
            request.setAttribute("reservations", reservations);
            request.getRequestDispatcher("/user/viewReservations.jsp").forward(request, response);
        }
    }
}