// ============================================================
// ARCHIVO: MatchOperations.java
// PAQUETE: animalwelfare.access
// ============================================================
package animalwelfare.access;

import java.sql.*;
import javax.swing.JOptionPane;
import javax.swing.table.DefaultTableModel;
import oracle.jdbc.OracleTypes;

/**
 * Data access operations for Pet Match module.
 * @author team
 */
public class MatchOperations {

    private static final String[] COLUMNS = {
        "ID", "Match %", "Lost Pet", "Owner",
        "Found Pet", "Finder", "Match Date"
    };

    // -------------------------------------------------------------------------
    // RUN MATCH
    // -------------------------------------------------------------------------

    /**
     * Executes the match procedure manually.
     * @return true if successful
     */
    public static boolean runMatch() {
        String call = "{ call pr_run_match() }";

        try (Connection con = ConexionOracle.connect();
             CallableStatement cs = con.prepareCall(call)) {

            cs.execute();
            return true;

        } catch (SQLException e) {
            JOptionPane.showMessageDialog(null,
                "Error running match: " + e.getMessage());
            return false;
        }
    }

    // -------------------------------------------------------------------------
    // COUNT PENDING
    // -------------------------------------------------------------------------

    /**
     * Returns number of potential new matches not yet generated.
     * @return count of pending matches
     */
    public static int countPendingMatches() {
        String call = "{ ? = call fn_count_pending_matches() }";

        try (Connection con = ConexionOracle.connect();
             CallableStatement cs = con.prepareCall(call)) {

            cs.registerOutParameter(1, Types.NUMERIC);
            cs.execute();
            return cs.getInt(1);

        } catch (SQLException e) {
            JOptionPane.showMessageDialog(null,
                "Error counting matches: " + e.getMessage());
            return 0;
        }
    }

    // -------------------------------------------------------------------------
    // GET MATCH REPORT
    // -------------------------------------------------------------------------

    /**
     * Returns the full match report as a table model.
     * @return DefaultTableModel ready for JTable
     */
    public static DefaultTableModel getMatchReport() {
        DefaultTableModel model = new DefaultTableModel(COLUMNS, 0) {
            @Override
            public boolean isCellEditable(int row, int col) { return false; }
        };

        String call = "{ call pr_get_match_report(?) }";

        try (Connection con = ConexionOracle.connect();
             CallableStatement cs = con.prepareCall(call)) {

            cs.registerOutParameter(1, OracleTypes.CURSOR);
            cs.execute();

            try (ResultSet rs = (ResultSet) cs.getObject(1)) {
                while (rs.next()) {
                    model.addRow(new Object[]{
                        rs.getInt("MatchId"),
                        rs.getInt("SimilarityPercentage") + "%",
                        rs.getString("LostPetName")  + " — " +
                            rs.getString("LostPetType")  + "/" +
                            rs.getString("LostPetBreed") + "/" +
                            rs.getString("LostPetColor"),
                        rs.getString("LostOwnerName"),
                        rs.getString("FoundPetName") + " — " +
                            rs.getString("FoundPetType")  + "/" +
                            rs.getString("FoundPetBreed") + "/" +
                            rs.getString("FoundPetColor"),
                        rs.getString("FinderName"),
                        rs.getDate("MatchDate")
                    });
                }
            }

        } catch (SQLException e) {
            JOptionPane.showMessageDialog(null,
                "Error loading match report: " + e.getMessage());
        }

        return model;
    }
}
