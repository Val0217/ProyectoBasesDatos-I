import java.awt.*;
import java.util.ArrayList;
import java.util.List;
import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import javax.swing.table.JTableHeader;

/**
 * Standalone visual demo of CatalogForm — no DB required.
 * Compile and run with:  javac CatalogFormDemo.java && java CatalogFormDemo
 */
public class CatalogFormDemo extends JFrame {

    // Minimal DbObject replacement
    static class Item {
        int id; String name;
        Item(int id, String name) { this.id = id; this.name = name; }
        @Override public String toString() { return name; }
    }

    private static class CatalogPanel extends JPanel {
        JTable table; JTextField txtName; JTextField txtExtra;
        JComboBox<Item> comboExtra;
        JButton btnAdd, btnUpdate, btnDelete, btnClear;
        String[] columns;
        // In-memory data
        List<Object[]> data = new ArrayList<>();
        int nextId = 10;
    }

    public CatalogFormDemo() {
        setTitle("Catalog Management — Animal Welfare");
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setMinimumSize(new Dimension(780, 580));

        // Header
        JPanel header = new JPanel(new FlowLayout(FlowLayout.LEFT, 20, 14));
        header.setBackground(new Color(0, 153, 153));
        header.setPreferredSize(new Dimension(780, 58));
        JLabel title = new JLabel("CATALOG MANAGEMENT");
        title.setFont(new Font("Segoe UI", Font.BOLD, 22));
        title.setForeground(Color.WHITE);
        header.add(title);
        JButton btnBack = new JButton("← Back");
        styleButton(btnBack, new Color(0, 102, 102), Color.WHITE);
        btnBack.addActionListener(e -> JOptionPane.showMessageDialog(this, "Would navigate back to Main Menu."));
        header.add(btnBack);

        // Tabs
        JTabbedPane tabs = new JTabbedPane();
        tabs.setFont(new Font("Segoe UI", Font.PLAIN, 12));
        tabs.addTab("Pet Type",     buildSimpleTab("PetType",        new String[]{"ID","Name"},
            new Object[][]{{1,"Cat"},{2,"Dog"},{3,"Bird"}}));
        tabs.addTab("Pet Breed",    buildBreedTab());
        tabs.addTab("Pet State",    buildSimpleTab("PetState",       new String[]{"ID","Name"},
            new Object[][]{{1,"Available"},{2,"Adopted"},{3,"Lost"}}));
        tabs.addTab("Pet Size",     buildSimpleTab("PetSize",        new String[]{"ID","Name"},
            new Object[][]{{1,"Small"},{2,"Medium"},{3,"Large"}}));
        tabs.addTab("Energy Level", buildSimpleTab("PetLevelEnergy", new String[]{"ID","Name"},
            new Object[][]{{1,"Low"},{2,"Medium"},{3,"High"}}));
        tabs.addTab("Training",     buildSimpleTab("PetTraining",    new String[]{"ID","Name"},
            new Object[][]{{1,"Basic"},{2,"Advanced"}}));
        tabs.addTab("Space Req.",   buildSimpleTab("SpaceRequired",  new String[]{"ID","Name"},
            new Object[][]{{1,"Apartment"},{2,"House with yard"}}));
        tabs.addTab("Severity",     buildSimpleTab("PetSeverity",    new String[]{"ID","Name"},
            new Object[][]{{1,"Low"},{2,"Medium"},{3,"High"}}));
        tabs.addTab("Illness",      buildSimpleTab("PetIllness",     new String[]{"ID","Name"},
            new Object[][]{{1,"Parvovirus"},{2,"Distemper"}}));
        tabs.addTab("Medicine",     buildMedicineTab());
        tabs.addTab("Treatment",    buildSimpleTab("PetTreatment",   new String[]{"ID","Name"},
            new Object[][]{{1,"Surgery"},{2,"Vaccination"}}));
        tabs.addTab("Currency",     buildSimpleTab("Currency",       new String[]{"ID","Name"},
            new Object[][]{{1,"USD"},{2,"CRC"}}));
        tabs.addTab("Association",  buildAssociationTab());

        getContentPane().setLayout(new BorderLayout());
        getContentPane().add(header, BorderLayout.NORTH);
        getContentPane().add(tabs,   BorderLayout.CENTER);
        pack();
        setLocationRelativeTo(null);
    }

