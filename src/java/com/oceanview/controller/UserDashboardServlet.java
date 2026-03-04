package com.oceanview.controller;

import com.oceanview.dao.NotificationDAO;
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

        NotificationDAO dao = new NotificationDAO();

        int notiCount = dao.countUnreadForUser(user.getId());
        List<String> notifications = dao.getLatestForUser(user.getId(), 5);

        request.setAttribute("notiCount", notiCount);
        request.setAttribute("notifications", notifications);

        request.getRequestDispatcher("/user/userdashbord.jsp").forward(request, response);
    }
}