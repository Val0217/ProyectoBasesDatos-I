package animalwelfare.business;

import animalwelfare.access.UserPetOperations;
import animalwelfare.access.UserPetOperations.CatalogItem;
import animalwelfare.access.UserPetOperations.PetFilter;
import java.sql.SQLException;
import java.util.List;
import javax.swing.JTable;
import javax.swing.table.DefaultTableModel;

public class UserPetTableController {

    private final UserPetOperations operations = new UserPetOperations();
    private final int currentUserId;

    public UserPetTableController(int currentUserId) {
        this.currentUserId = currentUserId;
    }

    public void loadUserPets(JTable table, PetFilter filter) throws SQLException {
        DefaultTableModel model = operations.getUserPets(currentUserId, safeFilter(filter));
        table.setModel(model);
        protectTable(table);
    }

    public void loadAdoptionPets(JTable table, PetFilter filter) throws SQLException {
        DefaultTableModel model = operations.getAdoptionPets(safeFilter(filter));
        table.setModel(model);
        protectTable(table);
    }

    public void putSelectedPetUpForAdoption(JTable table) throws SQLException {
        int petId = getSelectedPetId(table);
        operations.putPetUpForAdoption(petId, currentUserId);
    }

    public void reportSelectedPetMissing(JTable table) throws SQLException {
        int petId = getSelectedPetId(table);
        operations.reportPetMissing(petId, currentUserId);
    }

    public List<CatalogItem> getCatalog(String catalogName) throws SQLException {
        return operations.getCatalog(catalogName);
    }

    private PetFilter safeFilter(PetFilter filter) {
        return filter == null ? new PetFilter() : filter;
    }

    private void protectTable(JTable table) {
        table.setDefaultEditor(Object.class, null);
        table.getTableHeader().setReorderingAllowed(false);

        if (table.getColumnModel().getColumnCount() > 0) {
            table.getColumnModel().getColumn(0).setMinWidth(0);
            table.getColumnModel().getColumn(0).setMaxWidth(0);
            table.getColumnModel().getColumn(0).setPreferredWidth(0);
        }
    }
   public void undoSelectedPetUpForAdoption(JTable table) throws SQLException {
        int petId = getSelectedPetId(table);
        operations.undoPetUpForAdoption(petId, currentUserId);
    }
    private int getSelectedPetId(JTable table) throws SQLException {
        int selectedRow = table.getSelectedRow();

        if (selectedRow < 0) {
            throw new SQLException("Select a pet first.");
        }

        int modelRow = table.convertRowIndexToModel(selectedRow);
        Object value = table.getModel().getValueAt(modelRow, 0);

        if (value == null) {
            throw new SQLException("The selected row does not have a pet ID.");
        }

        if (value instanceof Number) {
            return ((Number) value).intValue();
        }

        return Integer.parseInt(value.toString());
    }
}
