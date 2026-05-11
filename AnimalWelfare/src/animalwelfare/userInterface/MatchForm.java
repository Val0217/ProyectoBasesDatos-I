package animalwelfare.userInterface;

import animalwelfare.business.MatchController;
import java.awt.*;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import javax.swing.table.JTableHeader;

/**
 * PREVIEW ONLY — no dependencies on Oracle, controller, or access layer.
 * Right click → Run File to preview the Match Report UI.
 * DELETE this file before final delivery.
 *
 * @author team
 */
public class MatchForm extends javax.swing.JFrame {

    private static final java.util.logging.Logger logger =
        java.util.logging.Logger.getLogger(MatchForm.class.getName());

    private MatchController controller = null;

    // -------------------------------------------------------------------------
    // Tab 1 — Match Report
    // -------------------------------------------------------------------------
    private JTable tableMatches;
    private JLabel labelCount;
    private JButton btnRefresh;

    // -------------------------------------------------------------------------
    // Tab 2 — Run Match (Admin only)
    // -------------------------------------------------------------------------
    private JLabel lblPendingMatches = new JLabel();;
    private JButton btnRunMatch;
    private JTextArea logArea;

    // -------------------------------------------------------------------------
    // Constructor
    // -------------------------------------------------------------------------
    public MatchForm() {
        initComponents();
        controller = new MatchController(this);
        setLocationRelativeTo(null);
        setVisible(true);
        // button back
        JButton btnBack = new JButton("← Back to Menu");
        btnBack.setBackground(new Color(0, 153, 153));
        btnBack.setForeground(Color.WHITE);
        btnBack.setFocusPainted(false);
        btnBack.setBorderPainted(false);
        btnBack.setOpaque(true);
        btnBack.setCursor(new Cursor(Cursor.HAND_CURSOR));
        btnBack.addActionListener(e -> {
            goBack();
        });
        getContentPane().add(btnBack, BorderLayout.SOUTH);
    }
    
    private void goBack(){
        MainMenu window = new MainMenu();
        dispose();
    }

    // -------------------------------------------------------------------------
    // UI Builder
    // -------------------------------------------------------------------------
    private void initComponents() {
        setTitle("Pet Match — Animal Welfare  [PREVIEW]");
        setDefaultCloseOperation(javax.swing.WindowConstants.DISPOSE_ON_CLOSE);
        setMinimumSize(new Dimension(950, 600));

        // Header
        JPanel header = new JPanel(new FlowLayout(FlowLayout.LEFT, 20, 14));
        header.setBackground(new Color(0, 153, 153));
        header.setPreferredSize(new Dimension(950, 58));

        JLabel title = new JLabel("PET MATCH");
        title.setFont(new Font("Segoe UI", Font.BOLD, 24));
        title.setForeground(Color.WHITE);

        JLabel subtitle = new JLabel("— Automatic matching between lost and found pets");
        subtitle.setFont(new Font("Segoe UI", Font.ITALIC, 13));
        subtitle.setForeground(new Color(255, 255, 255, 180));

        header.add(title);
        header.add(subtitle);

        // Tabs
        JTabbedPane tabs = new JTabbedPane();
        tabs.setFont(new Font("Segoe UI", Font.PLAIN, 13));
        tabs.addTab("  Match Report  ", buildReportTab());
        tabs.addTab("  Run Match  ",    buildRunTab());

        getContentPane().setLayout(new BorderLayout());
        getContentPane().add(header, BorderLayout.NORTH);
        getContentPane().add(tabs,   BorderLayout.CENTER);
        pack();
    }

