package com.oceanview.controller;

import com.oceanview.dao.NotificationDAO;
import com.oceanview.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/Notifications")
public class NotificationsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User loggedUser = (session != null) ? (User) session.getAttribute("loggedUser") : null;

        if (loggedUser == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        NotificationDAO dao = new NotificationDAO();

        // ✅ Load notifications for this user/role (choose ONE approach based on your DB design)
        // Option A: notifications stored with receiverUserId
        request.setAttribute("notifications", dao.getNotificationsForUser(loggedUser.getId()));

        // Optionally: unread count (if you have it)
        request.setAttribute("notiCount", dao.countUnreadForUser(loggedUser.getId()));

        // ✅ Forward to correct JSP based on role
        String role = (loggedUser.getRole() == null) ? "" : loggedUser.getRole().toUpperCase();

        if ("ADMIN".equals(role)) {
            request.getRequestDispatcher("/admin/notifications.jsp").forward(request, response);
        } else if ("STAFF".equals(role)) {
            request.getRequestDispatcher("/staff/notifications.jsp").forward(request, response);
        } else {
            request.getRequestDispatcher("/user/notifications.jsp").forward(request, response);
        }
    }
}