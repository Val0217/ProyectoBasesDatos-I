package animalwelfare.access;

import java.sql.CallableStatement;
import java.sql.ResultSet;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import javax.swing.table.DefaultTableModel;
import oracle.jdbc.OracleTypes;
import java.sql.Statement;
import javax.swing.JOptionPane;
import java.sql.Types;
import oracle.jdbc.OracleConnection;
import java.sql.Array;

public class PetOperations {
    

    private final String[] columnNames = {
        "ID", "COLOR", "AGE", "DESCRIPTION", "NAME", "CHIP", "ENERGY", "STATE",
        "TYPE", "BREED", "DISTRICT", "SPACE REQUIRED", "TRAINING", "SIZE", "OWNER", "VETERINARIAN"
    };

    public DefaultTableModel getPetsUpForAdoptionTableModel() {
        return getPetsUpForAdoptionTableModel(null);
    }

    public DefaultTableModel getFoundPetsTableModel() {
        return getFoundPetsTableModel(null);
    }

    public DefaultTableModel getPetsUpForAdoptionTableModel(Map<String, String> filters) {
        return callPetSearchProcedure("pr_pkg_get_pets_up_for_adoption", filters);
    }

    public DefaultTableModel getFoundPetsTableModel(Map<String, String> filters) {
        return callPetSearchProcedure("pr_pkg_get_found_pets", filters);
    }

    private DefaultTableModel callPetSearchProcedure(String procedureName, Map<String, String> filters) {
        DefaultTableModel model = new DefaultTableModel(columnNames, 0) {
            @Override
            public boolean isCellEditable(int row, int column) {
                return false;
            }
        };

        String call = "{ call " + procedureName + "(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?) }";

        try (
            Connection connection = ConexionMariaDB.conectar();
            CallableStatement statement = connection.prepareCall(call)
        ) {
            statement.setString(1, getFilter(filters, "color"));
            setNullableInteger(statement, 2, getFilter(filters, "age"));
            statement.setString(3, getFilter(filters, "name"));
            statement.setString(4, getFilter(filters, "chip"));
            statement.setString(5, getFilter(filters, "energy"));
            statement.setString(6, getFilter(filters, "type"));
            statement.setString(7, getFilter(filters, "breed"));
            statement.setString(8, getFilter(filters, "district"));
            statement.setString(9, getFilter(filters, "spaceRequired"));
            statement.setString(10, getFilter(filters, "training"));
            statement.setString(11, getFilter(filters, "size"));
            statement.setString(12, getFilter(filters, "veterinarian"));
            statement.registerOutParameter(13, OracleTypes.CURSOR);

            statement.execute();

            try (ResultSet resultSet = (ResultSet) statement.getObject(13)) {
                while (resultSet.next()) {
                    model.addRow(new Object[] {
                        resultSet.getInt("PetId"),
                        resultSet.getString("Color"),
                        resultSet.getInt("Age"),
                        resultSet.getString("Description"),
                        resultSet.getString("PetName"),
                        resultSet.getString("Chip"),
                        resultSet.getString("Energy"),
                        resultSet.getString("PetState"),
                        resultSet.getString("PetType"),
                        resultSet.getString("Breed"),
                        resultSet.getString("District"),
                        resultSet.getString("SpaceRequired"),
                        resultSet.getString("Training"),
                        resultSet.getString("PetSize"),
                        resultSet.getString("OwnerName"),
                        resultSet.getString("VeterinarianName")
                    });
                }
            }
        } catch (SQLException | NullPointerException e) {
            System.out.println("Error loading pets from stored procedure: " + e.getMessage());
        }

        return model;
    }

    public boolean putPetUpForAdoption(int petId) {
        String call = "{ call pr_pkg_get_pets_up_for_adoption(?) }";

        try (
            Connection connection = ConexionMariaDB.conectar();
            CallableStatement statement = connection.prepareCall(call)
        ) {
            statement.registerOutParameter(1, java.sql.Types.NUMERIC);
            statement.setInt(2, petId);
            statement.execute();

            boolean updated = statement.getInt(1) == 1;

            if (updated) {
                connection.commit();
            }

            return updated;
        } catch (SQLException | NullPointerException e) {
            System.out.println("Error updating pet state from stored function: " + e.getMessage());
            return false;
        }
    }

