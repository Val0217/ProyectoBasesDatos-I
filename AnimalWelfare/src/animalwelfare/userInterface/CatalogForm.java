package animalwelfare.userInterface;

import animalwelfare.access.ConexionOracle;
import animalwelfare.access.DbObject;
import animalwelfare.business.CatalogController;
import animalwelfare.security.Session;
import java.awt.*;
import java.sql.*;
import java.util.List;
import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import javax.swing.table.JTableHeader;

/**
 * Admin catalog management screen.
 * Allows adding, editing and deleting records from all catalog tables.
 * Only accessible by Admin users.
 *
 * View only — all validation and persistence is handled by CatalogController.
 *
 * @author team
 */
public class CatalogForm extends javax.swing.JFrame {

    private static final java.util.logging.Logger logger =
        java.util.logging.Logger.getLogger(CatalogForm.class.getName());

    private CatalogController controller;

    // Each catalog tab uses these components
    private static class CatalogPanel extends JPanel {
        JTable table;
        JTextField txtName;
        JTextField txtExtra;           // Medicine → Dose
        JLabel lblExtra;
        JComboBox<DbObject> comboExtra; // PetBreed → PetType selector
        JButton btnAdd;
        JButton btnUpdate;
        JButton btnDelete;
        JButton btnClear;
        String tableName;
        String[] columns;
        boolean hasExtra;
        boolean hasComboExtra;
    }

    public CatalogForm() {
        initComponents();
        setLocationRelativeTo(null);
        setVisible(true);
    }

    private void initComponents() {
        controller = new CatalogController(this);

        setTitle("Catalog Management — Animal Welfare");
        setDefaultCloseOperation(javax.swing.WindowConstants.DISPOSE_ON_CLOSE);
        setMinimumSize(new Dimension(750, 560));

        // Header
        JPanel header = new JPanel(new FlowLayout(FlowLayout.LEFT, 20, 14));
        header.setBackground(new Color(0, 153, 153));
        header.setPreferredSize(new Dimension(750, 58));

        JLabel title = new JLabel("CATALOG MANAGEMENT");
        title.setFont(new Font("Segoe UI", Font.BOLD, 22));
        title.setForeground(Color.WHITE);
        header.add(title);

        JButton btnBack = new JButton("← Back");
        btnBack.setBackground(new Color(0, 102, 102));
        btnBack.setForeground(Color.WHITE);
        btnBack.setFocusPainted(false);
        btnBack.setBorderPainted(false);
        btnBack.setOpaque(true);
        btnBack.setCursor(new Cursor(Cursor.HAND_CURSOR));
        btnBack.addActionListener(e -> {
            new MainMenu(Session.getInstance().getUserId()).setVisible(true);
            dispose();
        });
        header.add(btnBack);

        // Tabs
        JTabbedPane tabs = new JTabbedPane();
        tabs.setFont(new Font("Segoe UI", Font.PLAIN, 12));
        tabs.addTab("Pet Type",     buildSimpleTab("PetType",        new String[]{"ID","Name"}));
        tabs.addTab("Pet Breed",    buildBreedTab());
        tabs.addTab("Pet State",    buildSimpleTab("PetState",       new String[]{"ID","Name"}));
        tabs.addTab("Pet Size",     buildSimpleTab("PetSize",        new String[]{"ID","Name"}));
        tabs.addTab("Energy Level", buildSimpleTab("PetLevelEnergy", new String[]{"ID","Name"}));
        tabs.addTab("Training",     buildSimpleTab("PetTraining",    new String[]{"ID","Name"}));
        tabs.addTab("Space Req.",   buildSimpleTab("SpaceRequired",  new String[]{"ID","Name"}));
        tabs.addTab("Severity",     buildSimpleTab("PetSeverity",    new String[]{"ID","Name"}));
        tabs.addTab("Illness",      buildSimpleTab("PetIllness",     new String[]{"ID","Name"}));
        tabs.addTab("Medicine",     buildMedicineTab());
        tabs.addTab("Treatment",    buildSimpleTab("PetTreatment",   new String[]{"ID","Name"}));
        tabs.addTab("Currency",     buildSimpleTab("Currency",       new String[]{"ID","Name"}));
        tabs.addTab("Association",  buildAssociationTab());

        getContentPane().setLayout(new BorderLayout());
        getContentPane().add(header, BorderLayout.NORTH);
        getContentPane().add(tabs,   BorderLayout.CENTER);
        pack();
    }

