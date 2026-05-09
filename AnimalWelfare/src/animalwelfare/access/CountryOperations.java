/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package animalwelfare.access;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.CallableStatement;
import java.util.ArrayList;
import javax.swing.JOptionPane;
import oracle.jdbc.OracleTypes;


/**
 *
 * @author carlo
 */
public class CountryOperations {
    // funcion para traer todos los paises
    public static ArrayList<DbObject> listCountry() {
        ArrayList<DbObject> listCountry = new ArrayList(); //creamos una lista para guardar los resultados.

        try {
            String SQL = "{ ? = call fn_get_country_all() }";
            Connection con = ConexionOracle.connect();
            CallableStatement cs = con.prepareCall(SQL);

            cs.registerOutParameter(1, OracleTypes.CURSOR);
            cs.execute();
            ResultSet res = (ResultSet) cs.getObject(1);

            while (res.next()) {

                listCountry.add(new DbObject(
                    res.getInt("Id"),
                    res.getString("Name")
                ));
            }

            res.close();
            cs.close();
            con.close();

        } catch (SQLException e) {
            JOptionPane.showMessageDialog(null, "Error: " + e.getMessage()); //lanzar mensaje de error, esperemos que no se lanze nunca
        }

        return listCountry;
    }
    
    // funcion para traer las provincias asociadas a un Pais
    public static ArrayList<DbObject> listProvince(int IdCountry) {
        ArrayList<DbObject> listProvince = new ArrayList(); //creamos una lista para guardar los resultados.

        try {
            String SQL = "{ ? = call fn_get_province_by_country(?) }";
            Connection con = ConexionOracle.connect();
            CallableStatement cs = con.prepareCall(SQL);

            cs.registerOutParameter(1, OracleTypes.CURSOR);
            cs.setInt(2, IdCountry);
            cs.execute();
            ResultSet res = (ResultSet) cs.getObject(1);

            while (res.next()) {

                listProvince.add(new DbObject(
                    res.getInt("Id"),
                    res.getString("Name")
                ));
            }

            res.close();
            cs.close();
            con.close();

        } catch (SQLException e) {
            JOptionPane.showMessageDialog(null, "Error: " + e.getMessage()); //lanzar mensaje de error, esperemos que no se lanze nunca
        }

        return listProvince;
    }
    
    // funcion para traer los cantones asociados a una provincia
    public static ArrayList<DbObject> listCanton(int IdProvince) {
        ArrayList<DbObject> listCanton = new ArrayList(); //creamos una lista para guardar los resultados.

        try {
            String SQL = "{ ? = call fn_get_canton_by_province(?) }";
            Connection con = ConexionOracle.connect();
            CallableStatement cs = con.prepareCall(SQL);

            cs.registerOutParameter(1, OracleTypes.CURSOR);
            cs.setInt(2, IdProvince);
            cs.execute();
            ResultSet res = (ResultSet) cs.getObject(1);

            while (res.next()) {

                listCanton.add(new DbObject(
                    res.getInt("Id"),
                    res.getString("Name")
                ));
            }

            res.close();
            cs.close();
            con.close();

        } catch (SQLException e) {
            JOptionPane.showMessageDialog(null, "Error: " + e.getMessage()); //lanzar mensaje de error, esperemos que no se lanze nunca
        }

        return listCanton;
    }

    // funcion para traer los distritos asociados a una canton
    public static ArrayList<DbObject> listDistrict(int IdCanton) {
        ArrayList<DbObject> listDistrict = new ArrayList(); //creamos una lista para guardar los resultados.

        try {
            String SQL = "{ ? = call fn_get_districts_by_canton(?) }";

            Connection con = ConexionOracle.connect();

            CallableStatement cs = con.prepareCall(SQL);

            cs.registerOutParameter(1, OracleTypes.CURSOR);
            cs.setInt(2, IdCanton);

            cs.execute();

            ResultSet res = (ResultSet) cs.getObject(1);

            while (res.next()) {

                listDistrict.add(new DbObject(
                    res.getInt("Id"),
                    res.getString("Name")
                ));
            }

            res.close();
            cs.close();
            con.close();

        } catch (SQLException e) {
            JOptionPane.showMessageDialog(null, "Error: " + e.getMessage()); //lanzar mensaje de error, esperemos que no se lanze nunca
        }

        return listDistrict;
    }
    
}
