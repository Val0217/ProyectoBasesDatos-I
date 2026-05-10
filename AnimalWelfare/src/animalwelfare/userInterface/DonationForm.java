package animalwelfare.userInterface;

import animalwelfare.access.DbObject;
import java.awt.*;
import java.util.Calendar;
import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import javax.swing.table.JTableHeader;

/**
 * Donation form with two tabs:
 *   Tab 1 - Register a new voluntary donation
 *   Tab 2 - View and filter donation history
 *
 * MOCK MODE: runs without database for UI preview.
 * Search "MOCK" to find the lines to revert when BD is ready.
 *
 * @author team
 */
public class DonationForm extends javax.swing.JFrame {

    private static final java.util.logging.Logger logger =
        java.util.logging.Logger.getLogger(DonationForm.class.getName());

    // -------------------------------------------------------------------------
    // Tab 1 — New Donation components
    // -------------------------------------------------------------------------
    private JComboBox<DbObject> comboAssociationNew;
    private JComboBox<DbObject> comboCurrency;
    private JTextField textAmount;
    private JButton btnDonate;
    private JButton btnClearNew;

    // -------------------------------------------------------------------------
    // Tab 2 — Donation History components
    // -------------------------------------------------------------------------
    private JComboBox<DbObject> comboAssociationFilter;
    private JSpinner spinnerDateFrom;
    private JSpinner spinnerDateTo;
    private JButton btnSearch;
    private JButton btnClearFilter;
    private JTable tableDonations;
    private JLabel labelTotal;
    private JLabel labelCount;

    // -------------------------------------------------------------------------
    // Constructor
    // -------------------------------------------------------------------------
    public DonationForm() {
        initComponents();
        fillCombosMock();       // MOCK — replace with fillCombos() when BD ready
        loadDonationsMock();    // MOCK — replace with loadDonations(null, null, null)
        setLocationRelativeTo(null);
    }

    // -------------------------------------------------------------------------
    // UI Builder
    // -------------------------------------------------------------------------
    private void initComponents() {
        setTitle("Donations — Animal Welfare");
        setDefaultCloseOperation(javax.swing.WindowConstants.DISPOSE_ON_CLOSE);
        setMinimumSize(new Dimension(780, 580));

        // Header bar
        JPanel headerPanel = new JPanel(new FlowLayout(FlowLayout.LEFT, 20, 14));
        headerPanel.setBackground(new Color(0, 153, 153));
        headerPanel.setPreferredSize(new Dimension(780, 58));

        JLabel titleLabel = new JLabel("DONATIONS");
        titleLabel.setFont(new Font("Segoe UI", Font.BOLD, 24));
        titleLabel.setForeground(Color.WHITE);
        headerPanel.add(titleLabel);

        // Tabs
        JTabbedPane tabs = new JTabbedPane();
        tabs.setFont(new Font("Segoe UI", Font.PLAIN, 13));
        tabs.addTab("  New Donation  ",     buildNewDonationTab());
        tabs.addTab("  Donation History  ", buildHistoryTab());

        getContentPane().setLayout(new BorderLayout());
        getContentPane().add(headerPanel, BorderLayout.NORTH);
        getContentPane().add(tabs,        BorderLayout.CENTER);

        pack();
    }

