package animalwelfare.access;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;
import javax.swing.table.DefaultTableModel;
import oracle.jdbc.OracleTypes;

public class UserPetOperations {

    public static class CatalogItem {
        private final Integer id;
        private final String name;

        public CatalogItem(Integer id, String name) {
            this.id = id;
            this.name = name;
        }

        public Integer getId() {
            return id;
        }

        @Override
        public String toString() {
            return name;
        }
    }

    public static class PetFilter {
        public Integer idEnergy;
        public Integer idType;
        public Integer idBreed;
        public Integer idDistrict;
        public Integer idCountry;
        public Integer idProvince;
        public Integer idCanton;
        public Integer idSpace;
        public Integer idTraining;
        public Integer idSize;
        public Integer idVeterinarian;

        public String color;
        public Integer age;
        public String name;
        public String chip;
    }

    public DefaultTableModel getUserPets(int ownerId, PetFilter filter) throws SQLException {
        try (Connection conn = ConexionOracle.connect();
             CallableStatement cs = conn.prepareCall(
                 "{call pr_get_user_pet_table(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}")) {

            cs.setInt(1, ownerId);
            setNullableInt(cs, 2, filter.idEnergy);
            setNullableInt(cs, 3, filter.idType);
            setNullableInt(cs, 4, filter.idBreed);

            setNullableInt(cs, 5, filter.idCountry);
            setNullableInt(cs, 6, filter.idProvince);
            setNullableInt(cs, 7, filter.idCanton);
            setNullableInt(cs, 8, filter.idDistrict);

            setNullableInt(cs, 9, filter.idSpace);
            setNullableInt(cs, 10, filter.idTraining);
            setNullableInt(cs, 11, filter.idSize);
            setNullableInt(cs, 12, filter.idVeterinarian);

            setNullableString(cs, 13, filter.color);
            setNullableInt(cs, 14, filter.age);
            setNullableString(cs, 15, filter.name);
            setNullableString(cs, 16, filter.chip);

            cs.registerOutParameter(17, OracleTypes.CURSOR);

            cs.execute();

            try (ResultSet rs = (ResultSet) cs.getObject(17)) {
                return buildPetTableModel(rs);
            }
        }
    }

    public DefaultTableModel getAdoptionPets(PetFilter filter) throws SQLException {
        try (Connection conn = ConexionOracle.connect();
             CallableStatement cs = conn.prepareCall(
                 "{call pr_get_adoption_pet_table(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}")) {

            setNullableInt(cs, 1, filter.idEnergy);
            setNullableInt(cs, 2, filter.idType);
            setNullableInt(cs, 3, filter.idBreed);

            setNullableInt(cs, 4, filter.idCountry);
            setNullableInt(cs, 5, filter.idProvince);
            setNullableInt(cs, 6, filter.idCanton);
            setNullableInt(cs, 7, filter.idDistrict);

            setNullableInt(cs, 8, filter.idSpace);
            setNullableInt(cs, 9, filter.idTraining);
            setNullableInt(cs, 10, filter.idSize);
            setNullableInt(cs, 11, filter.idVeterinarian);

            setNullableString(cs, 12, filter.color);
            setNullableInt(cs, 13, filter.age);
            setNullableString(cs, 14, filter.name);
            setNullableString(cs, 15, filter.chip);

            cs.registerOutParameter(16, OracleTypes.CURSOR);

            cs.execute();

            try (ResultSet rs = (ResultSet) cs.getObject(16)) {
                return buildPetTableModel(rs);
            }
        }
    }

    public void putPetUpForAdoption(int petId, int ownerId) throws SQLException {
        try (Connection conn = ConexionOracle.connect();
             CallableStatement cs = conn.prepareCall(
                 "{ ? = call PKG_PET_OPERATIONS.FN_PUT_PET_UP_FOR_ADOPTION(?, ?) }")) {

            cs.registerOutParameter(1, Types.INTEGER);
            cs.setInt(2, petId);
            cs.setInt(3, ownerId);
            cs.execute();

            int result = cs.getInt(1);
            if (result != 1) {
                throw new SQLException("Pet not found, or this pet does not belong to this user.");
            }
        }
    }
    public void reportPetMissing(int petId, int ownerId) throws SQLException {
        try (Connection conn = ConexionOracle.connect();
             CallableStatement cs = conn.prepareCall("{call pr_report_pet_missing(?,?)}")) {

            cs.setInt(1, petId);
            cs.setInt(2, ownerId);
            cs.execute();
        }
    }
    public List<CatalogItem> getCatalog(String catalogName) throws SQLException {
        List<CatalogItem> items = new ArrayList<>();
        items.add(new CatalogItem(null, "Todos"));

        try (Connection conn = ConexionOracle.connect();
             CallableStatement cs = conn.prepareCall("{call pr_get_catalog(?,?)}")) {

            cs.setString(1, catalogName);
            cs.registerOutParameter(2, OracleTypes.CURSOR);
            cs.execute();

            try (ResultSet rs = (ResultSet) cs.getObject(2)) {
                while (rs.next()) {
                    items.add(new CatalogItem(rs.getInt("Id"), rs.getString("Name")));
                }
            }
        }

        return items;
    }

