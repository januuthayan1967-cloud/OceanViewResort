<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.oceanview.model.User" %>
<%@ page import="com.oceanview.model.Booking" %>
<%@ page import="com.oceanview.dao.BookingDAO" %>

<%
    User loggedUser = (User) session.getAttribute("loggedUser");
    if (loggedUser == null || !"USER".equalsIgnoreCase(loggedUser.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    String success = (String) session.getAttribute("successMessage");
    String error   = (String) session.getAttribute("errorMessage");
    session.removeAttribute("successMessage");
    session.removeAttribute("errorMessage");

    BookingDAO bookingDAO = new BookingDAO();
    List<Booking> myBookings = bookingDAO.getBookingsByUserId(loggedUser.getId());

    String backUrl = request.getContextPath() + "/user/userdashbord.jsp"; // change if needed
%>

<!DOCTYPE html>
<html>
<head>
    <title>User - Booking</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        body { background:#f3f6fb; }

        /* ========= ROOM LIST STYLE LIKE YOUR SCREENSHOT ========= */
        .rooms-shell{
            background:#fff;
            border-radius:18px;
            box-shadow:0 12px 40px rgba(0,0,0,.08);
            padding:22px;
        }
        .room-box{
            background:#fff;
            border-radius:18px;
            border:1px solid rgba(0,0,0,.06);
            box-shadow:0 10px 25px rgba(0,0,0,.06);
            padding:22px;
            height:100%;
        }
        .room-title{
            font-size:1.55rem;
            font-weight:800;
            margin:0;
        }
        .price-pill{
            background:#0d6efd;
            color:#fff;
            font-weight:800;
            border-radius:10px;
            padding:8px 14px;
            font-size:1rem;
            white-space:nowrap;
        }
        .muted-row{
            margin-top:8px;
            color:#6c757d;
            display:flex;
            align-items:center;
            gap:8px;
        }
        .info-dot{
            width:20px;height:20px;
            border-radius:50%;
            display:inline-flex;
            align-items:center;
            justify-content:center;
            font-size:12px;
            background:#eef2f7;
            color:#607080;
            font-weight:700;
        }
        .btn-booknow{
            margin-top:14px;
            background:#198754;
            color:#fff;
            font-weight:800;
            border-radius:14px;
            padding:12px 14px;
        }
        .btn-booknow:hover{ background:#157347; color:#fff; }
        .btn-booknow .cal{ margin-right:8px; }

        .selected-line{
            margin-top:14px;
            color:#6c757d;
            font-size:.95rem;
        }
        .selected-line b{ color:#111; }

        /* ========= FORM STYLE ========= */
        .mono { font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, "Liberation Mono", "Courier New", monospace; }
        .card-soft{
            border:1px solid rgba(0,0,0,.06);
            border-radius:18px;
            box-shadow:0 12px 40px rgba(0,0,0,.08);
        }
    </style>
</head>

<body>

<div class="container mt-4 mb-5">

    <div class="d-flex justify-content-between align-items-center mb-3">
        <h3 class="text-primary m-0">Book a Room</h3>
        <a class="btn btn-secondary" href="<%= backUrl %>">Back</a>
    </div>

    <% if (success != null) { %>
        <div class="alert alert-success"><%= success %></div>
    <% } %>
    <% if (error != null) { %>
        <div class="alert alert-danger"><%= error %></div>
    <% } %>

    <!-- ===================== ROOM LIST (LIKE YOUR SCREENSHOT) ===================== -->
    <div class="rooms-shell mb-4">
        <div class="row g-4">

            <!-- Ocean View Suite -->
            <div class="col-md-4">
                <div class="room-box">
                    <div class="d-flex justify-content-between align-items-start">
                        <h4 class="room-title">Ocean View Suite</h4>
                        <span class="price-pill">Rs. 25000</span>
                    </div>
                    <div class="muted-row">
                        <span class="info-dot">i</span>
                        <span>Price per night</span>
                    </div>
                    <button type="button" class="btn btn-booknow w-100"
                            onclick="selectRoom('Ocean View Suite', 25000)">
                        <span class="cal">📅</span>Book Now
                    </button>
                </div>
            </div>

            <!-- Deluxe Room -->
            <div class="col-md-4">
                <div class="room-box">
                    <div class="d-flex justify-content-between align-items-start">
                        <h4 class="room-title">Deluxe Room</h4>
                        <span class="price-pill">Rs. 18000</span>
                    </div>
                    <div class="muted-row">
                        <span class="info-dot">i</span>
                        <span>Price per night</span>
                    </div>
                    <button type="button" class="btn btn-booknow w-100"
                            onclick="selectRoom('Deluxe Room', 18000)">
                        <span class="cal">📅</span>Book Now
                    </button>
                </div>
            </div>

            <!-- Single Room -->
            <div class="col-md-4">
                <div class="room-box">
                    <div class="d-flex justify-content-between align-items-start">
                        <h4 class="room-title">Single Room</h4>
                        <span class="price-pill">Rs. 12000</span>
                    </div>
                    <div class="muted-row">
                        <span class="info-dot">i</span>
                        <span>Price per night</span>
                    </div>
                    <button type="button" class="btn btn-booknow w-100"
                            onclick="selectRoom('Single Room', 12000)">
                        <span class="cal">📅</span>Book Now
                    </button>
                </div>
            </div>

            <!-- Family Suite -->
            <div class="col-md-4">
                <div class="room-box">
                    <div class="d-flex justify-content-between align-items-start">
                        <h4 class="room-title">Family Suite</h4>
                        <span class="price-pill">Rs. 28000</span>
                    </div>
                    <div class="muted-row">
                        <span class="info-dot">i</span>
                        <span>Price per night</span>
                    </div>
                    <button type="button" class="btn btn-booknow w-100"
                            onclick="selectRoom('Family Suite', 28000)">
                        <span class="cal">📅</span>Book Now
                    </button>
                </div>
            </div>

            <!-- Presidential Suite -->
            <div class="col-md-4">
                <div class="room-box">
                    <div class="d-flex justify-content-between align-items-start">
                        <h4 class="room-title">Presidential Suite</h4>
                        <span class="price-pill">Rs. 50000</span>
                    </div>
                    <div class="muted-row">
                        <span class="info-dot">i</span>
                        <span>Price per night</span>
                    </div>
                    <button type="button" class="btn btn-booknow w-100"
                            onclick="selectRoom('Presidential Suite', 50000)">
                        <span class="cal">📅</span>Book Now
                    </button>
                </div>
            </div>

            <!-- Executive Suite -->
            <div class="col-md-4">
                <div class="room-box">
                    <div class="d-flex justify-content-between align-items-start">
                        <h4 class="room-title">Executive Suite</h4>
                        <span class="price-pill">Rs. 35000</span>
                    </div>
                    <div class="muted-row">
                        <span class="info-dot">i</span>
                        <span>Price per night</span>
                    </div>
                    <button type="button" class="btn btn-booknow w-100"
                            onclick="selectRoom('Executive Suite', 35000)">
                        <span class="cal">📅</span>Book Now
                    </button>
                </div>
            </div>

            <!-- Standard Room -->
            <div class="col-md-4">
                <div class="room-box">
                    <div class="d-flex justify-content-between align-items-start">
                        <h4 class="room-title">Standard Room</h4>
                        <span class="price-pill">Rs. 15000</span>
                    </div>
                    <div class="muted-row">
                        <span class="info-dot">i</span>
                        <span>Price per night</span>
                    </div>
                    <button type="button" class="btn btn-booknow w-100"
                            onclick="selectRoom('Standard Room', 15000)">
                        <span class="cal">📅</span>Book Now
                    </button>
                </div>
            </div>

            <!-- Double Room -->
            <div class="col-md-4">
                <div class="room-box">
                    <div class="d-flex justify-content-between align-items-start">
                        <h4 class="room-title">Double Room</h4>
                        <span class="price-pill">Rs. 20000</span>
                    </div>
                    <div class="muted-row">
                        <span class="info-dot">i</span>
                        <span>Price per night</span>
                    </div>
                    <button type="button" class="btn btn-booknow w-100"
                            onclick="selectRoom('Double Room', 20000)">
                        <span class="cal">📅</span>Book Now
                    </button>
                </div>
            </div>

            <!-- Suite Room -->
            <div class="col-md-4">
                <div class="room-box">
                    <div class="d-flex justify-content-between align-items-start">
                        <h4 class="room-title">Suite Room</h4>
                        <span class="price-pill">Rs. 30000</span>
                    </div>
                    <div class="muted-row">
                        <span class="info-dot">i</span>
                        <span>Price per night</span>
                    </div>
                    <button type="button" class="btn btn-booknow w-100"
                            onclick="selectRoom('Suite Room', 30000)">
                        <span class="cal">📅</span>Book Now
                    </button>
                </div>
            </div>

            <!-- Honeymoon Suite -->
            <div class="col-md-4">
                <div class="room-box">
                    <div class="d-flex justify-content-between align-items-start">
                        <h4 class="room-title">Honeymoon Suite</h4>
                        <span class="price-pill">Rs. 40000</span>
                    </div>
                    <div class="muted-row">
                        <span class="info-dot">i</span>
                        <span>Price per night</span>
                    </div>
                    <button type="button" class="btn btn-booknow w-100"
                            onclick="selectRoom('Honeymoon Suite', 40000)">
                        <span class="cal">📅</span>Book Now
                    </button>
                </div>
            </div>

        </div>

        <div class="selected-line">
            Selected room: <b id="selectedRoomText">None</b>
            &nbsp;|&nbsp; Price per night: <b id="selectedPriceText">0</b>
        </div>
    </div>

    <!-- ===================== BOOKING FORM ===================== -->
    <form id="bookingForm" class="card card-body card-soft mb-4"
          action="<%=request.getContextPath()%>/BookingServlet"
          method="post"
          onsubmit="return validateBeforeSubmit();">

        <h5 class="mb-3">Guest Details</h5>

        <div class="row g-3">

            <div class="col-md-4">
                <label class="form-label">Booking No</label>
                <input type="text" name="reservationNumber" class="form-control mono"
                       value="RES<%= System.currentTimeMillis() %>" readonly>
            </div>

            <div class="col-md-4">
                <label class="form-label">Room Type</label>
                <input type="text" id="roomType" name="roomType" class="form-control" readonly required>
                <div class="text-muted small mt-1">Choose a room from above</div>
            </div>

            <div class="col-md-4">
           <label class="form-label">Guest Name</label>
           <input type="text" name="guestName" class="form-control"
               value="<%= loggedUser.getUsername() %>" readonly>
                </div>

            <div class="col-md-4">
                <label class="form-label">Contact Number</label>
                <input type="text" name="contactNumber" class="form-control" required>
            </div>

            <div class="col-md-8">
                <label class="form-label">Address</label>
                <input type="text" name="address" class="form-control" required>
            </div>

            <div class="col-md-3">
                <label class="form-label">Check-in</label>
                <input type="date" id="checkIn" name="checkIn" class="form-control" required>
            </div>

            <div class="col-md-3">
                <label class="form-label">Check-out</label>
                <input type="date" id="checkOut" name="checkOut" class="form-control" required>
            </div>

            <div class="col-md-3">
                <label class="form-label">Nights</label>
                <input type="text" id="nights" class="form-control" value="0" readonly>
            </div>

            <div class="col-md-3">
                <label class="form-label">Total Amount</label>
                <input type="number" id="totalAmount" name="totalAmount" class="form-control" step="0.01" readonly required>
            </div>

            <div class="col-12 d-flex gap-2 mt-2">
                <button class="btn btn-success" type="submit">Confirm Booking</button>
                <button class="btn btn-outline-secondary" type="button" onclick="resetFormAll();">Reset</button>
            </div>

            <div class="col-12">
                <div class="alert alert-info mt-2 mb-0">
                    ✅ This booking will be saved as <b>CONFIRMED</b> automatically.
                </div>
            </div>

        </div>
    </form>

    <!-- ===================== MY CONFIRMED BOOKINGS TABLE ===================== -->
    <div class="card p-3 card-soft">
        <div class="d-flex justify-content-between align-items-center mb-2">
            <h5 class="m-0">My Confirmed Bookings</h5>
            <a class="btn btn-sm btn-primary" href="<%=request.getContextPath()%>/user/booking.jsp">Refresh</a>
        </div>

        <div class="table-responsive">
            <table class="table table-striped table-bordered align-middle mb-0">
                <thead class="table-dark">
                <tr>
                    <th>#</th>
                    <th>Booking No</th>
                    <th>Room</th>
                    <th>Guest</th>
                    <th>Contact</th>
                    <th>Check In</th>
                    <th>Check Out</th>
                    <th>Total</th>
                    <th>Status</th>
                    <th>Created At</th>
                </tr>
                </thead>
                <tbody>
                <%
                    if (myBookings == null || myBookings.isEmpty()) {
                %>
                    <tr>
                        <td colspan="10" class="text-center text-muted">No confirmed bookings yet.</td>
                    </tr>
                <%
                    } else {
                        int i = 1;
                        for (Booking b : myBookings) {
                            String st = (b.getStatus() == null) ? "CONFIRMED" : b.getStatus().toUpperCase();
                %>
                    <tr>
                        <td><%= i++ %></td>
                        <td><%= b.getReservationNumber() %></td>
                        <td><%= b.getRoomType() %></td>
                        <td><%= b.getGuestName() %></td>
                        <td><%= b.getContactNumber() %></td>
                        <td><%= b.getCheckIn() %></td>
                        <td><%= b.getCheckOut() %></td>
                        <td>Rs. <%= b.getTotalAmount() %></td>
                        <td><span class="badge bg-success"><%= st %></span></td>
                        <td><%= b.getCreatedAt() %></td>
                    </tr>
                <%
                        }
                    }
                %>
                </tbody>
            </table>
        </div>
    </div>

</div>

<script>
    let selectedPrice = 0;

    function parseDate(v){
        if(!v) return null;
        const parts = v.split("-");
        if(parts.length !== 3) return null;
        const y = parseInt(parts[0], 10);
        const m = parseInt(parts[1], 10) - 1;
        const d = parseInt(parts[2], 10);
        return new Date(y, m, d);
    }

    function daysBetween(start, end){
        const ms = 24 * 60 * 60 * 1000;
        return Math.floor((end - start) / ms);
    }

    function recalcTotal(){
        const inVal = document.getElementById("checkIn").value;
        const outVal = document.getElementById("checkOut").value;

        const inD = parseDate(inVal);
        const outD = parseDate(outVal);

        let nights = 0;
        if(inD && outD){
            nights = daysBetween(inD, outD);
            if(nights < 0) nights = 0;
        }
        document.getElementById("nights").value = nights;

        const total = (nights > 0 ? nights : 0) * (selectedPrice > 0 ? selectedPrice : 0);
        document.getElementById("totalAmount").value = total.toFixed(2);
    }

    function selectRoom(roomName, price){
        selectedPrice = price;

        document.getElementById("roomType").value = roomName;
        document.getElementById("selectedRoomText").innerText = roomName;
        document.getElementById("selectedPriceText").innerText = "Rs. " + price;

        recalcTotal();

        const form = document.getElementById("bookingForm");
        if(form) form.scrollIntoView({behavior:"smooth", block:"start"});
    }

    document.getElementById("checkIn").addEventListener("change", recalcTotal);
    document.getElementById("checkOut").addEventListener("change", recalcTotal);

    function validateBeforeSubmit(){
        if(!document.getElementById("roomType").value){
            alert("Please select a room type first!");
            return false;
        }

        const inD = parseDate(document.getElementById("checkIn").value);
        const outD = parseDate(document.getElementById("checkOut").value);

        if(!inD || !outD){
            alert("Please select Check-in and Check-out dates!");
            return false;
        }

        const nights = daysBetween(inD, outD);
        if(nights <= 0){
            alert("Check-out date must be after Check-in date!");
            return false;
        }

        const total = parseFloat(document.getElementById("totalAmount").value || "0");
        if(total <= 0){
            alert("Total amount is invalid. Please re-check dates and room selection.");
            return false;
        }

        return true;
    }

    function resetFormAll(){
        selectedPrice = 0;

        document.getElementById("roomType").value = "";
        document.getElementById("selectedRoomText").innerText = "None";
        document.getElementById("selectedPriceText").innerText = "0";

        document.getElementById("checkIn").value = "";
        document.getElementById("checkOut").value = "";
        document.getElementById("nights").value = "0";
        document.getElementById("totalAmount").value = "";
    }
</script>

</body>
</html>