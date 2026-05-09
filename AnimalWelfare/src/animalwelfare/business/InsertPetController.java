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
import animalwelfare.security.Hash;
import javax.swing.JOptionPane;

public class InsertPetController {
    

    public InsertPetController(InsertPetForm view) {
        view.fillEnergy(PetEnergyOperations.listEnergy());
        view.fillState(PetStateOperations.listState());
        view.fillType(PetTypeOperations.listType());
        view.fillBreed(PetBreedOperations.listBreed());
        view.fillCountry(CountryOperations.listCountry());
        view.fillSpaceRequired(PetSpaceRequiredOperations.listSpaceRequired());
        view.fillPetTraining(PetTrainingOperations.listPetTraining());
        view.fillPetSize(PetSizeOperations.listPetSize());
        view.fillVeterinarian(PetVeterinarianOperations.listVeterinarian());
    }
    
    public boolean InsertPet(String color, int age, String description, String petName, String chip, int idEnergy, int idState, int idType, int idBreed, int idDistrict, int idSpaceRequired, int idPetTraining, int idPetSize, int idPerson, int idVeterinarian){

        boolean success = PetOperations.InsertPet(color, age, description, petName, chip, idEnergy, idState, idType, idBreed, idDistrict, idSpaceRequired, idPetTraining, idPetSize, idPerson, idVeterinarian);
        if (success) {
            JOptionPane.showMessageDialog(null, "Pet inserted successfully.");
        } else {
            JOptionPane.showMessageDialog(null, "Failed to insert pet.");
        }
        return success;
    }

