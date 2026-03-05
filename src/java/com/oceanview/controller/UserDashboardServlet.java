package com.oceanview.controller;

import com.oceanview.dao.NotificationDAO;
import com.oceanview.dao.BookingDAO;
import com.oceanview.model.User;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/UserDashboard")
public class UserDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("loggedUser") : null;

        if (user == null || !"USER".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // ✅ Notifications
        NotificationDAO notiDao = new NotificationDAO();
        int notiCount = notiDao.countUnreadForUser(user.getId());
        List<String> notifications = notiDao.getLatestForUser(user.getId(), 5);

        request.setAttribute("notiCount", notiCount);
        request.setAttribute("notifications", notifications);

        // ✅ Booking Count (CONFIRMED bookings in reservation table)
        BookingDAO bookingDAO = new BookingDAO();
        int bookingCount = bookingDAO.countConfirmedBookings(user.getId());
        request.setAttribute("bookingCount", bookingCount);

        request.getRequestDispatcher("/user/userdashbord.jsp").forward(request, response);
    }
}