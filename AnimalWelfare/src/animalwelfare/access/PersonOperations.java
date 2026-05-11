/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package animalwelfare.access;

import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.CallableStatement;
import java.util.ArrayList;
import javax.swing.JOptionPane;
import oracle.jdbc.OracleTypes;
import java.sql.*;
import java.util.ArrayList;
import javax.swing.JOptionPane;
import javax.swing.table.DefaultTableModel;
import oracle.jdbc.OracleTypes;
import javax.swing.DefaultListModel;

/**
 *
 * @author carlo
 */
public class PersonOperations {
    public static int Insert(String FirstName, String LastName, String Password, String UserName, int IdDistrict) {
        int idPerson = -1;

        String sql = "{ call pr_insert_person(?, ?, ?, ?, ?, ?) }";

        try (Connection con = ConexionOracle.connect();
             CallableStatement cs = con.prepareCall(sql)) {

            cs.setString(1, FirstName);
            cs.setString(2, LastName);
            cs.setString(3, Password);
            cs.setString(4, UserName);
            cs.setInt(5, IdDistrict);

            cs.registerOutParameter(6, java.sql.Types.INTEGER);

            cs.execute();

            idPerson = cs.getInt(6);

        } catch (SQLException e) {
            JOptionPane.showMessageDialog(null, "Error inserting person: " + e.getMessage());
        }

        return idPerson;
    }

    // obtenemos si el usuario existe o no y en caso de que exista devuelve la password
    // esta forma de crear la consulta viene de https://docs.oracle.com/javase/tutorial/jdbc/basics/storedprocedures.html
    public static String CheckUser(String userName) {
        String password = null;

        try {
            try (Connection con = ConexionOracle.connect(); CallableStatement cs = con.prepareCall("{ ? = call fn_get_person_Password(?) }")) {
                
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
            try (Connection con = ConexionOracle.connect(); CallableStatement cs = con.prepareCall("{ ? = call fn_get_person_id(?) }")) {
                
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
            try (Connection con = ConexionOracle.connect(); CallableStatement cs = con.prepareCall("{ ? = call fn_is_admin(?) }")) {
                
                // Parámetro de retorno
                cs.registerOutParameter(1, java.sql.Types.INTEGER);
                
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


    public static ArrayList<String> getPersonPhones(int personId) {
        ArrayList<String> phones = new ArrayList<>();

        try (Connection con = ConexionOracle.connect();CallableStatement cs = con.prepareCall("{ ? = call fn_get_phone_by_person_id(?) }")) {

            cs.registerOutParameter(1, oracle.jdbc.OracleTypes.CURSOR);

            cs.setInt(2, personId);

            cs.execute();

            try (ResultSet rs = (ResultSet) cs.getObject(1)) {

                while (rs.next()) {
                    phones.add(rs.getString("Phone"));
                }

            }

        } catch (SQLException e) {
            JOptionPane.showMessageDialog(null, "Error: " + e.getMessage());
        }

        return phones;
    }


    public static ArrayList<String> getPersonEmails(int personId) {
        ArrayList<String> emails = new ArrayList<>();

        try (Connection con = ConexionOracle.connect();CallableStatement cs = con.prepareCall("{ ? = call fn_get_email_by_person_id(?) }")) {

            cs.registerOutParameter(1, oracle.jdbc.OracleTypes.CURSOR);

            cs.setInt(2, personId);

            cs.execute();

            try (ResultSet rs = (ResultSet) cs.getObject(1)) {

                while (rs.next()) {
                    emails.add(rs.getString("Email"));
                }

            }

        } catch (SQLException e) {
            JOptionPane.showMessageDialog(null, "Error: " + e.getMessage());
        }

            return emails;
        }
    public static boolean addEmailsToPerson(int idPerson, DefaultListModel<String> modelEmail) {
        String sql = "{ call ADD_EMAIL_PERSON(?, ?) }";

        try (Connection con = ConexionOracle.connect();
             CallableStatement stmt = con.prepareCall(sql)) {

            for (int i = 0; i < modelEmail.size(); i++) {
                String email = modelEmail.getElementAt(i);

                stmt.setString(1, email);
                stmt.setInt(2, idPerson);

                stmt.addBatch();
            }

            stmt.executeBatch();
            return true;

        } catch (SQLException e) {
            JOptionPane.showMessageDialog(null, "Error saving emails: " + e.getMessage());
            return false;
        }
    }
    public static boolean addPhonesToPerson(int idPerson, DefaultListModel<String> modelPhone) {
        String sql = "{ call ADD_PHONE_PERSON(?, ?) }";

        try (Connection con = ConexionOracle.connect();
             CallableStatement stmt = con.prepareCall(sql)) {

            for (int i = 0; i < modelPhone.size(); i++) {
                String phone = modelPhone.getElementAt(i);

                stmt.setString(1, phone);
                stmt.setInt(2, idPerson);

                stmt.addBatch();
            }

            stmt.executeBatch();
            return true;

        } catch (SQLException e) {
            JOptionPane.showMessageDialog(null, "Error saving phones: " + e.getMessage());
            return false;
        }
    }
}
