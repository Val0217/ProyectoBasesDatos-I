package animalwelfare.userInterface;

import javax.swing.text.*;

public class NoSpaceFilter extends DocumentFilter {

    @Override
    public void insertString(FilterBypass fb, int offset, String string, AttributeSet attr)
            throws BadLocationException {

        if (string != null && !string.contains(" ")) {
            super.insertString(fb, offset, string, attr);
        }
    }

    @Override
    public void replace(FilterBypass fb, int offset, int length, String text, AttributeSet attrs)
            throws BadLocationException {

        if (text != null && !text.contains(" ")) {
            super.replace(fb, offset, length, text, attrs);
        }
    }
}
