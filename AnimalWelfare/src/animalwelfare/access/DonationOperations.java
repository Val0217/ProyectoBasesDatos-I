package animalwelfare.access;

import java.sql.*;
import java.util.ArrayList;
import javax.swing.JOptionPane;
import javax.swing.table.DefaultTableModel;
import oracle.jdbc.OracleTypes;

/**
 * Data access operations for Donation module.
 * @author team
 */
public class DonationOperations {

    // Column names for the donation query table
    private static final String[] COLUMNS = {
        "ID", "Donor", "Association", "Amount", "Currency", "Date"
    };

    /**
     * Inserts a voluntary donation into the database.
     * @param idPerson     ID of the person donating
     * @param amount       Donation amount (must be > 0)
     * @param idCurrency   ID of the currency (1=Colones, 2=Dollars)
     * @param idAssociation ID of the beneficiary association
     * @return true if successful, false otherwise
     */
    public static boolean insertDonation(int idPerson, double amount,
                                          int idCurrency, int idAssociation) {
        String call = "{ call pr_insert_donation(?, ?, ?, ?) }";

        try (Connection con = ConexionOracle.connect();
             CallableStatement cs = con.prepareCall(call)) {

            cs.setInt(1, idPerson);
            cs.setDouble(2, amount);
            cs.setInt(3, idCurrency);
            cs.setInt(4, idAssociation);
            cs.execute();
            return true;

        } catch (SQLException e) {
            JOptionPane.showMessageDialog(null, "Error: " + e.getMessage());
            return false;
        }
    }

    /**
     * Retrieves donations with optional filters.
     * Null parameters are treated as "no filter".
     * @param idPerson      Filter by donor ID (nullable)
     * @param idAssociation Filter by association ID (nullable)
     * @param dateFrom      Filter start date (nullable)
     * @param dateTo        Filter end date (nullable)
     * @return DefaultTableModel with donation data
     */
    public static DefaultTableModel getDonations() {
        DefaultTableModel model = new DefaultTableModel(COLUMNS, 0) {
            @Override
            public boolean isCellEditable(int row, int column) {
                return false;
            }
        };

        String call = "{ ? = call fn_get_donation_join() }";

        try (Connection con = ConexionOracle.connect();
             CallableStatement cs = con.prepareCall(call)) {


            cs.registerOutParameter(1, OracleTypes.CURSOR);
            cs.execute();

            try (ResultSet rs = (ResultSet) cs.getObject(1)) {
                while (rs.next()) {
                    model.addRow(new Object[]{
                        rs.getInt("Id"),
                        rs.getString("DonorName"),
                        rs.getString("AssociationName"),
                        rs.getDouble("Amount"),
                        rs.getString("Currency"),
                        rs.getDate("DonationDate")
                    });
                }
            }

        } catch (SQLException e) {
            JOptionPane.showMessageDialog(null, "Error: " + e.getMessage());
        }

        return model;
    }

    /**
     * Returns all associations for the combo box.
     * @return List of DbObject with Id and Name
     */
    public static ArrayList<DbObject> listAssociations() {
        ArrayList<DbObject> list = new ArrayList<>();
        String call = "{ ? = call fn_get_associations_all() }";

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
            JOptionPane.showMessageDialog(null, "Error: " + e.getMessage());
        }

        return list;
    }

    /**
     * Returns all currencies for the combo box.
     * @return List of DbObject with Id and Name
     */
    public static ArrayList<DbObject> listCurrencies() {
        ArrayList<DbObject> list = new ArrayList<>();
        String call = "{ ? = call fn_get_currency_all() }";

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
            JOptionPane.showMessageDialog(null, "Error: " + e.getMessage());
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
