<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Ocean View Resort - Welcome</title>

  <!-- Bootstrap CSS -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
  <!-- Font Awesome -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
  <!-- Google Font -->
  <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600;700&display=swap" rel="stylesheet" />

  <style>
    :root{
      --glass: rgba(255,255,255,.14);
      --glass2: rgba(255,255,255,.08);
      --border: rgba(255,255,255,.22);
      --shadow: 0 26px 60px rgba(0,0,0,.35);
      --primary1:#00c6ff;
      --primary2:#0072ff;
      --green1:#00b09b;
      --green2:#96c93d;
    }

    * { font-family: 'Poppins', sans-serif; }
    html, body { height: 100%; }

    body{
      height: 100vh;              /* ✅ FULL SCREEN */
      margin: 0;
      overflow: hidden;           /* ✅ NO SCROLL */
      color: #fff;
      background:
        radial-gradient(1200px 700px at 10% 10%, rgba(0,198,255,.35), transparent 55%),
        radial-gradient(900px 600px at 90% 20%, rgba(0,114,255,.30), transparent 55%),
        radial-gradient(900px 600px at 40% 95%, rgba(150,201,61,.20), transparent 55%),
        url("https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1950&q=80")
        no-repeat center center / cover;
      position: relative;
    }

    /* Dark overlay */
    body::before{
      content:"";
      position:absolute; inset:0;
      background: linear-gradient(120deg, rgba(0,0,0,.55), rgba(0,0,0,.25));
      backdrop-filter: blur(2px);
      z-index: 0;
    }

    /* Animated light */
    .aurora{
      position:absolute; inset:-30%;
      background: conic-gradient(
        from 180deg,
        rgba(0,198,255,.22),
        rgba(0,114,255,.18),
        rgba(150,201,61,.16),
        rgba(0,198,255,.22)
      );
      filter: blur(70px);
      animation: spin 14s linear infinite;
      opacity: .55;
      z-index: 0;
    }
    @keyframes spin { to { transform: rotate(360deg); } }

    /* Bubbles */
    .bubble{
      position:absolute;
      width: 120px; height: 120px;
      border-radius: 50%;
      background: radial-gradient(circle at 30% 30%, rgba(255,255,255,.35), rgba(255,255,255,.05));
      border: 1px solid rgba(255,255,255,.18);
      animation: floaty 7s ease-in-out infinite;
      z-index: 0;
      opacity: .85;
    }
    .b1{ top: 10%; left: 8%; transform: scale(.9); }
    .b2{ top: 66%; left: 12%; width: 100px; height: 100px; animation-delay: 1.2s; opacity: .7;}
    .b3{ top: 16%; right: 10%; width: 150px; height: 150px; animation-delay: .9s; opacity: .65;}
    .b4{ bottom: 8%; right: 14%; width: 110px; height: 110px; animation-delay: 1.6s; opacity: .75;}
    @keyframes floaty{
      0%,100%{ transform: translateY(0) }
      50%{ transform: translateY(-12px) }
    }

    /* ✅ Center full screen */
    .wrap{
      position: relative;
      z-index: 1;
      height: 100vh;              /* ✅ */
      display:flex;
      align-items:center;
      justify-content:center;     /* ✅ */
      padding: 0;                 /* ✅ */
    }

    /* ✅ Slightly smaller card to fit */
    .glass{
      background: linear-gradient(180deg, var(--glass), var(--glass2));
      border: 1px solid var(--border);
      box-shadow: var(--shadow);
      border-radius: 24px;
      padding: 26px 26px;         /* ✅ reduced */
      backdrop-filter: blur(14px);
      -webkit-backdrop-filter: blur(14px);
      animation: pop 550ms ease-out;
    }
    @keyframes pop{
      from{ opacity: 0; transform: translateY(14px) scale(.99); }
      to{ opacity: 1; transform: translateY(0) scale(1); }
    }

    .brand{
      display:flex;
      gap: 12px;
      align-items:center;
      justify-content:center;
      margin-bottom: 8px;
    }

    .logoMark{
      width: 48px; height: 48px;       /* ✅ smaller */
      border-radius: 16px;
      background: linear-gradient(45deg, rgba(0,198,255,.95), rgba(0,114,255,.95));
      box-shadow: 0 10px 22px rgba(0,114,255,.32);
      display:grid; place-items:center;
      border: 1px solid rgba(255,255,255,.22);
    }
    .logoMark i{ font-size: 20px; }

    h1{
      font-weight: 700;
      letter-spacing: .5px;
      font-size: 2.05rem;          /* ✅ fixed smaller */
      margin: 0;
      text-shadow: 0 10px 26px rgba(0,0,0,.35);
    }

    .tagline{
      font-size: .95rem;           /* ✅ smaller */
      opacity: .92;
      margin: 4px 0 14px 0;
      text-shadow: 0 8px 22px rgba(0,0,0,.35);
    }

    /* ✅ Smaller chips */
    .chips{
      display:flex;
      flex-wrap: wrap;
      gap: 8px;
      justify-content:center;
      margin-bottom: 14px;
    }
    .chip{
      padding: 6px 10px;           /* ✅ smaller */
      border-radius: 999px;
      background: rgba(255,255,255,.10);
      border: 1px solid rgba(255,255,255,.18);
      font-size: .82rem;
      color: rgba(255,255,255,.92);
      line-height: 1.1;
    }
    .chip i{ margin-right: 6px; opacity: .95; }

    /* ✅ Smaller buttons */
    .btnXL{
      border: none;
      border-radius: 999px;
      padding: 10px 14px;          /* ✅ smaller */
      font-weight: 600;
      width: 100%;
      display:flex;
      gap: 10px;
      align-items:center;
      justify-content:center;
      transition: transform .2s ease, box-shadow .2s ease, filter .2s ease;
      text-decoration:none;
      user-select:none;
      font-size: .98rem;
    }
    .btnXL:active{ transform: translateY(1px) scale(.99); }

    .btnLogin{
      color: #fff;
      background: linear-gradient(45deg, var(--primary1), var(--primary2));
      box-shadow: 0 14px 28px rgba(0,114,255,.30);
    }
    .btnRegister{
      color: #fff;
      background: linear-gradient(45deg, var(--green1), var(--green2));
      box-shadow: 0 14px 28px rgba(0,176,155,.26);
    }
    .btnHelp{
      color: #fff;
      background: rgba(255,255,255,.12);
      border: 1px solid rgba(255,255,255,.22);
      box-shadow: 0 14px 28px rgba(0,0,0,.16);
    }
    .btnXL:hover{ transform: translateY(-2px); filter: brightness(1.05); }

    /* ✅ Smaller divider */
    .divider{
      height: 1px;
      background: rgba(255,255,255,.18);
      margin: 14px 0;             /* ✅ smaller */
    }

    /* ✅ Smaller features */
    .features{
      display:grid;
      grid-template-columns: repeat(3, 1fr);
      gap: 10px;
      margin-top: 4px;
    }
    .feature{
      background: rgba(255,255,255,.10);
      border: 1px solid rgba(255,255,255,.16);
      border-radius: 16px;
      padding: 10px 8px;          /* ✅ smaller */
      text-align:center;
    }
    .feature i{ font-size: 16px; margin-bottom: 4px; opacity: .95; }
    .feature .t{ font-weight: 600; font-size: .88rem; margin: 0; }
    .feature .s{ font-size: .76rem; opacity: .85; margin: 2px 0 0 0; }

    .footerNote{
      margin-top: 12px;
      font-size: .78rem;          /* ✅ smaller */
      opacity: .78;
      text-align:center;
    }

    /* ✅ Extra compact for small phones */
    @media (max-width: 576px){
      body{ overflow: hidden; }
      .glass{ padding: 18px 16px; border-radius: 20px; }
      h1{ font-size: 1.7rem; }
      .tagline{ font-size: .9rem; margin-bottom: 10px; }
      .features{ grid-template-columns: 1fr; }
      .chip{ font-size: .78rem; }
      .btnXL{ padding: 9px 12px; font-size: .95rem; }
      .divider{ margin: 10px 0; }
      .bubble{ display:none; } /* hide bubbles in very small screens */
    }
  </style>
