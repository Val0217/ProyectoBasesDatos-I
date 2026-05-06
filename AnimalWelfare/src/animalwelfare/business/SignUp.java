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
    
    private CountryOperations access;
    private SignUpForm view;

    // esto se ejecuta cuando lo creamos
    public SignUp(SignUpForm view) {
        this.view = view;
        this.access = new CountryOperations();

        view.fillCountry(access.listCountry());
    }
    
    // para entregar las Provincias
    public void FillProvince(SignUpForm view, int IdCountry) {
        this.view = view;
        this.access = new CountryOperations();

        view.fillProvince(access.listProvince(IdCountry));
    }
    
    // para entregar los cantones
    public void FillCanton(SignUpForm view, int IdProvince) {
        this.view = view;
        this.access = new CountryOperations();

        view.fillCanton(access.listCanton(IdProvince));
    }
    
    //para entregar los distritos
    public void FillDistrict(SignUpForm view, int IdCanton) {
        this.view = view;
        this.access = new CountryOperations();

        view.fillDistrict(access.listDistrict(IdCanton));
    }
    
    public void InsertPerson(String Email,String FirstName, String LastName, String Password, String UserName, int IdDistrict, int PhoneNumber){
        PersonOperations personAccess = new PersonOperations();
        personAccess.Insert(Email, FirstName, LastName, Password, UserName, IdDistrict, PhoneNumber);
    }
    
}
