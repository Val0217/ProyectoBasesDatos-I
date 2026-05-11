package animalwelfare.business;
 
import animalwelfare.access.DbObject;
import animalwelfare.access.VetFormOperations;
 
import java.sql.SQLException;
import java.util.List;
 

public class VetFormController {
 
    private final VetFormOperations operations = new VetFormOperations();

    public List<DbObject> getCountries() throws SQLException {
        return operations.getCountries();
    }
 
    public List<DbObject> getProvincesByCountry(int idCountry) throws SQLException {
        return operations.getProvincesByCountry(idCountry);
    }
 
    public List<DbObject> getCantonsByProvince(int idProvince) throws SQLException {
        return operations.getCantonsByProvince(idProvince);
    }
 
    public List<DbObject> getDistrictsByCanton(int idCanton) throws SQLException {
        return operations.getDistrictsByCanton(idCanton);
    }

    public int registerVeterinarian(String firstName,
                                    String lastName,
                                    String clinicName,
                                    String phoneText,
                                    String email,
                                    String location,
                                    DbObject selectedDistrict)
            throws IllegalArgumentException, SQLException {
 
        if (firstName == null || firstName.trim().isEmpty()) {
            throw new IllegalArgumentException("First name is required.");
        }
        if (lastName == null || lastName.trim().isEmpty()) {
            throw new IllegalArgumentException("Last name is required.");
        }
        if (clinicName == null || clinicName.trim().isEmpty()) {
            throw new IllegalArgumentException("Clinic name is required.");
        }
        if (phoneText == null || phoneText.trim().isEmpty()) {
            throw new IllegalArgumentException("Phone is required.");
        }
        if (location == null || location.trim().isEmpty()) {
            throw new IllegalArgumentException("Address is required.");
        }
        if (selectedDistrict == null) {
            throw new IllegalArgumentException("Please select a district.");
        }
 
        long phone;
        try {
            phone = Long.parseLong(phoneText.trim());
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException("Phone must contain only numbers.");
        }
 
        String emailClean = (email == null) ? "" : email.trim();
        if (!emailClean.isEmpty() && !emailClean.matches(".*@.*\\..*")) {
            throw new IllegalArgumentException("Invalid email format.");
        }
 
        return operations.registerVeterinarian(
                firstName.trim(),
                lastName.trim(),
                clinicName.trim(),
                phone,
                emailClean.isEmpty() ? null : emailClean,
                location.trim(),
                selectedDistrict.getId()
        );
    }
}