package com.oceanview.controller;

import com.oceanview.dao.NotificationDAO;
import com.oceanview.model.User;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/StaffDashboard")
public class StaffDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("loggedUser") : null;

        if (user == null || !"STAFF".equalsIgnoreCase(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        NotificationDAO dao = new NotificationDAO();

        int notiCount = dao.countUnreadForRole("STAFF");
        List<String> notifications = dao.getLatestForRole("STAFF", 5);

        request.setAttribute("notiCount", notiCount);
        request.setAttribute("notifications", notifications);

        request.getRequestDispatcher("/staff/staffdashboard.jsp")
               .forward(request, response);
    }
}