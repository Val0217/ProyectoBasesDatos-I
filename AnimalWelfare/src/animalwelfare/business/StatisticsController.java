package animalwelfare.business;

import animalwelfare.access.DbObject;
import animalwelfare.access.StatisticsOperations;
import java.sql.Date;
import java.util.ArrayList;
import org.jfree.data.category.DefaultCategoryDataset;
import org.jfree.data.general.DefaultPieDataset;

/**
 * Business logic controller for the Statistics module.
 * Converts raw DB rows into JFreeChart datasets.
 * No validation needed here — statistics are read-only.
 * @author team
 */
public class StatisticsController {

    // -------------------------------------------------------------------------
    // A. Pets by Type and State → CategoryDataset for Bar Chart
    // -------------------------------------------------------------------------

    /**
     * Builds a bar chart dataset: series = PetState, category = PetType.
     * @param dateFrom start date (nullable = no filter)
     * @param dateTo   end date (nullable = no filter)
     */
    public DefaultCategoryDataset getPetsByTypeAndState() {
        DefaultCategoryDataset dataset = new DefaultCategoryDataset();

        ArrayList<String[]> rows = StatisticsOperations.getPetsByTypeAndState();

        // rows: [PetType, PetState, Total]
        for (String[] row : rows) {
            String petType  = row[0];
            String petState = row[1];
            int total       = Integer.parseInt(row[2]);
            dataset.addValue(total, petState, petType);
        }

        return dataset;
    }

    /**
     * Returns summary totals for the stats row below the chart.
     * @return String array with one entry per state
     */
    public DefaultCategoryDataset getPetsByTypeAndState(Date dateFrom, Date dateTo) {
        DefaultCategoryDataset dataset = new DefaultCategoryDataset();

        ArrayList<String[]> rows = StatisticsOperations.getPetsByTypeAndState(dateFrom, dateTo);

        // rows: [PetType, PetState, Total]
        for (String[] row : rows) {
            String petType  = row[0];
            String petState = row[1];
            int total       = Integer.parseInt(row[2]);
            dataset.addValue(total, petState, petType);
        }

        return dataset;
    }
    
    

    /**
     * Returns summary totals for the stats row below the chart.
     * @return String array with one entry per state
     */
    public String[] getPetSummary(Date dateFrom, Date dateTo) {
        ArrayList<String[]> rows = StatisticsOperations.getPetsByTypeAndState(dateFrom, dateTo);

        int lost = 0, found = 0, inAdoption = 0, adopted = 0;

        for (String[] row : rows) {
            int total = Integer.parseInt(row[2]);
            switch (row[1]) {
                case "Perdido":     lost       += total; break;
                case "Encontrado":  found      += total; break;
                case "En Adopcion": inAdoption += total; break;
                case "Adoptado":    adopted    += total; break;
            }
        }

        int grandTotal = lost + found + inAdoption + adopted;
        return new String[]{
            "Total: " + grandTotal,
            "Lost: " + lost,
            "Found: " + found,
            "In Adoption: " + inAdoption,
            "Adopted: " + adopted
        };
    }

    // -------------------------------------------------------------------------
    // B. Donations by Association → CategoryDataset for Bar Chart
    // -------------------------------------------------------------------------

    /**
     * Builds a bar chart dataset: series = Currency, category = Association.
     * @param dateFrom start date (nullable)
     * @param dateTo   end date (nullable)
     */
    public DefaultCategoryDataset getDonationsByAssociation(Date dateFrom, Date dateTo) {
        DefaultCategoryDataset dataset = new DefaultCategoryDataset();

        ArrayList<String[]> rows = StatisticsOperations.getDonationsByAssociation(dateFrom, dateTo);

        // rows: [AssociationName, Currency, TotalAmount, DonationCount]
        for (String[] row : rows) {
            String association = row[0];
            String currency    = row[1];
            double total       = Double.parseDouble(row[2]);
            dataset.addValue(total, currency, association);
        }

        return dataset;
    }

    /**
     * Returns summary totals per currency for the stats row.
     */
    public String[] getDonationSummary(Date dateFrom, Date dateTo) {
        ArrayList<String[]> rows = StatisticsOperations.getDonationsByAssociation(dateFrom, dateTo);

        double totalColones = 0;
        double totalDollars = 0;
        int count = 0;

        for (String[] row : rows) {
            double amount = Double.parseDouble(row[2]);
            count += Integer.parseInt(row[3]);
            if ("Colones".equals(row[1])) totalColones += amount;
            else if ("Dólares".equals(row[1])) totalDollars += amount;
        }

        return new String[]{
            String.format("Total Colones: ₡%,.0f", totalColones),
            String.format("Total Dollars: $%,.2f", totalDollars),
            "Total Donations: " + count
        };
    }

    // -------------------------------------------------------------------------
    // C. Adoptions vs Waiting → PieDataset
    // -------------------------------------------------------------------------

