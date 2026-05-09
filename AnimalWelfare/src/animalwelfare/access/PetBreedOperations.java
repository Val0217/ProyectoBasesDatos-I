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
public class PetBreedOperations {
    public static ArrayList<DbObject> listPetBreed() {
        ArrayList<DbObject> listPetBreed = new ArrayList(); //creamos una lista para guardar los resultados.

        try {
            String SQL = "{ ? = call fn_get_pet_breed_all() }";
            Connection con = ConexionOracle.connect();
            CallableStatement cs = con.prepareCall(SQL);

            cs.registerOutParameter(1, OracleTypes.CURSOR);
            cs.execute();
            ResultSet res = (ResultSet) cs.getObject(1);

            while (res.next()) {

                listPetBreed.add(new DbObject(
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

        return listPetBreed;
    }

    public static ArrayList<DbObject> listPetBreedByPetType(int petTypeId) {
        ArrayList<DbObject> listPetBreed = new ArrayList(); //creamos una lista para guardar los resultados.

        try {
            String SQL = "{ ? = call fn_get_pet_breed_by_PetType(?) }";
            Connection con = ConexionOracle.connect();
            CallableStatement cs = con.prepareCall(SQL);

            cs.registerOutParameter(1, OracleTypes.CURSOR);
            cs.setInt(2, petTypeId);
            cs.execute();
            ResultSet res = (ResultSet) cs.getObject(1);

            while (res.next()) {

                listPetBreed.add(new DbObject(
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

        return listPetBreed;
    }
    
}