    // -------------------------------------------------------------------------
    // Tab 1 — New Donation
    // -------------------------------------------------------------------------
    private JPanel buildNewDonationTab() {
        JPanel panel = new JPanel(null);
        panel.setBackground(Color.WHITE);

        int labelX = 80;
        int fieldX = 250;
        int fieldW = 300;
        int rowH   = 32;
        int startY = 50;
        int gap    = 60;

        // Association
        JLabel lAssoc = styledLabel("Association *");
        lAssoc.setBounds(labelX, startY, 160, rowH);
        panel.add(lAssoc);

        comboAssociationNew = new JComboBox<>();
        comboAssociationNew.setFont(new Font("Segoe UI", Font.PLAIN, 13));
        comboAssociationNew.setBounds(fieldX, startY, fieldW, rowH);
        panel.add(comboAssociationNew);

        // Amount
        JLabel lAmount = styledLabel("Amount *");
        lAmount.setBounds(labelX, startY + gap, 160, rowH);
        panel.add(lAmount);

        textAmount = new JTextField();
        textAmount.setFont(new Font("Segoe UI", Font.PLAIN, 13));
        textAmount.setBorder(BorderFactory.createCompoundBorder(
            BorderFactory.createLineBorder(new Color(200, 200, 200)),
            BorderFactory.createEmptyBorder(4, 8, 4, 8)
        ));
        textAmount.setBounds(fieldX, startY + gap, fieldW, rowH);
        ((javax.swing.text.AbstractDocument) textAmount.getDocument())
            .setDocumentFilter(new DecimalFilter());
        panel.add(textAmount);

        // Currency
        JLabel lCurrency = styledLabel("Currency *");
        lCurrency.setBounds(labelX, startY + gap * 2, 160, rowH);
        panel.add(lCurrency);

        comboCurrency = new JComboBox<>();
        comboCurrency.setFont(new Font("Segoe UI", Font.PLAIN, 13));
        comboCurrency.setBounds(fieldX, startY + gap * 2, fieldW, rowH);
        panel.add(comboCurrency);

        // Separator
        JSeparator sep = new JSeparator();
        sep.setForeground(new Color(220, 220, 220));
        sep.setBounds(labelX, startY + gap * 3 - 10, fieldX + fieldW - labelX, 2);
        panel.add(sep);

        // Buttons
        btnDonate = tealButton("DONATE");
        btnDonate.setBounds(fieldX, startY + gap * 3 + 10, 140, 38);
        btnDonate.addActionListener(e -> onDonate());
        panel.add(btnDonate);

        btnClearNew = grayButton("CLEAR");
        btnClearNew.setBounds(fieldX + 155, startY + gap * 3 + 10, 140, 38);
        btnClearNew.addActionListener(e -> clearNewForm());
        panel.add(btnClearNew);

        return panel;
    }

    // -------------------------------------------------------------------------
    // Tab 2 — Donation History
    // -------------------------------------------------------------------------
    private JPanel buildHistoryTab() {
        JPanel panel = new JPanel(new BorderLayout(0, 8));
        panel.setBackground(Color.WHITE);
        panel.setBorder(BorderFactory.createEmptyBorder(12, 16, 12, 16));

        // Filter bar
        JPanel filterBar = new JPanel(new FlowLayout(FlowLayout.LEFT, 12, 8));
        filterBar.setBackground(new Color(245, 245, 245));
        filterBar.setBorder(BorderFactory.createTitledBorder(
            BorderFactory.createLineBorder(new Color(200, 200, 200)),
            "Filters",
            javax.swing.border.TitledBorder.LEFT,
            javax.swing.border.TitledBorder.TOP,
            new Font("Segoe UI", Font.BOLD, 12),
            new Color(0, 153, 153)
        ));

        filterBar.add(styledLabel("Association:"));
        comboAssociationFilter = new JComboBox<>();
        comboAssociationFilter.setFont(new Font("Segoe UI", Font.PLAIN, 13));
        comboAssociationFilter.setPreferredSize(new Dimension(180, 28));
        filterBar.add(comboAssociationFilter);

        filterBar.add(styledLabel("From:"));
        spinnerDateFrom = buildDateSpinner(getStartOfYear());
        filterBar.add(spinnerDateFrom);

        filterBar.add(styledLabel("To:"));
        spinnerDateTo = buildDateSpinner(new java.util.Date());
        filterBar.add(spinnerDateTo);

        btnSearch = tealButton("SEARCH");
        btnSearch.setPreferredSize(new Dimension(90, 28));
        btnSearch.addActionListener(e -> onSearch());
        filterBar.add(btnSearch);

        btnClearFilter = grayButton("CLEAR");
        btnClearFilter.setPreferredSize(new Dimension(80, 28));
        btnClearFilter.addActionListener(e -> clearFilter());
        filterBar.add(btnClearFilter);

        // Table
        tableDonations = new JTable();
        tableDonations.setFont(new Font("Segoe UI", Font.PLAIN, 13));
        tableDonations.setRowHeight(26);
        tableDonations.setGridColor(new Color(230, 230, 230));
        tableDonations.setSelectionBackground(new Color(204, 229, 255));
        tableDonations.setDefaultEditor(Object.class, null);

        JTableHeader header = tableDonations.getTableHeader();
        header.setFont(new Font("Segoe UI", Font.BOLD, 13));
        header.setBackground(new Color(0, 153, 153));
        header.setForeground(Color.WHITE);
        header.setReorderingAllowed(false);

        JScrollPane scrollPane = new JScrollPane(tableDonations);
        scrollPane.setBorder(BorderFactory.createLineBorder(new Color(200, 200, 200)));

        // Footer
        JPanel footer = new JPanel(new FlowLayout(FlowLayout.LEFT, 20, 6));
        footer.setBackground(new Color(245, 245, 245));
        footer.setBorder(BorderFactory.createMatteBorder(1, 0, 0, 0,
            new Color(200, 200, 200)));

        labelCount = new JLabel("Records: 0");
        labelCount.setFont(new Font("Segoe UI", Font.BOLD, 13));
        labelCount.setForeground(new Color(0, 102, 102));

        labelTotal = new JLabel("Total amount: 0.00");
        labelTotal.setFont(new Font("Segoe UI", Font.BOLD, 13));
        labelTotal.setForeground(new Color(0, 102, 102));

        footer.add(labelCount);
        footer.add(labelTotal);

        panel.add(filterBar,  BorderLayout.NORTH);
        panel.add(scrollPane, BorderLayout.CENTER);
        panel.add(footer,     BorderLayout.SOUTH);

        return panel;
    }

