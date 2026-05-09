package animalwelfare.access;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import javax.swing.table.DefaultTableModel;
import oracle.jdbc.OracleTypes;

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
        return callPetSearchProcedure("PKG_PET_OPERATIONS.SP_GET_PETS_UP_FOR_ADOPTION", filters);
    }

    public DefaultTableModel getFoundPetsTableModel(Map<String, String> filters) {
        return callPetSearchProcedure("PKG_PET_OPERATIONS.SP_GET_FOUND_PETS", filters);
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
            Connection connection = ConexionOracle.connect();
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
        String call = "{ ? = call PKG_PET_OPERATIONS.FN_PUT_PET_UP_FOR_ADOPTION(?) }";

        try (
            Connection connection = ConexionOracle.connect();
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

    public List<String> getEnergyOptions() {
        return callOptionsProcedure("PKG_PET_OPERATIONS.SP_GET_ENERGY_OPTIONS", "Name");
    }

    public List<String> getTypeOptions() {
        return callOptionsProcedure("PKG_PET_OPERATIONS.SP_GET_TYPE_OPTIONS", "Name");
    }

    public List<String> getBreedOptions() {
        return callOptionsProcedure("PKG_PET_OPERATIONS.SP_GET_BREED_OPTIONS", "Name");
    }

    public List<String> getDistrictOptions() {
        return callOptionsProcedure("PKG_PET_OPERATIONS.SP_GET_DISTRICT_OPTIONS", "Name");
    }

    public List<String> getSpaceRequiredOptions() {
        return callOptionsProcedure("PKG_PET_OPERATIONS.SP_GET_SPACE_REQUIRED_OPTIONS", "Name");
    }

    public List<String> getTrainingOptions() {
        return callOptionsProcedure("PKG_PET_OPERATIONS.SP_GET_TRAINING_OPTIONS", "Name");
    }

    public List<String> getSizeOptions() {
        return callOptionsProcedure("PKG_PET_OPERATIONS.SP_GET_SIZE_OPTIONS", "Name");
    }

    public List<String> getVeterinarianOptions() {
        return callOptionsProcedure("PKG_PET_OPERATIONS.SP_GET_VETERINARIAN_OPTIONS", "VeterinarianName");
    }

    private List<String> callOptionsProcedure(String procedureName, String columnName) {
        List<String> options = new ArrayList<>();
        String call = "{ call " + procedureName + "(?) }";

        try (
            Connection connection = ConexionOracle.connect();
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
}