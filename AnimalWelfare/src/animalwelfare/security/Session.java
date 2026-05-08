/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package animalwelfare.security;

/**
 *
 * @author carlo
 */
public class Session {
    // Singleton pattern implementation
    
    private static Session instance;
    // guards the user id of the logged in user
    private int userId;
    private String role;

    // Private constructor to prevent instantiation from outside the class
    private Session() {
    }

    // Get the singleton instance of Session
    public static Session getInstance() {
        if (instance == null) {
            instance = new Session();
        }
        return instance;
    }

    // Set the user ID for the current session
    public void setUserId(int userId) {
        this.userId = userId;
        
    }

    public void setRole(String role) {
        if (role.trim().equals("0")){
            this.role = "User";
        } else if (role.trim().equals("1")){
            this.role = "Admin";
        } else {
            this.role = "Unknown";
        }
    }

    // Get the user ID for the current session
    public int getUserId() {
        return userId;
    }

    // Clear the current session
    public void clearSession() {
        userId = 0; // Clear the user ID when logging out
    }

    // Get the role for the current session
    public String getRole() {
        return role;
    }      
}
