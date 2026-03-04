package com.oceanview.controller;

import com.oceanview.dao.NotificationDAO;
import com.oceanview.model.User;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/AdminDashboard")
public class AdminDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("loggedUser") : null;

        if (user == null || !"ADMIN".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        NotificationDAO dao = new NotificationDAO();

        int notiCount = dao.countUnreadForRole("ADMIN");
        List<String> notifications = dao.getLatestForRole("ADMIN", 5);

        request.setAttribute("notiCount", notiCount);
        request.setAttribute("notifications", notifications);

        request.getRequestDispatcher("/admin/admindashboard.jsp").forward(request, response);
    }
}