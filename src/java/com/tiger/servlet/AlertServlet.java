package com.tiger.servlet;

import com.tiger.dao.DBConnection;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

//@WebServlet("/AlertServlet")
public class AlertServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String cameraId = request.getParameter("cameraId");
        String level = request.getParameter("level");
        String message = request.getParameter("message");

        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(
                "INSERT INTO alerts(camera_id, level, message) VALUES (?, ?, ?)"
            );
            ps.setString(1, cameraId);
            ps.setString(2, level);
            ps.setString(3, message);
            int r = ps.executeUpdate();

            if (r > 0) {
                response.sendRedirect("view_alerts.jsp");
            } else {
                response.getWriter().println("Insert failed. <a href='add_alert.jsp'>Back</a>");
            }
        } catch (Exception e) {
            e.printStackTrace(response.getWriter());
        }
    }
}
