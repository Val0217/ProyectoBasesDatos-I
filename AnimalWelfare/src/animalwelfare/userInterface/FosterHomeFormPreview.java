package animalwelfare.userInterface;

import java.awt.*;
import java.util.ArrayList;
import java.util.List;
import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import javax.swing.table.JTableHeader;

/**
 * PREVIEW ONLY — no dependencies on Oracle, controller, or access layer.
 * Right click → Run File to preview the Foster Home UI.
 * DELETE this file before final delivery.
 *
 * @author team
 */
public class FosterHomeFormPreview extends javax.swing.JFrame {

    private static final java.util.logging.Logger logger =
        java.util.logging.Logger.getLogger(FosterHomeFormPreview.class.getName());

    // -------------------------------------------------------------------------
    // Tab 1 — Register
    // -------------------------------------------------------------------------
    private JCheckBox chkNeedsDonation;
    private JPanel panelSizes;
    private JPanel panelEnergy;
    private JPanel panelSpaces;
    private JButton btnRegister;
    private JButton btnClearRegister;
    private final List<JCheckBox> checkSizes  = new ArrayList<>();
    private final List<JCheckBox> checkEnergy = new ArrayList<>();
    private final List<JCheckBox> checkSpaces = new ArrayList<>();

    // -------------------------------------------------------------------------
    // Tab 2 — Foster Home List
    // -------------------------------------------------------------------------
    private JTable tableFosterHomes;
    private JLabel labelCount;
    private JButton btnContact;
    private JButton btnRefresh;

    // -------------------------------------------------------------------------
    // Tab 3 — Edit / Delete
    // -------------------------------------------------------------------------
    private JCheckBox chkNeedsDonationEdit;
    private JPanel panelSizesEdit;
    private JPanel panelEnergyEdit;
    private JPanel panelSpacesEdit;
    private final List<JCheckBox> checkSizesEdit  = new ArrayList<>();
    private final List<JCheckBox> checkEnergyEdit = new ArrayList<>();
    private final List<JCheckBox> checkSpacesEdit = new ArrayList<>();
    private JButton btnLoad;
    private JButton btnUpdate;
    private JButton btnDelete;

    // -------------------------------------------------------------------------
    // Constructor
    // -------------------------------------------------------------------------
    public FosterHomeFormPreview() {
        initComponents();
        fillMockCatalogs();
        loadMockTable();
        setLocationRelativeTo(null);
    }

    // -------------------------------------------------------------------------
    // UI Builder
    // -------------------------------------------------------------------------
    private void initComponents() {
        setTitle("Foster Homes — Animal Welfare  [PREVIEW]");
        setDefaultCloseOperation(javax.swing.WindowConstants.DISPOSE_ON_CLOSE);
        setMinimumSize(new Dimension(820, 620));

        // Header
        JPanel header = new JPanel(new FlowLayout(FlowLayout.LEFT, 20, 14));
        header.setBackground(new Color(0, 153, 153));
        header.setPreferredSize(new Dimension(820, 58));
        JLabel title = new JLabel("FOSTER HOMES");
        title.setFont(new Font("Segoe UI", Font.BOLD, 24));
        title.setForeground(Color.WHITE);
        header.add(title);

        // Tabs
        JTabbedPane tabs = new JTabbedPane();
        tabs.setFont(new Font("Segoe UI", Font.PLAIN, 13));
        tabs.addTab("  Register  ",        buildRegisterTab());
        tabs.addTab("  Foster Homes  ",    buildListTab());
        tabs.addTab("  My Foster Home  ",  buildEditTab());

        getContentPane().setLayout(new BorderLayout());
        getContentPane().add(header, BorderLayout.NORTH);
        getContentPane().add(tabs,   BorderLayout.CENTER);
        pack();
    }

