/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/GUIForms/JFrame.java to edit this template
 */
package animalwelfare.userInterface;

import animalwelfare.access.UserPetOperations.CatalogItem;
import animalwelfare.access.UserPetOperations.PetFilter;
import animalwelfare.business.UserPetTableController;
import java.sql.SQLException;
import javax.swing.JComboBox;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JTextField;

/**
 *
 * @author valer
 */
public class UserPetTable extends javax.swing.JFrame {
    
    private static final java.util.logging.Logger logger = java.util.logging.Logger.getLogger(UserPetTable.class.getName());
    private UserPetTableController controller;

    private PetFilter filterPanel1 = new PetFilter();
    private PetFilter filterPanel2 = new PetFilter();

    // OJOOOOO remplazar con el id del usuario de la aplicacion. ahorita esta en 1 por pruebas.
    private int currentUserId;
    /**
     * Creates new form UserPetTable
     */
    public UserPetTable() {
        this(1);
    }

    public UserPetTable(int currentUserId) {
        initComponents();
        setLocationRelativeTo(null);

        this.currentUserId = currentUserId;

        controller = new UserPetTableController(this.currentUserId);

        prepareTables();
        addTableSelectionListeners();
        loadTables();
        setVisible(true);
    }
    private void prepareTables() {
        jTable1.setDefaultEditor(Object.class, null);
        jTable2.setDefaultEditor(Object.class, null);
        jTable3.setDefaultEditor(Object.class, null);
        jTable4.setDefaultEditor(Object.class, null);
        jTable5.setDefaultEditor(Object.class, null);

        jTable1.getTableHeader().setReorderingAllowed(false);
        jTable2.getTableHeader().setReorderingAllowed(false);
        jTable3.getTableHeader().setReorderingAllowed(false);
        jTable4.getTableHeader().setReorderingAllowed(false);

        jButtonAdopt.setEnabled(false);
        jButtonEditPet.setEnabled(false);
        jButtonReportMissing.setEnabled(false);
        jButtonTakeBackMiss.setEnabled(false);
        jButtonAcceptAdopt.setEnabled(false);
        jButtonRejectAdopt.setEnabled(false);
        jButtonUndoAdoption.setVisible(false);
        jButtonPutAdopt.setEnabled(false);
    }
    private void addTableSelectionListeners() {
        jTable1.getSelectionModel().addListSelectionListener(event -> {
            if (!event.getValueIsAdjusting()) {
                updateUndoAdoptionButtonVisibility();
                updateEditPetButtonState();
                updateReportMissingButtonState();
                updatePutAdoptButtonState();
            }
        });

        jTable2.getSelectionModel().addListSelectionListener(event -> {
            if (!event.getValueIsAdjusting()) {
                updateAdoptButtonState();
            }
        });
        
        jTable3.getSelectionModel().addListSelectionListener(event -> {
        if (!event.getValueIsAdjusting()) {
            jButtonTakeBackMiss.setEnabled(jTable3.getSelectedRow() >= 0);
        }
        });
        
        jTable4.addMouseListener(new java.awt.event.MouseAdapter() {
            @Override
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                handleFoundPetsTableClick();
            }
        });

