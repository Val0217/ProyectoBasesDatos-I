package animalwelfare.business;

import animalwelfare.access.CountryOperations;
import animalwelfare.access.DbObject;
import animalwelfare.access.PetOperations;
import animalwelfare.access.PetBreedOperations;
import animalwelfare.access.PetEnergyOperations;
import animalwelfare.access.PetSizeOperations;
import animalwelfare.access.PetSpaceRequiredOperations;
import animalwelfare.access.PetTrainingOperations;
import animalwelfare.access.PetTypeOperations;
import animalwelfare.access.PetVeterinarianOperations;
import animalwelfare.security.Session;
import animalwelfare.userInterface.InsertPetForm;
import animalwelfare.userInterface.InsertPetFormForEdit;
import java.sql.SQLException;
import javax.swing.JOptionPane;

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

    public void FillPetBreed(InsertPetForm view, int IdPetType) {
        view.fillPetBreed(PetBreedOperations.listPetBreedByPetType(IdPetType));
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
    
    public boolean InsertPet(String color, int age, String description, String petName, String chip, DbObject idEnergy, DbObject idState, DbObject idType, DbObject idBreed, DbObject idDistrict, DbObject idSpaceRequired, DbObject idPetTraining, DbObject idPetSize, DbObject idVeterinarian) throws SQLException{

        // validaciones
        if (color == null || color.trim().isEmpty()) {
            JOptionPane.showMessageDialog(null, "Color is required.");
            return false;
        }

        if (age < 0) {
            JOptionPane.showMessageDialog(null, "Age is required.");
            return false;
        }

        if (petName == null || petName.trim().isEmpty()) {
            JOptionPane.showMessageDialog(null, "Pet name is required.");
            return false;
        }

        if (idEnergy == null || idEnergy.getId() == 0) {
            JOptionPane.showMessageDialog(null, "Please select an energy level.");
            return false;
        }

        if (idState == null || idState.getId() == 0) {
            JOptionPane.showMessageDialog(null, "Please select a state.");
            return false;
        }

        if (idType == null || idType.getId() == 0) {
            JOptionPane.showMessageDialog(null, "Please select a pet type.");
            return false;
        }

        if (idBreed == null || idBreed.getId() == 0) {
            JOptionPane.showMessageDialog(null, "Please select a pet breed.");
            return false;
        }

        if (idDistrict == null || idDistrict.getId() == 0) {
            JOptionPane.showMessageDialog(null, "Please select a district.");
            return false;
        }

        if (idSpaceRequired == null || idSpaceRequired.getId() == 0) {
            JOptionPane.showMessageDialog(null, "Please select a space requirement.");
            return false;
        }

        if (idPetTraining == null || idPetTraining.getId() == 0) {
            JOptionPane.showMessageDialog(null, "Please select a training option.");
            return false;
        }

        if (idPetSize == null || idPetSize.getId() == 0) {
            JOptionPane.showMessageDialog(null, "Please select a pet size.");
            return false;
        }

        if (idVeterinarian == null || idVeterinarian.getId() == 0) {
            JOptionPane.showMessageDialog(null, "Please select a veterinarian.");
            return false;
        }

        if (Session.getInstance().getUserId() == 0) {
            JOptionPane.showMessageDialog(null, "User must be logged in to insert a pet.");
            return false;
        }

        if (PetOperations.InsertPet(color, age, description, petName, chip, idEnergy.getId(), idState.getId(), idType.getId(), idBreed.getId(), idDistrict.getId(), idSpaceRequired.getId(), idPetTraining.getId(), idPetSize.getId(), Session.getInstance().getUserId(), idVeterinarian.getId())) {
            JOptionPane.showMessageDialog(null, "Pet inserted successfully.");
            return true;
        } else {
            JOptionPane.showMessageDialog(null, "Failed to insert pet.");
            return false;
        }
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
}

