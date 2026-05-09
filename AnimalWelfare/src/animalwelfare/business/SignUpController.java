/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package animalwelfare.business;
// esto es lo que maneja
import animalwelfare.access.CountryOperations;
import animalwelfare.access.DbObject;
import animalwelfare.access.PersonOperations;
import animalwelfare.userInterface.SignUpForm;
import animalwelfare.security.Hash;
import javax.swing.JOptionPane;

/**
 *
 * @author carlo
 */
public class SignUpController {
    

    // esto se ejecuta cuando lo creamos
    public SignUpController(SignUpForm view) {

        view.fillCountry(CountryOperations.listCountry());
    }
    
    // para enviar las Provincias a la view
    public void FillProvince(SignUpForm view, int IdCountry) {
        view.fillProvince(CountryOperations.listProvince(IdCountry));
    }
    
    // para enviar los Cantones a la view
    public void FillCanton(SignUpForm view, int IdProvince) {
        view.fillCanton(CountryOperations.listCanton(IdProvince));
    }
    
    // para enviar los Distritos a la view
    public void FillDistrict(SignUpForm view, int IdCanton) {
        view.fillDistrict(CountryOperations.listDistrict(IdCanton));
    }
    
    // Funcion que inserta los datos de una persona en la base de datos, ademas se comunica con seguridad para encryptar la contraseña.
    public boolean InsertPerson(String Email,String FirstName, String LastName, String Password, String rePassword, String UserName, DbObject District, String PhoneNumber){
        // restricciones de validacion de datos
        if(Email.isEmpty() || FirstName.isEmpty() || LastName.isEmpty() || Password.isEmpty() || UserName.isEmpty() || PhoneNumber.isEmpty()){
            JOptionPane.showMessageDialog(null, "All fields are required.");
            return false;
        }
        if (District == null || District.getId() == 0) {
            JOptionPane.showMessageDialog(null, "Please select a district.");
            return false;
        }
        if (!Password.equals(rePassword)){
            JOptionPane.showMessageDialog(null, "Passwords do not match.");
            return false;
        }
        if (PhoneNumber.length() > 8 || PhoneNumber.length() < 8){
            JOptionPane.showMessageDialog(null, "Phone number must have exactly 8 digits.");
            return false;
        }
        if(!Email.contains("@") || Email.startsWith("@") || Email.endsWith("@") || !Email.contains(".com") && !Email.contains(".net") && !Email.contains(".org")){
            JOptionPane.showMessageDialog(null, "Invalid email format. (example: user@example.com)");
            return false;
        }
        if(PhoneNumber.matches(".*[a-zA-Z]+.*")){
            JOptionPane.showMessageDialog(null, "Phone number must contain only digits.");
            return false;
        }
        // se llama a la funcion de insertar persona, ademas se encrypta la contraseña antes de enviarla a la base de datos
        if (PersonOperations.Insert(Email.trim(), FirstName, LastName, Hash.EncryptPassword(Password.trim()), UserName, District.getId(), Integer.parseInt(PhoneNumber))){
            JOptionPane.showMessageDialog(null, "User created successfully.");
            return true;
        }
        return false;
    }
    
}
