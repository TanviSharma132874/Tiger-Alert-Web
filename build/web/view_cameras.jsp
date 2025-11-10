<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Registered Cameras - Tiger Alert System</title>

  <!-- ✅ Bootstrap -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

  <style>
    body, html {
      margin: 0;
      padding: 0;
      height: 100%;
      color: #fff;
      font-family: 'Poppins', sans-serif;
      background: #000;
      overflow-x: hidden;
    }

    /* 🎥 Background */
    #bg-video {
      position: fixed;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      object-fit: cover;
      z-index: -1;
      filter: brightness(65%);
    }

    .overlay {
      position: fixed;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      background: rgba(0,0,0,0.6);
      z-index: -1;
    }

    /* 🌟 Navbar */
    .navbar {
      background: rgba(0,0,0,0.85);
      border-bottom: 2px solid #d4af37;
    }

    .navbar-brand {
      font-weight: 700;
      color: #d4af37 !important;
      letter-spacing: 0.5px;
    }

    /* 📸 Header Section */
    .header-row {
      display: flex;
      justify-content: space-between;
      align-items: center;
      padding: 30px 50px 20px;
    }

    .header-row h1 {
      color: #d4af37;
      font-weight: 700;
    }

    .btn-small {
      background: linear-gradient(45deg, #d4af37, #c49b31);
      border: none;
      padding: 10px 20px;
      border-radius: 25px;
      font-weight: 600;
      color: #000;
      transition: all 0.3s ease;
      text-decoration: none;
    }

    .btn-small:hover {
      background: #fff;
      transform: scale(1.05);
    }

    /* 📋 Table Section */
    .table-wrap {
      width: 90%;
      margin: 0 auto 40px;
      background: rgba(0, 0, 0, 0.65);
      border-radius: 15px;
      padding: 20px;
      backdrop-filter: blur(10px);
      box-shadow: 0 0 25px rgba(0,0,0,0.4);
    }

    .data-table {
      width: 100%;
      color: #fff;
      border-collapse: collapse;
      text-align: center;
    }

    .data-table th {
      background: rgba(212,175,55,0.25);
      color: #fff;
      font-weight: 600;
      padding: 12px;
      border-bottom: 2px solid #d4af37;
    }

    .data-table td {
      padding: 10px;
      border-bottom: 1px solid rgba(255,255,255,0.2);
    }

    .data-table tr:hover {
      background: rgba(255,255,255,0.1);
      transition: 0.2s ease;
    }

    /* 🔙 Back Button */
    .back-home {
      text-align: center;
      margin-bottom: 40px;
    }

    .btn-custom {
      background: linear-gradient(45deg, #d4af37, #c49b31);
      border: none;
      padding: 12px 28px;
      border-radius: 30px;
      color: #000;
      font-weight: 600;
      text-decoration: none;
      transition: all 0.3s ease;
    }

    .btn-custom:hover {
      background: #fff;
      transform: scale(1.05);
    }

    /* Responsive */
    @media (max-width: 768px) {
      .header-row {
        flex-direction: column;
        gap: 15px;
        text-align: center;
      }
    }
  </style>
</head>

<body>

  <!-- 🎥 Background -->
  <video autoplay muted loop id="bg-video">
    <source src="images/video.mp4" type="video/mp4">
  </video>
  <div class="overlay"></div>

  <!-- 🌟 Navbar -->
  <nav class="navbar navbar-expand-lg navbar-dark px-3">
    <a class="navbar-brand d-flex align-items-center" href="index.html">
      <img src="images/logo.png" alt="Logo" width="45" height="45" class="me-2">
      Tiger Alert System
    </a>
  </nav>

  <!-- 📸 Camera Dashboard -->
  <div class="container-fluid mt-3">
    <div class="header-row">
      <h1>Registered Cameras</h1>
      <a class="btn-small" href="add_camera.jsp">+ New Camera</a>
    </div>

    <!-- 📋 Table Section -->
    <div class="table-wrap">
      <table class="data-table">
        <thead>
          <tr>
            <th>ID</th>
            <th>Location</th>
            <th>Latitude</th>
            <th>Longitude</th>
          </tr>
        </thead>
        <tbody>
        <%
          try {
            Connection conn = com.tiger.dao.DBConnection.getConnection();
            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery("SELECT id, location, latitude, longitude FROM cameras ORDER BY id DESC");
            while (rs.next()) {
        %>
          <tr>
            <td><%= rs.getInt("id") %></td>
            <td><%= rs.getString("location") %></td>
            <td><%= rs.getString("latitude") %></td>
            <td><%= rs.getString("longitude") %></td>
          </tr>
        <%
            }
          } catch (Exception e) {
            out.println("<tr><td colspan='4' style='color:white;'>Error: " + e.getMessage() + "</td></tr>");
          }
        %>
        </tbody>
      </table>
    </div>

    <div class="back-home">
      <a href="index.html" class="btn-custom">⬅ Back to Home</a>
    </div>
  </div>

  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
