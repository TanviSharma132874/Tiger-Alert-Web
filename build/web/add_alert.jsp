<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Issue Alert - Tiger Alert System</title>

    <!-- ✅ Bootstrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        body, html {
            height: 100%;
            margin: 0;
            font-family: 'Poppins', sans-serif;
            overflow: hidden;
            color: #fff;
        }

       /* 🎥 Background video or image */
#bg-video {
  position: fixed;
  top: 0; 
  left: 0;
  width: 100%; 
  height: 100%;
  object-fit: cover;
  z-index: -2;
  filter: blur(5px) brightness(55%) contrast(105%);
  transform: scale(1.03);
}

.alert-overlay {
  position: fixed;
  top: 0; 
  left: 0;
  width: 100%; 
  height: 100%;
  background: rgba(0, 0, 0, 0.55);
  z-index: -1;
}


        /* 🌟 Navbar */
        .navbar {
            background: rgba(0, 0, 0, 0.85);
            border-bottom: 2px solid #d4af37;
        }
        .navbar-brand {
            font-weight: 700;
            color: #d4af37 !important;
        }

        /* 🧭 Layout */
        .alert-wrapper {
            height: calc(100vh - 70px);
            display: flex;
            flex-direction: row;
            justify-content: center;
            align-items: center;
            padding: 40px;
        }

        .alert-left {
            flex: 1;
            text-align: left;
            padding: 40px;
        }

        .alert-title {
            font-size: 2.6rem;
            font-weight: 700;
            color: #d4af37;
            text-shadow: 0 0 10px #000;
        }

        .alert-text {
            font-size: 1.1rem;
            margin-top: 15px;
            line-height: 1.6;
            opacity: 0.9;
        }

        /* 🧾 Form Card */
        .glass-card {
            flex: 1;
            background: rgba(255, 255, 255, 0.1);
            border-radius: 15px;
            padding: 40px;
            box-shadow: 0 0 25px rgba(0,0,0,0.5);
            backdrop-filter: blur(8px);
        }

        .input-field, select {
            width: 100%;
            padding: 12px 15px;
            margin-bottom: 18px;
            border-radius: 8px;
            border: none;
            outline: none;
            font-size: 1rem;
            background: rgba(255, 255, 255, 0.8);
            color: #000;
        }

        .btn-alert-submit {
            width: 100%;
            padding: 14px;
            border: none;
            border-radius: 30px;
            background: linear-gradient(45deg, #d4af37, #c49b31);
            font-weight: 600;
            color: #000;
            transition: all 0.3s;
        }

        .btn-alert-submit:hover {
            background: #fff;
            transform: scale(1.05);
        }

        .back-home {
            display: inline-block;
            margin-top: 18px;
            color: #d4af37;
            text-decoration: none;
        }

        .back-home:hover {
            color: #fff;
            text-decoration: underline;
        }

        @media (max-width: 992px) {
            .alert-wrapper {
                flex-direction: column;
                padding: 20px;
                text-align: center;
            }
            .alert-left, .glass-card {
                width: 100%;
                padding: 25px;
            }
            .alert-left { order: 2; }
        }
    </style>
</head>

<body>

    <!-- 🎬 Background -->
    <video autoplay muted loop id="bg-video">
        <source src="images/video.mp4" type="video/mp4">
    </video>
    <!-- Or replace with image:
    <div class="alert-overlay" style="background:url('images/image3.jpg') no-repeat center center/cover;"></div>
    -->

    <!-- 🌟 Navbar -->
    <nav class="navbar navbar-expand-lg navbar-dark px-3">
        <a class="navbar-brand d-flex align-items-center" href="index.html">
            <img src="images/logo.png" width="45" height="45" class="me-2" alt="Logo">
            Tiger Alert System
        </a>
    </nav>

    <!-- 🐅 Main Section -->
    <div class="alert-wrapper">
        <div class="alert-left">
            <h1 class="alert-title">🚨 Issue Tiger Alert</h1>
            <p class="alert-text">
                When danger is detected, every second matters.<br>
                Alert the forest team and ensure human-wildlife safety instantly.
            </p>
        </div>

        <div class="alert-right glass-card">
            <form action="AlertServlet" method="post" class="alert-form">

                <input class="input-field" type="text" name="cameraId" placeholder="Camera ID (e.g., 1)" required>

                <select class="input-field" name="level" required>
                    <option value="">-- Select Alert Level --</option>
                    <option>Low</option>
                    <option>Medium</option>
                    <option>High</option>
                </select>

                <input class="input-field" type="text" name="message"
                    placeholder="Alert Message (short description)" required>

                <button class="btn-alert-submit" type="submit">Submit Alert</button>

                <a class="back-home" href="index.html">⬅ Back to Home</a>
            </form>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
