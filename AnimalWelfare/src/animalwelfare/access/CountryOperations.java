/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package animalwelfare.access;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import javax.swing.JOptionPane;


/**
 *
 * @author carlo
 */
public class CountryOperations {
    // funcion para traer todos los paises
    public ArrayList<DbObject> listCountry() {
        ArrayList<DbObject> listCountry = new ArrayList(); //creamos una lista para guardar los resultados.

        try {
            String SQL = "SELECT Id, Name FROM Country"; // aqui va el query
            Connection con = ConexionOracle.connect(); // nos conectamos a la base de datos
            Statement cn = con.createStatement(); // esto es para poder ejecutar consultas
            ResultSet res = cn.executeQuery(SQL); // ejecutamos el query

            // bucle para recorrer el resultado del query
            while (res.next()) {
                // aqui guardamos los datos en un objeto llamado location en la lista de paises
                listCountry.add(new DbObject(
                    res.getInt("Id"),
                    res.getString("Name")
                ));
            }
            
            con.close();
            cn.close();

        } catch (SQLException e) {
            JOptionPane.showMessageDialog(null, "Error: " + e.getMessage()); //lanzar mensaje de error, esperemos que no se lanze nunca
        }

        return listCountry;
    }
    
    // funcion para traer las provincias asociadas a un Pais
    public ArrayList<DbObject> listProvince(int IdCountry) {
        ArrayList<DbObject> listProvince = new ArrayList(); //creamos una lista para guardar los resultados.

        try {
            String SQL = "SELECT Id, Name FROM Province WHERE IdCountry = " + IdCountry; // aqui va el query
            Connection con = ConexionOracle.connect(); // nos conectamos a la base de datos
            Statement cn = con.createStatement(); // esto es para poder ejecutar consultas
            ResultSet res = cn.executeQuery(SQL); // ejecutamos el query

            // bucle para recorrer el resultado del query
            while (res.next()) {
                // aqui guardamos los datos en un objeto llamado location en la lista de paises
                listProvince.add(new DbObject(
                    res.getInt("Id"),
                    res.getString("Name")
                ));
            }
            
            con.close();
            cn.close();

        } catch (SQLException e) {
            JOptionPane.showMessageDialog(null, "Error: " + e.getMessage()); //lanzar mensaje de error, esperemos que no se lanze nunca
        }

        return listProvince;
    }
    
    // funcion para traer los cantones asociados a una provincia
    public ArrayList<DbObject> listCanton(int IdProvince) {
        ArrayList<DbObject> listCanton = new ArrayList(); //creamos una lista para guardar los resultados.

        try {
            String SQL = "SELECT Id, Name FROM Canton WHERE IdProvince = " + IdProvince; // aqui va el query
            Connection con = ConexionOracle.connect(); // nos conectamos a la base de datos
            Statement cn = con.createStatement(); // esto es para poder ejecutar consultas
            ResultSet res = cn.executeQuery(SQL); // ejecutamos el query

            // bucle para recorrer el resultado del query
            while (res.next()) {
                // aqui guardamos los datos en un objeto llamado location en la lista de paises
                listCanton.add(new DbObject(
                    res.getInt("Id"),
                    res.getString("Name")
                ));
            }
            
            con.close();
            cn.close();

        } catch (SQLException e) {
            JOptionPane.showMessageDialog(null, "Error: " + e.getMessage()); //lanzar mensaje de error, esperemos que no se lanze nunca
        }

        return listCanton;
    }

    // funcion para traer los distritos asociados a una canton
    public ArrayList<DbObject> listDistrict(int IdCanton) {
        ArrayList<DbObject> listDistrict = new ArrayList(); //creamos una lista para guardar los resultados.

        try {
            String SQL = "SELECT Id, Name FROM District WHERE IdCanton = " + IdCanton; // aqui va el query
            Connection con = ConexionOracle.connect(); // nos conectamos a la base de datos
            Statement cn = con.createStatement(); // esto es para poder ejecutar consultas
            ResultSet res = cn.executeQuery(SQL); // ejecutamos el query

            // bucle para recorrer el resultado del query
            while (res.next()) {
                // aqui guardamos los datos en un objeto llamado location en la lista de paises
                listDistrict.add(new DbObject(
                    res.getInt("Id"),
                    res.getString("Name")
                ));
            }
            
            con.close();
            cn.close();

        } catch (SQLException e) {
            JOptionPane.showMessageDialog(null, "Error: " + e.getMessage()); //lanzar mensaje de error, esperemos que no se lanze nunca
        }

        return listDistrict;
    }
    
}
