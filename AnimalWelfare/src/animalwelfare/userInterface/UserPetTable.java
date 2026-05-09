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
    private int currentUserId = 1;
    /**
     * Creates new form UserPetTable
     */
    public UserPetTable() {
        initComponents();

        controller = new UserPetTableController(currentUserId);

        prepareTables();
        addTableSelectionListeners();
        loadTables();
    }
    private void prepareTables() {
        jTable1.setDefaultEditor(Object.class, null);
        jTable2.setDefaultEditor(Object.class, null);

        jTable1.getTableHeader().setReorderingAllowed(false);
        jTable2.getTableHeader().setReorderingAllowed(false);

        jButtonAdopt.setEnabled(false); //Boton de adoptar no hace nada  
        jButtonUndoAdoption.setVisible(false);
    }
    private void addTableSelectionListeners() {
        jTable1.getSelectionModel().addListSelectionListener(event -> {
            if (!event.getValueIsAdjusting()) {
                updateUndoAdoptionButtonVisibility();
            }
        });
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
                || state.equalsIgnoreCase("En Adopción")
                || state.equalsIgnoreCase("Up for adoption")
                || state.equals("1");

        jButtonUndoAdoption.setVisible(isUpForAdoption);
    }
    private void loadTables() {
        try {
            controller.loadUserPets(jTable1, filterPanel1);
            controller.loadAdoptionPets(jTable2, filterPanel2);
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
        jButton2 = new javax.swing.JButton();
        jPanel2 = new javax.swing.JPanel();
        jScrollPane2 = new javax.swing.JScrollPane();
        jTable2 = new javax.swing.JTable();
        jButtonFilter2 = new javax.swing.JButton();
        jButtonCleanFilter2 = new javax.swing.JButton();
        jButtonAdopt = new javax.swing.JButton();

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

        jButton2.setText("Edit Pet");
        jButton2.addActionListener(this::jButton2ActionPerformed);

        javax.swing.GroupLayout jPanel1Layout = new javax.swing.GroupLayout(jPanel1);
        jPanel1.setLayout(jPanel1Layout);
        jPanel1Layout.setHorizontalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jScrollPane1)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jButtonFilter1, javax.swing.GroupLayout.PREFERRED_SIZE, 175, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButtonCleanFilter1, javax.swing.GroupLayout.PREFERRED_SIZE, 180, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButtonPutAdopt, javax.swing.GroupLayout.PREFERRED_SIZE, 180, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButtonUndoAdoption, javax.swing.GroupLayout.PREFERRED_SIZE, 174, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButton2, javax.swing.GroupLayout.DEFAULT_SIZE, 146, Short.MAX_VALUE)
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
                    .addComponent(jButton2))
                .addGap(0, 21, Short.MAX_VALUE))
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
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );
        jPanel2Layout.setVerticalGroup(
            jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel2Layout.createSequentialGroup()
                .addComponent(jScrollPane2, javax.swing.GroupLayout.PREFERRED_SIZE, 387, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(18, 18, 18)
                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jButtonFilter2)
                    .addComponent(jButtonCleanFilter2)
                    .addComponent(jButtonAdopt))
                .addGap(0, 22, Short.MAX_VALUE))
        );

        jTabbedPane1.addTab("Adoption List", jPanel2);

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(getContentPane());
        getContentPane().setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jTabbedPane1)
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jTabbedPane1)
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
            JOptionPane.showMessageDialog(
                this,
                "Adopt function is not available yet."
            );
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

    private void jButton2ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton2ActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_jButton2ActionPerformed

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
    private javax.swing.JButton jButtonAdopt;
    private javax.swing.JButton jButtonCleanFilter1;
    private javax.swing.JButton jButtonCleanFilter2;
    private javax.swing.JButton jButtonFilter1;
    private javax.swing.JButton jButtonFilter2;
    private javax.swing.JButton jButtonPutAdopt;
    private javax.swing.JButton jButtonUndoAdoption;
    private javax.swing.JPanel jPanel1;
    private javax.swing.JPanel jPanel2;
    private javax.swing.JScrollPane jScrollPane1;
    private javax.swing.JScrollPane jScrollPane2;
    private javax.swing.JTabbedPane jTabbedPane1;
    private javax.swing.JTable jTable1;
    private javax.swing.JTable jTable2;
    // End of variables declaration//GEN-END:variables
}
