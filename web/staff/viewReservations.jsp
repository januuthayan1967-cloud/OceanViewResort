<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.oceanview.model.Reservation" %>
<%@ page import="com.oceanview.model.User" %>

<%
    User loggedUser = (User) session.getAttribute("loggedUser");
    if (loggedUser == null || !"STAFF".equalsIgnoreCase(loggedUser.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    List<Reservation> reservations = (List<Reservation>) request.getAttribute("reservations");

    String backUrl = request.getContextPath() + "/staff/staffdashboard.jsp"; // ✅ your file name
%>

<!DOCTYPE html>
<html>
<head>
    <title>Staff - View Reservations</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>

<body class="bg-light">
<div class="container mt-4">

    <div class="d-flex justify-content-between align-items-center mb-3">
        <h3 class="text-primary m-0">Reservations (Staff)</h3>
        <a class="btn btn-secondary" href="<%= backUrl %>">Back</a>
    </div>

    <div class="card p-3 shadow-sm">
        <div class="table-responsive">
            <table class="table table-striped table-bordered align-middle">
                <thead class="table-dark">
                <tr>
                    <th>#</th>
                    <th>Reservation No</th>
                    <th>Room</th>
                    <th>Guest</th>
                    <th>Contact</th>
                    <th>Check In</th>
                    <th>Check Out</th>
                    <th>Total</th>
                    <th>User ID</th>
                    <th>Created By</th>
                    <th>Created At</th>
                    <th>Status</th>
                    <th style="min-width:160px;">Action</th>
                </tr>
                </thead>

                <tbody>
                <%
                    if (reservations == null) {
                %>
                    <tr>
                        <td colspan="13" class="text-center text-danger">
                            Reservations list is NULL. Open using:
                            <b><%= request.getContextPath() %>/ViewReservations</b>
                        </td>
                    </tr>
                <%
                    } else if (reservations.isEmpty()) {
                %>
                    <tr>
                        <td colspan="13" class="text-center text-muted">No reservations found.</td>
                    </tr>
                <%
                    } else {
                        int i = 1;
                        for (Reservation r : reservations) {
                            String st = (r.getStatus() == null) ? "PENDING" : r.getStatus().toUpperCase();
                %>
                    <tr>
                        <td><%= i++ %></td>
                        <td><%= r.getReservationNumber() %></td>
                        <td><%= r.getRoomType() %></td>
                        <td><%= r.getGuestName() %></td>
                        <td><%= r.getContactNumber() %></td>
                        <td><%= r.getCheckIn() %></td>
                        <td><%= r.getCheckOut() %></td>
                        <td>Rs. <%= r.getTotalAmount() %></td>
                        <td><%= r.getUserId() %></td>
                        <td><%= r.getCreatedBy() %></td>
                        <td><%= r.getCreatedAt() %></td>

                        <td>
                            <span class="badge
                                <%= "CONFIRMED".equals(st) ? "bg-success" :
                                    "CANCELLED".equals(st) ? "bg-danger" : "bg-warning text-dark" %>">
                                <%= st %>
                            </span>
                        </td>

                        <td class="text-center">
                            <% if ("PENDING".equals(st)) { %>

                                <form action="<%=request.getContextPath()%>/UpdateReservationStatus" method="post" style="display:inline;">
                                    <input type="hidden" name="resNo" value="<%= r.getReservationNumber() %>">
                                    <input type="hidden" name="action" value="CONFIRM">
                                    <button class="btn btn-sm btn-success">Confirm</button>
                                </form>

                                <form action="<%=request.getContextPath()%>/UpdateReservationStatus" method="post" style="display:inline;">
                                    <input type="hidden" name="resNo" value="<%= r.getReservationNumber() %>">
                                    <input type="hidden" name="action" value="CANCEL">
                                    <button class="btn btn-sm btn-danger">Cancel</button>
                                </form>

                            <% } else { %>
                                <span class="text-muted">No Action</span>
                            <% } %>
                        </td>
                    </tr>
                <%
                        }
                    }
                %>
                </tbody>
            </table>
        </div>

        <div class="mt-2">
            <a class="btn btn-primary" href="<%=request.getContextPath()%>/ViewReservations">Refresh</a>
        </div>
    </div>

</div>
</body>
</html>