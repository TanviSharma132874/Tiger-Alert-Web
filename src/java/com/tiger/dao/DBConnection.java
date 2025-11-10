package com.tiger.dao;
import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {
    private static Connection conn;

    public static Connection getConnection() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/tiger_alert",
                "root",
                ""   // ✅ EMPTY PASSWORD
            );
        } catch (Exception e) {
            e.printStackTrace();
        }
        return conn;
    }
}
