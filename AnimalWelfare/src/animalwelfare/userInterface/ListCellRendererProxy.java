/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package animalwelfare.userInterface;

import java.awt.Color;
import java.awt.Component;
import javax.swing.BorderFactory;
import javax.swing.JLabel;
import javax.swing.JList;
import javax.swing.ListCellRenderer;


// https://shred.zone/en/dev/setting-a-renderer-on-jcombobox/
// esto es para cambiar como se renderizan los sub-menu de las combobox y que se vea mas bonito
public class ListCellRendererProxy implements ListCellRenderer {
  private final ListCellRenderer delegate;

  public ListCellRendererProxy(ListCellRenderer delegate) {
    this.delegate = delegate;
  }
  
  @Override
  public Component getListCellRendererComponent(JList list, Object value,int index, boolean isSelected, boolean cellHasFocus) {
      
    JLabel lbl = (JLabel) delegate.getListCellRendererComponent(list, value, index, isSelected, cellHasFocus);

    lbl.setBorder(BorderFactory.createEmptyBorder(5, 10, 5, 10));
    
    if (isSelected) {
        lbl.setBackground(new Color(255, 204, 0));
        lbl.setForeground(Color.BLACK);
    } else {
        lbl.setBackground(Color.WHITE);
        lbl.setForeground(Color.BLACK);
    }
    return lbl;
  }
}