    // =========================================================================
    // Simple tab — only Name field
    // =========================================================================
    private JPanel buildSimpleTab(String tableName, String[] columns) {
        CatalogPanel cp = new CatalogPanel();
        cp.tableName = tableName;
        cp.columns   = columns;
        cp.hasExtra  = false;
        cp.setLayout(new BorderLayout(0, 8));
        cp.setBackground(Color.WHITE);
        cp.setBorder(BorderFactory.createEmptyBorder(10, 14, 10, 14));

        JPanel formPanel = buildFormBorder("Record");
        formPanel.add(styledLabel("Name *"));
        cp.txtName = new JTextField(20);
        cp.txtName.setFont(new Font("Segoe UI", Font.PLAIN, 13));
        formPanel.add(cp.txtName);

        cp.btnAdd    = tealButton("ADD");
        cp.btnUpdate = tealButton("UPDATE");
        cp.btnDelete = redButton("DELETE");
        cp.btnClear  = grayButton("CLEAR");
        formPanel.add(cp.btnAdd);
        formPanel.add(cp.btnUpdate);
        formPanel.add(cp.btnDelete);
        formPanel.add(cp.btnClear);

        cp.table = buildTable(columns);
        JScrollPane scroll = new JScrollPane(cp.table);
        scroll.setBorder(BorderFactory.createLineBorder(new Color(200,200,200)));

        JLabel lblCount = countLabel();
        JPanel footer = footerPanel(lblCount);

        cp.add(formPanel, BorderLayout.NORTH);
        cp.add(scroll,    BorderLayout.CENTER);
        cp.add(footer,    BorderLayout.SOUTH);

        // Select row → fill form
        cp.table.getSelectionModel().addListSelectionListener(e -> {
            if (!e.getValueIsAdjusting() && cp.table.getSelectedRow() >= 0) {
                int row = cp.table.convertRowIndexToModel(cp.table.getSelectedRow());
                cp.txtName.setText(cp.table.getModel().getValueAt(row, 1).toString());
            }
        });

        cp.btnClear.addActionListener(e -> { cp.txtName.setText(""); cp.table.clearSelection(); });

        cp.btnAdd.addActionListener(e -> {
            String name = cp.txtName.getText().trim();
            if (controller.addSimple(tableName, name)) {
                cp.txtName.setText("");
                refreshSimple(cp, lblCount);
            }
        });

        cp.btnUpdate.addActionListener(e -> {
            int selRow = cp.table.getSelectedRow();
            if (selRow < 0) { showSelectFirst(); return; }
            int id = selectedId(cp.table);
            String name = cp.txtName.getText().trim();
            if (controller.editSimple(tableName, id, name)) {
                refreshSimple(cp, lblCount);
            }
        });

        cp.btnDelete.addActionListener(e -> {
            int selRow = cp.table.getSelectedRow();
            if (selRow < 0) { showSelectFirst(); return; }
            int id = selectedId(cp.table);
            if (controller.removeSimple(tableName, id)) {
                refreshSimple(cp, lblCount);
            }
        });

        refreshSimple(cp, lblCount);
        return cp;
    }

    private void refreshSimple(CatalogPanel cp, JLabel lblCount) {
        List<DbObject> rows = controller.loadSimple(cp.tableName);
        DefaultTableModel model = new DefaultTableModel(cp.columns, 0) {
            @Override public boolean isCellEditable(int r, int c) { return false; }
        };
        for (DbObject obj : rows) {
            model.addRow(new Object[]{obj.getId(), obj.getName()});
        }
        cp.table.setModel(model);
        hideIdColumn(cp.table);
        lblCount.setText("Records: " + model.getRowCount());
    }

