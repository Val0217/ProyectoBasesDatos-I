package animalwelfare.business;

import animalwelfare.access.PetOperations;
import javax.swing.JTable;
import javax.swing.JOptionPane;
import javax.swing.table.DefaultTableModel;

public class TableAdoptionController {

    private final PetOperations petOperations;

    public TableAdoptionController() {
        this.petOperations = new PetOperations();
    }

    public void loadPetsUpForAdoption(JTable table) {
        try {
            DefaultTableModel model = petOperations.getPetsUpForAdoptionTableModel();
            table.setModel(model);
            table.setAutoResizeMode(JTable.AUTO_RESIZE_OFF);

        } catch (Exception e) {
            JOptionPane.showMessageDialog(
                null,
                "Error loading pets up for adoption: " + e.getMessage(),
                "Database Error",
                JOptionPane.ERROR_MESSAGE
            );
        }
    }

    public void loadFoundPets(JTable table) {
        try {
            DefaultTableModel model = petOperations.getFoundPetsTableModel();
            table.setModel(model);
            table.setAutoResizeMode(JTable.AUTO_RESIZE_OFF);

        } catch (Exception e) {
            JOptionPane.showMessageDialog(
                null,
                "Error loading found pets: " + e.getMessage(),
                "Database Error",
                JOptionPane.ERROR_MESSAGE
            );
        }
    }

    public void putSelectedPetUpForAdoption(JTable foundPetsTable, JTable adoptionPetsTable) {
        int selectedRow = foundPetsTable.getSelectedRow();

        if (selectedRow == -1) {
            JOptionPane.showMessageDialog(
                null,
                "Please select a pet first.",
                "No Pet Selected",
                JOptionPane.WARNING_MESSAGE
            );
            return;
        }

        int modelRow = foundPetsTable.convertRowIndexToModel(selectedRow);

        int petId = Integer.parseInt(
            foundPetsTable.getModel().getValueAt(modelRow, 0).toString()
        );

        boolean updated = petOperations.putPetUpForAdoption(petId);

        if (updated) {
            JOptionPane.showMessageDialog(
                null,
                "The pet is now up for adoption.",
                "Pet Updated",
                JOptionPane.INFORMATION_MESSAGE
            );

            loadFoundPets(foundPetsTable);
            loadPetsUpForAdoption(adoptionPetsTable);

        } else {
            JOptionPane.showMessageDialog(
                null,
                "The pet could not be updated.",
                "Update Error",
                JOptionPane.ERROR_MESSAGE
            );
        }
    }
}