/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package animalwelfare.security;
import org.mindrot.jbcrypt.BCrypt;
/**
 *
 * @author carlo
 */
public class Hash {
    // Hash a password for the first time
        public static String EncryptPassword(String password) {
            String hashed = BCrypt.hashpw(password, BCrypt.gensalt(12));
            // gensalt's log_rounds parameter determines the complexity
            // the work factor is 2**log_rounds, and the default is 10
            return hashed;
        }

        
	// Check that an unencrypted password matches one that has
	// previously been hashed
        public static boolean ComparePassword(String password, String hashed) {
            return BCrypt.checkpw(password, hashed);
        }
    
}
