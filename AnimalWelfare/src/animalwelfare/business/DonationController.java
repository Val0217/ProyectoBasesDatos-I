package animalwelfare.business;

import animalwelfare.access.DbObject;
import animalwelfare.access.DonationOperations;
import animalwelfare.security.Session;
import animalwelfare.userInterface.DonationForm;
import java.sql.Date;
import java.util.ArrayList;
import javax.swing.JOptionPane;
import javax.swing.table.DefaultTableModel;

/**
 * Business logic controller for the Donation module.
 * Handles validation and delegates to DonationOperations.
 * @author team
 */
public class DonationController {

    private DonationForm view;

    
    public DonationController(DonationForm view) {
        this.view = view;
        view.fillCombosAssociation(DonationOperations.listAssociations());
        view.fillCombosCurrency(DonationOperations.listCurrencies());
        view.loadDonations(DonationOperations.getDonations(null, null, null, null));
    }

    /**
     * Returns all associations to populate the combo box.
     * @return List of associations as DbObject
     */
    public ArrayList<DbObject> getAssociations() {
        return DonationOperations.listAssociations();
    }

    /**
     * Returns all currencies to populate the combo box.
     * @return List of currencies as DbObject
     */
    public ArrayList<DbObject> getCurrencies() {
        return DonationOperations.listCurrencies();
    }

    /**
     * Validates inputs and inserts a voluntary donation.
     * @param amountStr   Amount as text from the UI field
     * @param association Selected association DbObject
     * @param currency    Selected currency DbObject
     * @return true if donation was registered successfully
     */
    public boolean insertDonation(String amountStr, DbObject association,
                                   DbObject currency) {
        // --- Validations ---
        if (amountStr == null || amountStr.trim().isEmpty()) {
            JOptionPane.showMessageDialog(null, "Amount is required.");
            return false;
        }

        double amount;
        try {
            amount = Double.parseDouble(amountStr.trim());
        } catch (NumberFormatException e) {
            JOptionPane.showMessageDialog(null, "Amount must be a valid number.");
            return false;
        }

        if (amount <= 0) {
            JOptionPane.showMessageDialog(null, "Amount must be greater than 0.");
            return false;
        }

        if (association == null || association.getId() == 0) {
            JOptionPane.showMessageDialog(null, "Please select an association.");
            return false;
        }

        if (currency == null || currency.getId() == 0) {
            JOptionPane.showMessageDialog(null, "Please select a currency.");
            return false;
        }

        int userId = Session.getInstance().getUserId();

        if (userId == 0) {
            JOptionPane.showMessageDialog(null, "You must be logged in to donate.",
                "Validation", JOptionPane.WARNING_MESSAGE);
            return false;
        }

        // --- Insert ---
        boolean success = DonationOperations.insertDonation(
            userId, amount, currency.getId(), association.getId()
        );

        if (success) {
                JOptionPane.showMessageDialog(null, "Donation registered successfully!",
                "Success", JOptionPane.INFORMATION_MESSAGE);
                view.loadDonations(DonationOperations.getDonations(null, null, null, null));
        } else {
            JOptionPane.showMessageDialog(null, "Failed to register donation. Please try again.",
                "Error", JOptionPane.ERROR_MESSAGE);
        }

        return success;
    }


    public DefaultTableModel getDonations(Integer idPerson, Integer idAssociation, Date dateFrom, Date dateTo) {
        if (idAssociation == 0) idAssociation = null;
        return DonationOperations.getDonations(idPerson, idAssociation, dateFrom, dateTo);
    }

    /**
     * Calculates the total amount from a DefaultTableModel.
     * Amount is expected in column index 3.
     * @param model The table model returned by getDonations
     * @return Sum of all amounts
     */
    public double calculateTotal(DefaultTableModel model) {
        double total = 0;
        for (int i = 0; i < model.getRowCount(); i++) {
            Object val = model.getValueAt(i, 4); // Amount column
            if (val instanceof Number) {
                total += ((Number) val).doubleValue();
            }
        }
        return total;
    }
}
