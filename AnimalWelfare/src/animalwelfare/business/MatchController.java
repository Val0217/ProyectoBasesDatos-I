package animalwelfare.business;

import animalwelfare.access.MatchOperations;
import animalwelfare.security.Session;
import animalwelfare.userInterface.MatchForm;
import javax.swing.JOptionPane;
import javax.swing.table.DefaultTableModel;

/**
 * Business logic controller for the Pet Match module.
 * @author team
 */
public class MatchController {

    private final MatchForm view;

    public MatchController(MatchForm view) {
        this.view = view;
        view.loadMatchReport(MatchOperations.getMatchReport());
        view.updatePendingCount(MatchOperations.countPendingMatches());
    }

    // -------------------------------------------------------------------------
    // RUN MATCH — only admins
    // -------------------------------------------------------------------------

    /**
     * Runs the match engine manually.
     * Only admins can trigger this.
     * @return true if successful
     */
    public boolean runMatch() {
        String role = Session.getInstance().getRole();

        if (!"Admin".equals(role)) {
            JOptionPane.showMessageDialog(null,
                "Only admins can run the match engine manually.",
                "Access Denied", JOptionPane.ERROR_MESSAGE);
            return false;
        }

        int confirm = JOptionPane.showConfirmDialog(null,
            "Run the match engine now? This will compare all lost and found pets.",
            "Confirm", JOptionPane.YES_NO_OPTION, JOptionPane.QUESTION_MESSAGE);

        if (confirm != JOptionPane.YES_OPTION) return false;

        boolean success = MatchOperations.runMatch();

        if (success) {
            int pending = MatchOperations.countPendingMatches();
            JOptionPane.showMessageDialog(null,
                "Match completed successfully!\nNew matches generated: " +
                (pending == 0 ? "check the report" : "see report"),
                "Success", JOptionPane.INFORMATION_MESSAGE);

            view.loadMatchReport(MatchOperations.getMatchReport());
            view.updatePendingCount(MatchOperations.countPendingMatches());
        } else {
            JOptionPane.showMessageDialog(null,
                "Match engine failed. Check the database logs.",
                "Error", JOptionPane.ERROR_MESSAGE);
        }

        return success;
    }

    // -------------------------------------------------------------------------
    // REFRESH
    // -------------------------------------------------------------------------

    public void refresh() {
        view.loadMatchReport(MatchOperations.getMatchReport());
        view.updatePendingCount(MatchOperations.countPendingMatches());
    }

    // -------------------------------------------------------------------------
    // TABLE MODEL
    // -------------------------------------------------------------------------

    public DefaultTableModel getMatchReport() {
        return MatchOperations.getMatchReport();
    }
}