    // =========================================================================
    // Breed tab — extra combo for PetType
    // =========================================================================
    private JPanel buildBreedTab() {
        CatalogPanel cp = new CatalogPanel();
        cp.tableName     = "PetBreed";
        cp.columns       = new String[]{"ID", "Name", "Type"};
        cp.hasComboExtra = true;
        cp.setLayout(new BorderLayout(0, 8));
        cp.setBackground(Color.WHITE);
        cp.setBorder(BorderFactory.createEmptyBorder(10, 14, 10, 14));

        JPanel formPanel = buildFormBorder("Record");
        formPanel.add(styledLabel("Name *"));
        cp.txtName = new JTextField(15);
        cp.txtName.setFont(new Font("Segoe UI", Font.PLAIN, 13));
        formPanel.add(cp.txtName);

        formPanel.add(styledLabel("Pet Type *"));
        cp.comboExtra = new JComboBox<>();
        cp.comboExtra.setFont(new Font("Segoe UI", Font.PLAIN, 13));
        cp.comboExtra.setPreferredSize(new Dimension(130, 28));
        loadComboFromTable(cp.comboExtra, "PetType");
        formPanel.add(cp.comboExtra);

        cp.btnAdd    = tealButton("ADD");
        cp.btnUpdate = tealButton("UPDATE");
        cp.btnDelete = redButton("DELETE");
        cp.btnClear  = grayButton("CLEAR");
        formPanel.add(cp.btnAdd);
        formPanel.add(cp.btnUpdate);
        formPanel.add(cp.btnDelete);
        formPanel.add(cp.btnClear);

        cp.table = buildTable(cp.columns);
        JScrollPane scroll = new JScrollPane(cp.table);
        JLabel lblCount = countLabel();
        JPanel footer = footerPanel(lblCount);

        cp.add(formPanel, BorderLayout.NORTH);
        cp.add(scroll,    BorderLayout.CENTER);
        cp.add(footer,    BorderLayout.SOUTH);

        cp.table.getSelectionModel().addListSelectionListener(e -> {
            if (!e.getValueIsAdjusting() && cp.table.getSelectedRow() >= 0) {
                int row = cp.table.convertRowIndexToModel(cp.table.getSelectedRow());
                cp.txtName.setText(cp.table.getModel().getValueAt(row, 1).toString());
            }
        });

        cp.btnClear.addActionListener(e -> { cp.txtName.setText(""); cp.table.clearSelection(); });

        cp.btnAdd.addActionListener(e -> {
            DbObject type = (DbObject) cp.comboExtra.getSelectedItem();
            if (controller.addBreed(cp.txtName.getText().trim(), type)) {
                cp.txtName.setText("");
                refreshBreeds(cp, lblCount);
            }
        });

        cp.btnUpdate.addActionListener(e -> {
            if (cp.table.getSelectedRow() < 0) { showSelectFirst(); return; }
            DbObject type = (DbObject) cp.comboExtra.getSelectedItem();
            if (controller.editBreed(selectedId(cp.table), cp.txtName.getText().trim(), type)) {
                refreshBreeds(cp, lblCount);
            }
        });

        cp.btnDelete.addActionListener(e -> {
            if (cp.table.getSelectedRow() < 0) { showSelectFirst(); return; }
            if (controller.removeBreed(selectedId(cp.table))) {
                refreshBreeds(cp, lblCount);
            }
        });

        refreshBreeds(cp, lblCount);
        return cp;
    }

    private void refreshBreeds(CatalogPanel cp, JLabel lblCount) {
        List<Object[]> rows = controller.loadBreeds();
        DefaultTableModel model = new DefaultTableModel(cp.columns, 0) {
            @Override public boolean isCellEditable(int r, int c) { return false; }
        };
        for (Object[] row : rows) model.addRow(row);
        cp.table.setModel(model);
        hideIdColumn(cp.table);
        lblCount.setText("Records: " + model.getRowCount());
    }