    private DefaultTableModel buildPetTableModel(ResultSet rs) throws SQLException {
        String[] columns = {
            "PetId",
            "Name",
            "Color",
            "Age",
            "Chip",
            "Energy",
            "State",
            "Type",
            "Breed",
            "District",
            "Space Required",
            "Training",
            "Size",
            "Veterinarian"
        };

        DefaultTableModel model = new DefaultTableModel(columns, 0) {
            @Override
            public boolean isCellEditable(int row, int column) {
                return false;
            }
        };

        while (rs.next()) {
            model.addRow(new Object[] {
                rs.getInt("PetId"),
                rs.getString("PetName"),
                rs.getString("Color"),
                rs.getObject("Age"),
                rs.getString("Chip"),
                rs.getString("Energy"),
                rs.getString("PetState"),
                rs.getString("PetType"),
                rs.getString("Breed"),
                rs.getString("District"),
                rs.getString("SpaceRequired"),
                rs.getString("Training"),
                rs.getString("PetSize"),
                rs.getString("VeterinarianName")
            });
        }

        return model;
    }

    private void setNullableInt(CallableStatement cs, int index, Integer value) throws SQLException {
        if (value == null) {
            cs.setNull(index, Types.NUMERIC);
        } else {
            cs.setInt(index, value);
        }
    }

    private void setNullableString(CallableStatement cs, int index, String value) throws SQLException {
        if (value == null || value.trim().isEmpty()) {
            cs.setNull(index, Types.VARCHAR);
        } else {
            cs.setString(index, value.trim());
        }
    }
    public void undoPetUpForAdoption(int petId, int ownerId) throws SQLException {
        try (Connection conn = ConexionOracle.connect();
             CallableStatement cs = conn.prepareCall("{call pr_undo_pet_up_for_adoption(?,?)}")) {

            cs.setInt(1, petId);
            cs.setInt(2, ownerId);
            cs.execute();
        }
    }
    
public DefaultTableModel getAdoptionRequestsForOwner(int ownerId) throws SQLException {
        try (Connection conn = ConexionOracle.connect();
             CallableStatement cs = conn.prepareCall("{call pr_get_adoption_requests_owner(?,?)}")) {

            cs.setInt(1, ownerId);
            cs.registerOutParameter(2, OracleTypes.CURSOR);
            cs.execute();

            try (ResultSet rs = (ResultSet) cs.getObject(2)) {
                return buildAdoptionRequestTableModel(rs);
            }
        }
    }

    public void createAdoptionRequest(int petId, int adopterId, String description) throws SQLException {
        try (Connection conn = ConexionOracle.connect();
             CallableStatement cs = conn.prepareCall("{call pr_create_adoption_request(?,?,?,?)}")) {

            cs.setInt(1, petId);
            cs.setInt(2, adopterId);
            setNullableString(cs, 3, description);
            cs.registerOutParameter(4, Types.NUMERIC);
            cs.execute();
        }
    }

    public void acceptAdoptionRequest(int adoptionId, int ownerId) throws SQLException {
        try (Connection conn = ConexionOracle.connect();
             CallableStatement cs = conn.prepareCall("{call pr_accept_adoption_request(?,?)}")) {

            cs.setInt(1, adoptionId);
            cs.setInt(2, ownerId);
            cs.execute();
        }
    }

    public void rejectAdoptionRequest(int adoptionId, int ownerId) throws SQLException {
        try (Connection conn = ConexionOracle.connect();
             CallableStatement cs = conn.prepareCall("{call pr_reject_adoption_request(?,?)}")) {

            cs.setInt(1, adoptionId);
            cs.setInt(2, ownerId);
            cs.execute();
        }
    }

    public void registerLostReportForOwner(int petId, int ownerId, java.sql.Date lostDate,
                                           String place, String description,
                                           java.math.BigDecimal reward, int currencyId) throws SQLException {
        try (Connection conn = ConexionOracle.connect();
             CallableStatement cs = conn.prepareCall("{call pr_register_lost_for_owner(?,?,?,?,?,?,?,?)}")) {

            cs.setInt(1, petId);
            cs.setInt(2, ownerId);
            cs.setDate(3, lostDate);
            setNullableString(cs, 4, place);
            setNullableString(cs, 5, description);
            if (reward == null) {
                cs.setNull(6, Types.NUMERIC);
            } else {
                cs.setBigDecimal(6, reward);
            }
            cs.setInt(7, currencyId);
            cs.registerOutParameter(8, Types.NUMERIC);
            cs.execute();
        }
    }

    private DefaultTableModel buildAdoptionRequestTableModel(ResultSet rs) throws SQLException {
        String[] columns = {
            "AdoptionId",
            "PetId",
            "AdopterId",
            "Pet Name",
            "Adoption Description",
            "First Name",
            "Last Name",
            "Phone",
            "Email",
            "State"
        };

        DefaultTableModel model = new DefaultTableModel(columns, 0) {
            @Override
            public boolean isCellEditable(int row, int column) {
                return false;
            }
        };

        while (rs.next()) {
            model.addRow(new Object[] {
                rs.getInt("AdoptionId"),
                rs.getInt("PetId"),
                rs.getInt("AdopterId"),
                rs.getString("PetName"),
                rs.getString("AdoptionDescription"),
                rs.getString("FirstName"),
                rs.getString("LastName"),
                rs.getString("Phone"),
                rs.getString("Email"),
                rs.getString("AdoptionState")
            });
        }

        return model;
    }
}