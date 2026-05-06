/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package animalwelfare.access;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.CallableStatement;
import javax.swing.JOptionPane;
/**
 *
 * @author carlo
 */
public class PersonOperations {
    public static boolean Insert(String Email,String FirstName, String LastName, String Password, String UserName, int IdDistrict, int PhoneNumber){
        try {
            Connection con = ConexionOracle.connect();

            String SQL = "BEGIN insertPerson('"+FirstName+"','"+LastName+"','"+Email+"','"+Password+"','"+UserName+"',"+IdDistrict+","+PhoneNumber+"); END;";
            
            Statement cn = con.createStatement(); // esto es para poder ejecutar consultas
            cn.execute(SQL); // ejecutamos el query
            

            cn.close();
            con.close();
            
            JOptionPane.showMessageDialog(null, "User created successfully.");
            return true;

        } catch (SQLException e) {
            JOptionPane.showMessageDialog(null, "Error: " + e.getMessage());
            return false;
        }
        
    }
    
    // obtenemos si el usuario existe o no y en caso de que exista devuelve la password
    public static String CheckUser(String userName) {
        String password = null;

        try {
            try (Connection con = ConexionOracle.connect(); CallableStatement cs = con.prepareCall("{ ? = call getPersonPass(?) }")) {
                
                // Parámetro de retorno
                cs.registerOutParameter(1, java.sql.Types.VARCHAR);
                
                // Parámetro de entrada
                cs.setString(2, userName);
                
                cs.execute();
                
                // Obtener resultado
                password = cs.getString(1);
                
            }

        } catch (SQLException e) {
            JOptionPane.showMessageDialog(null, "Error: " + e.getMessage());
        }

        return password;
    }
    
}
