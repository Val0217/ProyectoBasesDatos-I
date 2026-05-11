package animalwelfare.userInterface;

import animalwelfare.business.StatisticsController;
import java.awt.*;
import java.util.Calendar;
import javax.swing.*;
import org.jfree.chart.ChartFactory;
import org.jfree.chart.ChartPanel;
import org.jfree.chart.JFreeChart;
import org.jfree.chart.axis.CategoryAxis;
import org.jfree.chart.axis.NumberAxis;
import org.jfree.chart.plot.CategoryPlot;
import org.jfree.chart.plot.PiePlot;
import org.jfree.chart.plot.PlotOrientation;
import org.jfree.chart.renderer.category.BarRenderer;
import org.jfree.data.category.DefaultCategoryDataset;
import org.jfree.data.general.DefaultPieDataset;

import java.awt.Color;
import java.text.DecimalFormat;

/**
 * PREVIEW ONLY — Statistics screen using JFreeChart with mock data.
 * Right click → Run File to preview.
 * DELETE this file before final delivery.
 *
 * Statistics implemented:
 *   a. Total pets by type and state (bar chart)
 *   b. Total donations by association (bar chart)
 *   c. Adoption success vs waiting (pie chart)
 *   d. Non-adopted pets by age range (pie chart)
 *   e. Average adoption time by type and breed (bar chart) — group's additional stat
 *
 * @author team
 */
public class StatisticsForm extends javax.swing.JFrame {

    private static final java.util.logging.Logger logger =
        java.util.logging.Logger.getLogger(StatisticsForm.class.getName());

    // controlador
    private StatisticsController controller = null;

    // variable 
    DefaultCategoryDataset datasetPetsByTypeState = null;

    // Date range spinners (shared across tabs)
    private JSpinner spinnerFrom;
    private JSpinner spinnerTo;

    // Summary labels
    private JLabel lblTotalPets;
    private JLabel lblTotalDonations;
    private JLabel lblTotalAdoptions;

    // -------------------------------------------------------------------------
    // Constructor
    // -------------------------------------------------------------------------
    public StatisticsForm() {
        controller = new StatisticsController();
        initComponents();
        setLocationRelativeTo(null);
        setVisible(true);
    }

    // -------------------------------------------------------------------------
    // UI Builder
    // -------------------------------------------------------------------------
    private void initComponents() {
        setTitle("Statistics — Animal Welfare  [PREVIEW]");
        setDefaultCloseOperation(javax.swing.WindowConstants.DISPOSE_ON_CLOSE);
        setMinimumSize(new Dimension(950, 680));

        // Header
        JPanel header = new JPanel(new FlowLayout(FlowLayout.LEFT, 20, 14));
        header.setBackground(new Color(0, 153, 153));
        header.setPreferredSize(new Dimension(950, 58));
        JLabel title = new JLabel("STATISTICS");
        title.setFont(new Font("Segoe UI", Font.BOLD, 24));
        title.setForeground(Color.WHITE);
        header.add(title);

        // Date range bar (shared)
        JPanel dateBar = buildDateBar();

        // Summary cards
        JPanel summaryPanel = buildSummaryCards();

        // Tabs with charts
        JTabbedPane tabs = new JTabbedPane();
        tabs.setFont(new Font("Segoe UI", Font.PLAIN, 13));
        tabs.addTab("  Pets by Type & State  ",  buildPetsByTypeTab());
        tabs.addTab("  Donations  ",             buildDonationsTab());
        tabs.addTab("  Adoptions  ",             buildAdoptionsTab());
        tabs.addTab("  Age Ranges  ",            buildAgeRangesTab());
        tabs.addTab("  Avg Adoption Time  ",     buildAvgAdoptionTimeTab());

        // Top panel = date bar + summary
        JPanel topPanel = new JPanel(new BorderLayout());
        topPanel.add(dateBar,     BorderLayout.NORTH);
        topPanel.add(summaryPanel, BorderLayout.SOUTH);

        getContentPane().setLayout(new BorderLayout());
        getContentPane().add(header,   BorderLayout.NORTH);
        getContentPane().add(topPanel, BorderLayout.CENTER);
        getContentPane().add(tabs,     BorderLayout.SOUTH);

        // Give tabs most of the space
        getContentPane().setLayout(new BorderLayout());
        getContentPane().add(header,    BorderLayout.NORTH);
        getContentPane().add(topPanel,  BorderLayout.CENTER);

        JPanel mainContent = new JPanel(new BorderLayout());
        mainContent.add(topPanel, BorderLayout.NORTH);
        mainContent.add(tabs,     BorderLayout.CENTER);

        getContentPane().setLayout(new BorderLayout());
        getContentPane().add(header,      BorderLayout.NORTH);
        getContentPane().add(mainContent, BorderLayout.CENTER);

        pack();
    }

