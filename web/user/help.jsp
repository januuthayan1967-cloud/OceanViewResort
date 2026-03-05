<%@ page contentType="text/html;charset=UTF-8" language="java" session="true" %>
<%@ page import="com.oceanview.model.User" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>

<%
    User user = (User) session.getAttribute("loggedUser");
    if (user == null || !"USER".equalsIgnoreCase(user.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    String today = new SimpleDateFormat("EEEE, MMMM d, yyyy").format(new Date());
    String backUrl = request.getContextPath() + "/UserDashboard";
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>User Help - Ocean View Resort</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <!-- Bootstrap + Font Awesome -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

    <style>
        body{
            background: radial-gradient(circle at 10% 10%, #eef3ff 0%, #f4f6f9 40%, #e9fbff 100%);
            font-family: 'Poppins', sans-serif;
        }

        .hero{
            background: linear-gradient(135deg,#062c3a,#0b4f6c,#3a9bc5);
            color:#fff;
            border-radius: 28px;
            padding: 30px;
            box-shadow: 0 18px 50px rgba(0,0,0,.15);
            position:relative;
            overflow:hidden;
        }
        .hero .icon-bg{
            position:absolute;
            right:-18px;
            bottom:-24px;
            font-size: 140px;
            opacity:.14;
        }
        .chip{
            display:inline-flex;
            align-items:center;
            gap:8px;
            padding: 8px 12px;
            border-radius: 999px;
            background: rgba(255,255,255,.18);
            border: 1px solid rgba(255,255,255,.28);
            font-weight: 700;
        }

        .glass{
            background: rgba(255,255,255,.75);
            border: 1px solid rgba(255,255,255,.55);
            backdrop-filter: blur(8px);
            border-radius: 22px;
            box-shadow: 0 10px 26px rgba(0,0,0,.06);
        }

        .section-title{
            font-weight: 900;
            color:#0b4f6c;
        }
        .mini{
            color:#6c757d;
            font-size:.95rem;
        }

        .quick-btn{
            border-radius: 14px;
            font-weight: 800;
            padding: 10px 14px;
        }

        .feature-card{
            background:#fff;
            border-radius: 22px;
            padding: 18px;
            border: 1px solid rgba(0,0,0,.06);
            box-shadow: 0 12px 28px rgba(0,0,0,.06);
            height:100%;
            transition: .18s ease;
        }
        .feature-card:hover{ transform: translateY(-3px); }

        .feature-icon{
            width:52px;
            height:52px;
            border-radius: 18px;
            display:flex;
            align-items:center;
            justify-content:center;
            background: rgba(13,110,253,.12);
            color:#0d6efd;
            font-size: 1.3rem;
            margin-bottom: 10px;
        }

        .help-card{
            background:#fff;
            border-radius: 22px;
            padding: 18px;
            border: 1px solid rgba(0,0,0,.06);
            box-shadow: 0 12px 28px rgba(0,0,0,.06);
            height:100%;
        }

        .step{
            display:flex;
            gap:12px;
            padding: 12px;
            border-radius: 18px;
            background:#f8fbff;
            border: 1px solid rgba(13,110,253,.10);
            margin-bottom: 10px;
        }
        .step .num{
            width:42px;height:42px;
            border-radius: 14px;
            display:flex;align-items:center;justify-content:center;
            font-weight: 900;
            color:#fff;
            background:#0d6efd;
            flex: 0 0 auto;
        }
        .step h6{ margin:0; font-weight: 900; }
        .step p{ margin:0; color:#6c757d; font-size:.95rem; }

        .kbd{
            font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, "Liberation Mono","Courier New", monospace;
            background:#111827;
            color:#fff;
            padding:2px 8px;
            border-radius:8px;
            font-size:.85rem;
        }

        .tips{
            background: #f8fff9;
            border: 1px solid rgba(25,135,84,.12);
            border-radius: 18px;
            padding: 14px;
        }
        .issues{
            background:#fff5f5;
            border: 1px solid rgba(220,53,69,.16);
            border-radius: 18px;
            padding: 14px;
        }

        .faq .accordion-button{ font-weight: 800; }
        .faq .accordion-item{
            border-radius: 16px;
            overflow:hidden;
            border:1px solid rgba(0,0,0,.06);
            box-shadow: 0 8px 18px rgba(0,0,0,.05);
            margin-bottom: 12px;
        }

        .footer-line{
            border-top: 1px dashed rgba(0,0,0,.15);
            margin-top: 22px;
            padding-top: 12px;
        }
    </style>
</head>

<body>

<div class="container my-4">

    <!-- HERO -->
    <div class="hero mb-4">
        <div class="d-flex justify-content-between align-items-start flex-wrap gap-2">
            <div>
                <h2 class="mb-1">User Help Center</h2>
                <p class="mb-2" style="max-width: 820px;">
                    Learn how to book rooms, view reservations, and print bills in the Ocean View Resort system.
                    This page is designed for customers to use the system easily without confusion.
                </p>

                <span class="chip"><i class="fa-solid fa-user"></i> <b><%= user.getUsername() %></b></span>
                <span class="chip ms-2"><i class="fa-solid fa-calendar"></i> <%= today %></span>
                <span class="chip ms-2"><i class="fa-solid fa-circle-check"></i> Booking status: <b>CONFIRMED</b></span>
            </div>

            <div class="d-flex gap-2">
                <a class="btn btn-light fw-bold" style="border-radius:14px;" href="<%= backUrl %>">
                    <i class="fa-solid fa-arrow-left"></i> Back
                </a>
            </div>
        </div>

        <!-- Search bar (front-end only) -->
        <div class="glass p-3 mt-3">
            <div class="row g-2 align-items-center">
                <div class="col-md-9">
                    <input id="helpSearch" class="form-control" style="border-radius:14px;"
                           placeholder="Search help... (example: booking, dates, bill, status, cancel)">
                </div>
                <div class="col-md-3 d-grid">
                    <button class="btn btn-primary quick-btn" type="button" onclick="scrollToFirstMatch()">
                        <i class="fa-solid fa-magnifying-glass"></i> Search
                    </button>
                </div>
            </div>

            <!-- Quick actions -->
            <div class="d-flex flex-wrap gap-2 mt-3">
                <a class="btn btn-success quick-btn" href="<%=request.getContextPath()%>/user/booking.jsp">
                    <i class="fa-solid fa-bed"></i> Book Room
                </a>
                <a class="btn btn-primary quick-btn" href="<%=request.getContextPath()%>/ViewReservations">
                    <i class="fa-solid fa-calendar-check"></i> View Reservations
                </a>
                <a class="btn btn-dark quick-btn" href="<%=request.getContextPath()%>/PrintBill">
                    <i class="fa-solid fa-file-invoice-dollar"></i> Print Bill
                </a>
            </div>
        </div>

        <i class="fa-solid fa-circle-question icon-bg"></i>
    </div>

    <!-- BIG FEATURE CARDS -->
    <div class="row g-4 mb-4">
        <div class="col-lg-4">
            <div class="feature-card">
                <div class="feature-icon"><i class="fa-solid fa-bed"></i></div>
                <h5 class="fw-bold mb-1">Book Room Easily</h5>
                <div class="mini">
                    Select a room type, choose dates, and confirm. The system calculates nights and total amount automatically.
                </div>
            </div>
        </div>
        <div class="col-lg-4">
            <div class="feature-card">
                <div class="feature-icon"><i class="fa-solid fa-calendar-check"></i></div>
                <h5 class="fw-bold mb-1">View Reservations</h5>
                <div class="mini">
                    Track your booking number, room type, check-in/out dates, and current status (CONFIRMED/PENDING/CANCELLED).
                </div>
            </div>
        </div>
        <div class="col-lg-4">
            <div class="feature-card">
                <div class="feature-icon"><i class="fa-solid fa-file-invoice-dollar"></i></div>
                <h5 class="fw-bold mb-1">Bills & History</h5>
                <div class="mini">
                    View your bill and print it anytime. Your confirmed bookings appear under billing automatically.
                </div>
            </div>
        </div>
    </div>

    <!-- MAIN HELP CONTENT -->
    <div class="row g-4">

        <!-- BOOKING STEPS -->
        <div class="col-lg-7">
            <div class="help-card" id="section-booking">
                <h4 class="section-title mb-1">
                    <i class="fa-solid fa-bed text-primary"></i> How to Book a Room (Step-by-step)
                </h4>
                <div class="mini mb-3">
                    Follow these steps carefully to create a correct booking and avoid errors.
                </div>

                <div class="step">
                    <div class="num"><i class="fa-solid fa-right-to-bracket"></i></div>
                    <div>
                        <h6>Login to your account</h6>
                        <p>Login using your username and password. You must be logged in to book a room.</p>
                    </div>
                </div>

                <div class="step">
                    <div class="num">2</div>
                    <div>
                        <h6>Open the booking page</h6>
                        <p>From dashboard, click <span class="kbd">Book Room</span>. You will see room cards with prices.</p>
                    </div>
                </div>

                <div class="step">
                    <div class="num">3</div>
                    <div>
                        <h6>Select a room type</h6>
                        <p>Click a room card (example: Ocean View Suite). Room type and price will auto-fill.</p>
                    </div>
                </div>

                <div class="step">
                    <div class="num">4</div>
                    <div>
                        <h6>Select check-in and check-out dates</h6>
                        <p>Check-out date must be after check-in. The system calculates number of nights.</p>
                    </div>
                </div>

                <div class="step">
                    <div class="num">5</div>
                    <div>
                        <h6>Confirm booking</h6>
                        <p>Click <b>Confirm Booking</b>. Your booking saves as <b>CONFIRMED</b> and shows in your list.</p>
                    </div>
                </div>

                <div class="alert alert-info mt-3 mb-0" style="border-radius:16px;">
                    <i class="fa-solid fa-lightbulb"></i>
                    Tip: Always double-check room type and dates before confirming.
                </div>
            </div>
        </div>

        <!-- BILL + VIEW RESERVATIONS -->
        <div class="col-lg-5">
            <div class="help-card" id="section-bills">
                <h4 class="section-title mb-1">
                    <i class="fa-solid fa-file-invoice-dollar text-success"></i> Reservations, Bills & Notifications
                </h4>
                <div class="mini mb-3">How to manage your bookings after you create them.</div>

                <div class="step">
                    <div class="num"><i class="fa-solid fa-calendar-check"></i></div>
                    <div>
                        <h6>View Reservations</h6>
                        <p>Click <span class="kbd">View Reservations</span> to see your booking list and status.</p>
                    </div>
                </div>

                <div class="step">
                    <div class="num"><i class="fa-solid fa-print"></i></div>
                    <div>
                        <h6>Print Bill</h6>
                        <p>Open <span class="kbd">Print Bill</span>, select your confirmed booking, then print.</p>
                    </div>
                </div>

                <div class="step">
                    <div class="num"><i class="fa-solid fa-bell"></i></div>
                    <div>
                        <h6>Notifications</h6>
                        <p>Check the bell icon in dashboard to see new updates (confirmed/cancelled changes).</p>
                    </div>
                </div>

                <div class="tips mt-3">
                    <h6 class="fw-bold text-success mb-2"><i class="fa-solid fa-circle-check"></i> Helpful Rules</h6>
                    <ul class="mb-0">
                        <li>Always choose the correct dates (check-out must be after check-in).</li>
                        <li>Confirm booking only when details are correct.</li>
                        <li>Use refresh button if booking list doesn’t update.</li>
                    </ul>
                </div>
            </div>
        </div>

    </div>

    <!-- TROUBLESHOOTING -->
    <div class="row g-4 mt-1">
        <div class="col-lg-6">
            <div class="help-card" id="section-troubleshoot">
                <h4 class="section-title mb-2"><i class="fa-solid fa-screwdriver-wrench text-warning"></i> Troubleshooting</h4>
                <div class="mini mb-3">Common problems and quick solutions.</div>

                <div class="step">
                    <div class="num"><i class="fa-solid fa-triangle-exclamation"></i></div>
                    <div>
                        <h6>Total amount is 0</h6>
                        <p>Select a room first, then select correct dates (check-out must be after check-in).</p>
                    </div>
                </div>

                <div class="step">
                    <div class="num"><i class="fa-solid fa-calendar-xmark"></i></div>
                    <div>
                        <h6>Cannot confirm booking</h6>
                        <p>Check if any required field is empty. Re-check dates and room selection.</p>
                    </div>
                </div>

                <div class="step">
                    <div class="num"><i class="fa-solid fa-wifi"></i></div>
                    <div>
                        <h6>Booking not saving</h6>
                        <p>Try refreshing. If still fails, it may be DB connection issue—inform staff/admin.</p>
                    </div>
                </div>

                <div class="issues mt-3">
                    <h6 class="fw-bold text-danger mb-2"><i class="fa-solid fa-circle-exclamation"></i> Important</h6>
                    <ul class="mb-0">
                        <li>Do not use invalid contact numbers.</li>
                        <li>Do not select same date for check-in and check-out.</li>
                        <li>If error repeats, logout and login again.</li>
                    </ul>
                </div>
            </div>
        </div>

        <!-- FAQ -->
        <div class="col-lg-6">
            <div class="help-card faq" id="section-faq">
                <h4 class="section-title mb-2"><i class="fa-solid fa-circle-info text-warning"></i> FAQ</h4>
                <div class="mini mb-3">Frequently asked questions by customers.</div>

                <div class="accordion" id="faqAccUser">

                    <div class="accordion-item">
                        <h2 class="accordion-header" id="uq1">
                            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#ua1">
                                Why is total amount not calculating?
                            </button>
                        </h2>
                        <div id="ua1" class="accordion-collapse collapse" data-bs-parent="#faqAccUser">
                            <div class="accordion-body">
                                Select a room first, then select both dates. Check-out must be after check-in.
                            </div>
                        </div>
                    </div>

                    <div class="accordion-item">
                        <h2 class="accordion-header" id="uq2">
                            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#ua2">
                                Where can I see my booking status?
                            </button>
                        </h2>
                        <div id="ua2" class="accordion-collapse collapse" data-bs-parent="#faqAccUser">
                            <div class="accordion-body">
                                Open <b>View Reservations</b>. You will see CONFIRMED / PENDING / CANCELLED.
                            </div>
                        </div>
                    </div>

                    <div class="accordion-item">
                        <h2 class="accordion-header" id="uq3">
                            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#ua3">
                                Can I change dates after booking?
                            </button>
                        </h2>
                        <div id="ua3" class="accordion-collapse collapse" data-bs-parent="#faqAccUser">
                            <div class="accordion-body">
                                If your system supports editing, staff can help. Otherwise you can cancel and create a new booking.
                            </div>
                        </div>
                    </div>

                    <div class="accordion-item">
                        <h2 class="accordion-header" id="uq4">
                            <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#ua4">
                                Why I can’t see new booking in the list?
                            </button>
                        </h2>
                        <div id="ua4" class="accordion-collapse collapse" data-bs-parent="#faqAccUser">
                            <div class="accordion-body">
                                Click Refresh button on booking page. If still not visible, logout/login and try again.
                            </div>
                        </div>
                    </div>

                </div>

            </div>
        </div>
    </div>

    <!-- FOOTER -->
    <div class="text-center text-muted footer-line">
        <small>Ocean View Resort • User Help Page • Designed for easy booking</small>
    </div>

</div>

<script>
    // Simple scroll-to-first-match (front-end only, no backend)
    function scrollToFirstMatch(){
        const q = (document.getElementById("helpSearch").value || "").toLowerCase().trim();
        if(!q){
            alert("Type something to search (example: booking, bill, dates)");
            return;
        }

        const sections = [
            document.getElementById("section-booking"),
            document.getElementById("section-bills"),
            document.getElementById("section-troubleshoot"),
            document.getElementById("section-faq")
        ];

        for(const s of sections){
            if(!s) continue;
            const text = (s.innerText || "").toLowerCase();
            if(text.includes(q)){
                s.scrollIntoView({behavior:"smooth", block:"start"});
                return;
            }
        }

        alert("No matching help section found. Try another word.");
    }
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>