    // -------------------------------------------------------------------------
    // Tab 1 — Register
    // -------------------------------------------------------------------------
    private JPanel buildRegisterTab() {
        JPanel panel = new JPanel(new BorderLayout(10, 10));
        panel.setBackground(Color.WHITE);
        panel.setBorder(BorderFactory.createEmptyBorder(20, 30, 20, 30));

        // Needs donation checkbox
        JPanel topPanel = new JPanel(new FlowLayout(FlowLayout.LEFT));
        topPanel.setBackground(Color.WHITE);
        chkNeedsDonation = new JCheckBox("I need food donations for the pet");
        chkNeedsDonation.setFont(new Font("Segoe UI", Font.PLAIN, 13));
        chkNeedsDonation.setBackground(Color.WHITE);
        topPanel.add(chkNeedsDonation);

        // Three checkbox groups
        JPanel centerPanel = new JPanel(new GridLayout(1, 3, 15, 0));
        centerPanel.setBackground(Color.WHITE);
        panelSizes  = buildCheckboxGroup("Accepted Sizes");
        panelEnergy = buildCheckboxGroup("Accepted Energy Levels");
        panelSpaces = buildCheckboxGroup("Accepted Space Types");
        centerPanel.add(panelSizes);
        centerPanel.add(panelEnergy);
        centerPanel.add(panelSpaces);

        // Buttons
        JPanel bottomPanel = new JPanel(new FlowLayout(FlowLayout.CENTER, 15, 10));
        bottomPanel.setBackground(Color.WHITE);
        btnRegister = tealButton("REGISTER");
        btnRegister.addActionListener(e -> onRegister());
        btnClearRegister = grayButton("CLEAR");
        btnClearRegister.addActionListener(e -> clearRegisterForm());
        bottomPanel.add(btnRegister);
        bottomPanel.add(btnClearRegister);

        panel.add(topPanel,    BorderLayout.NORTH);
        panel.add(centerPanel, BorderLayout.CENTER);
        panel.add(bottomPanel, BorderLayout.SOUTH);
        return panel;
    }

    // -------------------------------------------------------------------------
    // Tab 2 — List
    // -------------------------------------------------------------------------
    private JPanel buildListTab() {
        JPanel panel = new JPanel(new BorderLayout(0, 8));
        panel.setBackground(Color.WHITE);
        panel.setBorder(BorderFactory.createEmptyBorder(12, 16, 12, 16));

        // Buttons bar
        JPanel btnBar = new JPanel(new FlowLayout(FlowLayout.LEFT, 10, 8));
        btnBar.setBackground(new Color(245, 245, 245));
        btnContact = tealButton("CONTACT SELECTED");
        btnContact.addActionListener(e -> onContact());
        btnRefresh = grayButton("REFRESH");
        btnRefresh.addActionListener(e -> loadMockTable());
        btnBar.add(btnContact);
        btnBar.add(btnRefresh);

        // Table
        tableFosterHomes = new JTable();
        tableFosterHomes.setFont(new Font("Segoe UI", Font.PLAIN, 13));
        tableFosterHomes.setRowHeight(26);
        tableFosterHomes.setGridColor(new Color(230, 230, 230));
        tableFosterHomes.setSelectionBackground(new Color(204, 229, 255));
        tableFosterHomes.setDefaultEditor(Object.class, null);

        JTableHeader tableHeader = tableFosterHomes.getTableHeader();
        tableHeader.setFont(new Font("Segoe UI", Font.BOLD, 13));
        tableHeader.setBackground(new Color(0, 153, 153));
        tableHeader.setForeground(Color.WHITE);
        tableHeader.setReorderingAllowed(false);

        JScrollPane scroll = new JScrollPane(tableFosterHomes);
        scroll.setBorder(BorderFactory.createLineBorder(new Color(200, 200, 200)));

        // Footer
        JPanel footer = new JPanel(new FlowLayout(FlowLayout.LEFT, 20, 6));
        footer.setBackground(new Color(245, 245, 245));
        footer.setBorder(BorderFactory.createMatteBorder(1, 0, 0, 0, new Color(200, 200, 200)));
        labelCount = new JLabel("Records: 0");
        labelCount.setFont(new Font("Segoe UI", Font.BOLD, 13));
        labelCount.setForeground(new Color(0, 102, 102));
        footer.add(labelCount);

        panel.add(btnBar, BorderLayout.NORTH);
        panel.add(scroll, BorderLayout.CENTER);
        panel.add(footer, BorderLayout.SOUTH);
        return panel;
    }