    // -------------------------------------------------------------------------
    // Date Range Bar
    // -------------------------------------------------------------------------
    private JPanel buildDateBar() {
        JPanel bar = new JPanel(new FlowLayout(FlowLayout.LEFT, 15, 8));
        bar.setBackground(new Color(245, 245, 245));
        bar.setBorder(BorderFactory.createMatteBorder(0, 0, 1, 0, new Color(200, 200, 200)));

        bar.add(styledLabel("From:"));
        spinnerFrom = buildDateSpinner(getStartOfYear());
        bar.add(spinnerFrom);

        bar.add(styledLabel("To:"));
        spinnerTo = buildDateSpinner(new java.util.Date());
        bar.add(spinnerTo);

        JButton btnApply = tealButton("APPLY");
        btnApply.setPreferredSize(new Dimension(90, 28));
        btnApply.addActionListener(e -> onApplyDateFilter());
        bar.add(btnApply);

        JButton btnReset = grayButton("RESET");
        btnReset.setPreferredSize(new Dimension(80, 28));
        btnReset.addActionListener(e -> {
            spinnerFrom.setValue(getStartOfYear());
            spinnerTo.setValue(new java.util.Date());
        });
        bar.add(btnReset);

        return bar;
    }

    // -------------------------------------------------------------------------
    // Summary Cards
    // -------------------------------------------------------------------------
    private JPanel buildSummaryCards() {
        JPanel panel = new JPanel(new GridLayout(1, 3, 10, 0));
        panel.setBackground(Color.WHITE);
        panel.setBorder(BorderFactory.createEmptyBorder(10, 20, 10, 20));

        lblTotalPets       = buildSummaryCard("Total Pets",       "42",     new Color(0, 153, 153));
        lblTotalDonations  = buildSummaryCard("Total Donations",  "₡85,000", new Color(0, 102, 102));
        lblTotalAdoptions  = buildSummaryCard("Adoptions",        "18",     new Color(255, 153, 0));

        panel.add(lblTotalPets.getParent());
        panel.add(lblTotalDonations.getParent());
        panel.add(lblTotalAdoptions.getParent());

        return panel;
    }

    private JLabel buildSummaryCard(String title, String value, Color color) {
        JPanel card = new JPanel(new BorderLayout());
        card.setBackground(color);
        card.setBorder(BorderFactory.createEmptyBorder(12, 16, 12, 16));
        card.setPreferredSize(new Dimension(200, 70));

        JLabel lTitle = new JLabel(title);
        lTitle.setFont(new Font("Segoe UI", Font.PLAIN, 12));
        lTitle.setForeground(new Color(255, 255, 255, 200));

        JLabel lValue = new JLabel(value);
        lValue.setFont(new Font("Segoe UI", Font.BOLD, 22));
        lValue.setForeground(Color.WHITE);

        card.add(lTitle, BorderLayout.NORTH);
        card.add(lValue, BorderLayout.CENTER);

        return lValue;
    }

    // =========================================================================
    // TAB A — Pets by Type and State (Bar Chart)
    // =========================================================================


    private JPanel buildPetsByTypeTab() {

        JPanel panel = new JPanel(new BorderLayout());
        panel.setBackground(Color.WHITE);

        datasetPetsByTypeState = controller.getPetsByTypeAndState(
            new java.sql.Date(((java.util.Date)spinnerFrom.getValue()).getTime()),
            new java.sql.Date(((java.util.Date)spinnerTo.getValue()).getTime())
        );

        if (datasetPetsByTypeState.getRowCount() == 0) {
            JLabel noData = new JLabel("No data available for the selected date range.");
            noData.setFont(new Font("Segoe UI", Font.ITALIC, 14));
            noData.setForeground(Color.GRAY);
            noData.setHorizontalAlignment(SwingConstants.CENTER);
            panel.add(noData, BorderLayout.CENTER);
            return panel;
        }

        JFreeChart chart = ChartFactory.createBarChart(
            "Total Pets by Type and State",
            "Pet Type",
            "Count",
            datasetPetsByTypeState,
            PlotOrientation.VERTICAL,
            true, true, false
        );

        styleBarChart(chart);

        // Color per state
        CategoryPlot plot = chart.getCategoryPlot();
        BarRenderer renderer = (BarRenderer) plot.getRenderer();
        renderer.setSeriesPaint(0, new Color(220, 80,  80));   // Lost — red
        renderer.setSeriesPaint(1, new Color(80,  180, 80));   // Found — green
        renderer.setSeriesPaint(2, new Color(255, 153, 0));    // In Adoption — orange
        renderer.setSeriesPaint(3, new Color(0,   153, 153));  // Adopted — teal

        ChartPanel chartPanel = new ChartPanel(chart);
        chartPanel.setPreferredSize(new Dimension(900, 380));

        // Numbers below chart
        /*JPanel statsRow = buildStatsRow(new String[]{
            "Total Lost: "+datasetPetsByTypeState.getValue(0, 0), "Total Found: "+datasetPetsByTypeState.getValue(1, 0), "In Adoption: "+datasetPetsByTypeState.getValue(2, 0), "Adopted: "+datasetPetsByTypeState.getValue(3, 0)
        });*/

        panel.add(chartPanel, BorderLayout.CENTER);
        //panel.add(statsRow,   BorderLayout.SOUTH); //descomentar para mockup sin números
        return panel;
    }

