package animalwelfare.userInterface;

import animalwelfare.access.DbObject;
import java.awt.*;
import java.awt.event.*;
import java.util.ArrayList;
import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import javax.swing.table.JTableHeader;

/**
 * PREVIEW ONLY — no dependencies on Oracle, controller, or access layer.
 * Right click → Run File to preview the Block List UI.
 * DELETE this file before final delivery.
 *
 * @author team
 */
public class BlockListForm extends javax.swing.JFrame {

    private static final java.util.logging.Logger logger =
        java.util.logging.Logger.getLogger(BlockListForm.class.getName());

    // -------------------------------------------------------------------------
    // Tab 1 — Block List
    // -------------------------------------------------------------------------
    private JTable tableBlockList;
    private JLabel labelCount;
    private JButton btnViewDetail;
    private JButton btnRemove;
    private JButton btnRefresh;

    // -------------------------------------------------------------------------
    // Tab 2 — Report Person
    // -------------------------------------------------------------------------
    private JComboBox<String> comboPerson;
    private JTextArea textDescription;
    private JButton btnReport;
    private JButton btnClearReport;

    // -------------------------------------------------------------------------
    // Constructor
    // -------------------------------------------------------------------------
    public BlockListForm() {
        initComponents();
        loadMockTable();
        setLocationRelativeTo(null);
    }

    // -------------------------------------------------------------------------
    // UI Builder
    // -------------------------------------------------------------------------
    private void initComponents() {
        setTitle("Block List — Animal Welfare  [PREVIEW]");
        setDefaultCloseOperation(javax.swing.WindowConstants.DISPOSE_ON_CLOSE);
        setMinimumSize(new Dimension(820, 580));

        // Header
        JPanel header = new JPanel(new FlowLayout(FlowLayout.LEFT, 20, 14));
        header.setBackground(new Color(0, 153, 153));
        header.setPreferredSize(new Dimension(820, 58));
        JLabel title = new JLabel("BLOCK LIST");
        title.setFont(new Font("Segoe UI", Font.BOLD, 24));
        title.setForeground(Color.WHITE);
        header.add(title);

        // Tabs
        JTabbedPane tabs = new JTabbedPane();
        tabs.setFont(new Font("Segoe UI", Font.PLAIN, 13));
        tabs.addTab("  Block List  ",    buildBlockListTab());
        tabs.addTab("  Report Person  ", buildReportTab());

        getContentPane().setLayout(new BorderLayout());
        getContentPane().add(header, BorderLayout.NORTH);
        getContentPane().add(tabs,   BorderLayout.CENTER);
        pack();
    }

