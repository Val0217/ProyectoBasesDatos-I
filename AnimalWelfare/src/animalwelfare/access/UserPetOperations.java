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
        try (Connection conn = ConexionMariaDB.conectar();
             CallableStatement cs = conn.prepareCall(
                 "call pr_get_user_pet_table(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)")) {

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
            
            ResultSet res = cs.executeQuery();

            
            return buildPetTableModel(res);     
        }
    }
    public DefaultTableModel getFoundPets(int currentUserId) throws SQLException {
        try (Connection conn = ConexionMariaDB.conectar();
             CallableStatement cs = conn.prepareCall("call pr_get_found_pet_table(?)")) {

            cs.setInt(1, currentUserId);
         
            ResultSet rs = cs.executeQuery();            
            return buildFoundPetTableModel(rs);
            
        }
    }
    private DefaultTableModel buildFoundPetTableModel(ResultSet rs) throws SQLException {
        String[] columns = {
            "PetId",
            "OwnerId",
            "First Name",
            "Last Name",
            "Emails",
            "Phones",
            "Pet Name",
            "Color",
            "Chip",
            "Type",
            "Breed",
            "Size"
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
                rs.getInt("OwnerId"),
                rs.getString("FirstName"),
                rs.getString("LastName"),
                rs.getString("Emails"),
                rs.getString("Phones"),
                rs.getString("PetName"),
                rs.getString("Color"),
                rs.getString("Chip"),
                rs.getString("PetType"),
                rs.getString("Breed"),
                rs.getString("PetSize")
            });
        }

        return model;
    }
    public List<String> getOwnerEmails(int ownerId) throws SQLException {
        List<String> emails = new ArrayList<>();

        try (Connection conn = ConexionMariaDB.conectar();
             CallableStatement cs = conn.prepareCall("call pr_get_owner_emails(?)")) {

            cs.setInt(1, ownerId);
            ResultSet rs = cs.executeQuery();
            
            while (rs.next()) {
                emails.add(rs.getString(1));
            }
          
        }

        return emails;
    }
    public List<String> getOwnerPhones(int ownerId) throws SQLException {
        List<String> phones = new ArrayList<>();

        try (Connection conn = ConexionMariaDB.conectar();
             CallableStatement cs = conn.prepareCall("call pr_get_owner_phones(?)")) {

            cs.setInt(1, ownerId);
            ResultSet rs = cs.executeQuery();
            
            while (rs.next()) {
                phones.add(rs.getString(1));
            }
            
        }

        return phones;
    }
    public DefaultTableModel getUserMissingPets(int ownerId) throws SQLException {
        try (Connection conn = ConexionMariaDB.conectar();
             CallableStatement cs = conn.prepareCall(
                 "call pr_get_user_missing_pet_table(?)")) {

            cs.setInt(1, ownerId);


            ResultSet rs = cs.executeQuery();
            
            return buildPetTableModel(rs);
            
        }
    }
    public void takeBackMissingReport(int petId, int ownerId) throws SQLException {
        try (Connection conn = ConexionMariaDB.conectar();
             CallableStatement cs = conn.prepareCall(
                 "call pr_take_back_missing_report(?,?)")) {

            cs.setInt(1, petId);
            cs.setInt(2, ownerId);
            ResultSet rs = cs.executeQuery();
        }
    }

        public DefaultTableModel getAdoptionPets(int currentUserId, PetFilter filter) throws SQLException {
            try (Connection conn = ConexionMariaDB.conectar();
                 CallableStatement cs = conn.prepareCall(
                     "call pr_get_adoption_pet_table(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)")) {

                cs.setInt(1, currentUserId);

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

                ResultSet rs = cs.executeQuery();                
                return buildPetTableModel(rs);
                
            }
        }

    public void putPetUpForAdoption(int petId, int ownerId) throws SQLException {
        try (Connection conn = ConexionMariaDB.conectar();
             CallableStatement cs = conn.prepareCall(
                 "{CALL pr_put_pet_up_for_adoption(?, ?, ?)}")) {

            cs.setInt(1, petId);
            cs.setInt(2, ownerId);
            cs.registerOutParameter(3, java.sql.Types.INTEGER);

            cs.execute();

            int result = cs.getInt(3);

            if (result == -2) {
                throw new SQLException("This pet is reported as missing and cannot be put up for adoption.");
            }

            if (result != 1) {
                throw new SQLException("Pet not found, or this pet does not belong to this user.");
            }
        }
    }
    public void reportPetMissing(int petId, int ownerId) throws SQLException {
        try (Connection conn = ConexionMariaDB.conectar();
             CallableStatement cs = conn.prepareCall("{call pr_report_pet_missing(?,?)}")) {

            cs.setInt(1, petId);
            cs.setInt(2, ownerId);
            ResultSet rs = cs.executeQuery();
        }
    }
    public List<CatalogItem> getCatalog(String catalogName) throws SQLException {
        List<CatalogItem> items = new ArrayList<>();
        items.add(new CatalogItem(null, "Todos"));

        try (Connection conn = ConexionMariaDB.conectar();
             CallableStatement cs = conn.prepareCall("{call pr_get_catalog(?)}")) {

            cs.setString(1, catalogName);
            ResultSet rs = cs.executeQuery();
            
            while (rs.next()) {
                items.add(new CatalogItem(rs.getInt("Id"), rs.getString("Name")));
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
        try (Connection conn = ConexionMariaDB.conectar();
             CallableStatement cs = conn.prepareCall("call pr_undo_pet_up_for_adoption(?,?)")) {

            cs.setInt(1, petId);
            cs.setInt(2, ownerId);
            ResultSet rs = cs.executeQuery();
        }
    }
    
public DefaultTableModel getAdoptionRequestsForOwner(int ownerId) throws SQLException {
        try (Connection conn = ConexionMariaDB.conectar();
             CallableStatement cs = conn.prepareCall("call pr_get_adoption_requests_owner(?)")) {

            cs.setInt(1, ownerId);
            ResultSet rs = cs.executeQuery();
            
            return buildAdoptionRequestTableModel(rs);
            
        }
    }

    public void createAdoptionRequest(int petId, int adopterId, String description) throws SQLException {
        try (Connection conn = ConexionMariaDB.conectar();
             CallableStatement cs = conn.prepareCall("call pr_create_adoption_request(?,?,?)")) {

            cs.setInt(1, petId);
            cs.setInt(2, adopterId);
            setNullableString(cs, 3, description);
            ResultSet rs = cs.executeQuery();
        }
    }

    public void acceptAdoptionRequest(int adoptionId, int ownerId) throws SQLException {
        try (Connection conn = ConexionMariaDB.conectar();
             CallableStatement cs = conn.prepareCall("{call pr_accept_adoption_request(?,?)}")) {

            cs.setInt(1, adoptionId);
            cs.setInt(2, ownerId);
            ResultSet rs = cs.executeQuery();
        }
    }

    public void rejectAdoptionRequest(int adoptionId, int ownerId) throws SQLException {
        try (Connection conn = ConexionMariaDB.conectar();
             CallableStatement cs = conn.prepareCall("{call pr_reject_adoption_request(?,?)}")) {

            cs.setInt(1, adoptionId);
            cs.setInt(2, ownerId);
            ResultSet rs = cs.executeQuery();
        }
    }

    public void registerLostReportForOwner(int petId, int ownerId, java.sql.Date lostDate,
                                           String place, String description,
                                           java.math.BigDecimal reward, int currencyId) throws SQLException {
        try (Connection conn = ConexionMariaDB.conectar();
             CallableStatement cs = conn.prepareCall("call pr_register_lost_for_owner(?,?,?,?,?,?,?,?)")) {

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
            ResultSet rs = cs.executeQuery();
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
    public void createPetClaimRequest(int petId, int claimantId, String description) throws SQLException {
        try (Connection conn = ConexionMariaDB.conectar();
             CallableStatement cs = conn.prepareCall("call pr_create_pet_claim(?,?,?)")) {

            cs.setInt(1, petId);
            cs.setInt(2, claimantId);
            setNullableString(cs, 3, description);
            ResultSet rs = cs.executeQuery();
        }
    }

    public DefaultTableModel getClaimRequestsForOwner(int ownerId) throws SQLException {
        try (Connection conn = ConexionMariaDB.conectar();
             CallableStatement cs = conn.prepareCall("call pr_get_claim_requests_owner(?)")) {

            cs.setInt(1, ownerId);
            ResultSet rs = cs.executeQuery();
            
            return buildClaimRequestTableModel(rs);
            
        }
    }

    public void acceptPetClaimRequest(int claimId, int ownerId) throws SQLException {
        try (Connection conn = ConexionMariaDB.conectar();
             CallableStatement cs = conn.prepareCall("call pr_accept_pet_claim(?,?)")) {

            cs.setInt(1, claimId);
            cs.setInt(2, ownerId);
            ResultSet rs = cs.executeQuery();
        }
    }

    public void rejectPetClaimRequest(int claimId, int ownerId) throws SQLException {
        try (Connection conn = ConexionMariaDB.conectar();
             CallableStatement cs = conn.prepareCall("call pr_reject_pet_claim(?,?)")) {

            cs.setInt(1, claimId);
            cs.setInt(2, ownerId);
            ResultSet rs = cs.executeQuery();
        }
    }

    private DefaultTableModel buildClaimRequestTableModel(ResultSet rs) throws SQLException {
        String[] columns = {
            "ClaimId",
            "PetId",
            "ClaimantId",
            "Pet Name",
            "Claim Description",
            "First Name",
            "Last Name",
            "Phone",
            "District",
            "Canton",
            "Province",
            "Country",
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
                rs.getInt("ClaimId"),
                rs.getInt("PetId"),
                rs.getInt("ClaimantId"),
                rs.getString("PetName"),
                rs.getString("ClaimDescription"),
                rs.getString("FirstName"),
                rs.getString("LastName"),
                rs.getString("Phone"),
                rs.getString("District"),
                rs.getString("Canton"),
                rs.getString("Province"),
                rs.getString("Country"),
                rs.getString("ClaimState")
            });
        }

        return model;
    }
    
    public DefaultTableModel getBitacora() throws SQLException {
        try (Connection conn = ConexionMariaDB.conectar();
             CallableStatement cs = conn.prepareCall("call pr_query_bitacora(?,?,?,?,?)")) {

            cs.setNull(1, Types.VARCHAR); // p_table_name
            cs.setNull(2, Types.VARCHAR); // p_field_name
            cs.setNull(3, Types.NUMERIC); // p_changed_by
            cs.setNull(4, Types.DATE);    // p_start_date
            cs.setNull(5, Types.DATE);    // p_end_date

            ResultSet rs = cs.executeQuery();
            
            return buildBitacoraTableModel(rs);
            
        }
    }
    private DefaultTableModel buildBitacoraTableModel(ResultSet rs) throws SQLException {
        String[] columns = {
            "Id",
            "Table Name",
            "Field Name",
            "Previous Value",
            "Current Value",
            "Changed By",
            "Change Date"
        };

    DefaultTableModel model = new DefaultTableModel(columns, 0) {
            @Override
            public boolean isCellEditable(int row, int column) {
                return false;
            }
        };

        while (rs.next()) {
            model.addRow(new Object[] {
                rs.getInt("Id"),
                rs.getString("TableName"),
                rs.getString("FieldName"),
                rs.getString("PreviousValue"),
                rs.getString("CurrentValue"),
                rs.getObject("ChangedBy"),
                rs.getTimestamp("ChangeDate")
            });
        }

        return model;
    }
}