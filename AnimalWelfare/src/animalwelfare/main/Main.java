
package animalwelfare.main;

import animalwelfare.userInterface.SignInForm;
//import animalwelfare.userInterface.TableAdoption;
//import animalwelfare.userInterface.UserPetTable;
import animalwelfare.userInterface.MainMenu;

public class Main {

    public static void main(String[] args) {
        SignInForm window = new SignInForm();
        //TableAdoption window = new TableAdoption();
        //UserPetTable window = new UserPetTable();
        //MainMenu window = new MainMenu(1);
        window.setVisible(true);
    }
    
}
