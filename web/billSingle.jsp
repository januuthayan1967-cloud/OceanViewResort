<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.oceanview.model.Reservation" %>

<%
    Reservation bill = (Reservation) request.getAttribute("bill");
    String error = (String) request.getAttribute("error");
%>

<!DOCTYPE html>
<html>
<head>
    <title>Print Bill</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        @media print {
            .no-print { display: none !important; }
            body { background: #fff !important; }
        }
        .bill-card {
            max-width: 800px;
            margin: 30px auto;
            border-radius: 14px;
        }
    </style>
</head>

<body class="bg-light">
<div class="container">

    <div class="card shadow bill-card">
        <div class="card-body p-4">
            <div class="d-flex justify-content-between align-items-center mb-3">
                <h3 class="m-0">Ocean View Resort - Bill</h3>
                <div class="no-print">
                    <button class="btn btn-primary" onclick="window.print()">Print</button>
                    <a class="btn btn-secondary" href="<%=request.getContextPath()%>/PrintBill">Back</a>
                </div>
            </div>

            <% if (error != null) { %>
                <div class="alert alert-danger"><%= error %></div>

            <% } else if (bill != null) { %>

                <div class="mb-3">
                    <span class="badge bg-success" style="font-size:0.95rem;">
                        STATUS: <%= bill.getStatus() %>
                    </span>
                </div>

                <table class="table table-bordered">
                    <tr><th>Reservation No</th><td><%= bill.getReservationNumber() %></td></tr>
                    <tr><th>Guest Name</th><td><%= bill.getGuestName() %></td></tr>
                    <tr><th>Room Type</th><td><%= bill.getRoomType() %></td></tr>
                    <tr><th>Contact</th><td><%= bill.getContactNumber() %></td></tr>
                    <tr><th>Address</th><td><%= bill.getAddress() %></td></tr>
                    <tr><th>Check In</th><td><%= bill.getCheckIn() %></td></tr>
                    <tr><th>Check Out</th><td><%= bill.getCheckOut() %></td></tr>
                    <tr><th>Total Amount</th><td><b>Rs. <%= bill.getTotalAmount() %></b></td></tr>
                    <tr><th>Created By</th><td><%= bill.getCreatedBy() %></td></tr>
                    <tr><th>Created At</th><td><%= bill.getCreatedAt() %></td></tr>
                </table>

                <p class="text-muted mt-3 mb-0">Thank you for choosing Ocean View Resort!</p>

            <% } %>
        </div>
    </div>

</div>
</body>
</html>