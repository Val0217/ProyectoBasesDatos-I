package animalwelfare.access;

import java.sql.*;
import java.util.ArrayList;
import javax.swing.JOptionPane;
import javax.swing.table.DefaultTableModel;
import oracle.jdbc.OracleTypes;

/**
 * Data access operations for Foster Home module.
 * @author team
 */
public class FosterHomeOperations {

    private static final String[] COLUMNS = {
        "ID", "Person", "Needs Donation", "Accepted Sizes",
        "Accepted Energy Levels", "Accepted Spaces"
    };

    // -------------------------------------------------------------------------
    // INSERT
    // -------------------------------------------------------------------------

    /**
     * Registers a new foster home for the given person.
     * @param idPerson      ID of the person becoming a foster home
     * @param needsDonation 'Y' or 'N'
     * @param sizeIds       Array of accepted PetSize IDs
     * @param energyIds     Array of accepted PetLevelEnergy IDs
     * @param spaceIds      Array of accepted SpaceRequired IDs
     * @return true if successful
     */
    public static boolean insertFosterHome(int idPerson, String needsDonation,Integer[] sizeIds,Integer[] energyIds, Integer[] spaceIds) {
        String call = "{ call pr_insert_foster_home(?, ?, ?, ?, ?) }";

        try (Connection con = ConexionOracle.connect();
             CallableStatement cs = con.prepareCall(call)) {

            cs.setInt(1, idPerson);
            cs.setString(2, needsDonation);

            oracle.jdbc.OracleConnection oraConn =
                con.unwrap(oracle.jdbc.OracleConnection.class);

            cs.setArray(3, oraConn.createOracleArray("NUMBERLIST", sizeIds));
            cs.setArray(4, oraConn.createOracleArray("NUMBERLIST", energyIds));
            cs.setArray(5, oraConn.createOracleArray("NUMBERLIST", spaceIds));

            cs.execute();
            return true;

        } catch (SQLException e) {
            JOptionPane.showMessageDialog(null, "Error inserting foster home: " + e.getMessage());
            return false;
        }
    }

    // -------------------------------------------------------------------------
    // SELECT ALL
    // -------------------------------------------------------------------------

    /**
     * Returns all foster homes as a table model.
     * @return DefaultTableModel with foster home data
     */
    public static DefaultTableModel getFosterHomes() {
        DefaultTableModel model = new DefaultTableModel(COLUMNS, 0) {
            @Override
            public boolean isCellEditable(int row, int col) { return false; }
        };

        String call = "{ call pr_get_foster_homes(?) }";

        try (Connection con = ConexionOracle.connect();
             CallableStatement cs = con.prepareCall(call)) {

            cs.registerOutParameter(1, OracleTypes.CURSOR);
            cs.execute();

            try (ResultSet rs = (ResultSet) cs.getObject(1)) {
                while (rs.next()) {
                    model.addRow(new Object[]{
                        rs.getInt("FosterHomeId"),
                        rs.getInt("PersonId"),
                        rs.getString("PersonName"),
                        rs.getString("NeedsDonation").equals("Y") ? "Yes" : "No",
                        rs.getString("AcceptedSizes"),
                        rs.getString("AcceptedEnergy"),
                        rs.getString("AcceptedSpaces")
                    });
                }
            }

        } catch (SQLException e) {
            JOptionPane.showMessageDialog(null, "Error loading foster homes: " + e.getMessage());
        }

        return model;
    }

    // -------------------------------------------------------------------------
    // SELECT BY PERSON (for edit/delete — only own foster home)
    // -------------------------------------------------------------------------