</head>

<body>
  <div class="aurora"></div>
  <div class="bubble b1"></div>
  <div class="bubble b2"></div>
  <div class="bubble b3"></div>
  <div class="bubble b4"></div>

  <div class="wrap">
    <div class="container">
      <div class="row justify-content-center">
        <div class="col-12 col-md-9 col-lg-6 col-xl-5">
          <div class="glass">
            <div class="brand">
              <div class="logoMark">
                <i class="fa-solid fa-umbrella-beach"></i>
              </div>
              <div>
                <h1>Ocean View Resort</h1>
                <div class="tagline"><i class="fa-solid fa-water me-2"></i>Your gateway to paradise</div>
              </div>
            </div>

            <div class="chips">
              <div class="chip"><i class="fa-solid fa-wifi"></i>Free Wi-Fi</div>
              <div class="chip"><i class="fa-solid fa-mug-hot"></i>Breakfast</div>
              <div class="chip"><i class="fa-solid fa-person-swimming"></i>Pool</div>
              <div class="chip"><i class="fa-solid fa-spa"></i>Spa</div>
            </div>

            <div class="d-grid gap-2">
              <a href="login.jsp" class="btnXL btnLogin">
                <i class="fa-solid fa-right-to-bracket"></i> Login
              </a>
              <a href="register.jsp" class="btnXL btnRegister">
                <i class="fa-solid fa-user-plus"></i> Register
              </a>
              <a href="help.jsp" class="btnXL btnHelp">
                <i class="fa-solid fa-circle-question"></i> Help
              </a>
            </div>

            <div class="divider"></div>

            <div class="features">
              <div class="feature">
                <i class="fa-solid fa-location-dot"></i>
                <p class="t">Beachfront</p>
                <p class="s">Ocean views</p>
              </div>
              <div class="feature">
                <i class="fa-solid fa-shield-heart"></i>
                <p class="t">Secure</p>
                <p class="s">Safe stay</p>
              </div>
              <div class="feature">
                <i class="fa-solid fa-star"></i>
                <p class="t">Premium</p>
                <p class="s">Luxury rooms</p>
              </div>
            </div>

            <div class="footerNote">
              <i class="fa-regular fa-copyright me-1"></i>
              <span id="y"></span> Ocean View Resort • All rights reserved
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>

  <script>
    document.getElementById("y").innerText = new Date().getFullYear();
  </script>
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>