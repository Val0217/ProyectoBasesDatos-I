/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/GUIForms/JFrame.java to edit this template
 */
package animalwelfare.userInterface;
import animalwelfare.business.TableAdoptionController;
import java.awt.BorderLayout;
import java.awt.GridLayout;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.swing.JButton;
import javax.swing.JComboBox;
import javax.swing.JLabel;
import javax.swing.JOptionPane;
import javax.swing.JPanel;
import javax.swing.JTextField;
/**
 *
 * @author valer
 */
public class TableAdoption extends javax.swing.JFrame {
    
    private static final java.util.logging.Logger logger = java.util.logging.Logger.getLogger(TableAdoption.class.getName());
    private TableAdoptionController controller;
    /**
     * Creates new form TableAdoption
     */
    public TableAdoption() {
        initComponents();

        controller = new TableAdoptionController();

        controller.loadPetsUpForAdoption(jTable1);
        controller.loadFoundPets(jTable2);

        JButton filterAdoptionButton = new JButton("Filter");
        JButton clearAdoptionFiltersButton = new JButton("Clear Filters");

        filterAdoptionButton.addActionListener(e -> {
            Map<String, String> filters = showFilterDialog();

            if (filters != null) {
                controller.loadPetsUpForAdoption(jTable1, filters);
            }
        });

        clearAdoptionFiltersButton.addActionListener(e -> {
            controller.loadPetsUpForAdoption(jTable1);
        });

        JPanel adoptionButtonPanel = new JPanel();
        adoptionButtonPanel.add(filterAdoptionButton);
        adoptionButtonPanel.add(clearAdoptionFiltersButton);

        jPanel1.setLayout(new BorderLayout());
        jPanel1.remove(jScrollPane1);
        jPanel1.add(jScrollPane1, BorderLayout.CENTER);
        jPanel1.add(adoptionButtonPanel, BorderLayout.SOUTH);

        JButton putOnAdoptionButton = new JButton("Put on Adoption");
        JButton filterFoundButton = new JButton("Filter");
        JButton clearFoundFiltersButton = new JButton("Clear Filters");

        putOnAdoptionButton.addActionListener(e -> {
            controller.putSelectedPetUpForAdoption(jTable2, jTable1);
        });

        filterFoundButton.addActionListener(e -> {
            Map<String, String> filters = showFilterDialog();

            if (filters != null) {
                controller.loadFoundPets(jTable2, filters);
            }
        });

        clearFoundFiltersButton.addActionListener(e -> {
            controller.loadFoundPets(jTable2);
        });

        JPanel foundButtonPanel = new JPanel();
        foundButtonPanel.add(putOnAdoptionButton);
        foundButtonPanel.add(filterFoundButton);
        foundButtonPanel.add(clearFoundFiltersButton);

        jPanel2.setLayout(new BorderLayout());
        jPanel2.remove(jScrollPane2);
        jPanel2.add(jScrollPane2, BorderLayout.CENTER);
        jPanel2.add(foundButtonPanel, BorderLayout.SOUTH);

        jPanel1.revalidate();
        jPanel1.repaint();

        jPanel2.revalidate();
        jPanel2.repaint();
    }
    
private Map<String, String> showFilterDialog() {
    Map<String, List<String>> options = controller.getFilterOptions();

    JTextField colorField = new JTextField();
    JTextField ageField = new JTextField();
    JTextField nameField = new JTextField();
    JTextField chipField = new JTextField();

    JComboBox<String> energyComboBox = createComboBox(options.get("energy"));
    JComboBox<String> typeComboBox = createComboBox(options.get("type"));
    JComboBox<String> breedComboBox = createComboBox(options.get("breed"));
    JComboBox<String> districtComboBox = createComboBox(options.get("district"));
    JComboBox<String> spaceRequiredComboBox = createComboBox(options.get("spaceRequired"));
    JComboBox<String> trainingComboBox = createComboBox(options.get("training"));
    JComboBox<String> sizeComboBox = createComboBox(options.get("size"));
    JComboBox<String> veterinarianComboBox = createComboBox(options.get("veterinarian"));

    JPanel panel = new JPanel(new GridLayout(0, 2, 5, 5));

    panel.add(new JLabel("Color:"));
    panel.add(colorField);

    panel.add(new JLabel("Age:"));
    panel.add(ageField);

    panel.add(new JLabel("Name:"));
    panel.add(nameField);

    panel.add(new JLabel("Chip:"));
    panel.add(chipField);

    panel.add(new JLabel("Energy:"));
    panel.add(energyComboBox);

    panel.add(new JLabel("Type:"));
    panel.add(typeComboBox);

    panel.add(new JLabel("Breed:"));
    panel.add(breedComboBox);

    panel.add(new JLabel("District:"));
    panel.add(districtComboBox);

    panel.add(new JLabel("Space Required:"));
    panel.add(spaceRequiredComboBox);

    panel.add(new JLabel("Pet Training:"));
    panel.add(trainingComboBox);

    panel.add(new JLabel("Size:"));
    panel.add(sizeComboBox);

    panel.add(new JLabel("Veterinarian:"));
    panel.add(veterinarianComboBox);

    int result = JOptionPane.showConfirmDialog(
        this,
        panel,
        "Filter Pets",
        JOptionPane.OK_CANCEL_OPTION,
        JOptionPane.PLAIN_MESSAGE
    );

    if (result != JOptionPane.OK_OPTION) {
        return null;
    }

    Map<String, String> filters = new HashMap<>();

    filters.put("color", colorField.getText());
    filters.put("age", ageField.getText());
    filters.put("name", nameField.getText());
    filters.put("chip", chipField.getText());

    filters.put("energy", getSelectedComboValue(energyComboBox));
    filters.put("type", getSelectedComboValue(typeComboBox));
    filters.put("breed", getSelectedComboValue(breedComboBox));
    filters.put("district", getSelectedComboValue(districtComboBox));
    filters.put("spaceRequired", getSelectedComboValue(spaceRequiredComboBox));
    filters.put("training", getSelectedComboValue(trainingComboBox));
    filters.put("size", getSelectedComboValue(sizeComboBox));
    filters.put("veterinarian", getSelectedComboValue(veterinarianComboBox));

    return filters;
}

private JComboBox<String> createComboBox(List<String> values) {
    JComboBox<String> comboBox = new JComboBox<>();

    if (values == null || values.isEmpty()) {
        comboBox.addItem("All");
        return comboBox;
    }

    for (String value : values) {
        comboBox.addItem(value);
    }

    return comboBox;
}

private String getSelectedComboValue(JComboBox<String> comboBox) {
    Object selectedItem = comboBox.getSelectedItem();

    if (selectedItem == null) {
        return "";
    }

    String value = selectedItem.toString();

    if (value.equals("All")) {
        return "";
    }

    return value;
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
        jPanel2 = new javax.swing.JPanel();
        jScrollPane2 = new javax.swing.JScrollPane();
        jTable2 = new javax.swing.JTable();

        setDefaultCloseOperation(javax.swing.WindowConstants.EXIT_ON_CLOSE);

        jTabbedPane1.addChangeListener(this::jTabbedPane1StateChanged);

        jPanel1.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                jPanel1MouseClicked(evt);
            }
        });

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

        javax.swing.GroupLayout jPanel1Layout = new javax.swing.GroupLayout(jPanel1);
        jPanel1.setLayout(jPanel1Layout);
        jPanel1Layout.setHorizontalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jScrollPane1, javax.swing.GroupLayout.DEFAULT_SIZE, 928, Short.MAX_VALUE)
        );
        jPanel1Layout.setVerticalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jScrollPane1, javax.swing.GroupLayout.DEFAULT_SIZE, 409, Short.MAX_VALUE)
        );

        jTabbedPane1.addTab("Pets Up for Adoption", jPanel1);

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

        javax.swing.GroupLayout jPanel2Layout = new javax.swing.GroupLayout(jPanel2);
        jPanel2.setLayout(jPanel2Layout);
        jPanel2Layout.setHorizontalGroup(
            jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jScrollPane2, javax.swing.GroupLayout.DEFAULT_SIZE, 928, Short.MAX_VALUE)
        );
        jPanel2Layout.setVerticalGroup(
            jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jScrollPane2, javax.swing.GroupLayout.DEFAULT_SIZE, 409, Short.MAX_VALUE)
        );

        jTabbedPane1.addTab("Put on Adoption", jPanel2);

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(getContentPane());
        getContentPane().setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addComponent(jTabbedPane1, javax.swing.GroupLayout.PREFERRED_SIZE, 928, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(0, 0, Short.MAX_VALUE))
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jTabbedPane1)
        );

        jTabbedPane1.getAccessibleContext().setAccessibleName("Adopt");

        pack();
    }// </editor-fold>//GEN-END:initComponents

    private void jPanel1MouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jPanel1MouseClicked
        // TODO add your handling code here:
    }//GEN-LAST:event_jPanel1MouseClicked

    private void jTabbedPane1StateChanged(javax.swing.event.ChangeEvent evt) {//GEN-FIRST:event_jTabbedPane1StateChanged
         if (jTabbedPane1.getSelectedComponent() == jPanel1) {
        refreshPetsForAdoption();
    }
    }//GEN-LAST:event_jTabbedPane1StateChanged

    private void refreshPetsForAdoption() {
    // Cargar los pets del db otra vez
    // Update  panel/table/list
    }

    private void refreshPutOnAdoption() {
        // Refresh el segundo tab si se ocupa
    }
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
        java.awt.EventQueue.invokeLater(() -> new TableAdoption().setVisible(true));
    }

    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JPanel jPanel1;
    private javax.swing.JPanel jPanel2;
    private javax.swing.JScrollPane jScrollPane1;
    private javax.swing.JScrollPane jScrollPane2;
    private javax.swing.JTabbedPane jTabbedPane1;
    private javax.swing.JTable jTable1;
    private javax.swing.JTable jTable2;
    // End of variables declaration//GEN-END:variables
}