    // -------------------------------------------------------------------------
    // Tab 1 — Match Report
    // -------------------------------------------------------------------------
    private JPanel buildReportTab() {
        JPanel panel = new JPanel(new BorderLayout(0, 8));
        panel.setBackground(Color.WHITE);
        panel.setBorder(BorderFactory.createEmptyBorder(12, 16, 12, 16));

        // Info bar
        JPanel infoBar = new JPanel(new FlowLayout(FlowLayout.LEFT, 10, 8));
        infoBar.setBackground(new Color(245, 245, 245));
        JLabel info = new JLabel("Double-click a row to see full match detail with contact info.");
        info.setFont(new Font("Segoe UI", Font.ITALIC, 12));
        info.setForeground(Color.GRAY);
        infoBar.add(info);

        btnRefresh = grayButton("REFRESH");
        btnRefresh.addActionListener(e -> controller.refresh());
        infoBar.add(btnRefresh);

        // Table
        tableMatches = new JTable();
        tableMatches.setFont(new Font("Segoe UI", Font.PLAIN, 13));
        tableMatches.setRowHeight(26);
        tableMatches.setGridColor(new Color(230, 230, 230));
        tableMatches.setSelectionBackground(new Color(204, 229, 255));
        tableMatches.setDefaultEditor(Object.class, null);

        // Double click for detail
        tableMatches.addMouseListener(new MouseAdapter() {
            @Override
            public void mouseClicked(MouseEvent e) {
                if (e.getClickCount() == 2) onViewDetail();
            }
        });

        JTableHeader tableHeader = tableMatches.getTableHeader();
        tableHeader.setFont(new Font("Segoe UI", Font.BOLD, 13));
        tableHeader.setBackground(new Color(0, 153, 153));
        tableHeader.setForeground(Color.WHITE);
        tableHeader.setReorderingAllowed(false);

        JScrollPane scroll = new JScrollPane(tableMatches);
        scroll.setBorder(BorderFactory.createLineBorder(new Color(200, 200, 200)));

        // Footer
        JPanel footer = new JPanel(new FlowLayout(FlowLayout.LEFT, 20, 6));
        footer.setBackground(new Color(245, 245, 245));
        footer.setBorder(BorderFactory.createMatteBorder(1, 0, 0, 0, new Color(200, 200, 200)));

        labelCount = new JLabel("Records: 0");
        labelCount.setFont(new Font("Segoe UI", Font.BOLD, 13));
        labelCount.setForeground(new Color(0, 102, 102));
        footer.add(labelCount);

        panel.add(infoBar, BorderLayout.NORTH);
        panel.add(scroll,  BorderLayout.CENTER);
        panel.add(footer,  BorderLayout.SOUTH);
        return panel;
    }

    // -------------------------------------------------------------------------
    // Tab 2 — Run Match
    // -------------------------------------------------------------------------
    private JPanel buildRunTab() {
        JPanel panel = new JPanel(new BorderLayout(10, 10));
        panel.setBackground(Color.WHITE);
        panel.setBorder(BorderFactory.createEmptyBorder(30, 40, 30, 40));

        // Top info card
        JPanel card = new JPanel(new BorderLayout(10, 10));
        card.setBackground(new Color(0, 153, 153));
        card.setBorder(BorderFactory.createEmptyBorder(20, 25, 20, 25));

        JLabel cardTitle = new JLabel("Match Engine");
        cardTitle.setFont(new Font("Segoe UI", Font.BOLD, 18));
        cardTitle.setForeground(Color.WHITE);

        JLabel cardDesc = new JLabel(
            "<html>The system automatically runs every 4 hours (configurable in Parameters).<br>" +
            "You can also trigger it manually from here.</html>");
        cardDesc.setFont(new Font("Segoe UI", Font.PLAIN, 13));
        cardDesc.setForeground(new Color(255, 255, 255, 220));

        lblPendingMatches.setFont(new Font("Segoe UI", Font.BOLD, 14));
        lblPendingMatches.setForeground(new Color(255, 230, 100));

        card.add(cardTitle,        BorderLayout.NORTH);
        card.add(cardDesc,         BorderLayout.CENTER);
        card.add(lblPendingMatches,BorderLayout.SOUTH);

        // Run button
        btnRunMatch = new JButton("RUN MATCH NOW");
        btnRunMatch.setBackground(new Color(255, 153, 0));
        btnRunMatch.setForeground(Color.WHITE);
        btnRunMatch.setFont(new Font("Segoe UI", Font.BOLD, 15));
        btnRunMatch.setCursor(new Cursor(Cursor.HAND_CURSOR));
        btnRunMatch.setFocusPainted(false);
        btnRunMatch.setBorderPainted(false);
        btnRunMatch.setOpaque(true);
        btnRunMatch.setPreferredSize(new Dimension(220, 48));
        btnRunMatch.addActionListener(e -> onRunMatch());

        JPanel btnPanel = new JPanel(new FlowLayout(FlowLayout.CENTER));
        btnPanel.setBackground(Color.WHITE);
        btnPanel.add(btnRunMatch);

        // Log area
        logArea = new JTextArea(8, 40);
        logArea.setFont(new Font("Courier New", Font.PLAIN, 12));
        logArea.setEditable(false);
        logArea.setBackground(new Color(30, 30, 30));
        logArea.setForeground(new Color(0, 230, 100));
        logArea.setBorder(BorderFactory.createEmptyBorder(10, 10, 10, 10));
        logArea.setText(
            "> Match engine ready.\n"
        );

        JScrollPane logScroll = new JScrollPane(logArea);
        logScroll.setBorder(BorderFactory.createTitledBorder(
            BorderFactory.createLineBorder(new Color(200, 200, 200)),
            "Log",
            javax.swing.border.TitledBorder.LEFT,
            javax.swing.border.TitledBorder.TOP,
            new Font("Segoe UI", Font.BOLD, 12),
            new Color(0, 153, 153)
        ));

        panel.add(card,      BorderLayout.NORTH);
        panel.add(btnPanel,  BorderLayout.CENTER);
        panel.add(logScroll, BorderLayout.SOUTH);
        return panel;
    }

