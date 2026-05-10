package animalwelfare.business;

import animalwelfare.access.DbObject;
import animalwelfare.access.FosterHomeOperations;
import animalwelfare.access.FosterHomeOperations.FosterHomeData;
import animalwelfare.security.Session;
import animalwelfare.userInterface.FosterHomeForm;
import java.util.ArrayList;
import javax.swing.JOptionPane;
import javax.swing.table.DefaultTableModel;

/**
 * Business logic controller for the Foster Home module.
 * Handles validation and delegates to FosterHomeOperations.
 * @author team
 */
public class FosterHomeController {

    private final FosterHomeForm view;

    public FosterHomeController(FosterHomeForm view) {
        this.view = view;
        // Fill all checkboxes from catalogs
        view.fillSizes(FosterHomeOperations.listSizes());
        view.fillEnergyLevels(FosterHomeOperations.listEnergyLevels());
        view.fillSpacesRequired(FosterHomeOperations.listSpacesRequired());
        // Load table
        view.loadFosterHomes(FosterHomeOperations.getFosterHomes());
    }

    // -------------------------------------------------------------------------
    // INSERT
    // -------------------------------------------------------------------------

    /**
     * Validates inputs and registers a new foster home.
     * @param needsDonation true if the foster home needs food donation
     * @param sizeIds       selected size IDs
     * @param energyIds     selected energy level IDs
     * @param spaceIds      selected space required IDs
     * @return true if successful
     */
    public boolean registerFosterHome(boolean needsDonation,
                                       ArrayList<Integer> sizeIds,
                                       ArrayList<Integer> energyIds,
                                       ArrayList<Integer> spaceIds) {
        int userId = Session.getInstance().getUserId();

        if (userId == 0) {
            JOptionPane.showMessageDialog(null,
                "You must be logged in to register as a foster home.",
                "Validation", JOptionPane.WARNING_MESSAGE);
            return false;
        }

        if (sizeIds.isEmpty()) {
            JOptionPane.showMessageDialog(null,
                "Please select at least one accepted pet size.",
                "Validation", JOptionPane.WARNING_MESSAGE);
            return false;
        }

        if (energyIds.isEmpty()) {
            JOptionPane.showMessageDialog(null,
                "Please select at least one accepted energy level.",
                "Validation", JOptionPane.WARNING_MESSAGE);
            return false;
        }

        if (spaceIds.isEmpty()) {
            JOptionPane.showMessageDialog(null,
                "Please select at least one space type.",
                "Validation", JOptionPane.WARNING_MESSAGE);
            return false;
        }

        String donation = needsDonation ? "Y" : "N";

        boolean success = FosterHomeOperations.insertFosterHome(
            userId, donation,
            sizeIds.toArray(new Integer[0]),
            energyIds.toArray(new Integer[0]),
            spaceIds.toArray(new Integer[0])
        );

        if (success) {
            JOptionPane.showMessageDialog(null,
                "Foster home registered successfully!",
                "Success", JOptionPane.INFORMATION_MESSAGE);
            view.loadFosterHomes(FosterHomeOperations.getFosterHomes());
            view.clearRegisterForm();
        } else {
            JOptionPane.showMessageDialog(null,
                "Failed to register foster home. You may already be registered.",
                "Error", JOptionPane.ERROR_MESSAGE);
        }

        return success;
    }

    // -------------------------------------------------------------------------
    // LOAD FOR EDIT
    // -------------------------------------------------------------------------

    /**
     * Loads the current user's foster home data into the edit form.
     * @return FosterHomeData or null if not registered
     */
    public FosterHomeData loadMyFosterHome() {
        int userId = Session.getInstance().getUserId();
        FosterHomeData data = FosterHomeOperations.getFosterHomeByPerson(userId);

        if (data == null) {
            JOptionPane.showMessageDialog(null,
                "You are not registered as a foster home.",
                "Info", JOptionPane.INFORMATION_MESSAGE);
        }

        return data;
    }

    // -------------------------------------------------------------------------
    // UPDATE
    // -------------------------------------------------------------------------

    /**
     * Updates the current user's foster home.
     */
    public boolean updateFosterHome(int idFosterHome, boolean needsDonation,
                                     ArrayList<Integer> sizeIds,
                                     ArrayList<Integer> energyIds,
                                     ArrayList<Integer> spaceIds) {
        int userId = Session.getInstance().getUserId();

        if (sizeIds.isEmpty() || energyIds.isEmpty() || spaceIds.isEmpty()) {
            JOptionPane.showMessageDialog(null,
                "Please select at least one option in each category.",
                "Validation", JOptionPane.WARNING_MESSAGE);
            return false;
        }

        String donation = needsDonation ? "Y" : "N";

        boolean success = FosterHomeOperations.updateFosterHome(
            idFosterHome, userId, donation,
            sizeIds.toArray(new Integer[0]),
            energyIds.toArray(new Integer[0]),
            spaceIds.toArray(new Integer[0])
        );

        if (success) {
            JOptionPane.showMessageDialog(null,
                "Foster home updated successfully!",
                "Success", JOptionPane.INFORMATION_MESSAGE);
            view.loadFosterHomes(FosterHomeOperations.getFosterHomes());
        } else {
            JOptionPane.showMessageDialog(null,
                "Failed to update foster home.",
                "Error", JOptionPane.ERROR_MESSAGE);
        }

        return success;
    }

    // -------------------------------------------------------------------------
    // DELETE
    // -------------------------------------------------------------------------

    /**
     * Deletes the current user's foster home after confirmation.
     */
    public boolean deleteFosterHome(int idFosterHome) {
        int userId = Session.getInstance().getUserId();

        int confirm = JOptionPane.showConfirmDialog(null,
            "Are you sure you want to remove yourself as a foster home?",
            "Confirm Delete", JOptionPane.YES_NO_OPTION,
            JOptionPane.WARNING_MESSAGE);

        if (confirm != JOptionPane.YES_OPTION) return false;

        boolean success = FosterHomeOperations.deleteFosterHome(idFosterHome, userId);

        if (success) {
            JOptionPane.showMessageDialog(null,
                "Foster home removed successfully.",
                "Success", JOptionPane.INFORMATION_MESSAGE);
            view.loadFosterHomes(FosterHomeOperations.getFosterHomes());
        } else {
            JOptionPane.showMessageDialog(null,
                "Failed to remove foster home.",
                "Error", JOptionPane.ERROR_MESSAGE);
        }

        return success;
    }

    // -------------------------------------------------------------------------
    // REFRESH TABLE
    // -------------------------------------------------------------------------

    public void refreshTable() {
        view.loadFosterHomes(FosterHomeOperations.getFosterHomes());
    }

    // -------------------------------------------------------------------------
    // TOTALS for footer
    // -------------------------------------------------------------------------

    public int countFosterHomes(DefaultTableModel model) {
        return model.getRowCount();
    }
}
