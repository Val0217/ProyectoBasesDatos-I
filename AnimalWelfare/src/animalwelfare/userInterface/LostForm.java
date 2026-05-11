/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/GUIForms/JFrame.java to edit this template
 */
package animalwelfare.userInterface;
import animalwelfare.access.UserPetOperations.CatalogItem;
import animalwelfare.business.UserPetTableController;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.Map;
import javax.swing.JOptionPane;
import javax.swing.JFormattedTextField;
import javax.swing.text.NumberFormatter;
import java.text.DecimalFormat;
import java.util.Date;
import javax.swing.JButton;
import javax.swing.JDialog;
import javax.swing.JPanel;
import javax.swing.JSpinner;
import javax.swing.SpinnerDateModel;
import java.awt.BorderLayout;
import java.awt.FlowLayout;
/**
 *
 * @author valer
 */
public class LostForm extends javax.swing.JFrame {
    
    private static final java.util.logging.Logger logger = java.util.logging.Logger.getLogger(LostForm.class.getName());
    private UserPetTableController controller;
    private UserPetTable parent;
    private int petId;
    private final Map<String, Integer> currencyIdsByName = new HashMap<>();

    /**
     * Creates new form LostForm
     */
    public LostForm() {
        initComponents();
        
        
    }

    public LostForm(int petId, int currentUserId, UserPetTable parent) {
        initComponents();
        setLocationRelativeTo(parent);
        this.petId = petId;
        this.parent = parent;
        this.controller = new UserPetTableController(currentUserId);
        setDefaultCloseOperation(javax.swing.WindowConstants.DISPOSE_ON_CLOSE);
        loadCurrencies();
        configureFormattedFields();
        configureDatePicker();
    }
    private void configureDatePicker() {
        jFormattedTextFieldDateLost.setEditable(false);
        jFormattedTextFieldDateLost.setToolTipText("Click to select a date");

        jFormattedTextFieldDateLost.addMouseListener(new java.awt.event.MouseAdapter() {
            @Override
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                showDatePickerDialog();
            }
        });
    }
    private void showDatePickerDialog() {
        JDialog dialog = new JDialog(this, "Select lost date", true);
        dialog.setLayout(new BorderLayout());

        SpinnerDateModel dateModel = new SpinnerDateModel();
        JSpinner dateSpinner = new JSpinner(dateModel);

        JSpinner.DateEditor dateEditor = new JSpinner.DateEditor(dateSpinner, "dd/MM/yyyy");
        dateSpinner.setEditor(dateEditor);

        JButton btnOk = new JButton("OK");
        JButton btnCancel = new JButton("Cancel");

        btnOk.addActionListener(e -> {
            Date selectedDate = (Date) dateSpinner.getValue();

            SimpleDateFormat format = new SimpleDateFormat("dd/MM/yyyy");
            jFormattedTextFieldDateLost.setText(format.format(selectedDate));
            jFormattedTextFieldDateLost.setValue(selectedDate);

            dialog.dispose();
        });

        btnCancel.addActionListener(e -> dialog.dispose());

        JPanel buttonPanel = new JPanel(new FlowLayout(FlowLayout.RIGHT));
        buttonPanel.add(btnCancel);
        buttonPanel.add(btnOk);

        dialog.add(dateSpinner, BorderLayout.CENTER);
        dialog.add(buttonPanel, BorderLayout.SOUTH);

        dialog.pack();
        dialog.setLocationRelativeTo(this);
        dialog.setVisible(true);
    }
    private void configureFormattedFields() {
        DecimalFormat decimalFormat = new DecimalFormat("#0.00");
        decimalFormat.setParseBigDecimal(true);

        NumberFormatter rewardFormatter = new NumberFormatter(decimalFormat);
        rewardFormatter.setValueClass(java.math.BigDecimal.class);
        rewardFormatter.setAllowsInvalid(false);
        rewardFormatter.setMinimum(java.math.BigDecimal.ZERO);

        jFormattedTextFieldReward.setFormatterFactory(
            new javax.swing.text.DefaultFormatterFactory(rewardFormatter)
        );

        jFormattedTextFieldReward.setFocusLostBehavior(JFormattedTextField.COMMIT_OR_REVERT);
    }
    private void loadCurrencies() {
        try {
            jComboBoxCurrency.removeAllItems();
            currencyIdsByName.clear();

            for (CatalogItem item : controller.getCatalog("CURRENCY")) {
                if (item.getId() == null) {
                    continue;
                }

                String name = item.toString();
                jComboBoxCurrency.addItem(name);
                currencyIdsByName.put(name, item.getId());
            }
        } catch (SQLException ex) {
            JOptionPane.showMessageDialog(this, ex.getMessage(), "Error", JOptionPane.ERROR_MESSAGE);
        }
    }

    private java.sql.Date readLostDate() throws ParseException {
        Object value = jFormattedTextFieldDateLost.getValue();

        if (value instanceof java.util.Date) {
            return new java.sql.Date(((java.util.Date) value).getTime());
        }

        String text = jFormattedTextFieldDateLost.getText() == null
                ? ""
                : jFormattedTextFieldDateLost.getText().trim();

        if (text.isEmpty()) {
            throw new ParseException("Lost date is required.", 0);
        }

        java.util.Date parsedDate;
        try {
            parsedDate = new SimpleDateFormat("M/d/yy").parse(text);
        } catch (ParseException ex) {
            parsedDate = new SimpleDateFormat("yyyy-MM-dd").parse(text);
        }

        return new java.sql.Date(parsedDate.getTime());
    }

    private BigDecimal readReward() {
        Object value = jFormattedTextFieldReward.getValue();
        if (value instanceof Number) {
            return BigDecimal.valueOf(((Number) value).doubleValue());
        }

        String text = jFormattedTextFieldReward.getText() == null
                ? ""
                : jFormattedTextFieldReward.getText().trim();

        if (text.isEmpty()) {
            return null;
        }

        return new BigDecimal(text);
    }
    /**
     * This method is called from within the constructor to initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is always
     * regenerated by the Form Editor.
     */
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        jLabel1 = new javax.swing.JLabel();
        jLabel2 = new javax.swing.JLabel();
        jFormattedTextFieldDateLost = new javax.swing.JFormattedTextField();
        jLabel3 = new javax.swing.JLabel();
        jTextFieldLastPlace = new javax.swing.JTextField();
        jLabel4 = new javax.swing.JLabel();
        jTextFieldDescriptionLost = new javax.swing.JTextField();
        jLabel5 = new javax.swing.JLabel();
        jFormattedTextFieldReward = new javax.swing.JFormattedTextField();
        jLabel7 = new javax.swing.JLabel();
        jComboBoxCurrency = new javax.swing.JComboBox<>();
        jButtonSubmitLostReport = new javax.swing.JButton();

        setDefaultCloseOperation(javax.swing.WindowConstants.EXIT_ON_CLOSE);

        jLabel1.setFont(new java.awt.Font("Segoe UI", 0, 24)); // NOI18N
        jLabel1.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        jLabel1.setText("Lost Report");

        jLabel2.setText("Lost Date:");

        jFormattedTextFieldDateLost.setFormatterFactory(new javax.swing.text.DefaultFormatterFactory(new javax.swing.text.DateFormatter()));
        jFormattedTextFieldDateLost.addActionListener(this::jFormattedTextFieldDateLostActionPerformed);

        jLabel3.setText("Last place it was seen:");

        jTextFieldLastPlace.addActionListener(this::jTextFieldLastPlaceActionPerformed);

        jLabel4.setText("Description");

        jLabel5.setText("Reward for finding the pet (Optional):");

        jFormattedTextFieldReward.setFormatterFactory(new javax.swing.text.DefaultFormatterFactory(new javax.swing.text.NumberFormatter(new java.text.DecimalFormat("#0.00"))));

        jLabel7.setText("Currency:");

        jButtonSubmitLostReport.setText("Submit");
        jButtonSubmitLostReport.addActionListener(this::jButtonSubmitLostReportActionPerformed);

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(getContentPane());
        getContentPane().setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(layout.createSequentialGroup()
                        .addContainerGap()
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(layout.createSequentialGroup()
                                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addComponent(jFormattedTextFieldDateLost, javax.swing.GroupLayout.PREFERRED_SIZE, 127, javax.swing.GroupLayout.PREFERRED_SIZE)
                                    .addComponent(jLabel2))
                                .addGap(18, 18, 18)
                                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addComponent(jLabel3, javax.swing.GroupLayout.PREFERRED_SIZE, 140, javax.swing.GroupLayout.PREFERRED_SIZE)
                                    .addComponent(jTextFieldLastPlace, javax.swing.GroupLayout.PREFERRED_SIZE, 290, javax.swing.GroupLayout.PREFERRED_SIZE)))
                            .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING, false)
                                .addComponent(jFormattedTextFieldReward, javax.swing.GroupLayout.Alignment.LEADING)
                                .addComponent(jLabel5, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))))
                    .addGroup(layout.createSequentialGroup()
                        .addContainerGap()
                        .addComponent(jLabel4))
                    .addGroup(layout.createSequentialGroup()
                        .addContainerGap()
                        .addComponent(jTextFieldDescriptionLost, javax.swing.GroupLayout.PREFERRED_SIZE, 394, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addGroup(layout.createSequentialGroup()
                        .addContainerGap()
                        .addComponent(jLabel7))
                    .addGroup(layout.createSequentialGroup()
                        .addContainerGap()
                        .addComponent(jComboBoxCurrency, javax.swing.GroupLayout.PREFERRED_SIZE, 200, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addGroup(layout.createSequentialGroup()
                        .addGap(94, 94, 94)
                        .addComponent(jLabel1, javax.swing.GroupLayout.PREFERRED_SIZE, 284, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addGroup(layout.createSequentialGroup()
                        .addContainerGap()
                        .addComponent(jButtonSubmitLostReport, javax.swing.GroupLayout.PREFERRED_SIZE, 114, javax.swing.GroupLayout.PREFERRED_SIZE)))
                .addContainerGap(48, Short.MAX_VALUE))
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addGap(16, 16, 16)
                .addComponent(jLabel1, javax.swing.GroupLayout.PREFERRED_SIZE, 40, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel2)
                    .addComponent(jLabel3))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jTextFieldLastPlace, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jFormattedTextFieldDateLost, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addGap(18, 18, 18)
                .addComponent(jLabel5)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jFormattedTextFieldReward, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jLabel7)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jComboBoxCurrency, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(18, 18, 18)
                .addComponent(jLabel4)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jTextFieldDescriptionLost, javax.swing.GroupLayout.PREFERRED_SIZE, 151, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(18, 18, 18)
                .addComponent(jButtonSubmitLostReport)
                .addContainerGap(21, Short.MAX_VALUE))
        );

        pack();
    }// </editor-fold>//GEN-END:initComponents

    private void jTextFieldLastPlaceActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jTextFieldLastPlaceActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_jTextFieldLastPlaceActionPerformed

    private void jButtonSubmitLostReportActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButtonSubmitLostReportActionPerformed
        Date lostDate = (Date) jFormattedTextFieldDateLost.getValue();
        if (lostDate == null) {
            JOptionPane.showMessageDialog(
                this,
                "Please select the lost date.",
                "Missing date",
                JOptionPane.WARNING_MESSAGE
            );
            return;
        }
        
        if (controller == null) {
            JOptionPane.showMessageDialog(this, "Open this form from My Pets.");
            return;
        }

        String place = jTextFieldLastPlace.getText() == null ? "" : jTextFieldLastPlace.getText().trim();
        String description = jTextFieldDescriptionLost.getText() == null ? "" : jTextFieldDescriptionLost.getText().trim();
        String selectedCurrency = (String) jComboBoxCurrency.getSelectedItem();

        if (place.isEmpty() || description.isEmpty()) {
            JOptionPane.showMessageDialog(this, "Lost place and description are required.");
            return;
        }

        if (selectedCurrency == null || !currencyIdsByName.containsKey(selectedCurrency)) {
            JOptionPane.showMessageDialog(this, "Select a currency.");
            return;
        }

        try {
            controller.registerLostReport(
                    petId,
                    readLostDate(),
                    place,
                    description,
                    readReward(),
                    currencyIdsByName.get(selectedCurrency)
            );

            JOptionPane.showMessageDialog(this, "Lost report submitted.");

            if (parent != null) {
                parent.refreshAfterLostReport();
                parent.setVisible(true);
            }

            dispose();
        } catch (SQLException | ParseException | NumberFormatException ex) {
            JOptionPane.showMessageDialog(this, ex.getMessage(), "Error", JOptionPane.ERROR_MESSAGE);
        }
    }//GEN-LAST:event_jButtonSubmitLostReportActionPerformed

    private void jFormattedTextFieldDateLostActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jFormattedTextFieldDateLostActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_jFormattedTextFieldDateLostActionPerformed

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
        java.awt.EventQueue.invokeLater(() -> new LostForm().setVisible(true));
    }

    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JButton jButtonSubmitLostReport;
    private javax.swing.JComboBox<String> jComboBoxCurrency;
    private javax.swing.JFormattedTextField jFormattedTextFieldDateLost;
    private javax.swing.JFormattedTextField jFormattedTextFieldReward;
    private javax.swing.JLabel jLabel1;
    private javax.swing.JLabel jLabel2;
    private javax.swing.JLabel jLabel3;
    private javax.swing.JLabel jLabel4;
    private javax.swing.JLabel jLabel5;
    private javax.swing.JLabel jLabel7;
    private javax.swing.JTextField jTextFieldDescriptionLost;
    private javax.swing.JTextField jTextFieldLastPlace;
    // End of variables declaration//GEN-END:variables
}
