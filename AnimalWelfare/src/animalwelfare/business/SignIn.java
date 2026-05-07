/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package animalwelfare.business;


import javax.swing.JOptionPane;
import animalwelfare.access.PersonOperations;
import animalwelfare.security.Hash;
import animalwelfare.security.Session;

/**
 *
 * @author carlo
 */
public class SignIn {
   
    // revisamos las credenciales del usuario con respecto a la base de datos y si estan llenas
    public boolean CheckUser(String userName, String password){
        // restricciones
        if (userName.isBlank()){
            JOptionPane.showMessageDialog(null, "Username cannot be empty..");
            return false;
        }
        if (password.isBlank()){
            JOptionPane.showMessageDialog(null, "Password cannot be empty..");
            return false;
        }
        String hashedPassword;
        hashedPassword = PersonOperations.CheckUser(userName);
        
        if (hashedPassword == null){
            JOptionPane.showMessageDialog(null, "Incorrect username or password.");
            return false;
        }

        if (Hash.ComparePassword(password,hashedPassword)){
            JOptionPane.showMessageDialog(null, "Sign in successful.");
            // Set the user ID and role in the session
            Session session = Session.getInstance();
            session.setUserId(PersonOperations.GetUserId(userName));
            session.setRole(PersonOperations.GetUserRole(session.getUserId()));
            JOptionPane.showMessageDialog(null, "User: " + session.getUserId() + " Role: " + session.getRole());
            return true;
        }
        JOptionPane.showMessageDialog(null, "Incorrect username or password.");
        return false;
    }
}
