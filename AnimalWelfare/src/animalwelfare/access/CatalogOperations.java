package animalwelfare.access;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

/**
 * Data-access layer for all catalog tables.
 * Every method opens its own connection and commits on write operations.
 *
 * @author team
 */
public class CatalogOperations {

    // -------------------------------------------------------------------------
    // Generic simple tables (Id, Name)
    // -------------------------------------------------------------------------

    /** Returns all rows of a simple catalog table ordered by Name. */
    public static List<DbObject> listSimple(String tableName) {
        List<DbObject> list = new ArrayList<>();
        String sql = "SELECT Id, Name FROM " + tableName + " ORDER BY Name";
        try (Connection con = ConexionOracle.connect();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new DbObject(rs.getInt(1), rs.getString(2)));
            }
        } catch (SQLException e) {
            System.out.println("listSimple(" + tableName + "): " + e.getMessage());
        }
        return list;
    }

    /** Inserts a row into a simple catalog table using its Oracle sequence. */
    public static boolean insertSimple(String tableName, String name) {
        String seq = "s_" + tableName;
        String sql = "INSERT INTO " + tableName + " (Id, Name) VALUES (" + seq + ".NEXTVAL, ?)";
        return executeWrite(sql, name);
    }

    /** Updates the Name of a row in a simple catalog table. */
    public static boolean updateSimple(String tableName, int id, String name) {
        String sql = "UPDATE " + tableName + " SET Name = ? WHERE Id = ?";
        return executeWrite(sql, name, String.valueOf(id));
    }

    /** Deletes a row from a simple catalog table. */
    public static boolean deleteSimple(String tableName, int id) {
        String sql = "DELETE FROM " + tableName + " WHERE Id = ?";
        return executeWrite(sql, String.valueOf(id));
    }

    // -------------------------------------------------------------------------
    // PetBreed (Id, Name, IdType)
    // -------------------------------------------------------------------------

    /**
     * Returns all breeds joined with their type name.
     * Each row: [id (Integer), breedName (String), typeName (String)]
     */
    public static List<Object[]> listBreeds() {
        List<Object[]> list = new ArrayList<>();
        String sql = "SELECT pb.Id, pb.Name, pt.Name AS TypeName "
                   + "FROM PetBreed pb JOIN PetType pt ON pb.IdType = pt.Id "
                   + "ORDER BY pb.Name";
        try (Connection con = ConexionOracle.connect();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new Object[]{rs.getInt(1), rs.getString(2), rs.getString(3)});
            }
        } catch (SQLException e) {
            System.out.println("listBreeds: " + e.getMessage());
        }
        return list;
    }

    public static boolean insertBreed(String name, int idType) {
        return executeWrite(
            "INSERT INTO PetBreed (Id, Name, IdType) VALUES (s_PetBreed.NEXTVAL, ?, ?)",
            name, String.valueOf(idType));
    }

    public static boolean updateBreed(int id, String name, int idType) {
        return executeWrite(
            "UPDATE PetBreed SET Name = ?, IdType = ? WHERE Id = ?",
            name, String.valueOf(idType), String.valueOf(id));
    }

    public static boolean deleteBreed(int id) {
        return executeWrite("DELETE FROM PetBreed WHERE Id = ?", String.valueOf(id));
    }

    // -------------------------------------------------------------------------
    // Medicine (Id, Name, Dose)
    // -------------------------------------------------------------------------

    /**
     * Returns all medicines ordered by Name.
     * Each row: [id (Integer), name (String), dose (String, may be null)]
     */
    public static List<Object[]> listMedicines() {
        List<Object[]> list = new ArrayList<>();
        String sql = "SELECT Id, Name, Dose FROM Medicine ORDER BY Name";
        try (Connection con = ConexionOracle.connect();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new Object[]{rs.getInt(1), rs.getString(2), rs.getString(3)});
            }
        } catch (SQLException e) {
            System.out.println("listMedicines: " + e.getMessage());
        }
        return list;
    }

    public static boolean insertMedicine(String name, String dose) {
        return executeWrite(
            "INSERT INTO Medicine (Id, Name, Dose) VALUES (s_Medicine.NEXTVAL, ?, ?)",
            name, dose);
    }

    public static boolean updateMedicine(int id, String name, String dose) {
        return executeWrite(
            "UPDATE Medicine SET Name = ?, Dose = ? WHERE Id = ?",
            name, dose, String.valueOf(id));
    }

    public static boolean deleteMedicine(int id) {
        return executeWrite("DELETE FROM Medicine WHERE Id = ?", String.valueOf(id));
    }

    // -------------------------------------------------------------------------
    // Association (Id, Name, PhoneNumber, Email, BankAccount)
    // -------------------------------------------------------------------------

    /**
     * Returns all associations ordered by Name.
     * Each row: [id, name, phone, email, bankAccount]  (all String except id Integer)
     */
    public static List<Object[]> listAssociations() {
        List<Object[]> list = new ArrayList<>();
        String sql = "SELECT Id, Name, PhoneNumber, Email, BankAccount "
                   + "FROM Association ORDER BY Name";
        try (Connection con = ConexionOracle.connect();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(new Object[]{
                    rs.getInt(1),
                    rs.getString(2),
                    rs.getString(3),
                    rs.getString(4),
                    rs.getString(5)
                });
            }
        } catch (SQLException e) {
            System.out.println("listAssociations: " + e.getMessage());
        }
        return list;
    }

    public static boolean insertAssociation(String name, String phone, String email, String bank) {
        return executeWrite(
            "INSERT INTO Association (Id, Name, PhoneNumber, Email, BankAccount) "
          + "VALUES (s_Association.NEXTVAL, ?, ?, ?, ?)",
            name, phone, email, bank);
    }

    public static boolean updateAssociation(int id, String name, String phone, String email, String bank) {
        return executeWrite(
            "UPDATE Association SET Name=?, PhoneNumber=?, Email=?, BankAccount=? WHERE Id=?",
            name, phone, email, bank, String.valueOf(id));
    }

    public static boolean deleteAssociation(int id) {
        return executeWrite("DELETE FROM Association WHERE Id = ?", String.valueOf(id));
    }

    // -------------------------------------------------------------------------
    // Internal helper
    // -------------------------------------------------------------------------

    /**
     * Executes an INSERT / UPDATE / DELETE.
     * Numeric strings are bound as INTEGER; anything else as VARCHAR.
     * Null or empty strings are bound as SQL NULL.
     */
    private static boolean executeWrite(String sql, String... params) {
        try (Connection con = ConexionOracle.connect();
             PreparedStatement ps = con.prepareStatement(sql)) {
            for (int i = 0; i < params.length; i++) {
                String p = params[i];
                if (p == null || p.isEmpty()) {
                    ps.setNull(i + 1, Types.VARCHAR);
                } else {
                    try {
                        ps.setInt(i + 1, Integer.parseInt(p));
                    } catch (NumberFormatException ex) {
                        ps.setString(i + 1, p);
                    }
                }
            }
            ps.executeUpdate();
            return true;
        } catch (SQLException e) {
            System.out.println("executeWrite: " + e.getMessage());
            return false;
        }
    }
}
