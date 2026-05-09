package animalwelfare.access;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.swing.table.DefaultTableModel;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;
import javax.swing.JOptionPane;

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

    public static boolean InsertPet(String color, int age, String description, String petName, String chip, int idEnergy, int idState, int idType, int idBreed, int idDistrict, int idSpaceRequired, int idPetTraining, int idPetSize, int idPerson, int idVeterinarian) throws SQLException {

        try {
            Connection con = ConexionOracle.connect();

            // Creamos la consulta SQL para insertar una nueva persona utilizando el procedimiento insertPerson
            String SQL = "BEGIN pr_insert_pet('"+color+"',"+age+",'"+description+"','"+petName+"','"+chip+"',"+idEnergy+","+idState+","+idType+","+idBreed+","+idDistrict+","+idSpaceRequired+","+idPetTraining+","+idPetSize+","+idPerson+","+idVeterinarian+"); END;";
            
            Statement cn = con.createStatement(); // esto es para poder ejecutar consultas
            cn.execute(SQL); // ejecutamos el query
            

            cn.close();
            con.close();
            
            return true;

        } catch (SQLException e) {
            JOptionPane.showMessageDialog(null, "Error: " + e.getMessage());
            return false;
        }
    }
}