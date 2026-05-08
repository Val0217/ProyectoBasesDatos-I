package animalwelfare.access;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.swing.table.DefaultTableModel;

public class PetOperations {

    private final String[] columnNames = {
        "ID",
        "COLOR",
        "AGE",
        "DESCRIPTION",
        "NAME",
        "CHIP",
        "ENERGY",
        "STATE",
        "TYPE",
        "BREED",
        "DISTRICT",
        "SPACE REQUIRED",
        "TRAINING",
        "SIZE",
        "OWNER",
        "VETERINARIAN"
    };

    public DefaultTableModel getPetsUpForAdoptionTableModel() {
        return getPetsByState(1);
    }

    public DefaultTableModel getFoundPetsTableModel() {
        return getPetsByState(4);
    }

    private DefaultTableModel getPetsByState(int idState) {
        DefaultTableModel model = new DefaultTableModel(columnNames, 0) {
            @Override
            public boolean isCellEditable(int row, int column) {
                return false;
            }
        };

        String sql = """
            SELECT
                PetId,
                Color,
                Age,
                Description,
                PetName,
                Chip,
                Energy,
                PetState,
                PetType,
                Breed,
                District,
                SpaceRequired,
                Training,
                PetSize,
                OwnerName,
                VeterinarianName
            FROM VW_TABLE_ADOPTION
            WHERE IdState = ?
            ORDER BY PetId
        """;

        try (
            Connection connection = ConexionOracle.connect();
            PreparedStatement statement = connection.prepareStatement(sql)
        ) {
            statement.setInt(1, idState);

            try (ResultSet resultSet = statement.executeQuery()) {
                while (resultSet.next()) {
                    Object[] row = {
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
                    };

                    model.addRow(row);
                }
            }

        } catch (SQLException | NullPointerException e) {
            System.out.println("Error loading pets by state: " + e.getMessage());
        }

        return model;
    }

    public boolean putPetUpForAdoption(int petId) {
        String sql = """
            UPDATE PET
            SET IDSTATE = 1
            WHERE ID = ? AND IDSTATE = 4
        """;

        try (
            Connection connection = ConexionOracle.connect();
            PreparedStatement statement = connection.prepareStatement(sql)
        ) {
            statement.setInt(1, petId);

            int rowsUpdated = statement.executeUpdate();

            return rowsUpdated > 0;

        } catch (SQLException | NullPointerException e) {
            System.out.println("Error updating pet state: " + e.getMessage());
            return false;
        }
    }
}