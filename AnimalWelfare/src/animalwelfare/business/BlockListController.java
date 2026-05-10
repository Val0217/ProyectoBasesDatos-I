package animalwelfare.business;

import animalwelfare.access.BlockListOperations;
import animalwelfare.access.DbObject;
import animalwelfare.security.Session;
//import animalwelfare.userInterface.BlockListForm; 
//cambiar nombre a BlickListFormPreview y hacer cambios necesarios
import java.util.ArrayList;
import javax.swing.JOptionPane;
import javax.swing.table.DefaultTableModel;

/**
 * Business logic controller for the Block List module.
 * @author team
 */
public class BlockListController {

    private final BlockListForm view;

    public BlockListController(BlockListForm view) {
        this.view = view;
        view.fillPersonCombo(BlockListOperations.listPersons());
        view.loadBlockList(BlockListOperations.getBlockList());
    }

    // -------------------------------------------------------------------------
    // REPORT
    // -------------------------------------------------------------------------

    /**
     * Validates and reports a person, adding them to the block list.
     * @param person      Selected person to report
     * @param description Reason for the report
     * @return true if successful
     */
    public boolean reportPerson(DbObject person, String description) {
        int reporterId = Session.getInstance().getUserId();

        if (reporterId == 0) {
            JOptionPane.showMessageDialog(null,
                "You must be logged in to report a person.",
                "Validation", JOptionPane.WARNING_MESSAGE);
            return false;
        }

        if (person == null || person.getId() == 0) {
            JOptionPane.showMessageDialog(null,
                "Please select a person to report.",
                "Validation", JOptionPane.WARNING_MESSAGE);
            return false;
        }

        if (person.getId() == reporterId) {
            JOptionPane.showMessageDialog(null,
                "You cannot report yourself.",
                "Validation", JOptionPane.WARNING_MESSAGE);
            return false;
        }

        if (description == null || description.trim().isEmpty()) {
            JOptionPane.showMessageDialog(null,
                "Please provide a reason for the report.",
                "Validation", JOptionPane.WARNING_MESSAGE);
            return false;
        }

        boolean success = BlockListOperations.reportPerson(
            person.getId(), reporterId, description.trim()
        );

        if (success) {
            JOptionPane.showMessageDialog(null,
                person.toString() + " has been reported and added to the block list.",
                "Success", JOptionPane.INFORMATION_MESSAGE);
            view.loadBlockList(BlockListOperations.getBlockList());
            view.clearReportForm();
        } else {
            JOptionPane.showMessageDialog(null,
                "Failed to report person. Please try again.",
                "Error", JOptionPane.ERROR_MESSAGE);
        }

        return success;
    }

    // -------------------------------------------------------------------------
    // DETAIL
    // -------------------------------------------------------------------------

    /**
     * Returns the full detail model for a blocked person.
     * @param idPerson ID of the selected person
     * @return DefaultTableModel with all reports and ratings
     */
    public DefaultTableModel getDetail(int idPerson) {
        return BlockListOperations.getBlockListDetail(idPerson);
    }

    // -------------------------------------------------------------------------
    // REMOVE
    // -------------------------------------------------------------------------

    /**
     * Removes a person from the block list.
     * Only admins can perform this action.
     * @param idPerson ID of the person to remove
     * @return true if successful
     */
    public boolean removeFromBlockList(int idPerson) {
        int adminId = Session.getInstance().getUserId();
        String role = Session.getInstance().getRole();

        if (!"Admin".equals(role)) {
            JOptionPane.showMessageDialog(null,
                "Only admins can remove people from the block list.",
                "Access Denied", JOptionPane.ERROR_MESSAGE);
            return false;
        }

        int confirm = JOptionPane.showConfirmDialog(null,
            "Are you sure you want to remove this person from the block list?",
            "Confirm", JOptionPane.YES_NO_OPTION, JOptionPane.WARNING_MESSAGE);

        if (confirm != JOptionPane.YES_OPTION) return false;

        boolean success = BlockListOperations.removeFromBlockList(idPerson, adminId);

        if (success) {
            JOptionPane.showMessageDialog(null,
                "Person removed from block list successfully.",
                "Success", JOptionPane.INFORMATION_MESSAGE);
            view.loadBlockList(BlockListOperations.getBlockList());
        } else {
            JOptionPane.showMessageDialog(null,
                "Failed to remove person from block list.",
                "Error", JOptionPane.ERROR_MESSAGE);
        }

        return success;
    }

    // -------------------------------------------------------------------------
    // REFRESH
    // -------------------------------------------------------------------------

    public void refreshBlockList() {
        view.loadBlockList(BlockListOperations.getBlockList());
    }

    // -------------------------------------------------------------------------
    // CATALOG
    // -------------------------------------------------------------------------

    public ArrayList<DbObject> getPersons() {
        return BlockListOperations.listPersons();
    }
}
