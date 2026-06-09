/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

package animalwelfare.access;
import java.sql.*;
/**
 *
 * @author valer
 */
public class ConexionMariaDB {
     static String url="jdbc:mysql://localhost:3306/welfare";
    static String user="root";
   static String pass="123";
    
    public static Connection conectar()
    {
       Connection con=null;
       try
       {
       con=DriverManager.getConnection(url,user,pass);
       }catch(SQLException e)
       {
        e.printStackTrace();
       }
       
       return con;
               
    }
}
