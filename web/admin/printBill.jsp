<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.oceanview.model.Reservation" %>
<%@ page import="com.oceanview.model.User" %>

<%
    User loggedUser = (User) session.getAttribute("loggedUser");
    if (loggedUser == null || !"ADMIN".equalsIgnoreCase(loggedUser.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    List<Reservation> bills = (List<Reservation>) request.getAttribute("bills");
%>

<!DOCTYPE html>
<html>
<head>
    <title>Confirmed Bills (Admin)</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container mt-4">

    <div class="d-flex justify-content-between align-items-center mb-3">
        <div>
            <h3 class="text-danger m-0">Confirmed Reservation Bills</h3>
            <small class="text-muted">Only CONFIRMED reservations can be printed.</small>
        </div>
        <a class="btn btn-secondary" href="<%=request.getContextPath()%>/AdminDashboard">Back</a>
    </div>

    <table class="table table-bordered table-hover align-middle">
        <thead class="table-dark">
        <tr>
            <th>#</th>
            <th>Reservation</th>
            <th>User ID</th>
            <th>Room</th>
            <th>Guest</th>
            <th>Check In</th>
            <th>Check Out</th>
            <th>Total</th>
            <th>Status</th>
            <th>Print</th>
        </tr>
        </thead>

        <tbody>
        <%
            if (bills == null) {
        %>
            <tr>
                <td colspan="10" class="text-center text-danger">
                    Bills list is NULL. Open using: <b><%=request.getContextPath()%>/PrintBill</b>
                </td>
            </tr>
        <%
            } else if (bills.isEmpty()) {
        %>
            <tr>
                <td colspan="10" class="text-center text-muted">No CONFIRMED bills found</td>
            </tr>
        <%
            } else {
                int i = 1;
                for (Reservation r : bills) {
        %>
            <tr>
                <td><%= i++ %></td>
                <td><%= r.getReservationNumber() %></td>
                <td><%= r.getUserId() %></td>
                <td><%= r.getRoomType() %></td>
                <td><%= r.getGuestName() %></td>
                <td><%= r.getCheckIn() %></td>
                <td><%= r.getCheckOut() %></td>
                <td>Rs. <%= r.getTotalAmount() %></td>
                <td>
                    <span class="badge bg-success"><%= r.getStatus() %></span>
                </td>
                <td>
                    <a class="btn btn-sm btn-primary"
                       target="_blank"
                       href="<%=request.getContextPath()%>/PrintBillSingle?resNo=<%=r.getReservationNumber()%>">
                        Print
                    </a>
                </td>
            </tr>
        <%
                }
            }
        %>
        </tbody>
    </table>

</div>
</body>
</html>