    // -------------------------------------------------------------------------
    // Actions
    // -------------------------------------------------------------------------

    private void onDonate() {
        String amountStr  = textAmount.getText().trim();
        DbObject assoc    = (DbObject) comboAssociationNew.getSelectedItem();
        DbObject currency = (DbObject) comboCurrency.getSelectedItem();

        if (amountStr.isEmpty()) {
            JOptionPane.showMessageDialog(this, "Amount is required.",
                "Validation", JOptionPane.WARNING_MESSAGE);
            return;
        }
        double amount;
        try {
            amount = Double.parseDouble(amountStr);
        } catch (NumberFormatException e) {
            JOptionPane.showMessageDialog(this, "Amount must be a valid number.",
                "Validation", JOptionPane.WARNING_MESSAGE);
            return;
        }
        if (amount <= 0) {
            JOptionPane.showMessageDialog(this, "Amount must be greater than 0.",
                "Validation", JOptionPane.WARNING_MESSAGE);
            return;
        }
        if (assoc == null || assoc.getId() == 0) {
            JOptionPane.showMessageDialog(this, "Please select an association.",
                "Validation", JOptionPane.WARNING_MESSAGE);
            return;
        }

        // MOCK — simulate successful insert, add row to table
        JOptionPane.showMessageDialog(this, "Donation registered successfully!",
            "Success", JOptionPane.INFORMATION_MESSAGE);

        DefaultTableModel model = (DefaultTableModel) tableDonations.getModel();
        model.insertRow(0, new Object[]{
            model.getRowCount() + 1,
            "Current User",
            assoc.toString(),
            amount,
            currency != null ? currency.toString() : "Colones",
            new java.sql.Date(System.currentTimeMillis()).toString()
        });
        updateFooter(model);
        clearNewForm();
    }

    private void onSearch() {
        // MOCK — in real version would call loadDonations(idAssoc, dateFrom, dateTo)
        JOptionPane.showMessageDialog(this, "Filtering... (mock: showing all)",
            "Info", JOptionPane.INFORMATION_MESSAGE);
        loadDonationsMock();
    }

    private void clearFilter() {
        comboAssociationFilter.setSelectedIndex(0);
        spinnerDateFrom.setValue(getStartOfYear());
        spinnerDateTo.setValue(new java.util.Date());
        loadDonationsMock(); // MOCK
    }

    private void clearNewForm() {
        textAmount.setText("");
        if (comboAssociationNew.getItemCount() > 0) comboAssociationNew.setSelectedIndex(0);
        if (comboCurrency.getItemCount() > 0)       comboCurrency.setSelectedIndex(0);
    }

    // -------------------------------------------------------------------------
    // MOCK methods — replace when BD is ready
    // -------------------------------------------------------------------------

    /** MOCK — replace body with calls to DonationOperations */
    private void fillCombosMock() {
        comboAssociationNew.addItem(new DbObject(1, "Refugio Animal CR"));
        comboAssociationNew.addItem(new DbObject(2, "Amigos Peludos"));
        comboAssociationNew.addItem(new DbObject(3, "Patitas Felices"));

        comboCurrency.addItem(new DbObject(1, "Colones"));
        comboCurrency.addItem(new DbObject(2, "Dólares"));

        comboAssociationFilter.addItem(new DbObject(0, "All"));
        comboAssociationFilter.addItem(new DbObject(1, "Refugio Animal CR"));
        comboAssociationFilter.addItem(new DbObject(2, "Amigos Peludos"));
        comboAssociationFilter.addItem(new DbObject(3, "Patitas Felices"));
    }

