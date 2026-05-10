
package animalwelfare.main;

import animalwelfare.userInterface.SignInForm;
//import animalwelfare.userInterface.TableAdoption;
import animalwelfare.userInterface.UserPetTable;

public class Main {

    public static void main(String[] args) {
        //SignInForm window = new SignInForm();
        //TableAdoption window = new TableAdoption();
        UserPetTable window = new UserPetTable();
        window.setVisible(true);
    }
    
}