    public static boolean InsertPet(String color, int age, String description, String petName, String chip, int idEnergy, int idType, int idBreed, int idDistrict, int idSpaceRequired, int idPetTraining, int idPetSize, int idPerson, int idVeterinarian, Integer[] illnessIds, Integer[] treatmentIds, Integer[] medicineIds, String[] imageFiles) throws SQLException {

        try {
            Connection con = ConexionMariaDB.conectar();

            CallableStatement cs =
                con.prepareCall("{ CALL pr_insert_pet(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?) }");

            cs.setString(1, color);
            cs.setInt(2, age);
            cs.setString(3, description);
            cs.setString(4, petName);
            cs.setString(5, chip);
            cs.setInt(6, idEnergy);
            cs.setInt(7, idType);
            cs.setInt(8, idBreed);
            cs.setInt(9, idDistrict);
            cs.setInt(10, idSpaceRequired);
            cs.setInt(11, idPetTraining);
            cs.setInt(12, idPetSize);
            cs.setInt(13, idPerson);
            cs.setInt(14, idVeterinarian);

            cs.setString(15, toJson(illnessIds));
            cs.setString(16, toJson(treatmentIds));
            cs.setString(17, toJson(medicineIds));
            cs.setString(18, toJson(imageFiles));

            cs.execute();

            cs.close();
            con.close();

            return true;

        } catch (SQLException e) {
            JOptionPane.showMessageDialog(null, "Error: " + e.getMessage());
            return false;
        }
    }

    public List<String> getEnergyOptions() {
        return callOptionsProcedure("pr_pkg_get_energy_options", "Name");
    }

    public List<String> getTypeOptions() {
        return callOptionsProcedure("pr_pkg_get_type_options", "Name");
    }

    public List<String> getBreedOptions() {
        return callOptionsProcedure("pr_pkg_get_breed_options", "Name");
    }

    public List<String> getDistrictOptions() {
        return callOptionsProcedure("pr_pkg_get_district_options", "Name");
    }

    public List<String> getSpaceRequiredOptions() {
        return callOptionsProcedure("pr_pkg_get_space_required_options", "Name");
    }

    public List<String> getTrainingOptions() {
        return callOptionsProcedure("pr_pkg_get_training_options", "Name");
    }

    public List<String> getSizeOptions() {
        return callOptionsProcedure("pr_pkg_get_size_options", "Name");
    }

    public List<String> getVeterinarianOptions() {
        return callOptionsProcedure("pr_pkg_get_veterinarian_options", "VeterinarianName");
    }

    private List<String> callOptionsProcedure(String procedureName, String columnName) {
        List<String> options = new ArrayList<>();
        String call = "{ call " + procedureName + "(?) }";

        try (
            Connection connection = ConexionMariaDB.conectar();
            CallableStatement statement = connection.prepareCall(call)
        ) {
            statement.registerOutParameter(1, OracleTypes.CURSOR);
            statement.execute();

            try (ResultSet resultSet = (ResultSet) statement.getObject(1)) {
                while (resultSet.next()) {
                    options.add(resultSet.getString(columnName));
                }
            }
        } catch (SQLException | NullPointerException e) {
            System.out.println("Error loading options from stored procedure: " + e.getMessage());
        }

        return options;
    }

    public Map<String, List<String>> getFilterOptions() {
        Map<String, List<String>> options = new LinkedHashMap<>();
        options.put("energy", getEnergyOptions());
        options.put("type", getTypeOptions());
        options.put("breed", getBreedOptions());
        options.put("district", getDistrictOptions());
        options.put("spaceRequired", getSpaceRequiredOptions());
        options.put("training", getTrainingOptions());
        options.put("size", getSizeOptions());
        options.put("veterinarian", getVeterinarianOptions());
        return options;
    }

    private String getFilter(Map<String, String> filters, String key) {
        if (filters == null) {
            return null;
        }
        return filters.get(key);
    }

