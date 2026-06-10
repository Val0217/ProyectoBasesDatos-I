/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package animalwelfare.access;
 
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author valer
 */
public class VetFormOperations {
 

    public List<DbObject> getCountries() throws SQLException {
        List<DbObject> list = new ArrayList<>();
        String sql = "{ call pr_get_country_all() }";
 
        try (Connection con = ConexionMariaDB.conectar();
             CallableStatement cs = con.prepareCall(sql)) {
 
            ResultSet rs = cs.executeQuery();
 
            while (rs.next()) {
                list.add(new DbObject(rs.getInt("Id"), rs.getString("Name")));
            }
            
        }
        return list;
    }
 

    public List<DbObject> getProvincesByCountry(int idCountry) throws SQLException {
        List<DbObject> list = new ArrayList<>();
        String sql = "{ call pr_get_province_by_country(?) }";
 
        try (Connection con = ConexionMariaDB.conectar();
             CallableStatement cs = con.prepareCall(sql)) {
 
            
            cs.setInt(1, idCountry);
            ResultSet rs = cs.executeQuery();
            
            while (rs.next()) {
                list.add(new DbObject(rs.getInt("Id"), rs.getString("Name")));
            }
            
        }
        return list;
    }
 

    public List<DbObject> getCantonsByProvince(int idProvince) throws SQLException {
        List<DbObject> list = new ArrayList<>();
        String sql = "{ call pr_get_canton_by_province(?) }";
 
        try (Connection con = ConexionMariaDB.conectar();
             CallableStatement cs = con.prepareCall(sql)) {
 
            cs.setInt(1, idProvince);
            ResultSet rs = cs.executeQuery();
            while (rs.next()) {
                list.add(new DbObject(rs.getInt("Id"), rs.getString("Name")));
            }
            
        }
        return list;
    }
 

    public List<DbObject> getDistrictsByCanton(int idCanton) throws SQLException {
        List<DbObject> list = new ArrayList<>();
        String sql = "{ call pr_get_districts_by_canton(?) }";
 
        try (Connection con = ConexionMariaDB.conectar();
             CallableStatement cs = con.prepareCall(sql)) {
 
            cs.setInt(1, idCanton);
            ResultSet rs = cs.executeQuery();
            while (rs.next()) {
                list.add(new DbObject(rs.getInt("Id"), rs.getString("Name")));
            }
            
        }
        return list;
    }
    public int registerVeterinarian(String firstName,
                                    String lastName,
                                    String clinicName,
                                    long   phone,
                                    String email,
                                    String location,
                                    int    idDistrict) throws SQLException {
 
        String sql = "{ call pr_register_veterinarian(?,?,?,?,?,?,?,?) }";
 
        try (Connection con = ConexionMariaDB.conectar();
             CallableStatement cs = con.prepareCall(sql)) {
 
            cs.setString(1, firstName);
            cs.setString(2, lastName);
            cs.setString(3, clinicName);
            cs.setLong  (4, phone);
 
            if (email == null || email.trim().isEmpty()) {
                cs.setNull(5, Types.VARCHAR);
            } else {
                cs.setString(5, email.trim());
            }
 
            cs.setString(6, location);
            cs.setInt   (7, idDistrict);
            cs.registerOutParameter(8, Types.NUMERIC);
 
            cs.execute();
            return cs.getInt(8);
        }
    }
}
