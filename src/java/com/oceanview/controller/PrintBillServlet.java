package com.oceanview.controller;

import com.oceanview.dao.ReservationDAO;
import com.oceanview.model.Reservation;
import com.oceanview.model.User;

import java.io.IOException;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/PrintBill")
public class PrintBillServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User loggedUser = (session != null) ? (User) session.getAttribute("loggedUser") : null;

        if (loggedUser == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String role = (loggedUser.getRole() == null) ? "" : loggedUser.getRole().toUpperCase();

        ReservationDAO dao = new ReservationDAO();
        List<Reservation> bills;

        System.out.println("=== PRINT BILL DEBUG (CONFIRMED ONLY) ===");
        System.out.println("User=" + loggedUser.getUsername() + " id=" + loggedUser.getId() + " role=" + role);

        if ("ADMIN".equals(role)) {
            bills = dao.getConfirmedBillsForAdmin();   // ✅ only confirmed
            System.out.println("ADMIN confirmed bills size=" + bills.size());
            request.setAttribute("bills", bills);
            request.getRequestDispatcher("/admin/printBill.jsp").forward(request, response);

        } else if ("STAFF".equals(role)) {
            bills = dao.getConfirmedBillsForStaff();   // ✅ only confirmed
            System.out.println("STAFF confirmed bills size=" + bills.size());
            request.setAttribute("bills", bills);
            request.getRequestDispatcher("/staff/printBill.jsp").forward(request, response);

        } else { // USER
            bills = dao.getConfirmedBillsForUser(loggedUser.getId());  // ✅ only own confirmed
            System.out.println("USER confirmed bills size=" + bills.size());
            request.setAttribute("bills", bills);
            request.getRequestDispatcher("/user/printBill.jsp").forward(request, response);
        }

        System.out.println("========================================");
    }
}