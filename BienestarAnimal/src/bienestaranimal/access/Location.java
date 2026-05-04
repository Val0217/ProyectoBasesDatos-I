
package bienestaranimal.access;

/**
 *
 * @author carlo
 */
public class Location {
    // esto se encarga de "empaquetar" la infromacion para que cuando se la pase al combobox pordamos acceder al id
    private final int id;
    private final String name;

    public Location(int id, String name) {
        this.id = id;
        this.name = name;
    }

    public int getId() { return id; }
    public String getName() { return name; }

    @Override
    public String toString() {
        return name;
    }
}