    // =========================================================================
    // Medicine tab — extra Dose field
    // =========================================================================
    private JPanel buildMedicineTab() {
        CatalogPanel cp = new CatalogPanel();
        cp.tableName = "Medicine";
        cp.columns   = new String[]{"ID", "Name", "Dose"};
        cp.hasExtra  = true;
        cp.setLayout(new BorderLayout(0, 8));
        cp.setBackground(Color.WHITE);
        cp.setBorder(BorderFactory.createEmptyBorder(10, 14, 10, 14));

        JPanel formPanel = buildFormBorder("Record");
        formPanel.add(styledLabel("Name *"));
        cp.txtName = new JTextField(15);
        cp.txtName.setFont(new Font("Segoe UI", Font.PLAIN, 13));
        formPanel.add(cp.txtName);

        formPanel.add(styledLabel("Dose"));
        cp.txtExtra = new JTextField(12);
        cp.txtExtra.setFont(new Font("Segoe UI", Font.PLAIN, 13));
        formPanel.add(cp.txtExtra);

        cp.btnAdd    = tealButton("ADD");
        cp.btnUpdate = tealButton("UPDATE");
        cp.btnDelete = redButton("DELETE");
        cp.btnClear  = grayButton("CLEAR");
        formPanel.add(cp.btnAdd);
        formPanel.add(cp.btnUpdate);
        formPanel.add(cp.btnDelete);
        formPanel.add(cp.btnClear);

        cp.table = buildTable(cp.columns);
        JScrollPane scroll = new JScrollPane(cp.table);
        JLabel lblCount = countLabel();
        JPanel footer = footerPanel(lblCount);

        cp.add(formPanel, BorderLayout.NORTH);
        cp.add(scroll,    BorderLayout.CENTER);
        cp.add(footer,    BorderLayout.SOUTH);

        cp.table.getSelectionModel().addListSelectionListener(e -> {
            if (!e.getValueIsAdjusting() && cp.table.getSelectedRow() >= 0) {
                int row = cp.table.convertRowIndexToModel(cp.table.getSelectedRow());
                cp.txtName.setText(cp.table.getModel().getValueAt(row, 1).toString());
                Object dose = cp.table.getModel().getValueAt(row, 2);
                cp.txtExtra.setText(dose != null ? dose.toString() : "");
            }
        });

        cp.btnClear.addActionListener(e -> {
            cp.txtName.setText(""); cp.txtExtra.setText(""); cp.table.clearSelection();
        });

        cp.btnAdd.addActionListener(e -> {
            if (controller.addMedicine(cp.txtName.getText().trim(), cp.txtExtra.getText().trim())) {
                cp.txtName.setText(""); cp.txtExtra.setText("");
                refreshMedicines(cp, lblCount);
            }
        });

        cp.btnUpdate.addActionListener(e -> {
            if (cp.table.getSelectedRow() < 0) { showSelectFirst(); return; }
            if (controller.editMedicine(selectedId(cp.table),
                    cp.txtName.getText().trim(), cp.txtExtra.getText().trim())) {
                refreshMedicines(cp, lblCount);
            }
        });

        cp.btnDelete.addActionListener(e -> {
            if (cp.table.getSelectedRow() < 0) { showSelectFirst(); return; }
            if (controller.removeMedicine(selectedId(cp.table))) {
                refreshMedicines(cp, lblCount);
            }
        });

        refreshMedicines(cp, lblCount);
        return cp;
    }

    private void refreshMedicines(CatalogPanel cp, JLabel lblCount) {
        List<Object[]> rows = controller.loadMedicines();
        DefaultTableModel model = new DefaultTableModel(cp.columns, 0) {
            @Override public boolean isCellEditable(int r, int c) { return false; }
        };
        for (Object[] row : rows) model.addRow(row);
        cp.table.setModel(model);
        hideIdColumn(cp.table);
        lblCount.setText("Records: " + model.getRowCount());
    }