        jTable5.getSelectionModel().addListSelectionListener(event -> {
            if (!event.getValueIsAdjusting()) {
                updateAdoptionDecisionButtonsState();
            }
        });
    }
    private void updatePutAdoptButtonState() {
        if (jTable1.getSelectedRow() < 0) {
            jButtonPutAdopt.setEnabled(false);
            return;
        }

        String state = getSelectedPetStateFromTable();

        boolean isLost =
                state != null &&
                (state.equalsIgnoreCase("Lost")
                || state.equalsIgnoreCase("Missing")
                || state.equals("3"));

        jButtonPutAdopt.setEnabled(!isLost);
    }
    
    private void handleFoundPetsTableClick() {
        int selectedRow = jTable4.getSelectedRow();
        int selectedColumn = jTable4.getSelectedColumn();

        if (selectedRow < 0 || selectedColumn < 0) {
            return;
        }

        String columnName = jTable4.getColumnName(selectedColumn);

        if (!columnName.equalsIgnoreCase("Emails")
                && !columnName.equalsIgnoreCase("Phones")) {
            return;
        }

        int modelRow = jTable4.convertRowIndexToModel(selectedRow);

        int ownerIdColumn = findModelColumn(jTable4, "OwnerId");
        if (ownerIdColumn < 0) {
            showError(new Exception("OwnerId column was not found."));
            return;
        }

        Object ownerValue = jTable4.getModel().getValueAt(modelRow, ownerIdColumn);

        if (ownerValue == null) {
            showError(new Exception("The selected row does not have an owner ID."));
            return;
        }

        int ownerId;

        if (ownerValue instanceof Number) {
            ownerId = ((Number) ownerValue).intValue();
        } else {
            ownerId = Integer.parseInt(ownerValue.toString());
        }

        try {
            if (columnName.equalsIgnoreCase("Emails")) {
                showListPopup("Owner emails", controller.getOwnerEmails(ownerId));
            } else {
                showListPopup("Owner phones", controller.getOwnerPhones(ownerId));
            }
        } catch (SQLException ex) {
            showError(ex);
        }
    }
    private void updateAdoptButtonState() {
        jButtonAdopt.setEnabled(jTable2.getSelectedRow() >= 0);
    }

    private void updateAdoptionDecisionButtonsState() {
        boolean hasSelection = jTable5.getSelectedRow() >= 0;
        jButtonAcceptAdopt.setEnabled(hasSelection);
        jButtonRejectAdopt.setEnabled(hasSelection);
    }
    private void updateEditPetButtonState() {
        jButtonEditPet.setEnabled(jTable1.getSelectedRow() >= 0);
    }
    private void updateReportMissingButtonState() {
        if (jTable1.getSelectedRow() < 0) {
            jButtonReportMissing.setEnabled(false);
            return;
        }

        jButtonReportMissing.setEnabled(!isMissingState(getSelectedPetStateFromTable()));
    } 
    private String getSelectedPetStateFromTable() {
        int selectedRow = jTable1.getSelectedRow();

        if (selectedRow < 0) {
            return null;
        }

        int modelRow = jTable1.convertRowIndexToModel(selectedRow);
        int stateColumn = findModelColumn("State");

        if (stateColumn < 0) {
            stateColumn = 6;
        }

        if (stateColumn < 0 || stateColumn >= jTable1.getModel().getColumnCount()) {
            return null;
        }

        Object value = jTable1.getModel().getValueAt(modelRow, stateColumn);
        return value == null ? null : value.toString().trim();
    }

    private boolean isMissingState(String state) {
        if (state == null) {
            return false;
        }

        return state.equalsIgnoreCase("Lost")
                || state.equalsIgnoreCase("Missing")
                || state.equalsIgnoreCase("Perdido")
                || state.equalsIgnoreCase("Perdida")
                || state.equals("3");
    }
    public void refreshAfterPetEdit() {
        loadTables();
        jButtonEditPet.setEnabled(false);
        jButtonUndoAdoption.setVisible(false);
        jButtonAdopt.setEnabled(false);
        updateAdoptionDecisionButtonsState();
    }

    public void refreshAfterAdoptionRequest() {
        loadTables();
        jTable2.clearSelection();
        jButtonAdopt.setEnabled(false);
    }

    public void refreshAfterLostReport() {
        loadTables();
        jTable1.clearSelection();
        jButtonUndoAdoption.setVisible(false);
        jButtonEditPet.setEnabled(false);
        jButtonReportMissing.setEnabled(false);
    }

    private int getSelectedPetIdFromTable() {
        int selectedRow = jTable1.getSelectedRow();

        if (selectedRow < 0) {
            throw new IllegalStateException("Select a pet first.");
        }

        int modelRow = jTable1.convertRowIndexToModel(selectedRow);

        int idColumn = findModelColumn("ID");

        if (idColumn < 0) {
            idColumn = 0; 
        }

        Object value = jTable1.getModel().getValueAt(modelRow, idColumn);

        if (value == null) {
            throw new IllegalStateException("The selected row does not have a pet ID.");
        }

        if (value instanceof Number) {
            return ((Number) value).intValue();
        }

        return Integer.parseInt(value.toString());
    }

    private int findModelColumn(String columnName) {
        for (int i = 0; i < jTable1.getModel().getColumnCount(); i++) {
            String currentName = jTable1.getModel().getColumnName(i);

            if (currentName != null && currentName.equalsIgnoreCase(columnName)) {
                return i;
            }
        }

        return -1;
    }
    private int findModelColumn(javax.swing.JTable table, String columnName) {
        for (int i = 0; i < table.getModel().getColumnCount(); i++) {
            String currentName = table.getModel().getColumnName(i);

            if (currentName != null && currentName.equalsIgnoreCase(columnName)) {
                return i;
            }
        }

        return -1;
    }
    private void showListPopup(String title, java.util.List<String> values) {
        if (values == null || values.isEmpty()) {
            JOptionPane.showMessageDialog(
                this,
                "No information registered.",
                title,
                JOptionPane.INFORMATION_MESSAGE
            );
            return;
        }

        StringBuilder message = new StringBuilder();

        for (String value : values) {
            if (value != null && !value.trim().isEmpty()) {
                message.append(value).append("\n");
            }
        }

        JOptionPane.showMessageDialog(
            this,
            message.toString(),
            title,
            JOptionPane.INFORMATION_MESSAGE
        );
    }
    private void updateUndoAdoptionButtonVisibility() {
        int selectedRow = jTable1.getSelectedRow();

        if (selectedRow < 0) {
            jButtonUndoAdoption.setVisible(false);
            return;
        }

        int modelRow = jTable1.convertRowIndexToModel(selectedRow);

        Object stateValue = jTable1.getModel().getValueAt(modelRow, 6);

        if (stateValue == null) {
            jButtonUndoAdoption.setVisible(false);
            return;
        }

        String state = stateValue.toString().trim();

        boolean isUpForAdoption =
                state.equalsIgnoreCase("En Adopcion")
                || state.equalsIgnoreCase("Up for adoption")
                || state.equals("1");

        jButtonUndoAdoption.setVisible(isUpForAdoption);
    }
    private void loadTables() {
        try {
            controller.loadUserPets(jTable1, filterPanel1);
            controller.loadAdoptionPets(jTable2, filterPanel2);
            controller.loadAdoptionRequests(jTable5);
            controller.loadUserMissingPets(jTable3);
            controller.loadFoundPets(jTable4);
        } catch (SQLException ex) {
            showError(ex);
        }
    }
    private void loadPanel3Table() {
        try {
            controller.loadUserMissingPets(jTable3);
        } catch (SQLException ex) {
            showError(ex);
        }
    }
    private void loadPanel1Table() {
        try {
            controller.loadUserPets(jTable1, filterPanel1);
        } catch (SQLException ex) {
            showError(ex);
        }
    }
    private void loadPanel2Table() {
        try {
            controller.loadAdoptionPets(jTable2, filterPanel2);
        } catch (SQLException ex) {
            showError(ex);
        }
    }
    private void showError(Exception ex) {
        JOptionPane.showMessageDialog(
            this,
            ex.getMessage(),
            "Error",
            JOptionPane.ERROR_MESSAGE
        );
    }   
    
