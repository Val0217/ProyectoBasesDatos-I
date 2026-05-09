/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package animalwelfare.access;

/**
 *
 * @author carlo
 */
public class DbObject {
    // esto se encarga de "empaquetar" la infromacion para que cuando se la pase al combobox pordamos acceder al id
    private final int id;
    private final String name;

    public DbObject(int id, String name) {
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