    // -------------------------------------------------------------------------
    // Tab 1 — Block List
    // -------------------------------------------------------------------------
    private JPanel buildBlockListTab() {
        JPanel panel = new JPanel(new BorderLayout(0, 8));
        panel.setBackground(Color.WHITE);
        panel.setBorder(BorderFactory.createEmptyBorder(12, 16, 12, 16));

        // Button bar
        JPanel btnBar = new JPanel(new FlowLayout(FlowLayout.LEFT, 10, 8));
        btnBar.setBackground(new Color(245, 245, 245));

        btnViewDetail = tealButton("VIEW DETAIL");
        btnViewDetail.addActionListener(e -> onViewDetail());

        btnRemove = new JButton("REMOVE FROM LIST");
        btnRemove.setBackground(new Color(200, 60, 60));
        btnRemove.setForeground(Color.WHITE);
        btnRemove.setFont(new Font("Segoe UI", Font.BOLD, 12));
        btnRemove.setCursor(new Cursor(Cursor.HAND_CURSOR));
        btnRemove.setFocusPainted(false);
        btnRemove.setBorderPainted(false);
        btnRemove.setOpaque(true);
        btnRemove.addActionListener(e -> onRemove());

        btnRefresh = grayButton("REFRESH");
        btnRefresh.addActionListener(e -> loadMockTable());

        btnBar.add(btnViewDetail);
        btnBar.add(btnRemove);
        btnBar.add(btnRefresh);

        // Table
        tableBlockList = new JTable();
        tableBlockList.setFont(new Font("Segoe UI", Font.PLAIN, 13));
        tableBlockList.setRowHeight(26);
        tableBlockList.setGridColor(new Color(230, 230, 230));
        tableBlockList.setSelectionBackground(new Color(255, 200, 200)); // reddish for blocked
        tableBlockList.setDefaultEditor(Object.class, null);

        // Double click to view detail
        tableBlockList.addMouseListener(new MouseAdapter() {
            @Override
            public void mouseClicked(MouseEvent e) {
                if (e.getClickCount() == 2) onViewDetail();
            }
        });

        JTableHeader tableHeader = tableBlockList.getTableHeader();
        tableHeader.setFont(new Font("Segoe UI", Font.BOLD, 13));
        tableHeader.setBackground(new Color(0, 153, 153));
        tableHeader.setForeground(Color.WHITE);
        tableHeader.setReorderingAllowed(false);

        JScrollPane scroll = new JScrollPane(tableBlockList);
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
    // Tab 2 — Report Person
    // -------------------------------------------------------------------------
    private JPanel buildReportTab() {
        JPanel panel = new JPanel(null);
        panel.setBackground(Color.WHITE);

        int labelX = 80;
        int fieldX = 250;
        int fieldW = 350;
        int startY = 50;
        int gap    = 60;

        // Person combo
        JLabel lPerson = styledLabel("Person to Report *");
        lPerson.setBounds(labelX, startY, 160, 30);
        panel.add(lPerson);

        comboPerson = new JComboBox<>();
        comboPerson.setFont(new Font("Segoe UI", Font.PLAIN, 13));
        comboPerson.setBounds(fieldX, startY, fieldW, 30);
        panel.add(comboPerson);

        // Description
        JLabel lDesc = styledLabel("Reason *");
        lDesc.setBounds(labelX, startY + gap, 160, 30);
        panel.add(lDesc);

        textDescription = new JTextArea();
        textDescription.setFont(new Font("Segoe UI", Font.PLAIN, 13));
        textDescription.setLineWrap(true);
        textDescription.setWrapStyleWord(true);
        textDescription.setBorder(BorderFactory.createCompoundBorder(
            BorderFactory.createLineBorder(new Color(200, 200, 200)),
            BorderFactory.createEmptyBorder(6, 8, 6, 8)
        ));
        JScrollPane descScroll = new JScrollPane(textDescription);
        descScroll.setBounds(fieldX, startY + gap, fieldW, 100);
        panel.add(descScroll);

        // Separator
        JSeparator sep = new JSeparator();
        sep.setForeground(new Color(220, 220, 220));
        sep.setBounds(labelX, startY + gap + 115, fieldX + fieldW - labelX, 2);
        panel.add(sep);

        // Buttons
        btnReport = new JButton("REPORT");
        btnReport.setBackground(new Color(200, 60, 60));
        btnReport.setForeground(Color.WHITE);
        btnReport.setFont(new Font("Segoe UI", Font.BOLD, 12));
        btnReport.setCursor(new Cursor(Cursor.HAND_CURSOR));
        btnReport.setFocusPainted(false);
        btnReport.setBorderPainted(false);
        btnReport.setOpaque(true);
        btnReport.setBounds(fieldX, startY + gap + 130, 140, 38);
        btnReport.addActionListener(e -> onReport());
        panel.add(btnReport);

        btnClearReport = grayButton("CLEAR");
        btnClearReport.setBounds(fieldX + 155, startY + gap + 130, 140, 38);
        btnClearReport.addActionListener(e -> clearReportForm());
        panel.add(btnClearReport);

        return panel;
    }

    // -------------------------------------------------------------------------
    // Actions
    // -------------------------------------------------------------------------

    private void onViewDetail() {
        int row = tableBlockList.getSelectedRow();
        if (row < 0) {
            JOptionPane.showMessageDialog(this,
                "Please select a person first.",
                "No Selection", JOptionPane.WARNING_MESSAGE);
            return;
        }

        // Get data from selected row
        String name      = tableBlockList.getValueAt(row, 1).toString();
        String blockDate = tableBlockList.getValueAt(row, 2).toString();
        String reason    = tableBlockList.getValueAt(row, 3).toString();
        String stars     = tableBlockList.getValueAt(row, 4).toString();
        String notes     = tableBlockList.getValueAt(row, 5).toString();

        // Build detail panel
        JPanel detail = new JPanel(new GridLayout(0, 1, 5, 5));
        detail.setBackground(Color.WHITE);
        detail.setBorder(BorderFactory.createEmptyBorder(10, 10, 10, 10));

        detail.add(boldLabel("Person:"));
        detail.add(new JLabel(name));
        detail.add(new JSeparator());

        detail.add(boldLabel("Blocked on:"));
        detail.add(new JLabel(blockDate));
        detail.add(new JSeparator());

        detail.add(boldLabel("Reason reported:"));
        JTextArea reasonArea = new JTextArea(reason);
        reasonArea.setLineWrap(true);
        reasonArea.setWrapStyleWord(true);
        reasonArea.setEditable(false);
        reasonArea.setBackground(new Color(245, 245, 245));
        detail.add(reasonArea);
        detail.add(new JSeparator());

        detail.add(boldLabel("Rating:"));
        detail.add(new JLabel(stars + " / 5 ★"));
        detail.add(new JSeparator());

        detail.add(boldLabel("Notes:"));
        JTextArea notesArea = new JTextArea(notes);
        notesArea.setLineWrap(true);
        notesArea.setWrapStyleWord(true);
        notesArea.setEditable(false);
        notesArea.setBackground(new Color(245, 245, 245));
        detail.add(notesArea);

        JOptionPane.showMessageDialog(this, detail,
            "Detail — " + name, JOptionPane.PLAIN_MESSAGE);
    }

    private void onRemove() {
        int row = tableBlockList.getSelectedRow();
        if (row < 0) {
            JOptionPane.showMessageDialog(this,
                "Please select a person first.",
                "No Selection", JOptionPane.WARNING_MESSAGE);
            return;
        }

        String name = tableBlockList.getValueAt(row, 1).toString();

        int confirm = JOptionPane.showConfirmDialog(this,
            "Remove " + name + " from the block list?",
            "Confirm", JOptionPane.YES_NO_OPTION, JOptionPane.WARNING_MESSAGE);

        if (confirm != JOptionPane.YES_OPTION) return;

        // MOCK — remove row from table
        ((DefaultTableModel) tableBlockList.getModel()).removeRow(row);
        labelCount.setText("Records: " + tableBlockList.getRowCount());

        JOptionPane.showMessageDialog(this,
            name + " removed from block list. (MOCK)",
            "Success", JOptionPane.INFORMATION_MESSAGE);
    }

    private void onReport() {
        String person = (String) comboPerson.getSelectedItem();
        String reason = textDescription.getText().trim();

        if (person == null || person.isEmpty()) {
            JOptionPane.showMessageDialog(this,
                "Please select a person to report.",
                "Validation", JOptionPane.WARNING_MESSAGE);
            return;
        }

        if (reason.isEmpty()) {
            JOptionPane.showMessageDialog(this,
                "Please provide a reason for the report.",
                "Validation", JOptionPane.WARNING_MESSAGE);
            return;
        }

        // MOCK — simulate report
        JOptionPane.showMessageDialog(this,
            person + " has been reported and added to the block list. (MOCK)",
            "Success", JOptionPane.INFORMATION_MESSAGE);

        // Add to table
        DefaultTableModel model = (DefaultTableModel) tableBlockList.getModel();
        model.insertRow(0, new Object[]{
            model.getRowCount() + 1,
            person,
            new java.sql.Date(System.currentTimeMillis()).toString(),
            reason,
            "N/A",
            "No notes yet"
        });
        labelCount.setText("Records: " + tableBlockList.getRowCount());
        clearReportForm();
    }

    public void clearReportForm() {
        comboPerson.setSelectedIndex(0);
        textDescription.setText("");
    }


    public void fillPersonCombo(ArrayList<DbObject> listPerson) {
        comboPerson.removeAllItems();
        comboPerson.addItem("Select a person...");
        for (DbObject person : listPerson) {
            comboPerson.addItem(person.getName());
        }
    }

    public void loadBlockList(DefaultTableModel blockList) {

        tableBlockList.setModel(blockList);

        // Hide ID column
        tableBlockList.getColumnModel().getColumn(0).setMinWidth(0);
        tableBlockList.getColumnModel().getColumn(0).setMaxWidth(0);
        tableBlockList.getColumnModel().getColumn(0).setPreferredWidth(0);

        labelCount.setText("Records: " + blockList.getRowCount());
    }

    private void loadMockTable() {
        DefaultTableModel model = new DefaultTableModel(
            new String[]{"ID", "Person", "Blocked On", "Reason", "Stars", "Notes"}, 0
        ) {
            @Override public boolean isCellEditable(int r, int c) { return false; }
        };

        model.addRow(new Object[]{1, "Pedro Salas",    "2024-02-01",
            "Reported for animal mistreatment", "1", "Returned the pet in bad condition."});
        model.addRow(new Object[]{2, "Roberto Méndez", "2024-03-15",
            "Did not follow adoption agreement", "2", "Ignored follow-up calls."});
        model.addRow(new Object[]{3, "Ana Solís",      "2024-05-20",
            "Abandoned the adopted pet",         "1", "Pet was found on the street."});

        tableBlockList.setModel(model);

        // Hide ID column
        tableBlockList.getColumnModel().getColumn(0).setMinWidth(0);
        tableBlockList.getColumnModel().getColumn(0).setMaxWidth(0);
        tableBlockList.getColumnModel().getColumn(0).setPreferredWidth(0);

        labelCount.setText("Records: " + model.getRowCount());
    }

    // -------------------------------------------------------------------------
    // Helpers
    // -------------------------------------------------------------------------

    private JLabel styledLabel(String text) {
        JLabel lbl = new JLabel(text);
        lbl.setFont(new Font("Segoe UI", Font.BOLD, 13));
        lbl.setForeground(new Color(0, 153, 153));
        return lbl;
    }

    private JLabel boldLabel(String text) {
        JLabel lbl = new JLabel(text);
        lbl.setFont(new Font("Segoe UI", Font.BOLD, 13));
        lbl.setForeground(Color.DARK_GRAY);
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
        java.awt.EventQueue.invokeLater(() -> new BlockListForm().setVisible(true));
    }
}
