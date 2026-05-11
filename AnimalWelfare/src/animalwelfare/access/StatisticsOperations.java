package animalwelfare.access;

import java.sql.*;
import java.util.ArrayList;
import javax.swing.JOptionPane;
import oracle.jdbc.OracleTypes;

/**
 * Data access operations for Statistics module.
 * Each method returns a list of rows ready for JFreeChart datasets.
 * @author team
 */
public class StatisticsOperations {

    // -------------------------------------------------------------------------
    // A. Pets by Type and State
    // -------------------------------------------------------------------------

    /**
     * Returns pet counts grouped by type and state.
     * Each row: [PetType, PetState, Total]
     * @param dateFrom start date (nullable)
     * @param dateTo   end date (nullable)
     */
    public static ArrayList<String[]> getPetsByTypeAndState(Date dateFrom, Date dateTo) {
        ArrayList<String[]> rows = new ArrayList<>();
        String call = "{ call pr_stat_pets_by_type_state(?, ?, ?) }";

        try (Connection con = ConexionOracle.connect();
             CallableStatement cs = con.prepareCall(call)) {

            setNullableDate(cs, 1, dateFrom);
            setNullableDate(cs, 2, dateTo);
            cs.registerOutParameter(3, OracleTypes.CURSOR);
            cs.execute();

            try (ResultSet rs = (ResultSet) cs.getObject(3)) {
                while (rs.next()) {
                    rows.add(new String[]{
                        rs.getString("PetType"),
                        rs.getString("PetState"),
                        String.valueOf(rs.getInt("Total"))
                    });
                }
            }

        } catch (SQLException e) {
            JOptionPane.showMessageDialog(null,
                "Error loading pet stats: " + e.getMessage());
        }

        return rows;
    }

    // -------------------------------------------------------------------------
    // B. Donations by Association
    // -------------------------------------------------------------------------

    /**
     * Returns donation totals grouped by association and currency.
     * Each row: [AssociationName, Currency, TotalAmount, DonationCount]
     * @param dateFrom start date (nullable)
     * @param dateTo   end date (nullable)
     */
    public static ArrayList<String[]> getDonationsByAssociation(Date dateFrom, Date dateTo) {
        ArrayList<String[]> rows = new ArrayList<>();
        String call = "{ call pr_stat_donations_by_association(?, ?, ?) }";

        try (Connection con = ConexionOracle.connect();
             CallableStatement cs = con.prepareCall(call)) {

            setNullableDate(cs, 1, dateFrom);
            setNullableDate(cs, 2, dateTo);
            cs.registerOutParameter(3, OracleTypes.CURSOR);
            cs.execute();

            try (ResultSet rs = (ResultSet) cs.getObject(3)) {
                while (rs.next()) {
                    rows.add(new String[]{
                        rs.getString("AssociationName"),
                        rs.getString("Currency"),
                        String.valueOf(rs.getDouble("TotalAmount")),
                        String.valueOf(rs.getInt("DonationCount"))
                    });
                }
            }

        } catch (SQLException e) {
            JOptionPane.showMessageDialog(null,
                "Error loading donation stats: " + e.getMessage());
        }

        return rows;
    }

    // -------------------------------------------------------------------------
    // C. Adoptions vs Waiting
    // -------------------------------------------------------------------------

    /**
     * Returns adoption counts: adopted vs waiting.
     * Each row: [PetState, Total, Percentage]
     * @param idType  pet type filter (nullable)
     * @param idBreed breed filter (nullable)
     */
    public static ArrayList<String[]> getAdoptionsVsWaiting(Integer idType, Integer idBreed) {
        ArrayList<String[]> rows = new ArrayList<>();
        String call = "{ call pr_stat_adoptions_vs_waiting(?, ?, ?) }";

        try (Connection con = ConexionOracle.connect();
             CallableStatement cs = con.prepareCall(call)) {

            setNullableInt(cs, 1, idType);
            setNullableInt(cs, 2, idBreed);
            cs.registerOutParameter(3, OracleTypes.CURSOR);
            cs.execute();

            try (ResultSet rs = (ResultSet) cs.getObject(3)) {
                while (rs.next()) {
                    rows.add(new String[]{
                        rs.getString("PetState"),
                        String.valueOf(rs.getInt("Total")),
                        String.valueOf(rs.getDouble("Percentage"))
                    });
                }
            }

        } catch (SQLException e) {
            JOptionPane.showMessageDialog(null,
                "Error loading adoption stats: " + e.getMessage());
        }

        return rows;
    }