//Combox Funcion para que salga un mini menu como estilo popup
private PetFilter showFilterDialog(PetFilter currentFilter) throws SQLException {
    JComboBox<CatalogItem> cbEnergy = createCatalogCombo("ENERGY", currentFilter.idEnergy);
    JComboBox<CatalogItem> cbType = createCatalogCombo("TYPE", currentFilter.idType);
    JComboBox<CatalogItem> cbBreed = createCatalogCombo("BREED", currentFilter.idBreed);
    JComboBox<CatalogItem> cbDistrict = createCatalogCombo("DISTRICT", currentFilter.idDistrict);
    JComboBox<CatalogItem> cbSpace = createCatalogCombo("SPACE", currentFilter.idSpace);
    JComboBox<CatalogItem> cbTraining = createCatalogCombo("TRAINING", currentFilter.idTraining);
    JComboBox<CatalogItem> cbSize = createCatalogCombo("SIZE", currentFilter.idSize);
    JComboBox<CatalogItem> cbVet = createCatalogCombo("VETERINARIAN", currentFilter.idVeterinarian);
    JComboBox<CatalogItem> cbCountry = createCatalogCombo("COUNTRY", currentFilter.idCountry);
    JComboBox<CatalogItem> cbProvince = createCatalogCombo("PROVINCE", currentFilter.idProvince);
    JComboBox<CatalogItem> cbCanton = createCatalogCombo("CANTON", currentFilter.idCanton);

    JTextField txtColor = new JTextField(nullToEmpty(currentFilter.color), 15);
    JComboBox<Integer> cbAge = createAgeCombo(currentFilter.age);
    JTextField txtName = new JTextField(nullToEmpty(currentFilter.name), 15);
    JTextField txtChip = new JTextField(nullToEmpty(currentFilter.chip), 15);

    JPanel panel = new JPanel(new java.awt.GridLayout(0, 2, 6, 6));

    panel.add(new JLabel("Energy:"));
    panel.add(cbEnergy);

    panel.add(new JLabel("Type:"));
    panel.add(cbType);

    panel.add(new JLabel("Breed:"));
    panel.add(cbBreed);

    panel.add(new JLabel("Country:"));
    panel.add(cbCountry);

    panel.add(new JLabel("Province:"));
    panel.add(cbProvince);

    panel.add(new JLabel("Canton:"));
    panel.add(cbCanton);

    panel.add(new JLabel("District:"));
    panel.add(cbDistrict);

    panel.add(new JLabel("Space Required:"));
    panel.add(cbSpace);

    panel.add(new JLabel("Training:"));
    panel.add(cbTraining);

    panel.add(new JLabel("Size:"));
    panel.add(cbSize);

    panel.add(new JLabel("Veterinarian:"));
    panel.add(cbVet);

    panel.add(new JLabel("Color:"));
    panel.add(txtColor);

    panel.add(new JLabel("Age:"));
    panel.add(cbAge);

    panel.add(new JLabel("Name:"));
    panel.add(txtName);

    panel.add(new JLabel("Chip:"));
    panel.add(txtChip);

    int result = JOptionPane.showConfirmDialog(
        this,
        panel,
        "Filter pets",
        JOptionPane.OK_CANCEL_OPTION,
        JOptionPane.PLAIN_MESSAGE
    );

    if (result != JOptionPane.OK_OPTION) {
        return currentFilter;
    }

    PetFilter newFilter = new PetFilter();

    newFilter.idEnergy = getSelectedId(cbEnergy);
    newFilter.idType = getSelectedId(cbType);
    newFilter.idBreed = getSelectedId(cbBreed);
    newFilter.idCountry = getSelectedId(cbCountry);
    newFilter.idProvince = getSelectedId(cbProvince);
    newFilter.idCanton = getSelectedId(cbCanton);
    newFilter.idDistrict = getSelectedId(cbDistrict);
    newFilter.idSpace = getSelectedId(cbSpace);
    newFilter.idTraining = getSelectedId(cbTraining);
    newFilter.idSize = getSelectedId(cbSize);
    newFilter.idVeterinarian = getSelectedId(cbVet);

    newFilter.color = cleanText(txtColor.getText());
    newFilter.name = cleanText(txtName.getText());
    newFilter.chip = cleanText(txtChip.getText());

    newFilter.age = getSelectedAge(cbAge);

    return newFilter;
}
private JComboBox<Integer> createAgeCombo(Integer selectedAge) {
    JComboBox<Integer> combo = new JComboBox<>();

    combo.addItem(null); // Means "Todos"

    for (int i = 1; i <= 99; i++) {
        combo.addItem(i);

        if (selectedAge != null && selectedAge == i) {
            combo.setSelectedItem(i);
        }
    }

    return combo;
}
private Integer getSelectedAge(JComboBox<Integer> combo) {
    return (Integer) combo.getSelectedItem();
}
private JComboBox<CatalogItem> createCatalogCombo(String catalogName, Integer selectedId) throws SQLException {
    JComboBox<CatalogItem> combo = new JComboBox<>();

    for (CatalogItem item : controller.getCatalog(catalogName)) {
        combo.addItem(item);

        if (selectedId != null && item.getId() != null && item.getId().equals(selectedId)) {
            combo.setSelectedItem(item);
        }
    }

    return combo;
}
private Integer getSelectedId(JComboBox<CatalogItem> combo) {
    CatalogItem item = (CatalogItem) combo.getSelectedItem();
    return item == null ? null : item.getId();
}
private String cleanText(String text) {
    if (text == null || text.trim().isEmpty()) {
        return null;
    }

    return text.trim();
}
private String nullToEmpty(String text) {
    return text == null ? "" : text;
}
    /**
     * This method is called from within the constructor to initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is always
     * regenerated by the Form Editor.
     */
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        jTabbedPane1 = new javax.swing.JTabbedPane();
        jPanel1 = new javax.swing.JPanel();
        jScrollPane1 = new javax.swing.JScrollPane();
        jTable1 = new javax.swing.JTable();
        jButtonFilter1 = new javax.swing.JButton();
        jButtonCleanFilter1 = new javax.swing.JButton();
        jButtonPutAdopt = new javax.swing.JButton();
        jButtonUndoAdoption = new javax.swing.JButton();
        jButtonEditPet = new javax.swing.JButton();
        jButtonReportMissing = new javax.swing.JButton();
        jButtonReturnMM = new javax.swing.JButton();
        jPanel2 = new javax.swing.JPanel();
        jScrollPane2 = new javax.swing.JScrollPane();
        jTable2 = new javax.swing.JTable();
        jButtonFilter2 = new javax.swing.JButton();
        jButtonCleanFilter2 = new javax.swing.JButton();
        jButtonAdopt = new javax.swing.JButton();
        jButtonReturnMM2 = new javax.swing.JButton();
        jPanel3 = new javax.swing.JPanel();
        jScrollPane3 = new javax.swing.JScrollPane();
        jTable3 = new javax.swing.JTable();
        jButtonTakeBackMiss = new javax.swing.JButton();
        jButtonReturnMM3 = new javax.swing.JButton();
        jPanel4 = new javax.swing.JPanel();
        jScrollPane4 = new javax.swing.JScrollPane();
        jTable4 = new javax.swing.JTable();
        jButton2 = new javax.swing.JButton();
        jButtonReturnMM4 = new javax.swing.JButton();
        jPanel5 = new javax.swing.JPanel();
        jScrollPane5 = new javax.swing.JScrollPane();
        jTable5 = new javax.swing.JTable();
        jButtonAcceptAdopt = new javax.swing.JButton();
        jButtonRejectAdopt = new javax.swing.JButton();
        jButtonReturnMM5 = new javax.swing.JButton();

        setDefaultCloseOperation(javax.swing.WindowConstants.EXIT_ON_CLOSE);

        jTabbedPane1.setToolTipText("");

        jTable1.setModel(new javax.swing.table.DefaultTableModel(
            new Object [][] {
                {null, null, null, null},
                {null, null, null, null},
                {null, null, null, null},
                {null, null, null, null}
            },
            new String [] {
                "Title 1", "Title 2", "Title 3", "Title 4"
            }
        ));
        jScrollPane1.setViewportView(jTable1);

        jButtonFilter1.setText("Filter");
        jButtonFilter1.addActionListener(this::jButtonFilter1ActionPerformed);

        jButtonCleanFilter1.setText("Clean Filter");
        jButtonCleanFilter1.addActionListener(this::jButtonCleanFilter1ActionPerformed);

        jButtonPutAdopt.setText("Put up for adoption");
        jButtonPutAdopt.addActionListener(this::jButtonPutAdoptActionPerformed);

        jButtonUndoAdoption.setText("Undo Adoption");
        jButtonUndoAdoption.addActionListener(this::jButtonUndoAdoptionActionPerformed);

        jButtonEditPet.setText("Edit Pet");
        jButtonEditPet.addActionListener(this::jButtonEditPetActionPerformed);

        jButtonReportMissing.setText("Report Missing");
        jButtonReportMissing.addActionListener(this::jButtonReportMissingActionPerformed);

        jButtonReturnMM.setText("Return to Main Menu");
        jButtonReturnMM.addActionListener(this::jButtonReturnMMActionPerformed);

        javax.swing.GroupLayout jPanel1Layout = new javax.swing.GroupLayout(jPanel1);
        jPanel1.setLayout(jPanel1Layout);
        jPanel1Layout.setHorizontalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jScrollPane1)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                    .addGroup(jPanel1Layout.createSequentialGroup()
                        .addComponent(jButtonFilter1, javax.swing.GroupLayout.PREFERRED_SIZE, 175, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jButtonCleanFilter1, javax.swing.GroupLayout.PREFERRED_SIZE, 180, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addGroup(jPanel1Layout.createSequentialGroup()
                        .addComponent(jButtonReportMissing, javax.swing.GroupLayout.PREFERRED_SIZE, 175, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jButtonReturnMM, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButtonPutAdopt, javax.swing.GroupLayout.PREFERRED_SIZE, 180, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButtonUndoAdoption, javax.swing.GroupLayout.PREFERRED_SIZE, 174, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButtonEditPet, javax.swing.GroupLayout.DEFAULT_SIZE, 146, Short.MAX_VALUE)
                .addContainerGap())
        );
        jPanel1Layout.setVerticalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addComponent(jScrollPane1, javax.swing.GroupLayout.PREFERRED_SIZE, 388, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(18, 18, 18)
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jButtonFilter1)
                    .addComponent(jButtonCleanFilter1)
                    .addComponent(jButtonPutAdopt)
                    .addComponent(jButtonUndoAdoption)
                    .addComponent(jButtonEditPet))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jButtonReportMissing)
                    .addComponent(jButtonReturnMM))
                .addGap(0, 9, Short.MAX_VALUE))
        );

        jTabbedPane1.addTab("My Pets", jPanel1);

        jTable2.setModel(new javax.swing.table.DefaultTableModel(
            new Object [][] {
                {null, null, null, null},
                {null, null, null, null},
                {null, null, null, null},
                {null, null, null, null}
            },
            new String [] {
                "Title 1", "Title 2", "Title 3", "Title 4"
            }
        ));
        jScrollPane2.setViewportView(jTable2);

        jButtonFilter2.setText("Filter");
        jButtonFilter2.addActionListener(this::jButtonFilter2ActionPerformed);

        jButtonCleanFilter2.setText("Clean Filter");
        jButtonCleanFilter2.addActionListener(this::jButtonCleanFilter2ActionPerformed);

        jButtonAdopt.setText("Adopt");
        jButtonAdopt.addActionListener(this::jButtonAdoptActionPerformed);

        jButtonReturnMM2.setText("Return to Main Menu");
        jButtonReturnMM2.addActionListener(this::jButtonReturnMM2ActionPerformed);

        javax.swing.GroupLayout jPanel2Layout = new javax.swing.GroupLayout(jPanel2);
        jPanel2.setLayout(jPanel2Layout);
        jPanel2Layout.setHorizontalGroup(
            jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jScrollPane2, javax.swing.GroupLayout.DEFAULT_SIZE, 891, Short.MAX_VALUE)
            .addGroup(jPanel2Layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jButtonFilter2, javax.swing.GroupLayout.PREFERRED_SIZE, 175, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButtonCleanFilter2, javax.swing.GroupLayout.PREFERRED_SIZE, 180, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButtonAdopt, javax.swing.GroupLayout.PREFERRED_SIZE, 180, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButtonReturnMM2, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addGap(152, 152, 152))
        );
        jPanel2Layout.setVerticalGroup(
            jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel2Layout.createSequentialGroup()
                .addComponent(jScrollPane2, javax.swing.GroupLayout.DEFAULT_SIZE, 407, Short.MAX_VALUE)
                .addGap(18, 18, 18)
                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jButtonFilter2)
                    .addComponent(jButtonCleanFilter2)
                    .addComponent(jButtonAdopt)
                    .addComponent(jButtonReturnMM2))
                .addGap(25, 25, 25))
        );

        jTabbedPane1.addTab("Adoption List", jPanel2);

        jTable3.setModel(new javax.swing.table.DefaultTableModel(
            new Object [][] {
                {null, null, null, null},
                {null, null, null, null},
                {null, null, null, null},
                {null, null, null, null}
            },
            new String [] {
                "Title 1", "Title 2", "Title 3", "Title 4"
            }
        ));
        jScrollPane3.setViewportView(jTable3);

        jButtonTakeBackMiss.setText("Take back missing report");
        jButtonTakeBackMiss.addActionListener(this::jButtonTakeBackMissActionPerformed);

        jButtonReturnMM3.setText("Return to Main Menu");
        jButtonReturnMM3.addActionListener(this::jButtonReturnMM3ActionPerformed);

        javax.swing.GroupLayout jPanel3Layout = new javax.swing.GroupLayout(jPanel3);
        jPanel3.setLayout(jPanel3Layout);
        jPanel3Layout.setHorizontalGroup(
            jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jScrollPane3, javax.swing.GroupLayout.DEFAULT_SIZE, 891, Short.MAX_VALUE)
            .addGroup(jPanel3Layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jButtonTakeBackMiss, javax.swing.GroupLayout.PREFERRED_SIZE, 199, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButtonReturnMM3, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addGap(500, 500, 500))
        );
        jPanel3Layout.setVerticalGroup(
            jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel3Layout.createSequentialGroup()
                .addComponent(jScrollPane3, javax.swing.GroupLayout.DEFAULT_SIZE, 409, Short.MAX_VALUE)
                .addGap(18, 18, 18)
                .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jButtonTakeBackMiss)
                    .addComponent(jButtonReturnMM3))
                .addGap(23, 23, 23))
        );

        jTabbedPane1.addTab("Missing Pets", jPanel3);

        jTable4.setModel(new javax.swing.table.DefaultTableModel(
            new Object [][] {
                {null, null, null, null},
                {null, null, null, null},
                {null, null, null, null},
                {null, null, null, null}
            },
            new String [] {
                "Title 1", "Title 2", "Title 3", "Title 4"
            }
        ));
        jScrollPane4.setViewportView(jTable4);

        jButton2.setText("Claim as mine");

        jButtonReturnMM4.setText("Return to Main Menu");
        jButtonReturnMM4.addActionListener(this::jButtonReturnMM4ActionPerformed);

        javax.swing.GroupLayout jPanel4Layout = new javax.swing.GroupLayout(jPanel4);
        jPanel4.setLayout(jPanel4Layout);
        jPanel4Layout.setHorizontalGroup(
            jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jScrollPane4, javax.swing.GroupLayout.DEFAULT_SIZE, 891, Short.MAX_VALUE)
            .addGroup(jPanel4Layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jButton2, javax.swing.GroupLayout.PREFERRED_SIZE, 175, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButtonReturnMM4)
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );
        jPanel4Layout.setVerticalGroup(
            jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel4Layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jScrollPane4, javax.swing.GroupLayout.PREFERRED_SIZE, 410, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(26, 26, 26)
                .addGroup(jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jButton2)
                    .addComponent(jButtonReturnMM4))
                .addGap(0, 8, Short.MAX_VALUE))
        );

        jTabbedPane1.addTab("Found Pets", jPanel4);

        jTable5.setModel(new javax.swing.table.DefaultTableModel(
            new Object [][] {
                {null, null, null, null},
                {null, null, null, null},
                {null, null, null, null},
                {null, null, null, null}
            },
            new String [] {
                "Title 1", "Title 2", "Title 3", "Title 4"
            }
        ));
        jScrollPane5.setViewportView(jTable5);

        jButtonAcceptAdopt.setText("Accept");
        jButtonAcceptAdopt.addActionListener(this::jButtonAcceptAdoptActionPerformed);

        jButtonRejectAdopt.setText("Reject");
        jButtonRejectAdopt.addActionListener(this::jButtonRejectAdoptActionPerformed);

        jButtonReturnMM5.setText("Return to Main Menu");
        jButtonReturnMM5.addActionListener(this::jButtonReturnMM5ActionPerformed);

        javax.swing.GroupLayout jPanel5Layout = new javax.swing.GroupLayout(jPanel5);
        jPanel5.setLayout(jPanel5Layout);
        jPanel5Layout.setHorizontalGroup(
            jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jScrollPane5, javax.swing.GroupLayout.DEFAULT_SIZE, 891, Short.MAX_VALUE)
            .addGroup(jPanel5Layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jButtonAcceptAdopt, javax.swing.GroupLayout.PREFERRED_SIZE, 171, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButtonRejectAdopt, javax.swing.GroupLayout.PREFERRED_SIZE, 158, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButtonReturnMM5)
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );
        jPanel5Layout.setVerticalGroup(
            jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel5Layout.createSequentialGroup()
                .addComponent(jScrollPane5, javax.swing.GroupLayout.PREFERRED_SIZE, 400, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(18, 18, 18)
                .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jButtonAcceptAdopt)
                    .addComponent(jButtonRejectAdopt)
                    .addComponent(jButtonReturnMM5))
                .addGap(0, 32, Short.MAX_VALUE))
        );

        jTabbedPane1.addTab("Adoption Aplications", jPanel5);

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(getContentPane());
        getContentPane().setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jTabbedPane1)
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jTabbedPane1, javax.swing.GroupLayout.PREFERRED_SIZE, 508, javax.swing.GroupLayout.PREFERRED_SIZE)
        );

        pack();
    }// </editor-fold>//GEN-END:initComponents

    private void jButtonFilter1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonFilter1ActionPerformed
            try {
                filterPanel1 = showFilterDialog(filterPanel1);
                loadPanel1Table();
            } catch (SQLException ex) {
                showError(ex);
            }
    }//GEN-LAST:event_jButtonFilter1ActionPerformed

    private void jButtonFilter2ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonFilter2ActionPerformed
            try {
                filterPanel2 = showFilterDialog(filterPanel2);
                loadPanel2Table();
            } catch (SQLException ex) {
                showError(ex);
            }
    }//GEN-LAST:event_jButtonFilter2ActionPerformed

    private void jButtonAdoptActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonAdoptActionPerformed
        try {
            int petId = controller.getSelectedPetIdFromTable(jTable2);
            AdoptForm adoptForm = new AdoptForm(petId, currentUserId, this);
            adoptForm.setVisible(true);
        } catch (SQLException ex) {
            showError(ex);
        }
    }//GEN-LAST:event_jButtonAdoptActionPerformed

    private void jButtonCleanFilter1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonCleanFilter1ActionPerformed
            filterPanel1 = new PetFilter();
            loadPanel1Table();
    }//GEN-LAST:event_jButtonCleanFilter1ActionPerformed

    private void jButtonPutAdoptActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonPutAdoptActionPerformed
            try {
                controller.putSelectedPetUpForAdoption(jTable1);

                JOptionPane.showMessageDialog(
                    this,
                    "Pet was put up for adoption."
                );

                loadTables();
                jButtonUndoAdoption.setVisible(false);
                jButtonEditPet.setEnabled(false);
                jButtonReportMissing.setEnabled(false);

            } catch (SQLException ex) {
                showError(ex);
            }
    }//GEN-LAST:event_jButtonPutAdoptActionPerformed

    private void jButtonCleanFilter2ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonCleanFilter2ActionPerformed
            filterPanel2 = new PetFilter();
            loadPanel2Table();
    }//GEN-LAST:event_jButtonCleanFilter2ActionPerformed

    private void jButtonUndoAdoptionActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonUndoAdoptionActionPerformed
            try {
                int option = JOptionPane.showConfirmDialog(
                    this,
                    "Do you want to change this pet back to Adopted?",
                    "Undo adoption post",
                    JOptionPane.YES_NO_OPTION
                );

                if (option != JOptionPane.YES_OPTION) {
                    return;
                }

                controller.undoSelectedPetUpForAdoption(jTable1);

                JOptionPane.showMessageDialog(
                    this,
                    "Pet was changed back to Adopted."
                );

                loadTables();
                jButtonUndoAdoption.setVisible(false);

            } catch (SQLException ex) {
                showError(ex);
            }
    }//GEN-LAST:event_jButtonUndoAdoptionActionPerformed

    private void jButtonEditPetActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonEditPetActionPerformed
            try {
                int petId = getSelectedPetIdFromTable();

                InsertPetFormForEdit editForm = new InsertPetFormForEdit(
                    petId,
                    currentUserId,
                    this
                );

                editForm.setVisible(true);
                this.setVisible(false);

            } catch (Exception ex) {
                showError(ex);
            }
    }//GEN-LAST:event_jButtonEditPetActionPerformed

    private void jButtonReportMissingActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonReportMissingActionPerformed
        try {
            if (isMissingState(getSelectedPetStateFromTable())) {
                JOptionPane.showMessageDialog(
                    this,
                    "This pet is already reported as missing."
                );
                jButtonReportMissing.setEnabled(false);
                return;
            }

            int petId = getSelectedPetIdFromTable();
            LostForm lostForm = new LostForm(petId, currentUserId, this);
            lostForm.setVisible(true);

        } catch (Exception ex) {
            showError(ex);
            updateReportMissingButtonState();
        }
    }//GEN-LAST:event_jButtonReportMissingActionPerformed

    private void jButtonAcceptAdoptActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonAcceptAdoptActionPerformed
        try {
            int option = JOptionPane.showConfirmDialog(
                this,
                "Do you want to accept this adoption request?",
                "Accept adoption",
                JOptionPane.YES_NO_OPTION
            );

            if (option != JOptionPane.YES_OPTION) {
                return;
            }

            controller.acceptSelectedAdoptionRequest(jTable5);
            JOptionPane.showMessageDialog(this, "Adoption accepted. The pet ownership was transferred.");
            loadTables();
            jTable5.clearSelection();
            updateAdoptionDecisionButtonsState();
        } catch (SQLException ex) {
            showError(ex);
        }
    }//GEN-LAST:event_jButtonAcceptAdoptActionPerformed

    private void jButtonRejectAdoptActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonRejectAdoptActionPerformed
        try {
            int option = JOptionPane.showConfirmDialog(
                this,
                "Do you want to reject this adoption request?",
                "Reject adoption",
                JOptionPane.YES_NO_OPTION
            );

            if (option != JOptionPane.YES_OPTION) {
                return;
            }

            controller.rejectSelectedAdoptionRequest(jTable5);
            JOptionPane.showMessageDialog(this, "Adoption request rejected.");
            loadTables();
            jTable5.clearSelection();
            updateAdoptionDecisionButtonsState();
        } catch (SQLException ex) {
            showError(ex);
        }
    }//GEN-LAST:event_jButtonRejectAdoptActionPerformed

    private void jButtonReturnMM5ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonReturnMM5ActionPerformed
        MainMenu window = new MainMenu(currentUserId);
        dispose();
    }//GEN-LAST:event_jButtonReturnMM5ActionPerformed

    private void jButtonReturnMMActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonReturnMMActionPerformed
            MainMenu window = new MainMenu(currentUserId);
            dispose();
    }//GEN-LAST:event_jButtonReturnMMActionPerformed

    private void jButtonReturnMM2ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonReturnMM2ActionPerformed
        MainMenu window = new MainMenu(currentUserId);
        dispose();
    }//GEN-LAST:event_jButtonReturnMM2ActionPerformed

    private void jButtonReturnMM3ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonReturnMM3ActionPerformed
        MainMenu window = new MainMenu(currentUserId);
        dispose();
    }//GEN-LAST:event_jButtonReturnMM3ActionPerformed

    private void jButtonReturnMM4ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonReturnMM4ActionPerformed
        MainMenu window = new MainMenu(currentUserId);
        dispose();
    }//GEN-LAST:event_jButtonReturnMM4ActionPerformed

    private void jButtonTakeBackMissActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonTakeBackMissActionPerformed
        try {
            int option = JOptionPane.showConfirmDialog(
                this,
                "Do you want to mark this pet as found?",
                "Take back missing report",
                JOptionPane.YES_NO_OPTION
            );

            if (option != JOptionPane.YES_OPTION) {
                return;
            }

            controller.takeBackSelectedMissingReport(jTable3);

            JOptionPane.showMessageDialog(
                this,
                "The pet was marked as found."
            );

            loadTables();
            jTable3.clearSelection();
            jButtonTakeBackMiss.setEnabled(false);

        } catch (SQLException ex) {
            showError(ex);
        }
    }//GEN-LAST:event_jButtonTakeBackMissActionPerformed

    /**
     * @param args the command line arguments
     */
    public static void main(String args[]) {
        /* Set the Nimbus look and feel */
        //<editor-fold defaultstate="collapsed" desc=" Look and feel setting code (optional) ">
        /* If Nimbus (introduced in Java SE 6) is not available, stay with the default look and feel.
         * For details see http://download.oracle.com/javase/tutorial/uiswing/lookandfeel/plaf.html 
         */
        try {
            for (javax.swing.UIManager.LookAndFeelInfo info : javax.swing.UIManager.getInstalledLookAndFeels()) {
                if ("Nimbus".equals(info.getName())) {
                    javax.swing.UIManager.setLookAndFeel(info.getClassName());
                    break;
                }
            }
        } catch (ReflectiveOperationException | javax.swing.UnsupportedLookAndFeelException ex) {
            logger.log(java.util.logging.Level.SEVERE, null, ex);
        }
        //</editor-fold>

        /* Create and display the form */
        java.awt.EventQueue.invokeLater(() -> new UserPetTable().setVisible(true));
    }

    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JButton jButton2;
    private javax.swing.JButton jButtonAcceptAdopt;
    private javax.swing.JButton jButtonAdopt;
    private javax.swing.JButton jButtonCleanFilter1;
    private javax.swing.JButton jButtonCleanFilter2;
    private javax.swing.JButton jButtonEditPet;
    private javax.swing.JButton jButtonFilter1;
    private javax.swing.JButton jButtonFilter2;
    private javax.swing.JButton jButtonPutAdopt;
    private javax.swing.JButton jButtonRejectAdopt;
    private javax.swing.JButton jButtonReportMissing;
    private javax.swing.JButton jButtonReturnMM;
    private javax.swing.JButton jButtonReturnMM2;
    private javax.swing.JButton jButtonReturnMM3;
    private javax.swing.JButton jButtonReturnMM4;
    private javax.swing.JButton jButtonReturnMM5;
    private javax.swing.JButton jButtonTakeBackMiss;
    private javax.swing.JButton jButtonUndoAdoption;
    private javax.swing.JPanel jPanel1;
    private javax.swing.JPanel jPanel2;
    private javax.swing.JPanel jPanel3;
    private javax.swing.JPanel jPanel4;
    private javax.swing.JPanel jPanel5;
    private javax.swing.JScrollPane jScrollPane1;
    private javax.swing.JScrollPane jScrollPane2;
    private javax.swing.JScrollPane jScrollPane3;
    private javax.swing.JScrollPane jScrollPane4;
    private javax.swing.JScrollPane jScrollPane5;
    private javax.swing.JTabbedPane jTabbedPane1;
    private javax.swing.JTable jTable1;
    private javax.swing.JTable jTable2;
    private javax.swing.JTable jTable3;
    private javax.swing.JTable jTable4;
    private javax.swing.JTable jTable5;
    // End of variables declaration//GEN-END:variables
}
