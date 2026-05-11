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
        String sql = "{ ? = call fn_get_country_all() }";
 
        try (Connection con = ConexionOracle.connect();
             CallableStatement cs = con.prepareCall(sql)) {
 
            cs.registerOutParameter(1, oracle.jdbc.OracleTypes.CURSOR);
            cs.execute();
 
            try (ResultSet rs = (ResultSet) cs.getObject(1)) {
                while (rs.next()) {
                    list.add(new DbObject(rs.getInt("Id"), rs.getString("Name")));
                }
            }
        }
        return list;
    }
 

    public List<DbObject> getProvincesByCountry(int idCountry) throws SQLException {
        List<DbObject> list = new ArrayList<>();
        String sql = "{ ? = call fn_get_province_by_country(?) }";
 
        try (Connection con = ConexionOracle.connect();
             CallableStatement cs = con.prepareCall(sql)) {
 
            cs.registerOutParameter(1, oracle.jdbc.OracleTypes.CURSOR);
            cs.setInt(2, idCountry);
            cs.execute();
 
            try (ResultSet rs = (ResultSet) cs.getObject(1)) {
                while (rs.next()) {
                    list.add(new DbObject(rs.getInt("Id"), rs.getString("Name")));
                }
            }
        }
        return list;
    }
 

    public List<DbObject> getCantonsByProvince(int idProvince) throws SQLException {
        List<DbObject> list = new ArrayList<>();
        String sql = "{ ? = call fn_get_canton_by_province(?) }";
 
        try (Connection con = ConexionOracle.connect();
             CallableStatement cs = con.prepareCall(sql)) {
 
            cs.registerOutParameter(1, oracle.jdbc.OracleTypes.CURSOR);
            cs.setInt(2, idProvince);
            cs.execute();
 
            try (ResultSet rs = (ResultSet) cs.getObject(1)) {
                while (rs.next()) {
                    list.add(new DbObject(rs.getInt("Id"), rs.getString("Name")));
                }
            }
        }
        return list;
    }
 

    public List<DbObject> getDistrictsByCanton(int idCanton) throws SQLException {
        List<DbObject> list = new ArrayList<>();
        String sql = "{ ? = call fn_get_districts_by_canton(?) }";
 
        try (Connection con = ConexionOracle.connect();
             CallableStatement cs = con.prepareCall(sql)) {
 
            cs.registerOutParameter(1, oracle.jdbc.OracleTypes.CURSOR);
            cs.setInt(2, idCanton);
            cs.execute();
 
            try (ResultSet rs = (ResultSet) cs.getObject(1)) {
                while (rs.next()) {
                    list.add(new DbObject(rs.getInt("Id"), rs.getString("Name")));
                }
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
 
        try (Connection con = ConexionOracle.connect();
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