    // -------------------------------------------------------------------------
    // Tab 3 — Edit / Delete
    // -------------------------------------------------------------------------
    private JPanel buildEditTab() {
        JPanel panel = new JPanel(new BorderLayout(10, 10));
        panel.setBackground(Color.WHITE);
        panel.setBorder(BorderFactory.createEmptyBorder(20, 30, 20, 30));

        // Top
        JPanel topPanel = new JPanel(new FlowLayout(FlowLayout.LEFT, 15, 5));
        topPanel.setBackground(Color.WHITE);
        btnLoad = tealButton("LOAD MY FOSTER HOME");
        btnLoad.addActionListener(e -> onLoad());
        chkNeedsDonationEdit = new JCheckBox("I need food donations for the pet");
        chkNeedsDonationEdit.setFont(new Font("Segoe UI", Font.PLAIN, 13));
        chkNeedsDonationEdit.setBackground(Color.WHITE);
        topPanel.add(btnLoad);
        topPanel.add(chkNeedsDonationEdit);

        // Checkbox groups
        JPanel centerPanel = new JPanel(new GridLayout(1, 3, 15, 0));
        centerPanel.setBackground(Color.WHITE);
        panelSizesEdit  = buildCheckboxGroup("Accepted Sizes");
        panelEnergyEdit = buildCheckboxGroup("Accepted Energy Levels");
        panelSpacesEdit = buildCheckboxGroup("Accepted Space Types");
        centerPanel.add(panelSizesEdit);
        centerPanel.add(panelEnergyEdit);
        centerPanel.add(panelSpacesEdit);

        // Buttons
        JPanel bottomPanel = new JPanel(new FlowLayout(FlowLayout.CENTER, 15, 10));
        bottomPanel.setBackground(Color.WHITE);

        btnUpdate = tealButton("UPDATE");
        btnUpdate.setEnabled(false);
        btnUpdate.addActionListener(e -> onUpdate());

        btnDelete = new JButton("DELETE");
        btnDelete.setBackground(new Color(200, 60, 60));
        btnDelete.setForeground(Color.WHITE);
        btnDelete.setFont(new Font("Segoe UI", Font.BOLD, 12));
        btnDelete.setCursor(new Cursor(Cursor.HAND_CURSOR));
        btnDelete.setFocusPainted(false);
        btnDelete.setBorderPainted(false);
        btnDelete.setOpaque(true);
        btnDelete.setEnabled(false);
        btnDelete.addActionListener(e -> onDelete());

        bottomPanel.add(btnUpdate);
        bottomPanel.add(btnDelete);

        panel.add(topPanel,    BorderLayout.NORTH);
        panel.add(centerPanel, BorderLayout.CENTER);
        panel.add(bottomPanel, BorderLayout.SOUTH);
        return panel;
    }

    // -------------------------------------------------------------------------
    // Actions
    // -------------------------------------------------------------------------

    private void onRegister() {
        ArrayList<Integer> sizes  = getSelectedIds(checkSizes);
        ArrayList<Integer> energy = getSelectedIds(checkEnergy);
        ArrayList<Integer> spaces = getSelectedIds(checkSpaces);

        if (sizes.isEmpty() || energy.isEmpty() || spaces.isEmpty()) {
            JOptionPane.showMessageDialog(this,
                "Please select at least one option in each category.",
                "Validation", JOptionPane.WARNING_MESSAGE);
            return;
        }
        JOptionPane.showMessageDialog(this,
            "Foster home registered successfully! (MOCK)",
            "Success", JOptionPane.INFORMATION_MESSAGE);
        clearRegisterForm();
    }