    // =========================================================================
    // Association tab — Name, Phone, Email, BankAccount
    // =========================================================================
    private JPanel buildAssociationTab() {
        CatalogPanel cp = new CatalogPanel();
        cp.tableName = "Association";
        cp.columns   = new String[]{"ID", "Name", "Phone", "Email", "Bank Account"};
        cp.setLayout(new BorderLayout(0, 8));
        cp.setBackground(Color.WHITE);
        cp.setBorder(BorderFactory.createEmptyBorder(10, 14, 10, 14));

        JTextField txtPhone = new JTextField(10);
        JTextField txtEmail = new JTextField(15);
        JTextField txtBank  = new JTextField(15);
        txtPhone.setFont(new Font("Segoe UI", Font.PLAIN, 13));
        txtEmail.setFont(new Font("Segoe UI", Font.PLAIN, 13));
        txtBank.setFont(new Font("Segoe UI", Font.PLAIN, 13));

        JPanel formPanel = buildFormBorder("Record");
        formPanel.add(styledLabel("Name *"));
        cp.txtName = new JTextField(14);
        cp.txtName.setFont(new Font("Segoe UI", Font.PLAIN, 13));
        formPanel.add(cp.txtName);

        formPanel.add(styledLabel("Phone"));    formPanel.add(txtPhone);
        formPanel.add(styledLabel("Email"));    formPanel.add(txtEmail);
        formPanel.add(styledLabel("Bank Account")); formPanel.add(txtBank);

        cp.btnAdd    = tealButton("ADD");
        cp.btnUpdate = tealButton("UPDATE");
        cp.btnDelete = redButton("DELETE");
        cp.btnClear  = grayButton("CLEAR");
        formPanel.add(cp.btnAdd);
        formPanel.add(cp.btnUpdate);
        formPanel.add(cp.btnDelete);
        formPanel.add(cp.btnClear);

        cp.table = buildTable(cp.columns);
        JScrollPane scroll = new JScrollPane(cp.table);
        JLabel lblCount = countLabel();
        JPanel footer = footerPanel(lblCount);

        cp.add(formPanel, BorderLayout.NORTH);
        cp.add(scroll,    BorderLayout.CENTER);
        cp.add(footer,    BorderLayout.SOUTH);

        cp.table.getSelectionModel().addListSelectionListener(e -> {
            if (!e.getValueIsAdjusting() && cp.table.getSelectedRow() >= 0) {
                int row = cp.table.convertRowIndexToModel(cp.table.getSelectedRow());
                cp.txtName.setText(nullToEmpty(cp.table.getModel().getValueAt(row, 1)));
                txtPhone.setText(nullToEmpty(cp.table.getModel().getValueAt(row, 2)));
                txtEmail.setText(nullToEmpty(cp.table.getModel().getValueAt(row, 3)));
                txtBank.setText(nullToEmpty(cp.table.getModel().getValueAt(row, 4)));
            }
        });

        cp.btnClear.addActionListener(e -> {
            cp.txtName.setText(""); txtPhone.setText("");
            txtEmail.setText(""); txtBank.setText("");
            cp.table.clearSelection();
        });

        cp.btnAdd.addActionListener(e -> {
            if (controller.addAssociation(
                    cp.txtName.getText().trim(), txtPhone.getText().trim(),
                    txtEmail.getText().trim(), txtBank.getText().trim())) {
                cp.txtName.setText(""); txtPhone.setText("");
                txtEmail.setText(""); txtBank.setText("");
                refreshAssociations(cp, lblCount);
            }
        });

        cp.btnUpdate.addActionListener(e -> {
            if (cp.table.getSelectedRow() < 0) { showSelectFirst(); return; }
            if (controller.editAssociation(
                    selectedId(cp.table),
                    cp.txtName.getText().trim(), txtPhone.getText().trim(),
                    txtEmail.getText().trim(), txtBank.getText().trim())) {
                refreshAssociations(cp, lblCount);
            }
        });

        cp.btnDelete.addActionListener(e -> {
            if (cp.table.getSelectedRow() < 0) { showSelectFirst(); return; }
            if (controller.removeAssociation(selectedId(cp.table))) {
                refreshAssociations(cp, lblCount);
            }
        });

        refreshAssociations(cp, lblCount);
        return cp;
    }

    private void refreshAssociations(CatalogPanel cp, JLabel lblCount) {
        List<Object[]> rows = controller.loadAssociations();
        DefaultTableModel model = new DefaultTableModel(cp.columns, 0) {
            @Override public boolean isCellEditable(int r, int c) { return false; }
        };
        for (Object[] row : rows) model.addRow(row);
        cp.table.setModel(model);
        hideIdColumn(cp.table);
        lblCount.setText("Records: " + model.getRowCount());
    }

