package animalwelfare.userInterface;

import animalwelfare.access.DbObject;
import animalwelfare.access.FosterHomeOperations.FosterHomeData;
import animalwelfare.business.FosterHomeController;
import java.awt.*;
import java.util.ArrayList;
import java.util.List;
import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import javax.swing.table.JTableHeader;

/**
 * Foster Home form with three tabs:
 *   Tab 1 - Register as a foster home
 *   Tab 2 - View all foster homes + contact
 *   Tab 3 - Edit or delete your own foster home
 *
 * MOCK MODE: runs without database for UI preview.
 * Search "MOCK" to find lines to revert when BD is ready.
 *
 * @author team
 */
public class FosterHomeForm extends javax.swing.JFrame {

    private static final java.util.logging.Logger logger =
        java.util.logging.Logger.getLogger(FosterHomeForm.class.getName());

    // Controller — uncomment when BD is ready
    // MOCK: private FosterHomeController controller;

    // -------------------------------------------------------------------------
    // Tab 1 — Register components
    // -------------------------------------------------------------------------
    private JCheckBox chkNeedsDonation;
    private JPanel panelSizes;
    private JPanel panelEnergy;
    private JPanel panelSpaces;
    private JButton btnRegister;
    private JButton btnClearRegister;

    // Checkbox lists for catalogs
    private final List<JCheckBox> checkSizes   = new ArrayList<>();
    private final List<JCheckBox> checkEnergy  = new ArrayList<>();
    private final List<JCheckBox> checkSpaces  = new ArrayList<>();

    // -------------------------------------------------------------------------
    // Tab 2 — Foster Home List components
    // -------------------------------------------------------------------------
    private JTable tableFosterHomes;
    private JLabel labelCount;
    private JButton btnContact;
    private JButton btnRefresh;

    // -------------------------------------------------------------------------
    // Tab 3 — Edit/Delete components
    // -------------------------------------------------------------------------
    private JCheckBox chkNeedsDonationEdit;
    private JPanel panelSizesEdit;
    private JPanel panelEnergyEdit;
    private JPanel panelSpacesEdit;
    private final List<JCheckBox> checkSizesEdit  = new ArrayList<>();
    private final List<JCheckBox> checkEnergyEdit = new ArrayList<>();
    private final List<JCheckBox> checkSpacesEdit = new ArrayList<>();
    private JButton btnLoadMyFosterHome;
    private JButton btnUpdate;
    private JButton btnDelete;
    private int currentFosterHomeId = -1; // stores loaded foster home ID

    // -------------------------------------------------------------------------
    // Constructor
    // -------------------------------------------------------------------------
    public FosterHomeForm() {
        initComponents();
        fillMockData();         // MOCK — replace with: controller = new FosterHomeController(this);
        setLocationRelativeTo(null);
    }

