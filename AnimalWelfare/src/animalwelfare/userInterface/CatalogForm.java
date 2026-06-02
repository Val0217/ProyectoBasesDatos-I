package animalwelfare.userInterface;

import animalwelfare.access.ConexionOracle;
import animalwelfare.security.Session;
import java.awt.*;
import java.sql.*;
import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import javax.swing.table.JTableHeader;

/**
 * Admin catalog management screen.
 * Allows adding, editing and deleting records from all catalog tables.
 * Only accessible by Admin users.
 *
 * @author team
 */
public class CatalogForm extends javax.swing.JFrame {

    private static final java.util.logging.Logger logger =
        java.util.logging.Logger.getLogger(CatalogForm.class.getName());

    // Each catalog tab uses these components
    private static class CatalogPanel extends JPanel {
        JTable table;
        JTextField txtName;
        JTextField txtExtra; // for PetBreed (IdType), Medicine (Dose), etc.
        JLabel lblExtra;
        JComboBox<animalwelfare.access.DbObject> comboExtra; // for PetBreed type selector
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

        tabs.addTab("Pet Type",     buildSimpleTab("PetType",     new String[]{"ID","Name"}));
        tabs.addTab("Pet Breed",    buildBreedTab());
        tabs.addTab("Pet State",    buildSimpleTab("PetState",    new String[]{"ID","Name"}));
        tabs.addTab("Pet Size",     buildSimpleTab("PetSize",     new String[]{"ID","Name"}));
        tabs.addTab("Energy Level", buildSimpleTab("PetLevelEnergy", new String[]{"ID","Name"}));
        tabs.addTab("Training",     buildSimpleTab("PetTraining", new String[]{"ID","Name"}));
        tabs.addTab("Space Req.",   buildSimpleTab("SpaceRequired",new String[]{"ID","Name"}));
        tabs.addTab("Severity",     buildSimpleTab("PetSeverity", new String[]{"ID","Name"}));
        tabs.addTab("Illness",      buildSimpleTab("PetIllness",  new String[]{"ID","Name"}));
        tabs.addTab("Medicine",     buildMedicineTab());
        tabs.addTab("Treatment",    buildSimpleTab("PetTreatment",new String[]{"ID","Name"}));
        tabs.addTab("Currency",     buildSimpleTab("Currency",    new String[]{"ID","Name"}));
        tabs.addTab("Association",  buildAssociationTab());

        getContentPane().setLayout(new BorderLayout());
        getContentPane().add(header, BorderLayout.NORTH);
        getContentPane().add(tabs,   BorderLayout.CENTER);

        pack();
    }

    // -------------------------------------------------------------------------
    // Simple tab — only Name field
    // -------------------------------------------------------------------------
    private JPanel buildSimpleTab(String tableName, String[] columns) {
        CatalogPanel cp = new CatalogPanel();
        cp.tableName = tableName;
        cp.columns   = columns;
        cp.hasExtra  = false;

        cp.setLayout(new BorderLayout(0, 8));
        cp.setBackground(Color.WHITE);
        cp.setBorder(BorderFactory.createEmptyBorder(10, 14, 10, 14));

        // Form area
        JPanel formPanel = new JPanel(new FlowLayout(FlowLayout.LEFT, 10, 8));
        formPanel.setBackground(new Color(245, 245, 245));
        formPanel.setBorder(BorderFactory.createTitledBorder(
            BorderFactory.createLineBorder(new Color(200,200,200)),
            "Record",
            javax.swing.border.TitledBorder.LEFT,
            javax.swing.border.TitledBorder.TOP,
            new Font("Segoe UI", Font.BOLD, 11),
            new Color(0, 153, 153)
        ));

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

        // Table
        cp.table = buildTable(columns);
        JScrollPane scroll = new JScrollPane(cp.table);
        scroll.setBorder(BorderFactory.createLineBorder(new Color(200,200,200)));

        // Footer
        JLabel lblCount = new JLabel("Records: 0");
        lblCount.setFont(new Font("Segoe UI", Font.BOLD, 12));
        lblCount.setForeground(new Color(0, 102, 102));
        JPanel footer = new JPanel(new FlowLayout(FlowLayout.LEFT, 10, 5));
        footer.setBackground(new Color(245,245,245));
        footer.add(lblCount);

        cp.add(formPanel, BorderLayout.NORTH);
        cp.add(scroll,    BorderLayout.CENTER);
        cp.add(footer,    BorderLayout.SOUTH);

        // Wire up actions
        wireSimpleTab(cp, lblCount);

        // Load initial data
        loadSimpleTable(cp, lblCount);

        return cp;
    }

