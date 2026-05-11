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
import javax.swing.DefaultListModel;

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

    // Inserta persona, emails y telefonos
    public boolean InsertPerson(
            String FirstName,
            String LastName,
            String Password,
            String rePassword,
            String UserName,
            DbObject District,
            DefaultListModel<String> modelEmail,
            DefaultListModel<String> modelPhone
    ) {
        // restricciones de validacion de datos
        if (FirstName.isEmpty() || LastName.isEmpty() || Password.isEmpty() || UserName.isEmpty()) {
            JOptionPane.showMessageDialog(null, "All fields are required.");
            return false;
        }

        if (District == null || District.getId() == 0) {
            JOptionPane.showMessageDialog(null, "Please select a district.");
            return false;
        }

        if (!Password.equals(rePassword)) {
            JOptionPane.showMessageDialog(null, "Passwords do not match.");
            return false;
        }

        if (modelEmail == null || modelEmail.isEmpty()) {
            JOptionPane.showMessageDialog(null, "Please add at least one email.");
            return false;
        }

        if (modelPhone == null || modelPhone.isEmpty()) {
            JOptionPane.showMessageDialog(null, "Please add at least one phone number.");
            return false;
        }

        // Validar todos los emails
        for (int i = 0; i < modelEmail.size(); i++) {
            String email = modelEmail.getElementAt(i).trim();

            if (!isValidEmail(email)) {
                JOptionPane.showMessageDialog(null, "Invalid email format: " + email);
                return false;
            }
        }

        // Validar todos los telefonos
        for (int i = 0; i < modelPhone.size(); i++) {
            String phone = modelPhone.getElementAt(i).trim();

            if (!phone.matches("\\d{8}")) {
                JOptionPane.showMessageDialog(null, "Phone number must have exactly 8 digits: " + phone);
                return false;
            }
        }

        // Insertar persona primero
        int idPerson = PersonOperations.Insert(
                FirstName.trim(),
                LastName.trim(),
                Hash.EncryptPassword(Password.trim()),
                UserName.trim(),
                District.getId()
        );

        if (idPerson == -1) {
            JOptionPane.showMessageDialog(null, "Could not create user.");
            return false;
        }

        // Insertar emails
        boolean emailsSaved = PersonOperations.addEmailsToPerson(idPerson, modelEmail);

        // Insertar telefonos
        boolean phonesSaved = PersonOperations.addPhonesToPerson(idPerson, modelPhone);

        if (emailsSaved && phonesSaved) {
            JOptionPane.showMessageDialog(null, "User created successfully.");
            return true;
        }

        JOptionPane.showMessageDialog(null, "User was created, but emails or phones could not be saved.");
        return false;
    }

    private boolean isValidEmail(String email) {
        return email.contains("@")
                && !email.startsWith("@")
                && !email.endsWith("@")
                && (email.contains(".com") || email.contains(".net") || email.contains(".org"));
    }
}