    // -------------------------------------------------------------------------
    // Actions
    // -------------------------------------------------------------------------

    private void onViewDetail() {
        int row = tableMatches.getSelectedRow();
        if (row < 0) return;

        String matchPct   = tableMatches.getValueAt(row, 1).toString();
        String lostPet    = tableMatches.getValueAt(row, 2).toString();
        String lostOwner  = tableMatches.getValueAt(row, 3).toString();
        String foundPet   = tableMatches.getValueAt(row, 4).toString();
        String finder     = tableMatches.getValueAt(row, 5).toString();
        String matchDate  = tableMatches.getValueAt(row, 6).toString();

        JPanel detail = new JPanel(new GridLayout(0, 1, 5, 5));
        detail.setBackground(Color.WHITE);
        detail.setBorder(BorderFactory.createEmptyBorder(10, 10, 10, 10));

        detail.add(boldLabel("Match: " + matchPct + "%"));
        detail.add(new JSeparator());

        detail.add(boldLabel("Lost Pet:"));
        detail.add(new JLabel(lostPet));
        detail.add(styledLabel("Owner: " + lostOwner));
        detail.add(new JSeparator());

        detail.add(boldLabel("Found Pet:"));
        detail.add(new JLabel(foundPet));
        detail.add(styledLabel("Finder: " + finder));
        detail.add(new JSeparator());

        detail.add(boldLabel("Match generated on: " + matchDate));

        JOptionPane.showMessageDialog(this, detail,
            "Match Detail", JOptionPane.PLAIN_MESSAGE);
    }

    private void onRunMatch() {
        int confirm = JOptionPane.showConfirmDialog(this,
            "Run the match engine now? This will compare all lost and found pets.",
            "Confirm", JOptionPane.YES_NO_OPTION, JOptionPane.QUESTION_MESSAGE);

        if (confirm != JOptionPane.YES_OPTION) return;

        controller.runMatch();
    }


    public void loadMatchReport(DefaultTableModel data){
        tableMatches.setModel(data);

        // Hide ID column
        tableMatches.getColumnModel().getColumn(0).setMinWidth(0);
        tableMatches.getColumnModel().getColumn(0).setMaxWidth(0);
        tableMatches.getColumnModel().getColumn(0).setPreferredWidth(0);

        // Color rows by match percentage
        tableMatches.setDefaultRenderer(Object.class, new javax.swing.table.DefaultTableCellRenderer() {
            @Override
            public Component getTableCellRendererComponent(JTable table, Object value,
                    boolean isSelected, boolean hasFocus, int row, int column) {
                Component c = super.getTableCellRendererComponent(
                    table, value, isSelected, hasFocus, row, column);

                if (!isSelected) {
                    String pct = table.getValueAt(row, 1).toString().replace("%", "");
                    int p = Integer.parseInt(pct);
                    if      (p == 100) c.setBackground(new Color(220, 255, 220)); // green
                    else if (p >= 80)  c.setBackground(new Color(255, 255, 204)); // yellow
                    else               c.setBackground(new Color(255, 240, 220)); // orange
                }

                return c;
            }
        });

        labelCount.setText("Records: " + data.getRowCount());
    }

    public void updatePendingCount(int count){
        logArea.setText(
            "> Match engine ready.\n" +
            "> Next scheduled run: in "+ count +" hours\n"
        );
    }

    // -------------------------------------------------------------------------
    // Helpers
    // -------------------------------------------------------------------------

    private JLabel styledLabel(String text) {
        JLabel lbl = new JLabel(text);
        lbl.setFont(new Font("Segoe UI", Font.PLAIN, 12));
        lbl.setForeground(new Color(0, 102, 102));
        return lbl;
    }

    private JLabel boldLabel(String text) {
        JLabel lbl = new JLabel(text);
        lbl.setFont(new Font("Segoe UI", Font.BOLD, 13));
        lbl.setForeground(Color.DARK_GRAY);
        return lbl;
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
        java.awt.EventQueue.invokeLater(() -> new MatchForm().setVisible(true));
    }
}

