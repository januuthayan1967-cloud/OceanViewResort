<%@ page contentType="text/html;charset=UTF-8" language="java" session="true" %>
<%@ page import="com.oceanview.model.User" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>

<%
    User staff = (User) session.getAttribute("loggedUser");
    if (staff == null || !"STAFF".equalsIgnoreCase(staff.getRole())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    String today = new SimpleDateFormat("EEEE, MMMM d, yyyy").format(new Date());

    // ✅ Change this if your staff dashboard path is different
    String backUrl = request.getContextPath() + "/StaffDashboard";
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Staff Help - Ocean View Resort</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <!-- Bootstrap + FontAwesome -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

    <style>
        body{
            background: radial-gradient(circle at 10% 10%, #ecfff5 0%, #f4f6f9 35%, #eef3ff 100%);
            font-family: 'Poppins', sans-serif;
        }

        .hero{
            background: linear-gradient(135deg,#0f5132,#198754,#2fbf71);
            color:#fff;
            border-radius: 26px;
            padding: 26px;
            box-shadow: 0 16px 45px rgba(0,0,0,.14);
            position: relative;
            overflow: hidden;
        }
        .hero .icon-bg{
            position:absolute;
            right:-15px;
            bottom:-22px;
            font-size: 120px;
            opacity: .14;
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
            background: rgba(255,255,255,.72);
            border: 1px solid rgba(255,255,255,.55);
            backdrop-filter: blur(8px);
            border-radius: 22px;
            box-shadow: 0 10px 26px rgba(0,0,0,.06);
        }

        .section-title{
            font-weight: 900;
            color: #14532d;
        }

        .mini{
            color:#6c757d;
            font-size: .92rem;
        }

        .quick-card{
            background:#fff;
            border-radius: 20px;
            padding: 16px;
            border: 1px solid rgba(0,0,0,.06);
            box-shadow: 0 10px 22px rgba(0,0,0,.06);
            height:100%;
            transition: .18s ease;
        }
        .quick-card:hover{ transform: translateY(-3px); }

        .quick-icon{
            width:46px;
            height:46px;
            border-radius: 16px;
            display:flex;
            align-items:center;
            justify-content:center;
            background: rgba(25,135,84,.12);
            color:#198754;
            font-size: 1.25rem;
            margin-bottom: 10px;
        }

        .help-card{
            background:#fff;
            border-radius: 22px;
            padding: 18px;
            border: 1px solid rgba(0,0,0,.06);
            box-shadow: 0 10px 22px rgba(0,0,0,.06);
            height:100%;
        }

        .step{
            display:flex;
            gap:12px;
            padding: 12px;
            border-radius: 18px;
            background: #f4fff8;
            border: 1px solid rgba(25,135,84,.12);
            margin-bottom: 10px;
        }
        .step .num{
            width:40px;height:40px;
            border-radius: 14px;
            display:flex;align-items:center;justify-content:center;
            font-weight:900;color:#fff;background:#198754;
            flex: 0 0 auto;
        }
        .step h6{ margin:0; font-weight:900; }
        .step p{ margin:0; color:#6c757d; font-size:.92rem; }

        .kbd{
            font-family: ui-monospace, SFMono-Regular, Menlo, Monaco, Consolas, "Liberation Mono","Courier New", monospace;
            background:#111827; color:#fff; padding:2px 8px; border-radius:8px; font-size:.85rem;
        }

        .dos{
            background: #f8fbff;
            border: 1px solid rgba(13,110,253,.10);
            border-radius: 18px;
            padding: 14px;
        }
        .donts{
            background: #fff5f5;
            border: 1px solid rgba(220,53,69,.16);
            border-radius: 18px;
            padding: 14px;
        }

        .faq .accordion-button{ font-weight:800; }
        .faq .accordion-item{
            border-radius: 16px;
            overflow: hidden;
            border:1px solid rgba(0,0,0,.06);
            box-shadow: 0 8px 18px rgba(0,0,0,.05);
            margin-bottom: 12px;
        }

        .badge-soft{
            background: rgba(25,135,84,.12);
            color:#14532d;
            border:1px solid rgba(25,135,84,.18);
            border-radius: 999px;
            padding: 4px 10px;
            font-weight: 800;
            font-size: .82rem;
        }
    </style>
</head>

<body>

<div class="container my-4">

    <!-- HERO -->
    <div class="hero mb-4">
        <div class="d-flex justify-content-between align-items-start flex-wrap gap-2">
            <div>
                <h2 class="mb-1">Staff Help Center</h2>
                <p class="mb-2">
                    Step-by-step guidelines for new staff members to manage <b>reservations</b>, <b>confirmations</b>,
                    and customer support in the Ocean View Resort system.
                </p>

                <span class="chip"><i class="fa-solid fa-user-tie"></i> <b><%= staff.getUsername() %></b></span>
                <span class="chip ms-2"><i class="fa-solid fa-calendar"></i> <%= today %></span>
                <span class="chip ms-2"><i class="fa-solid fa-shield-halved"></i> Role: STAFF</span>
            </div>

            <a class="btn btn-light fw-bold" style="border-radius:14px;"
               href="<%= backUrl %>">
                <i class="fa-solid fa-arrow-left"></i> Back
            </a>
        </div>

        <i class="fa-solid fa-circle-question icon-bg"></i>
    </div>

    <!-- QUICK OVERVIEW -->
    <div class="glass p-3 mb-4">
        <div class="row g-3">
            <div class="col-md-4">
                <div class="quick-card">
                    <div class="quick-icon"><i class="fa-solid fa-calendar-plus"></i></div>
                    <h6 class="fw-bold mb-1">Create Reservation</h6>
                    <div class="mini">Add a new reservation for walk-in guests or phone bookings.</div>
                    <div class="mt-2"><span class="badge-soft">Accuracy matters</span></div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="quick-card">
                    <div class="quick-icon"><i class="fa-solid fa-circle-check"></i></div>
                    <h6 class="fw-bold mb-1">Confirm & Update Status</h6>
                    <div class="mini">Confirm after verification/payment and keep the system up-to-date.</div>
                    <div class="mt-2"><span class="badge-soft">CONFIRMED / CANCELLED</span></div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="quick-card">
                    <div class="quick-icon"><i class="fa-solid fa-headset"></i></div>
                    <h6 class="fw-bold mb-1">Customer Support</h6>
                    <div class="mini">Assist customers with booking issues, date corrections, and guidance.</div>
                    <div class="mt-2"><span class="badge-soft">Be polite + clear</span></div>
                </div>
            </div>
        </div>
    </div>

    <!-- MAIN GUIDES -->
    <div class="row g-4">

        <!-- CREATE RESERVATION -->
        <div class="col-lg-6">
            <div class="help-card">
                <h4 class="section-title mb-1">
                    <i class="fa-solid fa-calendar-plus text-success"></i> Create a Reservation (Staff)
                </h4>
                <div class="mini mb-3">
                    Use this when a guest books at the reception, by phone, or needs staff assistance.
                </div>

                <div class="step">
                    <div class="num">1</div>
                    <div>
                        <h6>Login as Staff</h6>
                        <p>Login using staff credentials to access staff reservation pages.</p>
                    </div>
                </div>

                <div class="step">
                    <div class="num">2</div>
                    <div>
                        <h6>Open Add Reservation</h6>
                        <p>Go to the <span class="kbd">Add Reservation</span> page from staff menu.</p>
                    </div>
                </div>

                <div class="step">
                    <div class="num">3</div>
                    <div>
                        <h6>Enter Guest Details Correctly</h6>
                        <p>Fill guest name, phone number, and address. Always confirm contact number with the guest.</p>
                    </div>
                </div>

                <div class="step">
                    <div class="num">4</div>
                    <div>
                        <h6>Select Room Type & Dates</h6>
                        <p>Choose correct room type. Check-in and check-out dates must be correct.</p>
                    </div>
                </div>

                <div class="step">
                    <div class="num">5</div>
                    <div>
                        <h6>Save Reservation</h6>
                        <p>Click save. The reservation will store in the database and appear in the staff list.</p>
                    </div>
                </div>

                <div class="alert alert-info mt-3 mb-0" style="border-radius:16px;">
                    <i class="fa-solid fa-lightbulb"></i>
                    Best practice: Repeat booking details to the guest before saving (room + dates + contact).
                </div>
            </div>
        </div>

        <!-- CONFIRM & MANAGE -->
        <div class="col-lg-6">
            <div class="help-card">
                <h4 class="section-title mb-1">
                    <i class="fa-solid fa-clipboard-check text-success"></i> Confirm, Cancel & Manage
                </h4>
                <div class="mini mb-3">
                    Use this to keep reservation status updated and notify customers correctly.
                </div>

                <div class="step">
                    <div class="num">1</div>
                    <div>
                        <h6>Open Reservation List</h6>
                        <p>Go to reservation list to see all reservations sorted by latest.</p>
                    </div>
                </div>

                <div class="step">
                    <div class="num">2</div>
                    <div>
                        <h6>Confirm Reservation</h6>
                        <p>After verification/payment, update status to <b>CONFIRMED</b>.</p>
                    </div>
                </div>

                <div class="step">
                    <div class="num">3</div>
                    <div>
                        <h6>Cancel Reservation</h6>
                        <p>If guest requests cancellation, update status to <b>CANCELLED</b> and inform them.</p>
                    </div>
                </div>

                <div class="step">
                    <div class="num">4</div>
                    <div>
                        <h6>Handle Corrections</h6>
                        <p>If dates/room type is wrong, correct it immediately (or cancel and recreate if your flow requires).</p>
                    </div>
                </div>

                <div class="alert alert-warning mt-3 mb-0" style="border-radius:16px;">
                    <i class="fa-solid fa-shield-halved"></i>
                    Staff Rule: Never confirm if room type or dates are incorrect. Fix first, then confirm.
                </div>
            </div>
        </div>

    </div>

    <!-- DOs & DON'Ts + Troubleshooting -->
    <div class="row g-4 mt-1">
        <div class="col-lg-6">
            <div class="help-card">
                <h4 class="section-title mb-2"><i class="fa-solid fa-thumbs-up text-primary"></i> Do & Don’t (Staff)</h4>

                <div class="dos mb-3">
                    <h6 class="fw-bold mb-2 text-primary">✅ DO</h6>
                    <ul class="mb-0">
                        <li>Confirm phone number with the guest before saving.</li>
                        <li>Check that check-out date is after check-in date.</li>
                        <li>Confirm only after verification/payment.</li>
                        <li>Keep status updated so dashboard notifications are correct.</li>
                    </ul>
                </div>

                <div class="donts">
                    <h6 class="fw-bold mb-2 text-danger">❌ DON’T</h6>
                    <ul class="mb-0">
                        <li>Don’t confirm a booking with wrong dates or wrong room type.</li>
                        <li>Don’t leave bookings in PENDING for a long time (update status).</li>
                        <li>Don’t enter fake guest data—system records will become incorrect.</li>
                    </ul>
                </div>
            </div>
        </div>

        <div class="col-lg-6">
            <div class="help-card">
                <h4 class="section-title mb-2"><i class="fa-solid fa-screwdriver-wrench text-warning"></i> Troubleshooting</h4>
                <div class="mini mb-3">Common issues and quick solutions for staff.</div>

                <div class="step">
                    <div class="num"><i class="fa-solid fa-triangle-exclamation"></i></div>
                    <div>
                        <h6>“All fields are required” error</h6>
                        <p>Some input is empty. Re-check guest name, phone, address, dates, and room type.</p>
                    </div>
                </div>

                <div class="step">
                    <div class="num"><i class="fa-solid fa-calendar-xmark"></i></div>
                    <div>
                        <h6>Date validation issue</h6>
                        <p>Check-out must be after check-in. Select correct dates again.</p>
                    </div>
                </div>

                <div class="step">
                    <div class="num"><i class="fa-solid fa-database"></i></div>
                    <div>
                        <h6>Reservation not saving</h6>
                        <p>Check DB connection and table fields. Ensure reservationNumber is unique.</p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- FAQ -->
    <div class="mt-4 faq">
        <h4 class="section-title mb-3"><i class="fa-solid fa-circle-info text-warning"></i> FAQ (Staff)</h4>

        <div class="accordion" id="faqAccStaff">

            <div class="accordion-item">
                <h2 class="accordion-header" id="sq1">
                    <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#sa1">
                        What should I check before confirming a booking?
                    </button>
                </h2>
                <div id="sa1" class="accordion-collapse collapse" data-bs-parent="#faqAccStaff">
                    <div class="accordion-body">
                        Verify guest details (name + phone), correct room type, correct dates, and payment/approval.
                        Then set status as <b>CONFIRMED</b>.
                    </div>
                </div>
            </div>

            <div class="accordion-item">
                <h2 class="accordion-header" id="sq2">
                    <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#sa2">
                        What if the customer entered wrong dates or wrong room type?
                    </button>
                </h2>
                <div id="sa2" class="accordion-collapse collapse" data-bs-parent="#faqAccStaff">
                    <div class="accordion-body">
                        Update reservation details if your system allows editing. Otherwise, cancel the old record and create a new reservation
                        with correct details (follow your staff workflow).
                    </div>
                </div>
            </div>

            <div class="accordion-item">
                <h2 class="accordion-header" id="sq3">
                    <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#sa3">
                        Why does a reservation show as PENDING?
                    </button>
                </h2>
                <div id="sa3" class="accordion-collapse collapse" data-bs-parent="#faqAccStaff">
                    <div class="accordion-body">
                        PENDING means not yet confirmed. After verification/payment, update status to CONFIRMED.
                    </div>
                </div>
            </div>

            <div class="accordion-item">
                <h2 class="accordion-header" id="sq4">
                    <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#sa4">
                        How do notifications work?
                    </button>
                </h2>
                <div id="sa4" class="accordion-collapse collapse" data-bs-parent="#faqAccStaff">
                    <div class="accordion-body">
                        When status changes (CONFIRMED/CANCELLED), the system can create notifications for the user.
                        Keeping statuses correct ensures the notification bell shows accurate updates.
                    </div>
                </div>
            </div>

        </div>
    </div>

    <div class="text-center text-muted mt-4">
        <small>Ocean View Resort • Staff Help Page</small>
    </div>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>