    // -------------------------------------------------------------------------
    // UI Builder
    // -------------------------------------------------------------------------
    private void initComponents() {
        setTitle("Foster Homes — Animal Welfare");
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
        tabs.addTab("  Register  ",     buildRegisterTab());
        tabs.addTab("  Foster Homes  ", buildListTab());
        tabs.addTab("  My Foster Home  ", buildEditTab());

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

        // Top — needs donation checkbox
        JPanel topPanel = new JPanel(new FlowLayout(FlowLayout.LEFT));
        topPanel.setBackground(Color.WHITE);
        chkNeedsDonation = new JCheckBox("I need food donations for the pet");
        chkNeedsDonation.setFont(new Font("Segoe UI", Font.PLAIN, 13));
        chkNeedsDonation.setBackground(Color.WHITE);
        topPanel.add(chkNeedsDonation);

        // Center — checkboxes for catalogs
        JPanel centerPanel = new JPanel(new GridLayout(1, 3, 15, 0));
        centerPanel.setBackground(Color.WHITE);

        panelSizes  = buildCheckboxGroup("Accepted Sizes");
        panelEnergy = buildCheckboxGroup("Accepted Energy Levels");
        panelSpaces = buildCheckboxGroup("Accepted Space Types");

        centerPanel.add(panelSizes);
        centerPanel.add(panelEnergy);
        centerPanel.add(panelSpaces);

        // Bottom — buttons
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
    // Tab 2 — Foster Home List
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
        btnRefresh.addActionListener(e -> loadFosterHomesMock()); // MOCK

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
    // Tab 3 — Edit / Delete my foster home
    // -------------------------------------------------------------------------
    private JPanel buildEditTab() {
        JPanel panel = new JPanel(new BorderLayout(10, 10));
        panel.setBackground(Color.WHITE);
        panel.setBorder(BorderFactory.createEmptyBorder(20, 30, 20, 30));

        // Top
        JPanel topPanel = new JPanel(new FlowLayout(FlowLayout.LEFT, 15, 5));
        topPanel.setBackground(Color.WHITE);

        btnLoadMyFosterHome = tealButton("LOAD MY FOSTER HOME");
        btnLoadMyFosterHome.addActionListener(e -> onLoadMyFosterHome());
        topPanel.add(btnLoadMyFosterHome);

        chkNeedsDonationEdit = new JCheckBox("I need food donations for the pet");
        chkNeedsDonationEdit.setFont(new Font("Segoe UI", Font.PLAIN, 13));
        chkNeedsDonationEdit.setBackground(Color.WHITE);
        topPanel.add(chkNeedsDonationEdit);

        // Center — same structure as register but separate checkbox lists
        JPanel centerPanel = new JPanel(new GridLayout(1, 3, 15, 0));
        centerPanel.setBackground(Color.WHITE);

        panelSizesEdit  = buildCheckboxGroup("Accepted Sizes");
        panelEnergyEdit = buildCheckboxGroup("Accepted Energy Levels");
        panelSpacesEdit = buildCheckboxGroup("Accepted Space Types");

        centerPanel.add(panelSizesEdit);
        centerPanel.add(panelEnergyEdit);
        centerPanel.add(panelSpacesEdit);

        // Bottom — update and delete buttons
        JPanel bottomPanel = new JPanel(new FlowLayout(FlowLayout.CENTER, 15, 10));
        bottomPanel.setBackground(Color.WHITE);

        btnUpdate = tealButton("UPDATE");
        btnUpdate.addActionListener(e -> onUpdate());
        btnUpdate.setEnabled(false); // disabled until data is loaded

        btnDelete = new JButton("DELETE");
        btnDelete.setBackground(new Color(200, 60, 60));
        btnDelete.setForeground(Color.WHITE);
        btnDelete.setFont(new Font("Segoe UI", Font.BOLD, 12));
        btnDelete.setCursor(new Cursor(Cursor.HAND_CURSOR));
        btnDelete.setFocusPainted(false);
        btnDelete.setBorderPainted(false);
        btnDelete.setOpaque(true);
        btnDelete.addActionListener(e -> onDelete());
        btnDelete.setEnabled(false); // disabled until data is loaded

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
        ArrayList<Integer> sizes   = getSelectedIds(checkSizes);
        ArrayList<Integer> energy  = getSelectedIds(checkEnergy);
        ArrayList<Integer> spaces  = getSelectedIds(checkSpaces);
        boolean needsDonation      = chkNeedsDonation.isSelected();

        // MOCK — simulate registration
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

        // REAL — replace with:
        // controller.registerFosterHome(needsDonation, sizes, energy, spaces);
    }

    private void onContact() {
        int selectedRow = tableFosterHomes.getSelectedRow();
        if (selectedRow < 0) {
            JOptionPane.showMessageDialog(this,
                "Please select a foster home first.",
                "No Selection", JOptionPane.WARNING_MESSAGE);
            return;
        }
        // Get person name from column 1
        String personName = tableFosterHomes.getValueAt(selectedRow, 1).toString();
        JOptionPane.showMessageDialog(this,
            "Contact information for: " + personName +
            "\n\nIn the real version this would show their email and phone.",
            "Contact Foster Home", JOptionPane.INFORMATION_MESSAGE);
    }

    private void onLoadMyFosterHome() {
        // MOCK — load fake data into edit form
        chkNeedsDonationEdit.setSelected(true);

        // Pre-check first checkboxes as example
        if (!checkSizesEdit.isEmpty())  checkSizesEdit.get(0).setSelected(true);
        if (!checkEnergyEdit.isEmpty()) checkEnergyEdit.get(1).setSelected(true);
        if (!checkSpacesEdit.isEmpty()) checkSpacesEdit.get(0).setSelected(true);

        currentFosterHomeId = 1; // MOCK ID
        btnUpdate.setEnabled(true);
        btnDelete.setEnabled(true);

        JOptionPane.showMessageDialog(this,
            "Foster home data loaded. (MOCK)",
            "Loaded", JOptionPane.INFORMATION_MESSAGE);

        // REAL — replace with:
        // FosterHomeData data = controller.loadMyFosterHome();
        // if (data != null) { loadEditForm(data); }
    }

    private void onUpdate() {
        ArrayList<Integer> sizes  = getSelectedIds(checkSizesEdit);
        ArrayList<Integer> energy = getSelectedIds(checkEnergyEdit);
        ArrayList<Integer> spaces = getSelectedIds(checkSpacesEdit);
        boolean needsDonation     = chkNeedsDonationEdit.isSelected();

        if (sizes.isEmpty() || energy.isEmpty() || spaces.isEmpty()) {
            JOptionPane.showMessageDialog(this,
                "Please select at least one option in each category.",
                "Validation", JOptionPane.WARNING_MESSAGE);
            return;
        }

        // MOCK — simulate update
        JOptionPane.showMessageDialog(this,
            "Foster home updated successfully! (MOCK)",
            "Success", JOptionPane.INFORMATION_MESSAGE);

        // REAL — replace with:
        // controller.updateFosterHome(currentFosterHomeId, needsDonation, sizes, energy, spaces);
    }

    private void onDelete() {
        int confirm = JOptionPane.showConfirmDialog(this,
            "Are you sure you want to remove yourself as a foster home?",
            "Confirm Delete", JOptionPane.YES_NO_OPTION, JOptionPane.WARNING_MESSAGE);

        if (confirm != JOptionPane.YES_OPTION) return;

        // MOCK — simulate delete
        JOptionPane.showMessageDialog(this,
            "Foster home removed successfully. (MOCK)",
            "Success", JOptionPane.INFORMATION_MESSAGE);
        clearEditForm();

        // REAL — replace with:
        // controller.deleteFosterHome(currentFosterHomeId);
    }

    // -------------------------------------------------------------------------
    // Public methods called by controller
    // -------------------------------------------------------------------------

    public void fillSizes(ArrayList<DbObject> items) {
        fillCheckboxGroup(panelSizes,  checkSizes,  items);
        fillCheckboxGroup(panelSizesEdit, checkSizesEdit, items);
    }

    public void fillEnergyLevels(ArrayList<DbObject> items) {
        fillCheckboxGroup(panelEnergy,     checkEnergy,     items);
        fillCheckboxGroup(panelEnergyEdit, checkEnergyEdit, items);
    }

    public void fillSpacesRequired(ArrayList<DbObject> items) {
        fillCheckboxGroup(panelSpaces,     checkSpaces,     items);
        fillCheckboxGroup(panelSpacesEdit, checkSpacesEdit, items);
    }

    public void loadFosterHomes(DefaultTableModel model) {
        tableFosterHomes.setModel(model);

        // Hide ID column
        if (tableFosterHomes.getColumnCount() > 0) {
            tableFosterHomes.getColumnModel().getColumn(0).setMinWidth(0);
            tableFosterHomes.getColumnModel().getColumn(0).setMaxWidth(0);
            tableFosterHomes.getColumnModel().getColumn(0).setPreferredWidth(0);
        }

        labelCount.setText("Records: " + model.getRowCount());
    }

    public void clearRegisterForm() {
        chkNeedsDonation.setSelected(false);
        checkSizes.forEach(c  -> c.setSelected(false));
        checkEnergy.forEach(c -> c.setSelected(false));
        checkSpaces.forEach(c -> c.setSelected(false));
    }

    public void loadEditForm(FosterHomeData data) {
        currentFosterHomeId = data.id;
        chkNeedsDonationEdit.setSelected("Y".equals(data.needsDonation));

        setCheckedIds(checkSizesEdit,  data.sizeIds);
        setCheckedIds(checkEnergyEdit, data.energyIds);
        setCheckedIds(checkSpacesEdit, data.spaceIds);

        btnUpdate.setEnabled(true);
        btnDelete.setEnabled(true);
    }

    // -------------------------------------------------------------------------
    // MOCK data — replace when BD is ready
    // -------------------------------------------------------------------------

    private void fillMockData() {
        // Sizes
        ArrayList<DbObject> sizes = new ArrayList<>();
        sizes.add(new DbObject(1, "Small"));
        sizes.add(new DbObject(2, "Medium"));
        sizes.add(new DbObject(3, "Large"));
        sizes.add(new DbObject(4, "Extra Large"));
        fillSizes(sizes);

        // Energy levels
        ArrayList<DbObject> energy = new ArrayList<>();
        energy.add(new DbObject(1, "Athletic"));
        energy.add(new DbObject(2, "Runner"));
        energy.add(new DbObject(3, "Walker"));
        energy.add(new DbObject(4, "Couch potato"));
        energy.add(new DbObject(5, "Not important"));
        fillEnergyLevels(energy);

        // Spaces
        ArrayList<DbObject> spaces = new ArrayList<>();
        spaces.add(new DbObject(1, "Apartment"));
        spaces.add(new DbObject(2, "House without yard"));
        spaces.add(new DbObject(3, "House with yard"));
        spaces.add(new DbObject(4, "Farm"));
        fillSpacesRequired(spaces);

        // Table
        loadFosterHomesMock();
    }

    private void loadFosterHomesMock() {
        DefaultTableModel model = new DefaultTableModel(
            new String[]{"ID", "Person", "Needs Donation",
                         "Accepted Sizes", "Accepted Energy", "Accepted Spaces"}, 0
        ) {
            @Override
            public boolean isCellEditable(int r, int c) { return false; }
        };

        model.addRow(new Object[]{1, "José Vargas",   "Yes", "Small, Medium",        "Walker, Couch potato", "Apartment"});
        model.addRow(new Object[]{2, "Sofía Mena",    "No",  "Small, Medium, Large", "Athletic, Runner",     "House with yard"});
        model.addRow(new Object[]{3, "Laura Pérez",   "Yes", "Small",                "Couch potato",         "House without yard"});
        model.addRow(new Object[]{4, "Andrés Castro", "No",  "Large, Extra Large",   "Athletic",             "Farm"});

        loadFosterHomes(model);
    }

    // -------------------------------------------------------------------------
    // Helpers
    // -------------------------------------------------------------------------

    /** Builds an empty titled panel for checkboxes */
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

    /** Fills a checkbox group panel from a list of DbObjects */
    private void fillCheckboxGroup(JPanel panel, List<JCheckBox> checkList,
                                    ArrayList<DbObject> items) {
        panel.removeAll();
        checkList.clear();
        for (DbObject item : items) {
            JCheckBox chk = new JCheckBox(item.getName());
            chk.setFont(new Font("Segoe UI", Font.PLAIN, 13));
            chk.setBackground(Color.WHITE);
            chk.putClientProperty("id", item.getId()); // store ID
            panel.add(chk);
            checkList.add(chk);
        }
        panel.revalidate();
        panel.repaint();
    }

    /** Returns the IDs of all selected checkboxes */
    private ArrayList<Integer> getSelectedIds(List<JCheckBox> checkList) {
        ArrayList<Integer> ids = new ArrayList<>();
        for (JCheckBox chk : checkList) {
            if (chk.isSelected()) {
                ids.add((Integer) chk.getClientProperty("id"));
            }
        }
        return ids;
    }

    /** Pre-selects checkboxes matching the given IDs */
    private void setCheckedIds(List<JCheckBox> checkList, Integer[] ids) {
        for (JCheckBox chk : checkList) chk.setSelected(false);
        for (Integer id : ids) {
            for (JCheckBox chk : checkList) {
                if (id.equals(chk.getClientProperty("id"))) {
                    chk.setSelected(true);
                    break;
                }
            }
        }
    }

    private void clearEditForm() {
        chkNeedsDonationEdit.setSelected(false);
        checkSizesEdit.forEach(c  -> c.setSelected(false));
        checkEnergyEdit.forEach(c -> c.setSelected(false));
        checkSpacesEdit.forEach(c -> c.setSelected(false));
        currentFosterHomeId = -1;
        btnUpdate.setEnabled(false);
        btnDelete.setEnabled(false);
    }

    private JLabel styledLabel(String text) {
        JLabel lbl = new JLabel(text);
        lbl.setFont(new Font("Segoe UI", Font.BOLD, 13));
        lbl.setForeground(new Color(0, 153, 153));
        return lbl;
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
    // Main — RIGHT CLICK → Run File to preview
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
        java.awt.EventQueue.invokeLater(() -> new FosterHomeForm().setVisible(true));
    }
}