    // =========================================================================
    // TAB B — Donations by Association (Bar Chart)
    // =========================================================================
    private JPanel buildDonationsTab() {
        JPanel panel = new JPanel(new BorderLayout());
        panel.setBackground(Color.WHITE);

        DefaultCategoryDataset dataset = controller.getDonationsByAssociation(new java.sql.Date(((java.util.Date)spinnerFrom.getValue()).getTime()), new java.sql.Date(((java.util.Date)spinnerTo.getValue()).getTime()));

        JFreeChart chart = ChartFactory.createBarChart(
            "Total Donations by Association",
            "Association",
            "Amount",
            dataset,
            PlotOrientation.VERTICAL,
            true, true, false
        );


        if (dataset.getRowCount() == 0) {
            JLabel noData = new JLabel("No data available for the selected date range.");
            noData.setFont(new Font("Segoe UI", Font.ITALIC, 14));
            noData.setForeground(Color.GRAY);
            noData.setHorizontalAlignment(SwingConstants.CENTER);
            panel.add(noData, BorderLayout.CENTER);
            return panel;
        }


        styleBarChart(chart);

        CategoryPlot plot = chart.getCategoryPlot();
        BarRenderer renderer = (BarRenderer) plot.getRenderer();
        renderer.setSeriesPaint(0, new Color(0, 153, 153));
        renderer.setSeriesPaint(1, new Color(255, 153, 0));

        ChartPanel chartPanel = new ChartPanel(chart);
        chartPanel.setPreferredSize(new Dimension(900, 380));



        /*JPanel statsRow = buildStatsRow(new String[]{
            "Total Colones: "+dataset.getValue(0, 0), "Total Dollars: "+dataset.getValue(1, 0), "Associations: "+dataset.getColumnCount()
        });*/

        panel.add(chartPanel, BorderLayout.CENTER);
        //panel.add(statsRow,   BorderLayout.SOUTH); // descomentar para mockup sin números
        return panel;
    }

    // =========================================================================
    // TAB C — Adoption Success vs Waiting (Pie Chart)
    // =========================================================================
    private JPanel buildAdoptionsTab() {
        JPanel panel = new JPanel(new BorderLayout());
        panel.setBackground(Color.WHITE);

        // Filter bar for type and breed
        JPanel filterBar = new JPanel(new FlowLayout(FlowLayout.LEFT, 15, 8));
        filterBar.setBackground(new Color(245, 245, 245));

        filterBar.add(styledLabel("Pet Type:"));
        JComboBox<String> comboType = new JComboBox<>(
            new String[]{"All", "Dog", "Cat", "Rabbit"});
        comboType.setFont(new Font("Segoe UI", Font.PLAIN, 13));
        filterBar.add(comboType);

        filterBar.add(styledLabel("Breed:"));
        JComboBox<String> comboBreed = new JComboBox<>(
            new String[]{"All", "Labrador", "Poodle", "Siamese", "Mixed"});
        comboBreed.setFont(new Font("Segoe UI", Font.PLAIN, 13));
        filterBar.add(comboBreed);

        JButton btnFilter = tealButton("FILTER");
        btnFilter.setPreferredSize(new Dimension(80, 28));
        btnFilter.addActionListener(e -> JOptionPane.showMessageDialog(this,
            "Filter applied. (MOCK)", "Info", JOptionPane.INFORMATION_MESSAGE));
        filterBar.add(btnFilter);

        // Pie chart
        DefaultPieDataset dataset = new DefaultPieDataset();
        dataset.setValue("Adopted (18)",        18);
        dataset.setValue("Waiting for Adoption (8)", 8);

        JFreeChart chart = ChartFactory.createPieChart(
            "Adoptions: Success vs Waiting",
            dataset, true, true, false
        );

        stylePieChart(chart);

        PiePlot plot = (PiePlot) chart.getPlot();
        plot.setSectionPaint("Adopted (18)",             new Color(0, 153, 153));
        plot.setSectionPaint("Waiting for Adoption (8)", new Color(255, 153, 0));
        plot.setLabelGenerator(new org.jfree.chart.labels.StandardPieSectionLabelGenerator(
            "{0}: {1} ({2})", new DecimalFormat("0"), new DecimalFormat("0.0%")));

        ChartPanel chartPanel = new ChartPanel(chart);
        chartPanel.setPreferredSize(new Dimension(900, 340));

        JPanel statsRow = buildStatsRow(new String[]{
            "Adopted: 18 (69.2%)", "Waiting: 8 (30.8%)", "Total: 26"
        });

        panel.add(filterBar,  BorderLayout.NORTH);
        panel.add(chartPanel, BorderLayout.CENTER);
        panel.add(statsRow,   BorderLayout.SOUTH);
        return panel;
    }

