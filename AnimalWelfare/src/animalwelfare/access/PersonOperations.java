/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package animalwelfare.access;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import javax.swing.JOptionPane;
/**
 *
 * @author carlo
 */
public class PersonOperations {
    public void Insert(String Email,String FirstName, String LastName, String Password, String UserName, int IdDistrict, int PhoneNumber){
        try {
            Connection con = ConexionOracle.connect();

            String SQL = "BEGIN insertPerson('"+FirstName+"','"+LastName+"','"+Email+"','"+Password+"','"+UserName+"',"+IdDistrict+","+PhoneNumber+"); END;";
            
            Statement cn = con.createStatement(); // esto es para poder ejecutar consultas
            cn.execute(SQL); // ejecutamos el query
            

            cn.close();
            con.close();
            
            JOptionPane.showMessageDialog(null, "User created successfully.");

        } catch (SQLException e) {
            JOptionPane.showMessageDialog(null, "Error: " + e.getMessage());
        }
        
    }
    
}