    // -------------------------------------------------------------------------
    // Breed tab — has extra combo for PetType
    // -------------------------------------------------------------------------
    private JPanel buildBreedTab() {
        CatalogPanel cp = new CatalogPanel();
        cp.tableName     = "PetBreed";
        cp.columns       = new String[]{"ID", "Name", "Type"};
        cp.hasExtra      = false;
        cp.hasComboExtra = true;

        cp.setLayout(new BorderLayout(0, 8));
        cp.setBackground(Color.WHITE);
        cp.setBorder(BorderFactory.createEmptyBorder(10, 14, 10, 14));

        JPanel formPanel = new JPanel(new FlowLayout(FlowLayout.LEFT, 10, 8));
        formPanel.setBackground(new Color(245,245,245));
        formPanel.setBorder(BorderFactory.createTitledBorder(
            BorderFactory.createLineBorder(new Color(200,200,200)), "Record",
            javax.swing.border.TitledBorder.LEFT, javax.swing.border.TitledBorder.TOP,
            new Font("Segoe UI", Font.BOLD, 11), new Color(0, 153, 153)));

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

        JLabel lblCount = new JLabel("Records: 0");
        lblCount.setFont(new Font("Segoe UI", Font.BOLD, 12));
        lblCount.setForeground(new Color(0, 102, 102));
        JPanel footer = new JPanel(new FlowLayout(FlowLayout.LEFT));
        footer.setBackground(new Color(245,245,245));
        footer.add(lblCount);

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
            animalwelfare.access.DbObject type = (animalwelfare.access.DbObject) cp.comboExtra.getSelectedItem();
            if (name.isEmpty() || type == null) {
                JOptionPane.showMessageDialog(this, "Name and Type are required.");
                return;
            }
            executeUpdate("INSERT INTO PetBreed (Id, Name, IdType) VALUES (s_PetBreed.NEXTVAL, ?, ?)",
                name, String.valueOf(type.getId()));
            loadBreedTable(cp, lblCount);
            cp.txtName.setText("");
        });

        cp.btnUpdate.addActionListener(e -> {
            int row = cp.table.getSelectedRow();
            if (row < 0) { JOptionPane.showMessageDialog(this, "Select a record first."); return; }
            int id = Integer.parseInt(cp.table.getModel().getValueAt(cp.table.convertRowIndexToModel(row), 0).toString());
            String name = cp.txtName.getText().trim();
            animalwelfare.access.DbObject type = (animalwelfare.access.DbObject) cp.comboExtra.getSelectedItem();
            if (name.isEmpty() || type == null) return;
            executeUpdate("UPDATE PetBreed SET Name = ?, IdType = ? WHERE Id = ?",
                name, String.valueOf(type.getId()), String.valueOf(id));
            loadBreedTable(cp, lblCount);
        });

        cp.btnDelete.addActionListener(e -> {
            int row = cp.table.getSelectedRow();
            if (row < 0) { JOptionPane.showMessageDialog(this, "Select a record first."); return; }
            int id = Integer.parseInt(cp.table.getModel().getValueAt(cp.table.convertRowIndexToModel(row), 0).toString());
            if (confirmDelete()) {
                executeUpdate("DELETE FROM PetBreed WHERE Id = ?", String.valueOf(id));
                loadBreedTable(cp, lblCount);
            }
        });

        loadBreedTable(cp, lblCount);
        return cp;
    }

    // -------------------------------------------------------------------------
    // Medicine tab — has extra Dose field
    // -------------------------------------------------------------------------
    private JPanel buildMedicineTab() {
        CatalogPanel cp = new CatalogPanel();
        cp.tableName = "Medicine";
        cp.columns   = new String[]{"ID", "Name", "Dose"};
        cp.hasExtra  = true;

        cp.setLayout(new BorderLayout(0, 8));
        cp.setBackground(Color.WHITE);
        cp.setBorder(BorderFactory.createEmptyBorder(10, 14, 10, 14));

        JPanel formPanel = new JPanel(new FlowLayout(FlowLayout.LEFT, 10, 8));
        formPanel.setBackground(new Color(245,245,245));
        formPanel.setBorder(BorderFactory.createTitledBorder(
            BorderFactory.createLineBorder(new Color(200,200,200)), "Record",
            javax.swing.border.TitledBorder.LEFT, javax.swing.border.TitledBorder.TOP,
            new Font("Segoe UI", Font.BOLD, 11), new Color(0, 153, 153)));

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

        JLabel lblCount = new JLabel("Records: 0");
        lblCount.setFont(new Font("Segoe UI", Font.BOLD, 12));
        lblCount.setForeground(new Color(0, 102, 102));
        JPanel footer = new JPanel(new FlowLayout(FlowLayout.LEFT));
        footer.setBackground(new Color(245,245,245));
        footer.add(lblCount);

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
            String name = cp.txtName.getText().trim();
            if (name.isEmpty()) { JOptionPane.showMessageDialog(this, "Name is required."); return; }
            executeUpdate("INSERT INTO Medicine (Id, Name, Dose) VALUES (s_Medicine.NEXTVAL, ?, ?)",
                name, cp.txtExtra.getText().trim());
            loadTableFromDB(cp, lblCount, "SELECT Id, Name, Dose FROM Medicine ORDER BY Name");
        });

        cp.btnUpdate.addActionListener(e -> {
            int row = cp.table.getSelectedRow();
            if (row < 0) { JOptionPane.showMessageDialog(this, "Select a record first."); return; }
            int id = Integer.parseInt(cp.table.getModel().getValueAt(cp.table.convertRowIndexToModel(row), 0).toString());
            executeUpdate("UPDATE Medicine SET Name = ?, Dose = ? WHERE Id = ?",
                cp.txtName.getText().trim(), cp.txtExtra.getText().trim(), String.valueOf(id));
            loadTableFromDB(cp, lblCount, "SELECT Id, Name, Dose FROM Medicine ORDER BY Name");
        });

        cp.btnDelete.addActionListener(e -> {
            int row = cp.table.getSelectedRow();
            if (row < 0) { JOptionPane.showMessageDialog(this, "Select a record first."); return; }
            int id = Integer.parseInt(cp.table.getModel().getValueAt(cp.table.convertRowIndexToModel(row), 0).toString());
            if (confirmDelete()) {
                executeUpdate("DELETE FROM Medicine WHERE Id = ?", String.valueOf(id));
                loadTableFromDB(cp, lblCount, "SELECT Id, Name, Dose FROM Medicine ORDER BY Name");
            }
        });

        loadTableFromDB(cp, lblCount, "SELECT Id, Name, Dose FROM Medicine ORDER BY Name");
        return cp;
    }

    // -------------------------------------------------------------------------
    // Association tab — Name, Phone, Email, BankAccount
    // -------------------------------------------------------------------------
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

        JPanel formPanel = new JPanel(new FlowLayout(FlowLayout.LEFT, 8, 8));
        formPanel.setBackground(new Color(245,245,245));
        formPanel.setBorder(BorderFactory.createTitledBorder(
            BorderFactory.createLineBorder(new Color(200,200,200)), "Record",
            javax.swing.border.TitledBorder.LEFT, javax.swing.border.TitledBorder.TOP,
            new Font("Segoe UI", Font.BOLD, 11), new Color(0, 153, 153)));

        formPanel.add(styledLabel("Name *"));
        cp.txtName = new JTextField(14);
        cp.txtName.setFont(new Font("Segoe UI", Font.PLAIN, 13));
        formPanel.add(cp.txtName);
        formPanel.add(styledLabel("Phone"));
        formPanel.add(txtPhone);
        formPanel.add(styledLabel("Email"));
        formPanel.add(txtEmail);
        formPanel.add(styledLabel("Bank Account"));
        formPanel.add(txtBank);

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

        JLabel lblCount = new JLabel("Records: 0");
        lblCount.setFont(new Font("Segoe UI", Font.BOLD, 12));
        lblCount.setForeground(new Color(0, 102, 102));
        JPanel footer = new JPanel(new FlowLayout(FlowLayout.LEFT));
        footer.setBackground(new Color(245,245,245));
        footer.add(lblCount);

        cp.add(formPanel, BorderLayout.NORTH);
        cp.add(scroll,    BorderLayout.CENTER);
        cp.add(footer,    BorderLayout.SOUTH);

        String query = "SELECT Id, Name, PhoneNumber, Email, BankAccount FROM Association ORDER BY Name";

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
            String name = cp.txtName.getText().trim();
            if (name.isEmpty()) { JOptionPane.showMessageDialog(this, "Name is required."); return; }
            executeUpdate(
                "INSERT INTO Association (Id, Name, PhoneNumber, Email, BankAccount) VALUES (s_Association.NEXTVAL, ?, ?, ?, ?)",
                name, txtPhone.getText().trim(), txtEmail.getText().trim(), txtBank.getText().trim());
            loadTableFromDB(cp, lblCount, query);
        });

        cp.btnUpdate.addActionListener(e -> {
            int row = cp.table.getSelectedRow();
            if (row < 0) { JOptionPane.showMessageDialog(this, "Select a record first."); return; }
            int id = Integer.parseInt(cp.table.getModel().getValueAt(cp.table.convertRowIndexToModel(row), 0).toString());
            executeUpdate("UPDATE Association SET Name=?, PhoneNumber=?, Email=?, BankAccount=? WHERE Id=?",
                cp.txtName.getText().trim(), txtPhone.getText().trim(),
                txtEmail.getText().trim(), txtBank.getText().trim(), String.valueOf(id));
            loadTableFromDB(cp, lblCount, query);
        });

        cp.btnDelete.addActionListener(e -> {
            int row = cp.table.getSelectedRow();
            if (row < 0) { JOptionPane.showMessageDialog(this, "Select a record first."); return; }
            int id = Integer.parseInt(cp.table.getModel().getValueAt(cp.table.convertRowIndexToModel(row), 0).toString());
            if (confirmDelete()) {
                executeUpdate("DELETE FROM Association WHERE Id = ?", String.valueOf(id));
                loadTableFromDB(cp, lblCount, query);
            }
        });

        loadTableFromDB(cp, lblCount, query);
        return cp;
    }

    // -------------------------------------------------------------------------
    // Wire simple tab actions (tables with only Id, Name)
    // -------------------------------------------------------------------------
    private void wireSimpleTab(CatalogPanel cp, JLabel lblCount) {
        String seq = "s_" + cp.tableName;

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
            if (name.isEmpty()) { JOptionPane.showMessageDialog(this, "Name is required."); return; }
            executeUpdate("INSERT INTO " + cp.tableName + " (Id, Name) VALUES (" + seq + ".NEXTVAL, ?)", name);
            loadSimpleTable(cp, lblCount);
            cp.txtName.setText("");
        });

        cp.btnUpdate.addActionListener(e -> {
            int row = cp.table.getSelectedRow();
            if (row < 0) { JOptionPane.showMessageDialog(this, "Select a record first."); return; }
            int id = Integer.parseInt(cp.table.getModel().getValueAt(cp.table.convertRowIndexToModel(row), 0).toString());
            String name = cp.txtName.getText().trim();
            if (name.isEmpty()) return;
            executeUpdate("UPDATE " + cp.tableName + " SET Name = ? WHERE Id = ?", name, String.valueOf(id));
            loadSimpleTable(cp, lblCount);
        });

        cp.btnDelete.addActionListener(e -> {
            int row = cp.table.getSelectedRow();
            if (row < 0) { JOptionPane.showMessageDialog(this, "Select a record first."); return; }
            int id = Integer.parseInt(cp.table.getModel().getValueAt(cp.table.convertRowIndexToModel(row), 0).toString());
            if (confirmDelete()) {
                executeUpdate("DELETE FROM " + cp.tableName + " WHERE Id = ?", String.valueOf(id));
                loadSimpleTable(cp, lblCount);
            }
        });
    }

    // -------------------------------------------------------------------------
    // Data loading helpers
    // -------------------------------------------------------------------------

    private void loadSimpleTable(CatalogPanel cp, JLabel lblCount) {
        loadTableFromDB(cp, lblCount, "SELECT Id, Name FROM " + cp.tableName + " ORDER BY Name");
    }

    private void loadBreedTable(CatalogPanel cp, JLabel lblCount) {
        DefaultTableModel model = new DefaultTableModel(cp.columns, 0) {
            @Override public boolean isCellEditable(int r, int c) { return false; }
        };
        String sql = "SELECT pb.Id, pb.Name, pt.Name AS TypeName FROM PetBreed pb JOIN PetType pt ON pb.IdType = pt.Id ORDER BY pb.Name";
        try (Connection con = ConexionOracle.connect();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                model.addRow(new Object[]{rs.getInt(1), rs.getString(2), rs.getString(3)});
            }
        } catch (SQLException e) {
            JOptionPane.showMessageDialog(this, "Error: " + e.getMessage());
        }
        cp.table.setModel(model);
        hideIdColumn(cp.table);
        lblCount.setText("Records: " + model.getRowCount());
    }

    private void loadTableFromDB(CatalogPanel cp, JLabel lblCount, String sql) {
        DefaultTableModel model = new DefaultTableModel(cp.columns, 0) {
            @Override public boolean isCellEditable(int r, int c) { return false; }
        };
        try (Connection con = ConexionOracle.connect();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            int colCount = rs.getMetaData().getColumnCount();
            while (rs.next()) {
                Object[] row = new Object[colCount];
                for (int i = 0; i < colCount; i++) row[i] = rs.getObject(i + 1);
                model.addRow(row);
            }
        } catch (SQLException e) {
            JOptionPane.showMessageDialog(this, "Error loading data: " + e.getMessage());
        }
        cp.table.setModel(model);
        hideIdColumn(cp.table);
        lblCount.setText("Records: " + model.getRowCount());
    }

    private void loadComboFromTable(JComboBox<animalwelfare.access.DbObject> combo, String tableName) {
        combo.removeAllItems();
        String sql = "SELECT Id, Name FROM " + tableName + " ORDER BY Name";
        try (Connection con = ConexionOracle.connect();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                combo.addItem(new animalwelfare.access.DbObject(rs.getInt(1), rs.getString(2)));
            }
        } catch (SQLException e) {
            JOptionPane.showMessageDialog(this, "Error loading combo: " + e.getMessage());
        }
    }

    // -------------------------------------------------------------------------
    // DB execute helper
    // -------------------------------------------------------------------------
    private void executeUpdate(String sql, String... params) {
        try (Connection con = ConexionOracle.connect();
             PreparedStatement ps = con.prepareStatement(sql)) {
            for (int i = 0; i < params.length; i++) {
                if (params[i] == null || params[i].isEmpty()) ps.setNull(i + 1, Types.VARCHAR);
                else {
                    try { ps.setInt(i + 1, Integer.parseInt(params[i])); }
                    catch (NumberFormatException e2) { ps.setString(i + 1, params[i]); }
                }
            }
            ps.executeUpdate();
            con.commit();
        } catch (SQLException e) {
            JOptionPane.showMessageDialog(this, "Error: " + e.getMessage());
        }
    }

    // -------------------------------------------------------------------------
    // UI helpers
    // -------------------------------------------------------------------------

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

    private boolean confirmDelete() {
        return JOptionPane.showConfirmDialog(this,
            "Are you sure you want to delete this record?",
            "Confirm Delete", JOptionPane.YES_NO_OPTION,
            JOptionPane.WARNING_MESSAGE) == JOptionPane.YES_OPTION;
    }

    private String nullToEmpty(Object val) {
        return val == null ? "" : val.toString();
    }

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