    // =========================================================================
    // TAB D — Non-adopted by Age Range (Pie Chart)
    // =========================================================================
    private JPanel buildAgeRangesTab() {
        JPanel panel = new JPanel(new BorderLayout());
        panel.setBackground(Color.WHITE);

        DefaultPieDataset dataset = new DefaultPieDataset();
        dataset.setValue("0-1 yrs (Puppies): 3",  3);
        dataset.setValue("1-5 yrs: 8",            8);
        dataset.setValue("5-9 yrs: 5",            5);
        dataset.setValue("10-12 yrs: 2",          2);
        dataset.setValue("+12 yrs: 1",            1);

        JFreeChart chart = ChartFactory.createPieChart(
            "Non-adopted Pets by Age Range",
            dataset, true, true, false
        );

        stylePieChart(chart);

        PiePlot plot = (PiePlot) chart.getPlot();
        plot.setSectionPaint("0-1 yrs (Puppies): 3", new Color(0,   153, 153));
        plot.setSectionPaint("1-5 yrs: 8",           new Color(255, 153, 0));
        plot.setSectionPaint("5-9 yrs: 5",           new Color(80,  180, 80));
        plot.setSectionPaint("10-12 yrs: 2",         new Color(220, 80,  80));
        plot.setSectionPaint("+12 yrs: 1",           new Color(150, 100, 200));
        plot.setLabelGenerator(new org.jfree.chart.labels.StandardPieSectionLabelGenerator(
            "{0}: {2}", new DecimalFormat("0"), new DecimalFormat("0.0%")));

        ChartPanel chartPanel = new ChartPanel(chart);
        chartPanel.setPreferredSize(new Dimension(900, 360));

        JPanel statsRow = buildStatsRow(new String[]{
            "Puppies (0-1): 3 (15.8%)", "Young (1-5): 8 (42.1%)",
            "Adult (5-9): 5 (26.3%)", "Senior (10-12): 2 (10.5%)", "+12: 1 (5.3%)"
        });

        panel.add(chartPanel, BorderLayout.CENTER);
        panel.add(statsRow,   BorderLayout.SOUTH);
        return panel;
    }

    // =========================================================================
    // TAB E — Average Adoption Time by Type and Breed (Bar Chart) — ADDITIONAL
    // =========================================================================
    private JPanel buildAvgAdoptionTimeTab() {
        JPanel panel = new JPanel(new BorderLayout());
        panel.setBackground(Color.WHITE);

        // Info label
        JPanel infoBar = new JPanel(new FlowLayout(FlowLayout.LEFT, 15, 8));
        infoBar.setBackground(new Color(245, 245, 245));
        JLabel info = new JLabel("Average days a pet waits before being adopted, grouped by type and breed.");
        info.setFont(new Font("Segoe UI", Font.ITALIC, 12));
        info.setForeground(Color.GRAY);
        infoBar.add(info);

        // MOCK data — average days to adoption
        DefaultCategoryDataset dataset = new DefaultCategoryDataset();
        dataset.addValue(12, "Dog",    "Labrador");
        dataset.addValue(25, "Dog",    "Poodle");
        dataset.addValue(18, "Dog",    "Chihuahua");
        dataset.addValue(30, "Dog",    "Mixed");
        dataset.addValue(20, "Cat",    "Siamese");
        dataset.addValue(35, "Cat",    "Persian");
        dataset.addValue(28, "Cat",    "Mixed");
        dataset.addValue(45, "Rabbit", "Mixed");

        JFreeChart chart = ChartFactory.createBarChart(
            "Average Adoption Time (days) by Type and Breed",
            "Breed",
            "Average Days",
            dataset,
            PlotOrientation.VERTICAL,
            true, true, false
        );

        styleBarChart(chart);

        CategoryPlot plot = chart.getCategoryPlot();
        BarRenderer renderer = (BarRenderer) plot.getRenderer();
        renderer.setSeriesPaint(0, new Color(0,   153, 153));  // Dog
        renderer.setSeriesPaint(1, new Color(255, 153, 0));    // Cat
        renderer.setSeriesPaint(2, new Color(150, 100, 200));  // Rabbit

        // Rotate x labels for readability
        CategoryAxis domainAxis = plot.getDomainAxis();
        domainAxis.setCategoryLabelPositions(
            org.jfree.chart.axis.CategoryLabelPositions.UP_45);

        ChartPanel chartPanel = new ChartPanel(chart);
        chartPanel.setPreferredSize(new Dimension(900, 360));

        JPanel statsRow = buildStatsRow(new String[]{
            "Fastest: Labrador (12 days)", "Slowest: Rabbit Mixed (45 days)",
            "Overall Average: 26.6 days"
        });

        panel.add(infoBar,    BorderLayout.NORTH);
        panel.add(chartPanel, BorderLayout.CENTER);
        panel.add(statsRow,   BorderLayout.SOUTH);
        return panel;
    }

