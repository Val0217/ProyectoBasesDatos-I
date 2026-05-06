package animalwelfare.userInterface;

import javax.swing.text.*;


// esto viene de https://docs.oracle.com/javase/8/docs/api/javax/swing/text/DocumentFilter.html?utm_source=chatgpt.com
// y de https://docs.oracle.com/javase/8/docs/api/javax/swing/text/AbstractDocument.html?utm_source=chatgpt.com
public class NumericFilter extends DocumentFilter {

// Este filtro se asegura de que solo se puedan ingresar números en el campo de texto
    @Override
    public void insertString(FilterBypass fb, int offset, String string, AttributeSet attr)
            throws BadLocationException {
        // Si el texto que se va a insertar contiene solo dígitos, entonces se permite la inserción
        if (string.matches("\\d+") && (fb.getDocument().getLength() + string.length() <= 8)) {
            super.insertString(fb, offset, string, attr);
        }
    }
// Este método se llama cuando se reemplaza el texto en el campo de texto, y también se asegura de que solo se puedan ingresar números
    @Override
    public void replace(FilterBypass fb, int offset, int length, String text, AttributeSet attrs)
            throws BadLocationException {
        // Si el texto que se va a reemplazar contiene solo dígitos, entonces se permite la operación
        if (text.matches("\\d+") && (fb.getDocument().getLength() - length + text.length() <= 8)) {
            super.replace(fb, offset, length, text, attrs);
        }
    }
}