    /** MOCK — replace with loadDonations(null, null, null) */
    private void loadDonationsMock() {
        DefaultTableModel model = new DefaultTableModel(
            new String[]{"ID", "Donor", "Association", "Amount", "Currency", "Date"}, 0
        ) {
            @Override
            public boolean isCellEditable(int row, int col) { return false; }
        };

        model.addRow(new Object[]{1, "Carlos González", "Refugio Animal CR", 25000.0, "Colones", "2024-06-05"});
        model.addRow(new Object[]{2, "María Rodríguez", "Amigos Peludos",       50.0, "Dólares", "2024-07-22"});
        model.addRow(new Object[]{3, "Carlos González", "Patitas Felices",   10000.0, "Colones", "2024-08-01"});
        model.addRow(new Object[]{4, "José Vargas",     "Refugio Animal CR",  5000.0, "Colones", "2024-09-10"});
        model.addRow(new Object[]{5, "Luisa Campos",    "Amigos Peludos",       75.0, "Dólares", "2024-10-03"});

        tableDonations.setModel(model);

        // Hide ID column
        tableDonations.getColumnModel().getColumn(0).setMinWidth(0);
        tableDonations.getColumnModel().getColumn(0).setMaxWidth(0);
        tableDonations.getColumnModel().getColumn(0).setPreferredWidth(0);

        updateFooter(model);
    }

    private void updateFooter(DefaultTableModel model) {
        int count    = model.getRowCount();
        double total = 0;
        for (int i = 0; i < count; i++) {
            Object val = model.getValueAt(i, 3);
            if (val instanceof Number) total += ((Number) val).doubleValue();
        }
        labelCount.setText("Records: " + count);
        labelTotal.setText(String.format("Total amount: %,.2f", total));
    }

    // -------------------------------------------------------------------------
    // UI helpers
    // -------------------------------------------------------------------------

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

    private JSpinner buildDateSpinner(java.util.Date initialDate) {
        SpinnerDateModel mdl = new SpinnerDateModel(
            initialDate, null, null, Calendar.DAY_OF_MONTH
        );
        JSpinner spinner = new JSpinner(mdl);
        spinner.setEditor(new JSpinner.DateEditor(spinner, "dd/MM/yyyy"));
        spinner.setFont(new Font("Segoe UI", Font.PLAIN, 13));
        spinner.setPreferredSize(new Dimension(110, 28));
        return spinner;
    }

    private java.util.Date getStartOfYear() {
        Calendar cal = Calendar.getInstance();
        cal.set(Calendar.MONTH, Calendar.JANUARY);
        cal.set(Calendar.DAY_OF_MONTH, 1);
        return cal.getTime();
    }

    // -------------------------------------------------------------------------
    // DecimalFilter — only numbers and one decimal point
    // -------------------------------------------------------------------------
    private static class DecimalFilter extends javax.swing.text.DocumentFilter {
        @Override
        public void insertString(FilterBypass fb, int offset, String text,
                                  javax.swing.text.AttributeSet attr)
                throws javax.swing.text.BadLocationException {
            if (isValid(fb, offset, 0, text)) super.insertString(fb, offset, text, attr);
        }
        @Override
        public void replace(FilterBypass fb, int offset, int length, String text,
                             javax.swing.text.AttributeSet attrs)
                throws javax.swing.text.BadLocationException {
            if (isValid(fb, offset, length, text)) super.replace(fb, offset, length, text, attrs);
        }
        private boolean isValid(FilterBypass fb, int offset, int length, String text) {
            try {
                String current = fb.getDocument().getText(0, fb.getDocument().getLength());
                String result  = current.substring(0, offset) + text
                               + current.substring(offset + length);
                if (result.isEmpty()) return true;
                Double.parseDouble(result);
                return true;
            } catch (Exception e) {
                return false;
            }
        }
    }

    // -------------------------------------------------------------------------
    // Main — RIGHT CLICK THIS FILE → Run File to preview
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
        java.awt.EventQueue.invokeLater(() -> new DonationForm().setVisible(true));
    }
}