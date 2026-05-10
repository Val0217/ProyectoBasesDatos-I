package animalwelfare.access;

import java.sql.*;
import java.util.ArrayList;
import javax.swing.JOptionPane;
import javax.swing.table.DefaultTableModel;
import oracle.jdbc.OracleTypes;

/**
 * Data access operations for Block List module.
 * @author team
 */
public class BlockListOperations {

    private static final String[] COLUMNS = {
        "ID", "Person", "Blocked On", "Reason", "Stars", "Notes"
    };

    // -------------------------------------------------------------------------
    // REPORT — inserts into ReportList and BlockList
    // -------------------------------------------------------------------------

    /**
     * Reports a person and adds them to the block list.
     * @param idPerson    ID of the person being reported
     * @param idReporter  ID of the person doing the report
     * @param description Reason for the report
     * @return true if successful
     */
    public static boolean reportPerson(int idPerson, int idReporter,
                                        String description) {
        String call = "{ call pr_report_person(?, ?, ?) }";

        try (Connection con = ConexionOracle.connect();
             CallableStatement cs = con.prepareCall(call)) {

            cs.setInt(1, idPerson);
            cs.setInt(2, idReporter);
            cs.setString(3, description);
            cs.execute();
            return true;

        } catch (SQLException e) {
            JOptionPane.showMessageDialog(null, "Error: " + e.getMessage());
            return false;
        }
    }

    // -------------------------------------------------------------------------
    // GET ALL — block list with ratings and notes
    // -------------------------------------------------------------------------

    /**
     * Returns the full block list with ratings and latest note.
     * @return DefaultTableModel ready for JTable
     */
    public static DefaultTableModel getBlockList() {
        DefaultTableModel model = new DefaultTableModel(COLUMNS, 0) {
            @Override
            public boolean isCellEditable(int row, int col) { return false; }
        };

        String call = "{ call pr_get_block_list(?) }";

        try (Connection con = ConexionOracle.connect();
             CallableStatement cs = con.prepareCall(call)) {

            cs.registerOutParameter(1, OracleTypes.CURSOR);
            cs.execute();

            try (ResultSet rs = (ResultSet) cs.getObject(1)) {
                while (rs.next()) {
                    model.addRow(new Object[]{
                        rs.getInt("BlockListId"),
                        rs.getString("PersonName"),
                        rs.getDate("BlockDate"),
                        rs.getString("Reason"),
                        rs.getDouble("AvgStars"),
                        rs.getString("LatestNote")
                    });
                }
            }

        } catch (SQLException e) {
            JOptionPane.showMessageDialog(null, "Error loading block list: " + e.getMessage());
        }

        return model;
    }

    // -------------------------------------------------------------------------
    // GET DETAIL — all reports and ratings for one person
    // -------------------------------------------------------------------------

    /**
     * Returns the full detail of a blocked person.
     * @param idPerson ID of the person
     * @return DefaultTableModel with all reports and ratings
     */
    public static DefaultTableModel getBlockListDetail(int idPerson) {
        DefaultTableModel model = new DefaultTableModel(
            new String[]{"Person", "Blocked On", "Reason", "Reported By",
                         "Report Date", "Stars", "Notes", "Rating Date"}, 0
        ) {
            @Override
            public boolean isCellEditable(int row, int col) { return false; }
        };

        String call = "{ call pr_get_block_list_detail(?, ?) }";

        try (Connection con = ConexionOracle.connect();
             CallableStatement cs = con.prepareCall(call)) {

            cs.setInt(1, idPerson);
            cs.registerOutParameter(2, OracleTypes.CURSOR);
            cs.execute();

            try (ResultSet rs = (ResultSet) cs.getObject(2)) {
                while (rs.next()) {
                    model.addRow(new Object[]{
                        rs.getString("PersonName"),
                        rs.getDate("BlockDate"),
                        rs.getString("ReportReason"),
                        rs.getString("ReportedBy"),
                        rs.getDate("ReportDate"),
                        rs.getInt("Stars"),
                        rs.getString("Note"),
                        rs.getDate("CalificationDate")
                    });
                }
            }

        } catch (SQLException e) {
            JOptionPane.showMessageDialog(null, "Error loading detail: " + e.getMessage());
        }

        return model;
    }

    // -------------------------------------------------------------------------
    // REMOVE — only admins can do this
    // -------------------------------------------------------------------------

    /**
     * Removes a person from the block list.
     * @param idPerson ID of the person to remove
     * @param idAdmin  ID of the admin performing the action
     * @return true if successful
     */
    public static boolean removeFromBlockList(int idPerson, int idAdmin) {
        String call = "{ call pr_remove_from_block_list(?, ?) }";

        try (Connection con = ConexionOracle.connect();
             CallableStatement cs = con.prepareCall(call)) {

            cs.setInt(1, idPerson);
            cs.setInt(2, idAdmin);
            cs.execute();
            return true;

        } catch (SQLException e) {
            JOptionPane.showMessageDialog(null, "Error removing from block list: " + e.getMessage());
            return false;
        }
    }

    // -------------------------------------------------------------------------
    // PERSONS LIST — for the report combo box
    // -------------------------------------------------------------------------

    /**
     * Returns all persons for the combo box.
     * @return List of DbObject with Id and Name
     */
    public static ArrayList<DbObject> listPersons() {
        ArrayList<DbObject> list = new ArrayList<>();
        String call = "{ ? = call fn_get_persons_all() }";

        try (Connection con = ConexionOracle.connect();
             CallableStatement cs = con.prepareCall(call)) {

            cs.registerOutParameter(1, OracleTypes.CURSOR);
            cs.execute();

            try (ResultSet rs = (ResultSet) cs.getObject(1)) {
                while (rs.next()) {
                    list.add(new DbObject(
                        rs.getInt("Id"),
                        rs.getString("Name")
                    ));
                }
            }

        } catch (SQLException e) {
            JOptionPane.showMessageDialog(null, "Error listing persons: " + e.getMessage());
        }

        return list;
    }
}