    public void onApplyDateFilter() {
        controller.getPetsByTypeAndState(
            new java.sql.Date(((java.util.Date)spinnerFrom.getValue()).getTime()),
            new java.sql.Date(((java.util.Date)spinnerTo.getValue()).getTime())
        );
    }

    // -------------------------------------------------------------------------
    // Chart styling helpers
    // -------------------------------------------------------------------------

    private void styleBarChart(JFreeChart chart) {
        chart.setBackgroundPaint(Color.WHITE);
        chart.getTitle().setFont(new Font("Segoe UI", Font.BOLD, 14));

        CategoryPlot plot = chart.getCategoryPlot();
        plot.setBackgroundPaint(Color.WHITE);
        plot.setRangeGridlinePaint(new Color(220, 220, 220));
        plot.setOutlineVisible(false);

        BarRenderer renderer = (BarRenderer) plot.getRenderer();
        renderer.setDrawBarOutline(false);
        renderer.setShadowVisible(false);
        renderer.setMaximumBarWidth(0.1);

        NumberAxis rangeAxis = (NumberAxis) plot.getRangeAxis();
        rangeAxis.setStandardTickUnits(NumberAxis.createIntegerTickUnits());
        rangeAxis.setTickLabelFont(new Font("Segoe UI", Font.PLAIN, 11));

        CategoryAxis domainAxis = plot.getDomainAxis();
        domainAxis.setTickLabelFont(new Font("Segoe UI", Font.PLAIN, 11));
    }

    private void stylePieChart(JFreeChart chart) {
        chart.setBackgroundPaint(Color.WHITE);
        chart.getTitle().setFont(new Font("Segoe UI", Font.BOLD, 14));

        PiePlot plot = (PiePlot) chart.getPlot();
        plot.setBackgroundPaint(Color.WHITE);
        plot.setOutlineVisible(false);
        plot.setShadowPaint(null);
        plot.setLabelFont(new Font("Segoe UI", Font.PLAIN, 11));
        plot.setLabelBackgroundPaint(new Color(255, 255, 255, 200));
        plot.setLabelOutlinePaint(null);
        plot.setLabelShadowPaint(null);
    }

    // -------------------------------------------------------------------------
    // Stats row below chart
    // -------------------------------------------------------------------------
    private JPanel buildStatsRow(String[] stats) {
        JPanel row = new JPanel(new FlowLayout(FlowLayout.CENTER, 30, 8));
        row.setBackground(new Color(245, 245, 245));
        row.setBorder(BorderFactory.createMatteBorder(1, 0, 0, 0, new Color(200, 200, 200)));

        for (String stat : stats) {
            JLabel lbl = new JLabel(stat);
            lbl.setFont(new Font("Segoe UI", Font.BOLD, 12));
            lbl.setForeground(new Color(0, 102, 102));
            row.add(lbl);

            if (stats.length > 1) {
                JSeparator sep = new JSeparator(SwingConstants.VERTICAL);
                sep.setPreferredSize(new Dimension(1, 16));
                sep.setForeground(new Color(200, 200, 200));
                row.add(sep);
            }
        }

        return row;
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
            initialDate, null, null, Calendar.DAY_OF_MONTH);
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
        java.awt.EventQueue.invokeLater(() -> new StatisticsForm().setVisible(true));
    }
}
