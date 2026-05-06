/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package animalwelfare.business;
// esto es lo que maneja
import animalwelfare.access.CountryOperations;
import animalwelfare.access.PersonOperations;
import animalwelfare.userInterface.SignUpForm;
import animalwelfare.security.Hash;

/**
 *
 * @author carlo
 */
public class SignUp {
    
    // para obtener los datos de ubicacion
    private CountryOperations access;

    // esto se ejecuta cuando lo creamos
    public SignUp(SignUpForm view) {
        this.access = new CountryOperations();

        view.fillCountry(access.listCountry());
    }
    
    // para enviar las Provincias a la view
    public void FillProvince(SignUpForm view, int IdCountry) {
        view.fillProvince(access.listProvince(IdCountry));
    }
    
    // para enviar los Cantones a la view
    public void FillCanton(SignUpForm view, int IdProvince) {
        view.fillCanton(access.listCanton(IdProvince));
    }
    
    // para enviar los Distritos a la view
    public void FillDistrict(SignUpForm view, int IdCanton) {
        view.fillDistrict(access.listDistrict(IdCanton));
    }
    
    // Funcion que inserta los datos de una persona en la base de datos, ademas se comunica con seguridad para encryptar la contraseña.
    public boolean InsertPerson(String Email,String FirstName, String LastName, String Password, String UserName, int IdDistrict, int PhoneNumber){
        return PersonOperations.Insert(Email, FirstName, LastName, Hash.EncryptPassword(Password), UserName, IdDistrict, PhoneNumber);
    }
    
}
