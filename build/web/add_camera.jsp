<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="UTF-8">
  <title>Add Camera - Tiger Alert System</title>

  <!-- ✅ Bootstrap -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

  <style>
    body, html {
      height: 100%;
      margin: 0;
      font-family: 'Poppins', sans-serif;
      color: #fff;
      overflow: hidden;
    }

   /* 🎬 Background */
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

.overlay {
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

    /* 📸 Form Container */
    .form-container {
      display: flex;
      justify-content: center;
      align-items: center;
      height: calc(100vh - 70px);
    }

    .form-card {
      background: rgba(255, 255, 255, 0.1);
      border-radius: 15px;
      padding: 45px;
      width: 100%;
      max-width: 500px;
      text-align: center;
      box-shadow: 0 0 25px rgba(0, 0, 0, 0.6);
      backdrop-filter: blur(8px);
    }

    .form-card h2 {
      margin-bottom: 30px;
      font-weight: 700;
      color: #d4af37;
    }

    .input-field {
      width: 100%;
      padding: 12px 15px;
      margin-bottom: 18px;
      border: none;
      border-radius: 8px;
      background: rgba(255, 255, 255, 0.85);
      color: #000;
      font-size: 1rem;
      outline: none;
    }

    .btn-custom {
      width: 100%;
      padding: 14px;
      background: linear-gradient(45deg, #d4af37, #c49b31);
      border: none;
      border-radius: 30px;
      color: #000;
      font-weight: 600;
      transition: all 0.3s ease;
    }

    .btn-custom:hover {
      background: #fff;
      transform: scale(1.05);
    }

    .link-home {
      display: inline-block;
      margin-top: 18px;
      color: #d4af37;
      text-decoration: none;
    }

    .link-home:hover {
      color: #fff;
      text-decoration: underline;
    }

    @media (max-width: 576px) {
      .form-card {
        padding: 30px;
      }
      .form-card h2 {
        font-size: 1.6rem;
      }
    }
  </style>
</head>

<body>

  <!-- 🎥 Background -->
  <video autoplay muted loop id="bg-video">
    <source src="images/video.mp4" type="video/mp4">
  </video>
  <!-- Or use an image background instead:
  <div class="overlay" style="background:url('images/image3.jpg') no-repeat center center/cover;"></div>
  -->

  <!-- 🌟 Navbar -->
  <nav class="navbar navbar-expand-lg navbar-dark px-3">
    <a class="navbar-brand d-flex align-items-center" href="index.html">
      <img src="images/logo.png" alt="Logo" width="45" height="45" class="me-2">
      Tiger Alert System
    </a>
  </nav>

  <!-- 📸 Main Form Section -->
  <div class="form-container">
    <div class="form-card">
      <h2>Add New Camera</h2>

      <form action="CameraServlet" method="post">
        <input class="input-field" type="text" name="location" placeholder="Camera Location (e.g., Gate 1)" required>
        <input class="input-field" type="text" name="latitude" placeholder="Latitude (e.g., 26.017)" required>
        <input class="input-field" type="text" name="longitude" placeholder="Longitude (e.g., 76.502)" required>
        <button class="btn-custom" type="submit">Save Camera</button>
      </form>

      <a class="link-home" href="index.html">⬅ Back to Home</a>
    </div>
  </div>

  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
