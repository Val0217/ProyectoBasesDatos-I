package animalwelfare.business;

import animalwelfare.access.UserPetOperations;
import animalwelfare.access.UserPetOperations.CatalogItem;
import animalwelfare.access.UserPetOperations.PetFilter;
import java.sql.SQLException;
import java.util.List;
import javax.swing.JTable;
import javax.swing.table.DefaultTableModel;
import java.math.BigDecimal;

public class UserPetTableController {

    private final UserPetOperations operations = new UserPetOperations();
    private final int currentUserId;

    public UserPetTableController(int currentUserId) {
        this.currentUserId = currentUserId;
    }
    public void loadUserMissingPets(JTable table) throws SQLException {
        DefaultTableModel model = operations.getUserMissingPets(currentUserId);
        table.setModel(model);
        protectTable(table);
    }
    public void takeBackSelectedMissingReport(JTable table) throws SQLException {
        int petId = getSelectedPetId(table);
        operations.takeBackMissingReport(petId, currentUserId);
    }
    public void loadUserPets(JTable table, PetFilter filter) throws SQLException {
        DefaultTableModel model = operations.getUserPets(currentUserId, safeFilter(filter));
        table.setModel(model);
        protectTable(table);
    }

    public void loadAdoptionPets(JTable table, PetFilter filter) throws SQLException {
        DefaultTableModel model = operations.getAdoptionPets(currentUserId, safeFilter(filter));
        table.setModel(model);
        protectTable(table);
    }

    public void loadAdoptionRequests(JTable table) throws SQLException {
        DefaultTableModel model = operations.getAdoptionRequestsForOwner(currentUserId);
        table.setModel(model);
        protectTable(table);
        hideColumn(table, 1);
        hideColumn(table, 2);
    } 
    
    public void createAdoptionRequest(int petId, String description) throws SQLException {
        operations.createAdoptionRequest(petId, currentUserId, description);
    }

    public void acceptSelectedAdoptionRequest(JTable table) throws SQLException {
        int adoptionId = getSelectedId(table, 0, "Select an adoption request first.");
        operations.acceptAdoptionRequest(adoptionId, currentUserId);
    }

    public void rejectSelectedAdoptionRequest(JTable table) throws SQLException {
        int adoptionId = getSelectedId(table, 0, "Select an adoption request first.");
        operations.rejectAdoptionRequest(adoptionId, currentUserId);
    }

    public void registerLostReport(int petId, java.sql.Date lostDate, String place,
                                   String description, BigDecimal reward, int currencyId) throws SQLException {
        operations.registerLostReportForOwner(petId, currentUserId, lostDate, place, description, reward, currencyId);
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
        hideColumn(table, 0);
    }    
    private void hideColumn(JTable table, int columnIndex) {
        if (table.getColumnModel().getColumnCount() > columnIndex) {
            table.getColumnModel().getColumn(columnIndex).setMinWidth(0);
            table.getColumnModel().getColumn(columnIndex).setMaxWidth(0);
            table.getColumnModel().getColumn(columnIndex).setPreferredWidth(0);
        }
    } 
    
    public int getSelectedPetIdFromTable(JTable table) throws SQLException {
        return getSelectedPetId(table);
    }

    private int getSelectedId(JTable table, int modelColumn, String emptySelectionMessage) throws SQLException {
        int selectedRow = table.getSelectedRow();

        if (selectedRow < 0) {
            throw new SQLException(emptySelectionMessage);
        }

        int modelRow = table.convertRowIndexToModel(selectedRow);
        Object value = table.getModel().getValueAt(modelRow, modelColumn);

        if (value == null) {
            throw new SQLException("The selected row does not have the required ID.");
        }

        if (value instanceof Number) {
            return ((Number) value).intValue();
        }

        return Integer.parseInt(value.toString());
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