    private void setNullableInteger(CallableStatement statement, int index, String value) throws SQLException {
        if (value == null || value.trim().isEmpty()) {
            statement.setNull(index, java.sql.Types.NUMERIC);
            return;
        }

        try {
            statement.setInt(index, Integer.parseInt(value.trim()));
        } catch (NumberFormatException e) {
            statement.setNull(index, java.sql.Types.NUMERIC);
        }
    }
    public static PetEditData GetPetForEdit(int petId, int ownerId) throws SQLException {
        String call = "{ call pr_get_pet_for_edit(?, ?, ?) }";

        try (
            Connection connection = ConexionMariaDB.conectar();
            CallableStatement statement = connection.prepareCall(call)
        ) {
            statement.setInt(1, petId);
            statement.setInt(2, ownerId);
            statement.registerOutParameter(3, OracleTypes.CURSOR);

            statement.execute();

            try (ResultSet resultSet = (ResultSet) statement.getObject(3)) {
                if (!resultSet.next()) {
                    return null;
                }

                PetEditData pet = new PetEditData();

                pet.idPet = resultSet.getInt("IdPet");
                pet.idOwner = resultSet.getInt("IdOwner");

                pet.color = resultSet.getString("Color");
                pet.age = resultSet.getInt("Age");
                pet.description = resultSet.getString("Description");
                pet.petName = resultSet.getString("PetName");
                pet.chip = resultSet.getString("Chip");

                pet.idEnergy = resultSet.getInt("IdEnergy");
                pet.idType = resultSet.getInt("IdType");

                int breedId = resultSet.getInt("IdBreed");
                if (resultSet.wasNull()) {
                    pet.idBreed = null;
                } else {
                    pet.idBreed = breedId;
                }

                pet.idDistrict = resultSet.getInt("IdDistrict");
                pet.idCanton = resultSet.getInt("IdCanton");
                pet.idProvince = resultSet.getInt("IdProvince");
                pet.idCountry = resultSet.getInt("IdCountry");

                pet.idSpace = resultSet.getInt("IdSpace");
                pet.idPetTraining = resultSet.getInt("IdPetTraining");
                pet.idSize = resultSet.getInt("IdSize");
                pet.idVeterinarian = resultSet.getInt("IdVeterinarian");

                return pet;
            }
        }
    }
    private static String toJson(Integer[] values) {
        if (values == null) {
            return "[]";
        }

        StringBuilder sb = new StringBuilder("[");
        for (int i = 0; i < values.length; i++) {
            if (i > 0) sb.append(",");
            sb.append(values[i]);
        }
        sb.append("]");

        return sb.toString();
    }
    private static String toJson(String[] values) {
        if (values == null) {
            return "[]";
    }

    StringBuilder sb = new StringBuilder("[");
        for (int i = 0; i < values.length; i++) {
            if (i > 0) sb.append(",");
            sb.append("\"").append(values[i]).append("\"");
        }
        sb.append("]");

        return sb.toString();
    }
    public static boolean UpdatePetForOwner(
            int petId,
            int ownerId,
            String color,
            int age,
            String description,
            String petName,
            String chip,
            int idEnergy,
            int idType,
            Integer idBreed,
            int idDistrict,
            int idSpace,
            int idPetTraining,
            int idSize,
            int idVeterinarian
    ) throws SQLException {

        String call = "{ call pr_update_pet_for_owner(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?) }";

        try (
            Connection connection = ConexionMariaDB.conectar();
            CallableStatement statement = connection.prepareCall(call)
        ) {
            statement.setInt(1, petId);
            statement.setInt(2, ownerId);

            statement.setString(3, color);
            statement.setInt(4, age);
            statement.setString(5, description);
            statement.setString(6, petName);
            statement.setString(7, chip);

            statement.setInt(8, idEnergy);
            statement.setInt(9, idType);

            if (idBreed == null) {
                statement.setNull(10, Types.NUMERIC);
            } else {
                statement.setInt(10, idBreed);
            }

            statement.setInt(11, idDistrict);
            statement.setInt(12, idSpace);
            statement.setInt(13, idPetTraining);
            statement.setInt(14, idSize);
            statement.setInt(15, idVeterinarian);

            statement.registerOutParameter(16, Types.NUMERIC);

            statement.execute();

            int rowsUpdated = statement.getInt(16);

            if (rowsUpdated > 0) {
                
                return true;
            }

            return false;
        }
    }
}