    /**
     * Builds a pie chart dataset: Adopted vs Waiting.
     * @param idType  pet type filter (nullable)
     * @param idBreed breed filter (nullable)
     */
    public DefaultPieDataset getAdoptionsVsWaiting(Integer idType, Integer idBreed) {
        DefaultPieDataset dataset = new DefaultPieDataset();

        ArrayList<String[]> rows = StatisticsOperations.getAdoptionsVsWaiting(idType, idBreed);

        // rows: [PetState, Total, Percentage]
        for (String[] row : rows) {
            String label = row[0] + " (" + row[1] + ")";
            int total    = Integer.parseInt(row[1]);
            dataset.setValue(label, total);
        }

        return dataset;
    }

    /**
     * Returns summary for the stats row.
     */
    public String[] getAdoptionSummary(Integer idType, Integer idBreed) {
        ArrayList<String[]> rows = StatisticsOperations.getAdoptionsVsWaiting(idType, idBreed);

        int totalAdopted = 0, totalWaiting = 0;
        double pctAdopted = 0, pctWaiting = 0;

        for (String[] row : rows) {
            if (row[0].contains("Adoptado")) {
                totalAdopted = Integer.parseInt(row[1]);
                pctAdopted   = Double.parseDouble(row[2]);
            } else {
                totalWaiting = Integer.parseInt(row[1]);
                pctWaiting   = Double.parseDouble(row[2]);
            }
        }

        return new String[]{
            "Adopted: " + totalAdopted + " (" + pctAdopted + "%)",
            "Waiting: " + totalWaiting + " (" + pctWaiting + "%)",
            "Total: " + (totalAdopted + totalWaiting)
        };
    }

    // -------------------------------------------------------------------------
    // D. Non-adopted by Age Range → PieDataset
    // -------------------------------------------------------------------------

    /**
     * Builds a pie chart dataset for age ranges.
     */
    public DefaultPieDataset getNonAdoptedByAge() {
        DefaultPieDataset dataset = new DefaultPieDataset();

        ArrayList<String[]> rows = StatisticsOperations.getNonAdoptedByAge();

        // rows: [AgeRange, Total, Percentage]
        for (String[] row : rows) {
            String label = row[0] + ": " + row[1];
            int total    = Integer.parseInt(row[1]);
            dataset.setValue(label, total);
        }

        return dataset;
    }

    /**
     * Returns summary for the stats row.
     */
    public String[] getAgeSummary() {
        ArrayList<String[]> rows = StatisticsOperations.getNonAdoptedByAge();

        int grandTotal = 0;
        ArrayList<String> parts = new ArrayList<>();

        for (String[] row : rows) {
            int total = Integer.parseInt(row[1]);
            grandTotal += total;
            parts.add(row[0] + ": " + total + " (" + row[2] + "%)");
        }

        parts.add("Total: " + grandTotal);
        return parts.toArray(new String[0]);
    }

    // -------------------------------------------------------------------------
    // E. Average Adoption Time → CategoryDataset for Bar Chart
    // -------------------------------------------------------------------------

    /**
     * Builds a bar chart dataset: series = PetType, category = Breed, value = AvgDays.
     */
    public DefaultCategoryDataset getAvgAdoptionTime() {
        DefaultCategoryDataset dataset = new DefaultCategoryDataset();

        ArrayList<String[]> rows = StatisticsOperations.getAvgAdoptionTime();

        // rows: [PetType, PetBreed, AvgDays, TotalAdoptions]
        for (String[] row : rows) {
            String petType  = row[0];
            String breed    = row[1];
            double avgDays  = Double.parseDouble(row[2]);
            dataset.addValue(avgDays, petType, breed);
        }

        return dataset;
    }

    /**
     * Returns summary: fastest, slowest, overall average.
     */
    public String[] getAvgAdoptionSummary() {
        ArrayList<String[]> rows = StatisticsOperations.getAvgAdoptionTime();

        if (rows.isEmpty()) {
            return new String[]{"No adoption data available."};
        }

        double minDays = Double.MAX_VALUE, maxDays = 0, sum = 0;
        String fastest = "", slowest = "";

        for (String[] row : rows) {
            double days = Double.parseDouble(row[2]);
            sum += days;
            if (days < minDays) {
                minDays = days;
                fastest = row[1] + " (" + days + " days)";
            }
            if (days > maxDays) {
                maxDays = days;
                slowest = row[1] + " (" + days + " days)";
            }
        }

        double avg = sum / rows.size();

        return new String[]{
            "Fastest: " + fastest,
            "Slowest: " + slowest,
            String.format("Overall Average: %.1f days", avg)
        };
    }

    // -------------------------------------------------------------------------
    // Catalogs for filters
    // -------------------------------------------------------------------------

    public ArrayList<DbObject> getPetTypes() {
        return StatisticsOperations.listPetTypes();
    }

    public ArrayList<DbObject> getBreeds() {
        return StatisticsOperations.listBreeds();
    }
}