    /**
     * Returns the foster home of a specific person, or null if none.
     * @param idPerson ID of the logged-in user
     * @return FosterHomeData or null
     */
    public static FosterHomeData getFosterHomeByPerson(int idPerson) {
        String call = "{ call pr_get_foster_home_by_person(?, ?) }";

        try (Connection con = ConexionOracle.connect();
             CallableStatement cs = con.prepareCall(call)) {

            cs.setInt(1, idPerson);
            cs.registerOutParameter(2, OracleTypes.CURSOR);
            cs.execute();

            try (ResultSet rs = (ResultSet) cs.getObject(2)) {
                if (!rs.next()) return null;

                FosterHomeData data = new FosterHomeData();
                data.id            = rs.getInt("FosterHomeId");
                data.idPerson      = rs.getInt("IdPerson");
                data.needsDonation = rs.getString("NeedsDonation");
                data.sizeIds       = parseIntArray(rs.getString("SizeIds"));
                data.energyIds     = parseIntArray(rs.getString("EnergyIds"));
                data.spaceIds      = parseIntArray(rs.getString("SpaceIds"));
                return data;
            }

        } catch (SQLException e) {
            JOptionPane.showMessageDialog(null, "Error loading foster home: " + e.getMessage());
            return null;
        }
    }

    // -------------------------------------------------------------------------
    // UPDATE
    // -------------------------------------------------------------------------

    /**
     * Updates the foster home of the given person.
     * Only the owner can update their own foster home.
     */
    public static boolean updateFosterHome(int idFosterHome, int idPerson,String needsDonation,Integer[] sizeIds,Integer[] energyIds,Integer[] spaceIds) {
        String call = "{ call pr_update_foster_home(?, ?, ?, ?, ?, ?) }";

        try (Connection con = ConexionOracle.connect();
             CallableStatement cs = con.prepareCall(call)) {

            cs.setInt(1, idFosterHome);
            cs.setInt(2, idPerson);
            cs.setString(3, needsDonation);

            oracle.jdbc.OracleConnection oraConn =
                con.unwrap(oracle.jdbc.OracleConnection.class);

            cs.setArray(4, oraConn.createOracleArray("NUMBERLIST", sizeIds));
            cs.setArray(5, oraConn.createOracleArray("NUMBERLIST", energyIds));
            cs.setArray(6, oraConn.createOracleArray("NUMBERLIST", spaceIds));

            cs.execute();
            return true;

        } catch (SQLException e) {
            JOptionPane.showMessageDialog(null, "Error updating foster home: " + e.getMessage());
            return false;
        }
    }

    // -------------------------------------------------------------------------
    // DELETE
    // -------------------------------------------------------------------------

    /**
     * Deletes the foster home of the given person.
     * Only the owner can delete their own foster home.
     */
    public static boolean deleteFosterHome(int idFosterHome, int idPerson) {
        String call = "{ call pr_delete_foster_home(?, ?) }";

        try (Connection con = ConexionOracle.connect();
             CallableStatement cs = con.prepareCall(call)) {

            cs.setInt(1, idFosterHome);
            cs.setInt(2, idPerson);
            cs.execute();
            return true;

        } catch (SQLException e) {
            JOptionPane.showMessageDialog(null, "Error deleting foster home: " + e.getMessage());
            return false;
        }
    }

    // -------------------------------------------------------------------------
    // CATALOG LISTS (for checkboxes)
    // -------------------------------------------------------------------------

    public static ArrayList<DbObject> listSizes() {
        return listCatalog("{ ? = call fn_get_pet_size_all() }");
    }

    public static ArrayList<DbObject> listEnergyLevels() {
        return listCatalog("{ ? = call fn_get_pet_energy_all() }");
    }

    public static ArrayList<DbObject> listSpacesRequired() {
        return listCatalog("{ ? = call fn_get_pet_space_required_all() }");
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
            JOptionPane.showMessageDialog(null, "Error loading catalog: " + e.getMessage());
        }

        return list;
    }

    // -------------------------------------------------------------------------
    // Helper — parse comma-separated IDs from DB string "1,2,3"
    // -------------------------------------------------------------------------
    private static Integer[] parseIntArray(String csv) {
        if (csv == null || csv.trim().isEmpty()) return new Integer[0];
        String[] parts = csv.split(",");
        Integer[] result = new Integer[parts.length];
        for (int i = 0; i < parts.length; i++) {
            result[i] = Integer.parseInt(parts[i].trim());
        }
        return result;
    }

    // -------------------------------------------------------------------------
    // Data holder
    // -------------------------------------------------------------------------
    public static class FosterHomeData {
        public int id;
        public int idPerson;
        public String needsDonation;
        public Integer[] sizeIds;
        public Integer[] energyIds;
        public Integer[] spaceIds;
    }
}
