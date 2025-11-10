package com.tiger.servlet;

import com.tiger.dao.DBConnection;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import javax.servlet.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

//@WebServlet("/CameraServlet")
public class CameraServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String location = request.getParameter("location");
        String latitude = request.getParameter("latitude");
        String longitude = request.getParameter("longitude");

        try {
            Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(
                "INSERT INTO cameras(location, latitude, longitude) VALUES (?, ?, ?)"
            );
            ps.setString(1, location);
            ps.setString(2, latitude);
            ps.setString(3, longitude);
            int r = ps.executeUpdate();

            if (r > 0) {
                response.sendRedirect("view_cameras.jsp");
            } else {
                response.getWriter().println("Insert failed. <a href='add_camera.jsp'>Back</a>");
            }
        } catch (Exception e) {
            // print stacktrace to response so page is not blank; helpful during dev
            e.printStackTrace(response.getWriter());
        }
    }
}
