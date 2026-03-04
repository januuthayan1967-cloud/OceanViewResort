package com.oceanview.controller;

import com.oceanview.dao.ReservationDAO;
import com.oceanview.model.Reservation;
import com.oceanview.model.User;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/PrintBillSingle")
public class PrintBillSingleServlet extends HttpServlet {

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

        String resNo = request.getParameter("resNo");
        if (resNo == null || resNo.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/PrintBill");
            return;
        }
        resNo = resNo.trim();

        ReservationDAO dao = new ReservationDAO();
        Reservation bill = dao.getReservationByNumber(resNo);

        if (bill == null) {
            request.setAttribute("error", "Bill not found for reservation: " + resNo);
            request.getRequestDispatcher("/billSingle.jsp").forward(request, response);
            return;
        }

        // ✅ RULE 1: Only CONFIRMED can print (for ALL roles)
        if (bill.getStatus() == null || !"CONFIRMED".equalsIgnoreCase(bill.getStatus())) {
            request.setAttribute("error", "This reservation is not CONFIRMED yet. You can print bill only after confirmation.");
            request.setAttribute("bill", bill); // optional (so you can show details)
            request.getRequestDispatcher("/billSingle.jsp").forward(request, response);
            return;
        }

        // ✅ RULE 2: USER can print only OWN bill
        if ("USER".equals(role)) {
            if (bill.getUserId() == null || bill.getUserId() != loggedUser.getId()) {
                response.sendError(403, "You are not allowed to print this bill.");
                return;
            }
        }
        // ✅ ADMIN/STAFF can print any CONFIRMED bill

        request.setAttribute("bill", bill);
        request.getRequestDispatcher("/billSingle.jsp").forward(request, response);
    }
}