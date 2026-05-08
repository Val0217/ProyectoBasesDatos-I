/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package animalwelfare.access;

import java.sql.Connection;
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

            // Creamos la consulta SQL para insertar una nueva persona utilizando el procedimiento insertPerson
            String SQL = "BEGIN pr_insert_person('"+FirstName+"','"+LastName+"','"+Email+"','"+Password+"','"+UserName+"',"+IdDistrict+","+PhoneNumber+"); END;";
            
            Statement cn = con.createStatement(); // esto es para poder ejecutar consultas
            cn.execute(SQL); // ejecutamos el query
            

            cn.close();
            con.close();
            
            return true;

        } catch (SQLException e) {
            JOptionPane.showMessageDialog(null, "Error: " + e.getMessage());
            return false;
        }
        
    }
    
    // obtenemos si el usuario existe o no y en caso de que exista devuelve la password
    // esta forma de crear la consulta viene de https://docs.oracle.com/javase/tutorial/jdbc/basics/storedprocedures.html
    public static String CheckUser(String userName) {
        String password = null;

        try {
            try (Connection con = ConexionOracle.connect(); CallableStatement cs = con.prepareCall("{ ? = call pr_get_person_Pass(?) }")) {
                
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

    // obtenemos el ID del usuario para poder usarlo en la session
    public static int GetUserId(String userName) {
        int userId = -1;

        try {
            // Conexión a la base de datos
            try (Connection con = ConexionOracle.connect(); CallableStatement cs = con.prepareCall("{ ? = call pr_get_person_id(?) }")) {
                
                // Parámetro de retorno
                cs.registerOutParameter(1, java.sql.Types.INTEGER);
                
                // Parámetro de entrada
                cs.setString(2, userName);
                
                cs.execute();
                
                // Obtener resultado
                userId = cs.getInt(1);
                
            }

        } catch (SQLException e) {
            JOptionPane.showMessageDialog(null, "Error: " + e.getMessage());
        }

        return userId;
    }

    // obtenemos el rol del usuario para poder usarlo en la session
    public static String GetUserRole(int userId) {
        String role = null;

        try {
            // Usamos un CallableStatement para llamar a la función almacenada en la base de datos que devuelve el rol del usuario
            try (Connection con = ConexionOracle.connect(); CallableStatement cs = con.prepareCall("{ ? = call pr_get_person_role(?) }")) {
                
                // Parámetro de retorno
                cs.registerOutParameter(1, java.sql.Types.VARCHAR);
                
                // Parámetro de entrada
                cs.setInt(2, userId);
                
                cs.execute();
                
                // Obtener resultado
                role = cs.getString(1);
                
            }

        } catch (SQLException e) {
            JOptionPane.showMessageDialog(null, "Error: " + e.getMessage());
        }

        return role;
    }
    
}