    private void onContact() {
        int row = tableFosterHomes.getSelectedRow();
        if (row < 0) {
            JOptionPane.showMessageDialog(this,
                "Please select a foster home first.",
                "No Selection", JOptionPane.WARNING_MESSAGE);
            return;
        }
        String name = tableFosterHomes.getValueAt(row, 1).toString();
        JOptionPane.showMessageDialog(this,
            "Contact info for: " + name +
            "\n\nEmail: example@mail.com\nPhone: 8800-0000\n\n(MOCK data)",
            "Contact Foster Home", JOptionPane.INFORMATION_MESSAGE);
    }

    private void onLoad() {
        // Simulate loading current user's foster home
        chkNeedsDonationEdit.setSelected(true);
        if (checkSizesEdit.size() > 0)  checkSizesEdit.get(0).setSelected(true);
        if (checkSizesEdit.size() > 1)  checkSizesEdit.get(1).setSelected(true);
        if (checkEnergyEdit.size() > 2) checkEnergyEdit.get(2).setSelected(true);
        if (checkSpacesEdit.size() > 0) checkSpacesEdit.get(0).setSelected(true);
        btnUpdate.setEnabled(true);
        btnDelete.setEnabled(true);
        JOptionPane.showMessageDialog(this,
            "Your foster home data loaded. (MOCK)",
            "Loaded", JOptionPane.INFORMATION_MESSAGE);
    }

    private void onUpdate() {
        ArrayList<Integer> sizes  = getSelectedIds(checkSizesEdit);
        ArrayList<Integer> energy = getSelectedIds(checkEnergyEdit);
        ArrayList<Integer> spaces = getSelectedIds(checkSpacesEdit);

        if (sizes.isEmpty() || energy.isEmpty() || spaces.isEmpty()) {
            JOptionPane.showMessageDialog(this,
                "Please select at least one option in each category.",
                "Validation", JOptionPane.WARNING_MESSAGE);
            return;
        }
        JOptionPane.showMessageDialog(this,
            "Foster home updated successfully! (MOCK)",
            "Success", JOptionPane.INFORMATION_MESSAGE);
    }

    private void onDelete() {
        int confirm = JOptionPane.showConfirmDialog(this,
            "Are you sure you want to remove yourself as a foster home?",
            "Confirm Delete", JOptionPane.YES_NO_OPTION, JOptionPane.WARNING_MESSAGE);
        if (confirm != JOptionPane.YES_OPTION) return;

        JOptionPane.showMessageDialog(this,
            "Foster home removed successfully. (MOCK)",
            "Success", JOptionPane.INFORMATION_MESSAGE);

        checkSizesEdit.forEach(c  -> c.setSelected(false));
        checkEnergyEdit.forEach(c -> c.setSelected(false));
        checkSpacesEdit.forEach(c -> c.setSelected(false));
        chkNeedsDonationEdit.setSelected(false);
        btnUpdate.setEnabled(false);
        btnDelete.setEnabled(false);
    }

    // -------------------------------------------------------------------------
    // Mock data
    // -------------------------------------------------------------------------

    private void fillMockCatalogs() {
        String[] sizes   = {"Small", "Medium", "Large", "Extra Large"};
        String[] energy  = {"Athletic", "Runner", "Walker", "Couch potato", "Not important"};
        String[] spaces  = {"Apartment", "House without yard", "House with yard", "Farm"};

        for (int i = 0; i < sizes.length; i++) {
            fillCheckboxGroup(panelSizes,      checkSizes,      i + 1, sizes[i]);
            fillCheckboxGroup(panelSizesEdit,  checkSizesEdit,  i + 1, sizes[i]);
        }
        for (int i = 0; i < energy.length; i++) {
            fillCheckboxGroup(panelEnergy,     checkEnergy,     i + 1, energy[i]);
            fillCheckboxGroup(panelEnergyEdit, checkEnergyEdit, i + 1, energy[i]);
        }
        for (int i = 0; i < spaces.length; i++) {
            fillCheckboxGroup(panelSpaces,     checkSpaces,     i + 1, spaces[i]);
            fillCheckboxGroup(panelSpacesEdit, checkSpacesEdit, i + 1, spaces[i]);
        }
    }

