/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package bienestaranimal.access;

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
    public void Insert(String Email,String FirstName, String LastName, String Password, int IdDistrict){
        try {
            Connection con = ConexionOracle.connect();

            String SQL = "INSERT INTO Person (Id, FirstName, LastName, Password, IdDistrict) VALUES (s_Person.NEXTVAL, '"+FirstName+"',  '"+LastName+"', '"+Password+"', "+IdDistrict+")";
            
            Statement cn = con.createStatement(); // esto es para poder ejecutar consultas
            ResultSet res = cn.executeQuery(SQL); // ejecutamos el query
            

            cn.close();
            con.close();
            
            JOptionPane.showMessageDialog(null, "User created successfully.");

        } catch (SQLException e) {
            JOptionPane.showMessageDialog(null, "Error: " + e.getMessage());
        }
        
    }
    
}
