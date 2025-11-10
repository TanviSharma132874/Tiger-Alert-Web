package com.tiger.model;

import java.sql.Timestamp;

public class Alert {
    private int id;
    private int cameraId;
    private String message;
    private String level;
    private Timestamp createdAt;

    public Alert() {}

    // getters & setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public int getCameraId() { return cameraId; }
    public void setCameraId(int cameraId) { this.cameraId = cameraId; }
    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }
    public String getLevel() { return level; }
    public void setLevel(String level) { this.level = level; }
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}
