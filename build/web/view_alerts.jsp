<%@ page import="java.sql.*" %>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>View Alerts - Tiger Alert System</title>

  <!-- ✅ Bootstrap -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

  <style>
    body, html {
      margin: 0;
      padding: 0;
      height: 100%;
      color: #fff;
      font-family: 'Poppins', sans-serif;
      overflow-x: hidden;
      background: #000;
    }

    /* 🎥 Background video */
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
      background: rgba(0, 0, 0, 0.85);
      border-bottom: 2px solid #d4af37;
    }

    .navbar-brand {
      font-weight: 700;
      color: #d4af37 !important;
      letter-spacing: 0.5px;
    }

    /* 📊 Dashboard Header */
    .header-row {
      display: flex;
      justify-content: space-between;
      align-items: center;
      padding: 30px 50px 20px;
    }

    .header-row h1 {
      font-weight: 700;
      color: #d4af37;
      margin: 0;
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

    /* 🟡 Alert Cards Section */
    .cards-row {
      display: flex;
      flex-wrap: wrap;
      justify-content: center;
      gap: 20px;
      padding: 10px 40px 30px;
    }

    .alert-card {
      width: 260px;
      background: rgba(255,255,255,0.1);
      border-radius: 15px;
      padding: 15px 20px;
      box-shadow: 0 0 15px rgba(0,0,0,0.5);
      backdrop-filter: blur(10px);
      transition: all 0.3s ease;
    }

    .alert-card:hover {
      transform: translateY(-5px) scale(1.03);
      box-shadow: 0 0 20px rgba(212,175,55,0.4);
    }

    .card-head {
      display: flex;
      justify-content: space-between;
      align-items: center;
      font-size: 1rem;
      font-weight: 600;
    }

    .card-body {
      margin: 8px 0;
      font-size: 0.95rem;
    }

    .card-foot {
      text-align: right;
      font-size: 0.8rem;
      color: #ccc;
    }

    /* 🟥 Level Colors */
    .card-high { border-left: 5px solid #ff4444; }
    .card-medium { border-left: 5px solid #ffcc00; }
    .card-low { border-left: 5px solid #00c851; }

    .badge-level {
      background: rgba(255,255,255,0.2);
      padding: 2px 10px;
      border-radius: 12px;
      font-size: 0.8rem;
    }

    /* 📋 Data Table */
    .table-wrap {
      width: 90%;
      margin: 0 auto 40px;
      background: rgba(0, 0, 0, 0.65);
      border-radius: 15px;
      padding: 20px;
      backdrop-filter: blur(10px);
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

    @media (max-width: 768px) {
      .header-row {
        flex-direction: column;
        text-align: center;
        gap: 15px;
      }
      .cards-row {
        padding: 10px 20px;
      }
      .alert-card {
        width: 90%;
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

  <!-- 🟡 Dashboard Content -->
  <div class="container-fluid mt-3">
    <div class="header-row">
      <h1>Alerts Dashboard</h1>
      <a class="btn-small" href="add_alert.jsp">+ New Alert</a>
    </div>

    <div class="cards-row">
      <% 
        try {
          Class.forName("com.mysql.cj.jdbc.Driver");
          Connection conn = com.tiger.dao.DBConnection.getConnection();
          Statement st = conn.createStatement();
          ResultSet rsCards = st.executeQuery("SELECT id, camera_id, level, message, created_at FROM alerts ORDER BY id DESC LIMIT 6");

          while (rsCards.next()) {
              String level = rsCards.getString("level");
              String levelClass = "card-low";
              if ("High".equalsIgnoreCase(level)) levelClass = "card-high";
              else if ("Medium".equalsIgnoreCase(level)) levelClass = "card-medium";
      %>
      <div class="alert-card <%= levelClass %>">
        <div class="card-head">
          <strong>Cam #<%= rsCards.getString("camera_id") %></strong>
          <span class="badge-level"><%= level %></span>
        </div>
        <div class="card-body"><%= rsCards.getString("message") %></div>
        <div class="card-foot"><small><%= rsCards.getTimestamp("created_at") %></small></div>
      </div>
      <% 
          }
        } catch (Exception e) {
          out.println("<div style='color:#fff;text-align:center;'>Error: " + e.getMessage() + "</div>");
        }
      %>
    </div>

    <!-- 📋 Table Section -->
    <div class="table-wrap">
      <table class="data-table">
        <thead>
          <tr>
            <th>ID</th>
            <th>Camera</th>
            <th>Level</th>
            <th>Message</th>
            <th>Time</th>
          </tr>
        </thead>
        <tbody>
          <%
            try {
              Connection conn2 = com.tiger.dao.DBConnection.getConnection();
              Statement st2 = conn2.createStatement();
              ResultSet rs = st2.executeQuery("SELECT id, camera_id, level, message, created_at FROM alerts ORDER BY id DESC");
              while (rs.next()) {
          %>
          <tr>
            <td><%= rs.getInt("id") %></td>
            <td><%= rs.getString("camera_id") %></td>
            <td><%= rs.getString("level") %></td>
            <td><%= rs.getString("message") %></td>
            <td><%= rs.getTimestamp("created_at") %></td>
          </tr>
          <%
              }
            } catch (Exception e) {
              out.println("<tr><td colspan='5' style='color:white;'>Error: " + e.getMessage() + "</td></tr>");
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