    // -------------------------------------------------------------------------
    // D. Non-adopted by Age Range
    // -------------------------------------------------------------------------

    /**
     * Returns non-adopted pet counts by age range.
     * Each row: [AgeRange, Total, Percentage]
     */
    public static ArrayList<String[]> getNonAdoptedByAge() {
        ArrayList<String[]> rows = new ArrayList<>();
        String call = "{ call pr_stat_nonadopted_by_age(?) }";

        try (Connection con = ConexionOracle.connect();
             CallableStatement cs = con.prepareCall(call)) {

            cs.registerOutParameter(1, OracleTypes.CURSOR);
            cs.execute();

            try (ResultSet rs = (ResultSet) cs.getObject(1)) {
                while (rs.next()) {
                    rows.add(new String[]{
                        rs.getString("AgeRange"),
                        String.valueOf(rs.getInt("Total")),
                        String.valueOf(rs.getDouble("Percentage"))
                    });
                }
            }

        } catch (SQLException e) {
            JOptionPane.showMessageDialog(null,
                "Error loading age stats: " + e.getMessage());
        }

        return rows;
    }

    // -------------------------------------------------------------------------
    // E. Average Adoption Time by Type and Breed
    // -------------------------------------------------------------------------

    /**
     * Returns average adoption time in days by pet type and breed.
     * Each row: [PetType, PetBreed, AvgDays, TotalAdoptions]
     */
    public static ArrayList<String[]> getAvgAdoptionTime() {
        ArrayList<String[]> rows = new ArrayList<>();
        String call = "{ call pr_stat_avg_adoption_time(?) }";

        try (Connection con = ConexionOracle.connect();
             CallableStatement cs = con.prepareCall(call)) {

            cs.registerOutParameter(1, OracleTypes.CURSOR);
            cs.execute();

            try (ResultSet rs = (ResultSet) cs.getObject(1)) {
                while (rs.next()) {
                    rows.add(new String[]{
                        rs.getString("PetType"),
                        rs.getString("PetBreed"),
                        String.valueOf(rs.getDouble("AvgDays")),
                        String.valueOf(rs.getInt("TotalAdoptions"))
                    });
                }
            }

        } catch (SQLException e) {
            JOptionPane.showMessageDialog(null,
                "Error loading adoption time stats: " + e.getMessage());
        }

        return rows;
    }

    // -------------------------------------------------------------------------
    // Catalog helpers for filters
    // -------------------------------------------------------------------------

    /** Returns all pet types for filter combos */
    public static ArrayList<DbObject> listPetTypes() {
        return listCatalog("{ ? = call fn_get_pet_type_all() }");
    }

    /** Returns all breeds for filter combos */
    public static ArrayList<DbObject> listBreeds() {
        return listCatalog("{ ? = call fn_get_pet_breed_all() }");
    }

    private static ArrayList<DbObject> listCatalog(String sql) {
        ArrayList<DbObject> list = new ArrayList<>();

        try (Connection con = ConexionOracle.connect();
             CallableStatement cs = con.prepareCall(sql)) {

            cs.registerOutParameter(1, OracleTypes.CURSOR);
            cs.execute();

            try (ResultSet rs = (ResultSet) cs.getObject(1)) {
                while (rs.next()) {
                    list.add(new DbObject(rs.getInt("Id"), rs.getString("Name")));
                }
            }

        } catch (SQLException e) {
            JOptionPane.showMessageDialog(null,
                "Error loading catalog: " + e.getMessage());
        }

        return list;
    }

    // -------------------------------------------------------------------------
    // Helpers
    // -------------------------------------------------------------------------

    private static void setNullableInt(CallableStatement cs, int index,
                                        Integer value) throws SQLException {
        if (value == null) cs.setNull(index, Types.NUMERIC);
        else cs.setInt(index, value);
    }

    private static void setNullableDate(CallableStatement cs, int index,
                                         Date value) throws SQLException {
        if (value == null) cs.setNull(index, Types.DATE);
        else cs.setDate(index, value);
    }
}