    private void loadMockTable() {
        DefaultTableModel model = new DefaultTableModel(
            new String[]{"ID", "Person", "Needs Donation",
                         "Accepted Sizes", "Accepted Energy", "Accepted Spaces"}, 0
        ) {
            @Override public boolean isCellEditable(int r, int c) { return false; }
        };

        model.addRow(new Object[]{1, "José Vargas",   "Yes", "Small, Medium",        "Walker, Couch potato", "Apartment"});
        model.addRow(new Object[]{2, "Sofía Mena",    "No",  "Small, Medium, Large", "Athletic, Runner",     "House with yard"});
        model.addRow(new Object[]{3, "Laura Pérez",   "Yes", "Small",                "Couch potato",         "House without yard"});
        model.addRow(new Object[]{4, "Andrés Castro", "No",  "Large, Extra Large",   "Athletic",             "Farm"});

        tableFosterHomes.setModel(model);

        // Hide ID column
        tableFosterHomes.getColumnModel().getColumn(0).setMinWidth(0);
        tableFosterHomes.getColumnModel().getColumn(0).setMaxWidth(0);
        tableFosterHomes.getColumnModel().getColumn(0).setPreferredWidth(0);

        labelCount.setText("Records: " + model.getRowCount());
    }

    // -------------------------------------------------------------------------
    // Helpers
    // -------------------------------------------------------------------------

    private JPanel buildCheckboxGroup(String title) {
        JPanel panel = new JPanel();
        panel.setLayout(new BoxLayout(panel, BoxLayout.Y_AXIS));
        panel.setBackground(Color.WHITE);
        panel.setBorder(BorderFactory.createTitledBorder(
            BorderFactory.createLineBorder(new Color(200, 200, 200)),
            title,
            javax.swing.border.TitledBorder.LEFT,
            javax.swing.border.TitledBorder.TOP,
            new Font("Segoe UI", Font.BOLD, 12),
            new Color(0, 153, 153)
        ));
        return panel;
    }

    private void fillCheckboxGroup(JPanel panel, List<JCheckBox> list,
                                    int id, String name) {
        JCheckBox chk = new JCheckBox(name);
        chk.setFont(new Font("Segoe UI", Font.PLAIN, 13));
        chk.setBackground(Color.WHITE);
        chk.putClientProperty("id", id);
        panel.add(chk);
        list.add(chk);
        panel.revalidate();
        panel.repaint();
    }

    private ArrayList<Integer> getSelectedIds(List<JCheckBox> list) {
        ArrayList<Integer> ids = new ArrayList<>();
        for (JCheckBox chk : list) {
            if (chk.isSelected()) ids.add((Integer) chk.getClientProperty("id"));
        }
        return ids;
    }

    private void clearRegisterForm() {
        chkNeedsDonation.setSelected(false);
        checkSizes.forEach(c  -> c.setSelected(false));
        checkEnergy.forEach(c -> c.setSelected(false));
        checkSpaces.forEach(c -> c.setSelected(false));
    }

    private JButton tealButton(String text) {
        JButton btn = new JButton(text);
        btn.setBackground(new Color(0, 153, 153));
        btn.setForeground(Color.WHITE);
        btn.setFont(new Font("Segoe UI", Font.BOLD, 12));
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
        btn.setFont(new Font("Segoe UI", Font.BOLD, 12));
        btn.setCursor(new Cursor(Cursor.HAND_CURSOR));
        btn.setFocusPainted(false);
        btn.setBorderPainted(false);
        btn.setOpaque(true);
        return btn;
    }

    // -------------------------------------------------------------------------
    // Main — RIGHT CLICK → Run File
    // -------------------------------------------------------------------------
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
        java.awt.EventQueue.invokeLater(() -> new FosterHomeFormPreview().setVisible(true));
    }
}