    // =========================================================================
    // Simple tab
    // =========================================================================
    private JPanel buildSimpleTab(String tableName, String[] columns, Object[][] seedData) {
        CatalogPanel cp = new CatalogPanel();
        cp.columns = columns;
        for (Object[] row : seedData) cp.data.add(row);

        cp.setLayout(new BorderLayout(0, 8));
        cp.setBackground(Color.WHITE);
        cp.setBorder(BorderFactory.createEmptyBorder(10, 14, 10, 14));

        JPanel form = formBorder("Record");
        form.add(styledLabel("Name *"));
        cp.txtName = textField(20);
        form.add(cp.txtName);
        cp.btnAdd = tealButton("ADD");
        cp.btnUpdate = tealButton("UPDATE");
        cp.btnDelete = redButton("DELETE");
        cp.btnClear = grayButton("CLEAR");
        form.add(cp.btnAdd); form.add(cp.btnUpdate);
        form.add(cp.btnDelete); form.add(cp.btnClear);

        cp.table = buildTable(columns);
        JScrollPane scroll = new JScrollPane(cp.table);
        JLabel lblCount = countLabel();

        cp.add(form, BorderLayout.NORTH);
        cp.add(scroll, BorderLayout.CENTER);
        cp.add(footerPanel(lblCount), BorderLayout.SOUTH);

        // Select row → fill
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
            cp.data.add(new Object[]{cp.nextId++, name});
            cp.txtName.setText("");
            refreshSimple(cp, lblCount);
        });

        cp.btnUpdate.addActionListener(e -> {
            int sel = cp.table.getSelectedRow();
            if (sel < 0) { JOptionPane.showMessageDialog(this, "Select a record first."); return; }
            String name = cp.txtName.getText().trim();
            if (name.isEmpty()) return;
            int modelRow = cp.table.convertRowIndexToModel(sel);
            cp.data.get(modelRow)[1] = name;
            refreshSimple(cp, lblCount);
        });

        cp.btnDelete.addActionListener(e -> {
            int sel = cp.table.getSelectedRow();
            if (sel < 0) { JOptionPane.showMessageDialog(this, "Select a record first."); return; }
            if (confirmDelete()) {
                cp.data.remove(cp.table.convertRowIndexToModel(sel));
                refreshSimple(cp, lblCount);
            }
        });

        refreshSimple(cp, lblCount);
        return cp;
    }

    private void refreshSimple(CatalogPanel cp, JLabel lblCount) {
        DefaultTableModel model = new DefaultTableModel(cp.columns, 0) {
            @Override public boolean isCellEditable(int r, int c) { return false; }
        };
        for (Object[] row : cp.data) model.addRow(row);
        cp.table.setModel(model);
        hideIdColumn(cp.table);
        lblCount.setText("Records: " + model.getRowCount());
    }

    // =========================================================================
    // Breed tab
    // =========================================================================
    private JPanel buildBreedTab() {
        CatalogPanel cp = new CatalogPanel();
        cp.columns = new String[]{"ID", "Name", "Type"};
        cp.data.add(new Object[]{1, "Labrador", "Dog"});
        cp.data.add(new Object[]{2, "Persian", "Cat"});
        cp.data.add(new Object[]{3, "Poodle", "Dog"});

        cp.setLayout(new BorderLayout(0, 8));
        cp.setBackground(Color.WHITE);
        cp.setBorder(BorderFactory.createEmptyBorder(10, 14, 10, 14));

        JPanel form = formBorder("Record");
        form.add(styledLabel("Name *"));
        cp.txtName = textField(15);
        form.add(cp.txtName);
        form.add(styledLabel("Pet Type *"));
        cp.comboExtra = new JComboBox<>(new Item[]{new Item(1,"Cat"), new Item(2,"Dog"), new Item(3,"Bird")});
        cp.comboExtra.setFont(new Font("Segoe UI", Font.PLAIN, 13));
        cp.comboExtra.setPreferredSize(new Dimension(130, 28));
        form.add(cp.comboExtra);
        cp.btnAdd = tealButton("ADD");
        cp.btnUpdate = tealButton("UPDATE");
        cp.btnDelete = redButton("DELETE");
        cp.btnClear = grayButton("CLEAR");
        form.add(cp.btnAdd); form.add(cp.btnUpdate);
        form.add(cp.btnDelete); form.add(cp.btnClear);

        cp.table = buildTable(cp.columns);
        JScrollPane scroll = new JScrollPane(cp.table);
        JLabel lblCount = countLabel();

        cp.add(form, BorderLayout.NORTH);
        cp.add(scroll, BorderLayout.CENTER);
        cp.add(footerPanel(lblCount), BorderLayout.SOUTH);

        cp.table.getSelectionModel().addListSelectionListener(e -> {
            if (!e.getValueIsAdjusting() && cp.table.getSelectedRow() >= 0) {
                int row = cp.table.convertRowIndexToModel(cp.table.getSelectedRow());
                cp.txtName.setText(cp.table.getModel().getValueAt(row, 1).toString());
            }
        });

        cp.btnClear.addActionListener(e -> { cp.txtName.setText(""); cp.table.clearSelection(); });

        cp.btnAdd.addActionListener(e -> {
            String name = cp.txtName.getText().trim();
            Item type = (Item) cp.comboExtra.getSelectedItem();
            if (name.isEmpty() || type == null) { JOptionPane.showMessageDialog(this, "Name and Type are required."); return; }
            cp.data.add(new Object[]{cp.nextId++, name, type.name});
            cp.txtName.setText("");
            refreshSimple(cp, lblCount);
        });

        cp.btnUpdate.addActionListener(e -> {
            int sel = cp.table.getSelectedRow();
            if (sel < 0) { JOptionPane.showMessageDialog(this, "Select a record first."); return; }
            Item type = (Item) cp.comboExtra.getSelectedItem();
            int modelRow = cp.table.convertRowIndexToModel(sel);
            cp.data.get(modelRow)[1] = cp.txtName.getText().trim();
            if (type != null) cp.data.get(modelRow)[2] = type.name;
            refreshSimple(cp, lblCount);
        });

        cp.btnDelete.addActionListener(e -> {
            int sel = cp.table.getSelectedRow();
            if (sel < 0) { JOptionPane.showMessageDialog(this, "Select a record first."); return; }
            if (confirmDelete()) {
                cp.data.remove(cp.table.convertRowIndexToModel(sel));
                refreshSimple(cp, lblCount);
            }
        });

        refreshSimple(cp, lblCount);
        return cp;
    }

    // =========================================================================
    // Medicine tab
    // =========================================================================
    private JPanel buildMedicineTab() {
        CatalogPanel cp = new CatalogPanel();
        cp.columns = new String[]{"ID", "Name", "Dose"};
        cp.data.add(new Object[]{1, "Amoxicillin", "250mg"});
        cp.data.add(new Object[]{2, "Ivermectin", "1ml/10kg"});

        cp.setLayout(new BorderLayout(0, 8));
        cp.setBackground(Color.WHITE);
        cp.setBorder(BorderFactory.createEmptyBorder(10, 14, 10, 14));

        JPanel form = formBorder("Record");
        form.add(styledLabel("Name *")); cp.txtName = textField(15); form.add(cp.txtName);
        form.add(styledLabel("Dose")); cp.txtExtra = textField(12); form.add(cp.txtExtra);
        cp.btnAdd = tealButton("ADD"); cp.btnUpdate = tealButton("UPDATE");
        cp.btnDelete = redButton("DELETE"); cp.btnClear = grayButton("CLEAR");
        form.add(cp.btnAdd); form.add(cp.btnUpdate); form.add(cp.btnDelete); form.add(cp.btnClear);

        cp.table = buildTable(cp.columns);
        JScrollPane scroll = new JScrollPane(cp.table);
        JLabel lblCount = countLabel();

        cp.add(form, BorderLayout.NORTH);
        cp.add(scroll, BorderLayout.CENTER);
        cp.add(footerPanel(lblCount), BorderLayout.SOUTH);

        cp.table.getSelectionModel().addListSelectionListener(e -> {
            if (!e.getValueIsAdjusting() && cp.table.getSelectedRow() >= 0) {
                int row = cp.table.convertRowIndexToModel(cp.table.getSelectedRow());
                cp.txtName.setText(cp.table.getModel().getValueAt(row, 1).toString());
                Object dose = cp.table.getModel().getValueAt(row, 2);
                cp.txtExtra.setText(dose != null ? dose.toString() : "");
            }
        });

        cp.btnClear.addActionListener(e -> { cp.txtName.setText(""); cp.txtExtra.setText(""); cp.table.clearSelection(); });

        cp.btnAdd.addActionListener(e -> {
            String name = cp.txtName.getText().trim();
            if (name.isEmpty()) { JOptionPane.showMessageDialog(this, "Name is required."); return; }
            cp.data.add(new Object[]{cp.nextId++, name, cp.txtExtra.getText().trim()});
            cp.txtName.setText(""); cp.txtExtra.setText("");
            refreshSimple(cp, lblCount);
        });

        cp.btnUpdate.addActionListener(e -> {
            int sel = cp.table.getSelectedRow();
            if (sel < 0) { JOptionPane.showMessageDialog(this, "Select a record first."); return; }
            int modelRow = cp.table.convertRowIndexToModel(sel);
            cp.data.get(modelRow)[1] = cp.txtName.getText().trim();
            cp.data.get(modelRow)[2] = cp.txtExtra.getText().trim();
            refreshSimple(cp, lblCount);
        });

        cp.btnDelete.addActionListener(e -> {
            int sel = cp.table.getSelectedRow();
            if (sel < 0) { JOptionPane.showMessageDialog(this, "Select a record first."); return; }
            if (confirmDelete()) { cp.data.remove(cp.table.convertRowIndexToModel(sel)); refreshSimple(cp, lblCount); }
        });

        refreshSimple(cp, lblCount);
        return cp;
    }

    // =========================================================================
    // Association tab
    // =========================================================================
    private JPanel buildAssociationTab() {
        CatalogPanel cp = new CatalogPanel();
        cp.columns = new String[]{"ID", "Name", "Phone", "Email", "Bank Account"};
        cp.data.add(new Object[]{1, "Paws & Friends", "88001234", "info@paws.org", "CR21-0152-0001"});

        JTextField txtPhone = textField(10);
        JTextField txtEmail = textField(15);
        JTextField txtBank  = textField(15);

        cp.setLayout(new BorderLayout(0, 8));
        cp.setBackground(Color.WHITE);
        cp.setBorder(BorderFactory.createEmptyBorder(10, 14, 10, 14));

        JPanel form = formBorder("Record");
        form.add(styledLabel("Name *")); cp.txtName = textField(14); form.add(cp.txtName);
        form.add(styledLabel("Phone")); form.add(txtPhone);
        form.add(styledLabel("Email")); form.add(txtEmail);
        form.add(styledLabel("Bank Account")); form.add(txtBank);
        cp.btnAdd = tealButton("ADD"); cp.btnUpdate = tealButton("UPDATE");
        cp.btnDelete = redButton("DELETE"); cp.btnClear = grayButton("CLEAR");
        form.add(cp.btnAdd); form.add(cp.btnUpdate); form.add(cp.btnDelete); form.add(cp.btnClear);

        cp.table = buildTable(cp.columns);
        JScrollPane scroll = new JScrollPane(cp.table);
        JLabel lblCount = countLabel();

        cp.add(form, BorderLayout.NORTH);
        cp.add(scroll, BorderLayout.CENTER);
        cp.add(footerPanel(lblCount), BorderLayout.SOUTH);

        cp.table.getSelectionModel().addListSelectionListener(e -> {
            if (!e.getValueIsAdjusting() && cp.table.getSelectedRow() >= 0) {
                int row = cp.table.convertRowIndexToModel(cp.table.getSelectedRow());
                cp.txtName.setText(s(cp.table.getModel().getValueAt(row, 1)));
                txtPhone.setText(s(cp.table.getModel().getValueAt(row, 2)));
                txtEmail.setText(s(cp.table.getModel().getValueAt(row, 3)));
                txtBank.setText(s(cp.table.getModel().getValueAt(row, 4)));
            }
        });

        cp.btnClear.addActionListener(e -> {
            cp.txtName.setText(""); txtPhone.setText(""); txtEmail.setText(""); txtBank.setText("");
            cp.table.clearSelection();
        });

        cp.btnAdd.addActionListener(e -> {
            String name = cp.txtName.getText().trim();
            if (name.isEmpty()) { JOptionPane.showMessageDialog(this, "Name is required."); return; }
            cp.data.add(new Object[]{cp.nextId++, name, txtPhone.getText().trim(),
                txtEmail.getText().trim(), txtBank.getText().trim()});
            cp.txtName.setText(""); txtPhone.setText(""); txtEmail.setText(""); txtBank.setText("");
            refreshSimple(cp, lblCount);
        });

        cp.btnUpdate.addActionListener(e -> {
            int sel = cp.table.getSelectedRow();
            if (sel < 0) { JOptionPane.showMessageDialog(this, "Select a record first."); return; }
            int r = cp.table.convertRowIndexToModel(sel);
            cp.data.get(r)[1] = cp.txtName.getText().trim();
            cp.data.get(r)[2] = txtPhone.getText().trim();
            cp.data.get(r)[3] = txtEmail.getText().trim();
            cp.data.get(r)[4] = txtBank.getText().trim();
            refreshSimple(cp, lblCount);
        });

        cp.btnDelete.addActionListener(e -> {
            int sel = cp.table.getSelectedRow();
            if (sel < 0) { JOptionPane.showMessageDialog(this, "Select a record first."); return; }
            if (confirmDelete()) { cp.data.remove(cp.table.convertRowIndexToModel(sel)); refreshSimple(cp, lblCount); }
        });

        refreshSimple(cp, lblCount);
        return cp;
    }

    // =========================================================================
    // UI helpers
    // =========================================================================
    private JTable buildTable(String[] columns) {
        JTable t = new JTable(new DefaultTableModel(columns, 0) {
            @Override public boolean isCellEditable(int r, int c) { return false; }
        });
        t.setFont(new Font("Segoe UI", Font.PLAIN, 13));
        t.setRowHeight(24);
        t.setGridColor(new Color(230,230,230));
        t.setSelectionBackground(new Color(204,229,255));
        JTableHeader h = t.getTableHeader();
        h.setFont(new Font("Segoe UI", Font.BOLD, 13));
        h.setBackground(new Color(0,153,153));
        h.setForeground(Color.WHITE);
        h.setReorderingAllowed(false);
        return t;
    }

    private void hideIdColumn(JTable t) {
        if (t.getColumnCount() > 0) {
            t.getColumnModel().getColumn(0).setMinWidth(0);
            t.getColumnModel().getColumn(0).setMaxWidth(0);
            t.getColumnModel().getColumn(0).setPreferredWidth(0);
        }
    }

    private JPanel formBorder(String title) {
        JPanel p = new JPanel(new FlowLayout(FlowLayout.LEFT, 10, 8));
        p.setBackground(new Color(245,245,245));
        p.setBorder(BorderFactory.createTitledBorder(
            BorderFactory.createLineBorder(new Color(200,200,200)), title,
            javax.swing.border.TitledBorder.LEFT, javax.swing.border.TitledBorder.TOP,
            new Font("Segoe UI", Font.BOLD, 11), new Color(0,153,153)));
        return p;
    }

    private JTextField textField(int cols) {
        JTextField f = new JTextField(cols);
        f.setFont(new Font("Segoe UI", Font.PLAIN, 13));
        return f;
    }

    private JLabel countLabel() {
        JLabel l = new JLabel("Records: 0");
        l.setFont(new Font("Segoe UI", Font.BOLD, 12));
        l.setForeground(new Color(0,102,102));
        return l;
    }

    private JPanel footerPanel(JLabel lbl) {
        JPanel p = new JPanel(new FlowLayout(FlowLayout.LEFT, 10, 5));
        p.setBackground(new Color(245,245,245));
        p.add(lbl);
        return p;
    }

    private JLabel styledLabel(String text) {
        JLabel l = new JLabel(text);
        l.setFont(new Font("Segoe UI", Font.BOLD, 12));
        l.setForeground(new Color(0,153,153));
        return l;
    }

    private boolean confirmDelete() {
        return JOptionPane.showConfirmDialog(this,
            "Are you sure you want to delete this record?", "Confirm Delete",
            JOptionPane.YES_NO_OPTION, JOptionPane.WARNING_MESSAGE) == JOptionPane.YES_OPTION;
    }

    private void styleButton(JButton btn, Color bg, Color fg) {
        btn.setBackground(bg); btn.setForeground(fg);
        btn.setFont(new Font("Segoe UI", Font.BOLD, 11));
        btn.setCursor(new Cursor(Cursor.HAND_CURSOR));
        btn.setFocusPainted(false); btn.setBorderPainted(false); btn.setOpaque(true);
    }

    private JButton tealButton(String text) {
        JButton b = new JButton(text); styleButton(b, new Color(0,153,153), Color.WHITE); return b;
    }
    private JButton redButton(String text) {
        JButton b = new JButton(text); styleButton(b, new Color(200,60,60), Color.WHITE); return b;
    }
    private JButton grayButton(String text) {
        JButton b = new JButton(text); styleButton(b, new Color(200,200,200), Color.DARK_GRAY); return b;
    }

    private String s(Object v) { return v == null ? "" : v.toString(); }

    // =========================================================================
    public static void main(String[] args) {
        try {
            for (UIManager.LookAndFeelInfo info : UIManager.getInstalledLookAndFeels()) {
                if ("Nimbus".equals(info.getName())) {
                    UIManager.setLookAndFeel(info.getClassName());
                    break;
                }
            }
        } catch (Exception ignored) {}
        SwingUtilities.invokeLater(() -> new CatalogFormDemo().setVisible(true));
    }
}
