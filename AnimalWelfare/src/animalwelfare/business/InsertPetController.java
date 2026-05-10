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
import animalwelfare.access.PetEditData;
import animalwelfare.access.PetIllnessOperations;
import animalwelfare.access.PetMedicineOperations;
import animalwelfare.access.PetTreatmentOperations;
import java.util.ArrayList;

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
        view.fillIllness(PetIllnessOperations.listIllness());
        view.fillTreatment(PetTreatmentOperations.listTreatment());
        view.fillMedicine(PetMedicineOperations.listMedicine());
    }
    
    public boolean InsertPet(String color, int age, String description, String petName, String chip, DbObject idEnergy, DbObject idType, DbObject idBreed, DbObject idDistrict, DbObject idSpaceRequired, DbObject idPetTraining, DbObject idPetSize, DbObject idVeterinarian, ArrayList<DbObject> idIllness, ArrayList<DbObject> idTreatment, ArrayList<DbObject> idMedicine, ArrayList<String> imageFiles) throws SQLException{

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

        if (Session.getInstance().getUserId() == 0) {
            JOptionPane.showMessageDialog(null, "User must be logged in to insert a pet.");
            return false;
        }

        if (idVeterinarian == null) {
            idVeterinarian = new DbObject(0, "None");
        }


        // Convertir las listas de DbObject a listas de IDs
        ArrayList<Integer> illnessIds = new ArrayList<>();
        for (DbObject illness : idIllness) {
            illnessIds.add(illness.getId());
        }
        ArrayList<Integer> treatmentIds = new ArrayList<>();
        for (DbObject treatment : idTreatment) {
            treatmentIds.add(treatment.getId());
        }
        ArrayList<Integer> medicineIds = new ArrayList<>();
        for (DbObject medicine : idMedicine) {
            medicineIds.add(medicine.getId());
        }


        Integer[] dataIllness = illnessIds.toArray(new Integer[0]);
        Integer[] dataTreatment = treatmentIds.toArray(new Integer[0]);
        Integer[] dataMedicine = medicineIds.toArray(new Integer[0]);
        String[] dataImageFiles = imageFiles.toArray(new String[0]);
        
        

        if (PetOperations.InsertPet(color, age, description, petName, chip, idEnergy.getId(), idType.getId(), idBreed.getId(), idDistrict.getId(), idSpaceRequired.getId(), idPetTraining.getId(), idPetSize.getId(), Session.getInstance().getUserId(), idVeterinarian.getId(), dataIllness, dataTreatment, dataMedicine, dataImageFiles)) {
            JOptionPane.showMessageDialog(null, "Pet inserted successfully.");
            return true;
        } else {
            JOptionPane.showMessageDialog(null, "Failed to insert pet.");
            return false;
        }
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

