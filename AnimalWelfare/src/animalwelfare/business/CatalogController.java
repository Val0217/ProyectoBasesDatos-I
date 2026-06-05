package animalwelfare.business;

import animalwelfare.access.CatalogOperations;
import animalwelfare.access.DbObject;
import animalwelfare.userInterface.CatalogForm;
import animalwelfare.userInterface.CatalogForm;
import javax.swing.JOptionPane;
import java.util.List;

/**
 * Business layer for CatalogForm.
 * Validates input, delegates persistence to CatalogOperations,
 * and tells the view to reload when something changes.
 *
 * @author team
 */
public class CatalogController {

    private final CatalogForm view;

    public CatalogController(CatalogForm view) {
        this.view = view;
    }

    // =========================================================================
    // Simple catalogs (tables that only have Id + Name)
    // =========================================================================

    public List<DbObject> loadSimple(String tableName) {
        return CatalogOperations.listSimple(tableName);
    }

    public boolean addSimple(String tableName, String name) {
        if (!validateName(name)) return false;
        boolean ok = CatalogOperations.insertSimple(tableName, name);
        if (!ok) showError("Could not insert the record.");
        return ok;
    }

    public boolean editSimple(String tableName, int id, String name) {
        if (!validateName(name)) return false;
        boolean ok = CatalogOperations.updateSimple(tableName, id, name);
        if (!ok) showError("Could not update the record.");
        return ok;
    }

    public boolean removeSimple(String tableName, int id) {
        if (!confirmDelete()) return false;
        boolean ok = CatalogOperations.deleteSimple(tableName, id);
        if (!ok) showError("Could not delete the record. It may be referenced by other data.");
        return ok;
    }

    // =========================================================================
    // PetBreed
    // =========================================================================

    public List<Object[]> loadBreeds() {
        return CatalogOperations.listBreeds();
    }

    public boolean addBreed(String name, DbObject type) {
        if (!validateName(name)) return false;
        if (!validateCombo(type, "Pet Type")) return false;
        boolean ok = CatalogOperations.insertBreed(name, type.getId());
        if (!ok) showError("Could not insert the breed.");
        return ok;
    }

    public boolean editBreed(int id, String name, DbObject type) {
        if (!validateName(name)) return false;
        if (!validateCombo(type, "Pet Type")) return false;
        boolean ok = CatalogOperations.updateBreed(id, name, type.getId());
        if (!ok) showError("Could not update the breed.");
        return ok;
    }

    public boolean removeBreed(int id) {
        if (!confirmDelete()) return false;
        boolean ok = CatalogOperations.deleteBreed(id);
        if (!ok) showError("Could not delete the breed. It may be referenced by pets.");
        return ok;
    }

    // =========================================================================
    // Medicine
    // =========================================================================

    public List<Object[]> loadMedicines() {
        return CatalogOperations.listMedicines();
    }

    public boolean addMedicine(String name, String dose) {
        if (!validateName(name)) return false;
        boolean ok = CatalogOperations.insertMedicine(name, dose);
        if (!ok) showError("Could not insert the medicine.");
        return ok;
    }

    public boolean editMedicine(int id, String name, String dose) {
        if (!validateName(name)) return false;
        boolean ok = CatalogOperations.updateMedicine(id, name, dose);
        if (!ok) showError("Could not update the medicine.");
        return ok;
    }

    public boolean removeMedicine(int id) {
        if (!confirmDelete()) return false;
        boolean ok = CatalogOperations.deleteMedicine(id);
        System.out.println("Resultado deleteMedicine: " + ok);
        if (!ok) showError("Could not delete the medicine. It may be in use.");
        return ok;
    }

    // =========================================================================
    // Association
    // =========================================================================

    public List<Object[]> loadAssociations() {
        return CatalogOperations.listAssociations();
    }

    public boolean addAssociation(String name, String phone, String email, String bank) {
        if (!validateName(name)) return false;
        if (!validateEmail(email)) return false;
        boolean ok = CatalogOperations.insertAssociation(name, phone, email, bank);
        if (!ok) showError("Could not insert the association.");
        return ok;
    }

    public boolean editAssociation(int id, String name, String phone, String email, String bank) {
        if (!validateName(name)) return false;
        if (!validateEmail(email)) return false;
        boolean ok = CatalogOperations.updateAssociation(id, name, phone, email, bank);
        if (!ok) showError("Could not update the association.");
        return ok;
    }

    public boolean removeAssociation(int id) {
        if (!confirmDelete()) return false;
        boolean ok = CatalogOperations.deleteAssociation(id);
        if (!ok) showError("Could not delete the association.");
        return ok;
    }

    // =========================================================================
    // Validation helpers
    // =========================================================================

    private boolean validateName(String name) {
        if (name == null || name.trim().isEmpty()) {
            showError("Name is required.");
            return false;
        }
        return true;
    }

    private boolean validateCombo(DbObject selected, String fieldLabel) {
        if (selected == null) {
            showError(fieldLabel + " is required.");
            return false;
        }
        return true;
    }

    /**
     * Basic email validation — same rules used in SignUpController.
     * Accepts empty string (email is optional in some catalogs).
     */
    private boolean validateEmail(String email) {
        if (email == null || email.trim().isEmpty()) return true; // optional field
        if (!email.contains("@")
                || email.startsWith("@")
                || email.endsWith("@")
                || (!email.contains(".com") && !email.contains(".net") && !email.contains(".org") && !email.contains(".cr"))) {
            showError("Invalid email format: " + email);
            return false;
        }
        return true;
    }

    private boolean confirmDelete() {
        return JOptionPane.showConfirmDialog(
            view,
            "Are you sure you want to delete this record?",
            "Confirm Delete",
            JOptionPane.YES_NO_OPTION,
            JOptionPane.WARNING_MESSAGE
        ) == JOptionPane.YES_OPTION;
    }

    private void showError(String message) {
        JOptionPane.showMessageDialog(view, message, "Error", JOptionPane.ERROR_MESSAGE);
    }
}
