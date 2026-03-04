<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.oceanview.model.User" %>
<%@ page import="com.oceanview.dao.UserDAO" %>

<%
    User loggedUser = (User) session.getAttribute("loggedUser");
    if (loggedUser == null || !"STAFF".equalsIgnoreCase(loggedUser.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    // ✅ Session flash messages (works with sendRedirect)
    String successMessage = (String) session.getAttribute("successMessage");
    String errorMessage = (String) session.getAttribute("errorMessage");
    if (successMessage != null) session.removeAttribute("successMessage");
    if (errorMessage != null) session.removeAttribute("errorMessage");

    String action = request.getParameter("action");
    String selectedRoom = request.getParameter("selectedRoom");
    String selectedPrice = request.getParameter("selectedPrice");
    String selectedUserId = request.getParameter("userId");

    boolean showForm = "selectRoom".equals(action);

    // ✅ Load users directly
    UserDAO userDAO = new UserDAO();
    List<User> users = userDAO.getAllUsers();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Staff Room Booking</title>

    <!-- Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

    <!-- Google Font -->
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600&display=swap" rel="stylesheet">

    <!-- Font Awesome Icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css"/>

    <style>
        * { font-family: 'Poppins', sans-serif; }

        body{
            background: linear-gradient(135deg,#eef2f7,#f8fbff);
            min-height:100vh;
        }

        .page-title{
            font-weight:600;
            color:#0d6efd;
        }

        .card{
            border:none;
            border-radius:15px;
        }

        .shadow-soft{
            box-shadow:0 10px 25px rgba(0,0,0,0.08);
        }

        .room-card{
            transition:0.25s ease;
            border:1px solid rgba(0,0,0,0.05);
        }

        .room-card:hover{
            transform:translateY(-6px);
            box-shadow:0 14px 30px rgba(0,0,0,0.12);
        }

        .badge-price{
            background:#0d6efd;
            font-weight:500;
        }

        .btn{
            border-radius:10px;
            font-weight:500;
        }

        .form-control, .form-select, textarea{
            border-radius:10px;
        }

        .small-muted{
            color:#6c757d;
            font-size:0.92rem;
        }

        .msg-wrap{
            border-radius:12px;
            padding:12px 14px;
            box-shadow:0 10px 25px rgba(0,0,0,0.06);
        }
        .msg-success{
            background:#e9f9ee;
            border-left:6px solid #28a745;
        }
        .msg-error{
            background:#ffecec;
            border-left:6px solid #dc3545;
        }
    </style>

    <script>
        function calculateBill() {
            const checkIn = document.getElementById('checkIn').value;
            const checkOut = document.getElementById('checkOut').value;
            const pricePerNight = parseFloat(document.getElementById('pricePerNight').value || "0");
            const numNightsField = document.getElementById('numNights');
            const totalAmountField = document.getElementById('totalAmount');

            if (checkIn && checkOut) {
                const diffTime = new Date(checkOut) - new Date(checkIn);
                let diffDays = Math.ceil(diffTime / (1000*60*60*24));
                if (isNaN(diffDays) || diffDays <= 0) diffDays = 1;

                numNightsField.value = diffDays;
                totalAmountField.value = diffDays * pricePerNight;
            } else {
                numNightsField.value = 1;
                totalAmountField.value = pricePerNight;
            }
        }

        // auto hide flash message
        window.addEventListener("DOMContentLoaded", function () {
            const msg = document.getElementById("flashMessage");
            if (msg) {
                setTimeout(() => {
                    msg.style.transition = "0.4s";
                    msg.style.opacity = "0";
                    setTimeout(() => msg.remove(), 400);
                }, 4000);
            }
        });
    </script>
</head>

<body>
<div class="container py-4">

    <!-- Header -->
    <div class="d-flex justify-content-between align-items-center mb-3 flex-wrap gap-2">
        <div>
            <h3 class="page-title mb-1">
                <i class="fa-solid fa-user-tie"></i> Staff Room Booking
            </h3>
            <div class="small-muted">Select a guest, choose a room, then confirm booking.</div>
        </div>

        <!-- Back button (to staff dashboard or your page) -->
        <a href="<%=request.getContextPath()%>/StaffDashboard" class="btn btn-secondary">
            <i class="fa fa-arrow-left"></i> Back
        </a>
    </div>

    <!-- ✅ Success/Error from session -->
    <% if (successMessage != null) { %>
        <div id="flashMessage" class="msg-wrap msg-success mb-4">
            <i class="fa fa-check-circle text-success"></i>
            <b class="ms-1"><%= successMessage %></b>
        </div>
    <% } %>

    <% if (errorMessage != null) { %>
        <div id="flashMessage" class="msg-wrap msg-error mb-4">
            <i class="fa fa-triangle-exclamation text-danger"></i>
            <b class="ms-1"><%= errorMessage %></b>
        </div>
    <% } %>

    <% if (successMessage == null && errorMessage == null) { %>
        <div class="msg-wrap msg-success mb-4">
            <i class="fa fa-circle-info text-success"></i>
            Booking system ready. Please select a user to show rooms.
        </div>
    <% } %>

    <!-- ====== SELECT GUEST ====== -->
    <div class="card p-3 shadow-soft mb-4">
        <div class="d-flex justify-content-between align-items-center flex-wrap">
            <div>
                <h5 class="mb-1"><i class="fa-solid fa-user"></i> Select Guest</h5>
                <div class="small-muted">Choose a registered user to book a room on behalf of them.</div>
            </div>
        </div>

        <hr class="my-3"/>

        <form method="get" action="<%=request.getRequestURI()%>">
            <select name="userId" class="form-select mb-3" required>
                <option value="">-- Select User --</option>
                <% if (users != null) {
                    for (User u : users) { %>
                        <option value="<%=u.getId()%>" <%= (u.getId()+"").equals(selectedUserId) ? "selected" : "" %>>
                            <%=u.getUsername()%> (<%=u.getEmail()%>)
                        </option>
                <%  }
                } %>
            </select>

            <input type="hidden" name="action" value="keepUser">
            <button type="submit" class="btn btn-primary">
                <i class="fa-solid fa-check"></i> Select User
            </button>
        </form>
    </div>

    <!-- If no user selected -->
    <% if (selectedUserId == null || selectedUserId.isEmpty()) { %>
        <div class="alert alert-warning shadow-soft">
            <i class="fa-solid fa-triangle-exclamation"></i>
            Please select a user first to show rooms.
        </div>
    <% } %>

    <!-- ====== ROOM LIST ====== -->
    <% if (!showForm && selectedUserId != null && !selectedUserId.isEmpty()) { %>
        <div class="d-flex justify-content-between align-items-center mb-2 flex-wrap">
            <div class="fw-semibold">
                <i class="fa-solid fa-hotel"></i> Choose a Room
            </div>
            <div class="small-muted">User ID: <b><%=selectedUserId%></b></div>
        </div>

        <div class="row mb-4">
            <%
                String[][] rooms = {
                    {"Ocean View Suite","25000"},
                    {"Deluxe Room","18000"},
                    {"Single Room","12000"},
                    {"Family Suite","28000"},
                    {"Presidential Suite","50000"},
                    {"Executive Suite","35000"},
                    {"Standard Room","15000"},
                    {"Double Room","20000"},
                    {"Suite Room","30000"},
                    {"Honeymoon Suite","40000"}
                };
                for (String[] room : rooms) {
            %>

            <div class="col-md-4 mb-3">
                <div class="card room-card p-3 shadow-soft h-100">
                    <div class="d-flex justify-content-between align-items-start">
                        <h5 class="mb-1"><%=room[0]%></h5>
                        <span class="badge badge-price text-white px-3 py-2">
                            Rs. <%=room[1]%>
                        </span>
                    </div>

                    <div class="small-muted mt-2">
                        <i class="fa-solid fa-circle-info"></i> Price per night
                    </div>

                    <div class="mt-3">
                        <form method="get" action="<%=request.getRequestURI()%>">
                            <input type="hidden" name="action" value="selectRoom">
                            <input type="hidden" name="selectedRoom" value="<%=room[0]%>">
                            <input type="hidden" name="selectedPrice" value="<%=room[1]%>">
                            <input type="hidden" name="userId" value="<%=selectedUserId%>">
                            <button type="submit" class="btn btn-success w-100">
                                <i class="fa-solid fa-calendar-plus"></i> Book Now
                            </button>
                        </form>
                    </div>
                </div>
            </div>

            <% } %>
        </div>
    <% } %>

    <!-- ====== RESERVATION FORM ====== -->
    <% if (showForm && selectedUserId != null && !selectedUserId.isEmpty()) { %>
        <div class="card p-4 shadow-soft mt-4">
            <h4 class="mb-1 text-success">
                <i class="fa-solid fa-calendar-check"></i> Reservation Form
            </h4>
            <div class="small-muted mb-4">
                Room: <b><%=selectedRoom%></b> | User ID: <b><%=selectedUserId%></b>
            </div>

            <form action="<%=request.getContextPath()%>/ReservationServlet" method="post">
                <input type="hidden" name="roomType" value="<%=selectedRoom%>">
                <input type="hidden" name="userId" value="<%=selectedUserId%>">
                <input type="hidden" name="createdBy" value="staff">
                <input type="hidden" id="pricePerNight" value="<%=selectedPrice%>">

                <div class="row g-3">
                    <div class="col-md-6">
                        <label class="form-label">Reservation Number</label>
                        <input type="text" name="reservationNumber" class="form-control"
                               value="RES<%=System.currentTimeMillis()%>" readonly>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label">Room Type</label>
                        <input type="text" class="form-control" value="<%=selectedRoom%>" readonly>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label">Guest Name</label>
                        <input type="text" name="guestName" class="form-control" required>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label">Contact Number</label>
                        <input type="text" name="contactNumber" class="form-control" required>
                    </div>

                    <div class="col-12">
                        <label class="form-label">Address</label>
                        <textarea name="address" class="form-control" rows="3" required></textarea>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label">Check In</label>
                        <input type="date" name="checkIn" id="checkIn" class="form-control"
                               onchange="calculateBill()" required>
                    </div>

                    <div class="col-md-6">
                        <label class="form-label">Check Out</label>
                        <input type="date" name="checkOut" id="checkOut" class="form-control"
                               onchange="calculateBill()" required>
                    </div>

                    <div class="col-md-4">
                        <label class="form-label">Number of Nights</label>
                        <input type="number" id="numNights" class="form-control" readonly value="1">
                    </div>

                    <div class="col-md-4">
                        <label class="form-label">Price Per Night</label>
                        <input type="number" class="form-control" value="<%=selectedPrice%>" readonly>
                    </div>

                    <div class="col-md-4">
                        <label class="form-label">Total Amount</label>
                        <input type="number" id="totalAmount" name="totalAmount" class="form-control" readonly
                               value="<%=selectedPrice%>">
                    </div>
                </div>

                <div class="mt-4 d-flex flex-wrap gap-2">
                    <button type="submit" class="btn btn-success">
                        <i class="fa-solid fa-circle-check"></i> Confirm Booking
                    </button>

                    <a href="<%=request.getContextPath()%>/staff/staffBookRoom.jsp" class="btn btn-secondary">
                        <i class="fa fa-arrow-left"></i> Back
                    </a>
                </div>
            </form>
        </div>
    <% } %>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>