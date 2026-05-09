package animalwelfare.business;

import animalwelfare.access.CountryOperations;
import javax.swing.JOptionPane;
import animalwelfare.access.PetOperations;
import animalwelfare.access.DbObject;
import animalwelfare.access.PetBreedOperations;
import animalwelfare.access.PetEnergyOperations;
import animalwelfare.access.PetSizeOperations;
import animalwelfare.access.PetSpaceRequiredOperations;
import animalwelfare.access.PetStateOperations;
import animalwelfare.access.PetTrainingOperations;
import animalwelfare.access.PetTypeOperations;
import animalwelfare.access.PetVeterinarianOperations;
import animalwelfare.userInterface.InsertPetForm;
import animalwelfare.userInterface.InsertPetFormForEdit;
import animalwelfare.security.Hash;
import java.sql.SQLException;
import javax.swing.JOptionPane;
import animalwelfare.access.PetEditData;

public class InsertPetController {
    
        // para enviar las Provincias a la view
    public void FillProvince(InsertPetForm view, int IdCountry) {
        view.fillProvince(CountryOperations.listProvince(IdCountry));
    }
    
    // para enviar los Cantones a la view
    public void FillCanton(InsertPetForm view, int IdProvince) {
        view.fillCanton(CountryOperations.listCanton(IdProvince));
    }
    
    // para enviar los Distritos a la view
    public void FillDistrict(InsertPetForm view, int IdCanton) {
        view.fillDistrict(CountryOperations.listDistrict(IdCanton));
    }

    public InsertPetController(InsertPetForm view) {
        view.fillPetEnergy(PetEnergyOperations.listPetEnergy());
        view.fillPetType(PetTypeOperations.listPetType());
        view.fillPetBreed(PetBreedOperations.listPetBreed());
        view.fillCountry(CountryOperations.listCountry());
        view.fillPetSpaceRequired(PetSpaceRequiredOperations.listPetSpaceRequired());
        view.fillPetTraining(PetTrainingOperations.listPetTraining());
        view.fillPetSize(PetSizeOperations.listPetSize());
        view.fillVeterinarian(PetVeterinarianOperations.listPetVeterinarian());
    }
    
    public boolean InsertPet(String color, int age, String description, String petName, String chip, int idEnergy, int idState, int idType, int idBreed, int idDistrict, int idSpaceRequired, int idPetTraining, int idPetSize, int idPerson, int idVeterinarian) throws SQLException{

        boolean success = PetOperations.InsertPet(color, age, description, petName, chip, idEnergy, idState, idType, idBreed, idDistrict, idSpaceRequired, idPetTraining, idPetSize, idPerson, idVeterinarian);
        if (success) {
            JOptionPane.showMessageDialog(null, "Pet inserted successfully.");
        } else {
            JOptionPane.showMessageDialog(null, "Failed to insert pet.");
        }
        return success;
    }
    public void FillProvince(InsertPetFormForEdit view, int IdCountry) {
        view.fillProvince(CountryOperations.listProvince(IdCountry));
    }

    public void FillCanton(InsertPetFormForEdit view, int IdProvince) {
        view.fillCanton(CountryOperations.listCanton(IdProvince));
    }

    public void FillDistrict(InsertPetFormForEdit view, int IdCanton) {
        view.fillDistrict(CountryOperations.listDistrict(IdCanton));
    }
    public void LoadPetForEdit(InsertPetFormForEdit view, int petId, int ownerId) throws SQLException {
        PetEditData pet = PetOperations.GetPetForEdit(petId, ownerId);

        if (pet == null) {
            JOptionPane.showMessageDialog(
                null,
                "Pet not found or this pet does not belong to the current owner."
            );
            view.dispose();
            return;
        }

        view.loadPetData(pet);
    }
    public InsertPetController(InsertPetFormForEdit view) {
        view.fillPetEnergy(PetEnergyOperations.listPetEnergy());
        view.fillPetType(PetTypeOperations.listPetType());
        view.fillPetBreed(PetBreedOperations.listPetBreed());
        view.fillCountry(CountryOperations.listCountry());
        view.fillPetSpaceRequired(PetSpaceRequiredOperations.listPetSpaceRequired());
        view.fillPetTraining(PetTrainingOperations.listPetTraining());
        view.fillPetSize(PetSizeOperations.listPetSize());
        view.fillVeterinarian(PetVeterinarianOperations.listPetVeterinarian());
    }
public boolean UpdatePetForOwner(
            int petId,
            int ownerId,
            String color,
            int age,
            String description,
            String petName,
            String chip,
            int idEnergy,
            int idType,
            Integer idBreed,
            int idDistrict,
            int idSpaceRequired,
            int idPetTraining,
            int idPetSize,
            int idVeterinarian
    ) throws SQLException {

        boolean success = PetOperations.UpdatePetForOwner(
                petId,
                ownerId,
                color,
                age,
                description,
                petName,
                chip,
                idEnergy,
                idType,
                idBreed,
                idDistrict,
                idSpaceRequired,
                idPetTraining,
                idPetSize,
                idVeterinarian
        );

        if (success) {
            JOptionPane.showMessageDialog(null, "Pet updated successfully.");
        } else {
            JOptionPane.showMessageDialog(
                null,
                "Pet was not updated. Check that the pet belongs to this owner."
            );
        }

        return success;
    }    

}