    // =========================================================================
    // DB helper — only used here for loading combos (pure read, no logic)
    // =========================================================================
    private void loadComboFromTable(JComboBox<DbObject> combo, String tableName) {
        combo.removeAllItems();
        String sql = "SELECT Id, Name FROM " + tableName + " ORDER BY Name";
        try (Connection con = ConexionOracle.connect();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                combo.addItem(new DbObject(rs.getInt(1), rs.getString(2)));
            }
        } catch (SQLException e) {
            JOptionPane.showMessageDialog(this, "Error loading combo: " + e.getMessage());
        }
    }

    // =========================================================================
    // UI helpers
    // =========================================================================
    private JTable buildTable(String[] columns) {
        JTable table = new JTable(new DefaultTableModel(columns, 0) {
            @Override public boolean isCellEditable(int r, int c) { return false; }
        });
        table.setFont(new Font("Segoe UI", Font.PLAIN, 13));
        table.setRowHeight(24);
        table.setGridColor(new Color(230,230,230));
        table.setSelectionBackground(new Color(204,229,255));
        JTableHeader h = table.getTableHeader();
        h.setFont(new Font("Segoe UI", Font.BOLD, 13));
        h.setBackground(new Color(0,153,153));
        h.setForeground(Color.WHITE);
        h.setReorderingAllowed(false);
        return table;
    }

    private void hideIdColumn(JTable table) {
        if (table.getColumnCount() > 0) {
            table.getColumnModel().getColumn(0).setMinWidth(0);
            table.getColumnModel().getColumn(0).setMaxWidth(0);
            table.getColumnModel().getColumn(0).setPreferredWidth(0);
        }
    }

    /** Returns the hidden ID value from the first column of the selected row. */
    private int selectedId(JTable table) {
        int row = table.convertRowIndexToModel(table.getSelectedRow());
        return Integer.parseInt(table.getModel().getValueAt(row, 0).toString());
    }

    private JPanel buildFormBorder(String title) {
        JPanel p = new JPanel(new FlowLayout(FlowLayout.LEFT, 10, 8));
        p.setBackground(new Color(245,245,245));
        p.setBorder(BorderFactory.createTitledBorder(
            BorderFactory.createLineBorder(new Color(200,200,200)),
            title,
            javax.swing.border.TitledBorder.LEFT,
            javax.swing.border.TitledBorder.TOP,
            new Font("Segoe UI", Font.BOLD, 11),
            new Color(0, 153, 153)));
        return p;
    }

    private JLabel countLabel() {
        JLabel lbl = new JLabel("Records: 0");
        lbl.setFont(new Font("Segoe UI", Font.BOLD, 12));
        lbl.setForeground(new Color(0, 102, 102));
        return lbl;
    }

    private JPanel footerPanel(JLabel lblCount) {
        JPanel p = new JPanel(new FlowLayout(FlowLayout.LEFT, 10, 5));
        p.setBackground(new Color(245,245,245));
        p.add(lblCount);
        return p;
    }

    private void showSelectFirst() {
        JOptionPane.showMessageDialog(this, "Select a record first.");
    }

    private String nullToEmpty(Object val) { return val == null ? "" : val.toString(); }

    private JLabel styledLabel(String text) {
        JLabel lbl = new JLabel(text);
        lbl.setFont(new Font("Segoe UI", Font.BOLD, 12));
        lbl.setForeground(new Color(0, 153, 153));
        return lbl;
    }

    private JButton tealButton(String text) {
        JButton btn = new JButton(text);
        btn.setBackground(new Color(0, 153, 153));
        btn.setForeground(Color.WHITE);
        btn.setFont(new Font("Segoe UI", Font.BOLD, 11));
        btn.setCursor(new Cursor(Cursor.HAND_CURSOR));
        btn.setFocusPainted(false);
        btn.setBorderPainted(false);
        btn.setOpaque(true);
        return btn;
    }

    private JButton redButton(String text) {
        JButton btn = new JButton(text);
        btn.setBackground(new Color(200, 60, 60));
        btn.setForeground(Color.WHITE);
        btn.setFont(new Font("Segoe UI", Font.BOLD, 11));
        btn.setCursor(new Cursor(Cursor.HAND_CURSOR));
        btn.setFocusPainted(false);
        btn.setBorderPainted(false);
        btn.setOpaque(true);
        return btn;
    }

    private JButton grayButton(String text) {
        JButton btn = new JButton(text);
        btn.setBackground(new Color(200, 200, 200));
        btn.setForeground(Color.DARK_GRAY);
        btn.setFont(new Font("Segoe UI", Font.BOLD, 11));
        btn.setCursor(new Cursor(Cursor.HAND_CURSOR));
        btn.setFocusPainted(false);
        btn.setBorderPainted(false);
        btn.setOpaque(true);
        return btn;
    }

    public static void main(String[] args) {
        try {
            for (UIManager.LookAndFeelInfo info : UIManager.getInstalledLookAndFeels()) {
                if ("Nimbus".equals(info.getName())) {
                    UIManager.setLookAndFeel(info.getClassName());
                    break;
                }
            }
        } catch (ReflectiveOperationException | UnsupportedLookAndFeelException ex) {
            logger.log(java.util.logging.Level.SEVERE, null, ex);
        }
        java.awt.EventQueue.invokeLater(() -> new CatalogForm().setVisible(true));
    }
}
