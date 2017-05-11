package com.andallus.swingdebug;

import java.awt.Component;
import java.awt.Rectangle;
import java.awt.event.ComponentEvent;
import java.awt.event.ComponentListener;
import java.lang.reflect.Field;

import javax.swing.JComponent;

/**
 * Adds a tooltip to any JComponent naming:
 * <ul>
 * <li> The class within which it was constructed </li>
 * <li> The field name or 'anonymouse' for local variables and unbound instances</li>
 * </ul>
 * @author otwebti@andallus.com
 *
 */
public aspect JComponentIdentifier {



    /** Component Instantiation*/
    pointcut constructJComponent(Object container) : call(javax.swing.JComponent+.new(..))
            && this(container);

    after (Object container) returning(javax.swing.JComponent component) : constructJComponent(container){
        String componentType = component.getClass().getName();
        String containerType = container.getClass().getName();
        StringBuilder b = new StringBuilder("<html><b>Class: </b>")
                .append(componentType)
                .append("<br>")
                .append("<html><b>Instantiated in: </b>")
                .append(containerType)
                .append("<br></html>");
        component.setToolTipText(b.toString());
    }

    /** JComponent ToolTipChanges*/
    pointcut setToolTip(javax.swing.JComponent component, String text) :
            call(public void javax.swing.JComponent+.setToolTipText(String))
                    && args(text)
                    && target(component)
                    && !within(com.andallus.swingdebug.JComponentIdentifier);

    void around(javax.swing.JComponent component,String text) : setToolTip(component,text) {

        //TODO: Fix this. Should never need to check for null as instantiation advise should have set a tooltip
        text = (text != null) ? text.replaceAll("<html>|</html>", "") : "";

        String componentText = component.getToolTipText();
        componentText = (componentText != null) ? componentText.replaceAll("<html>|</html>", "") : "";

        StringBuilder b = new StringBuilder("<html>")
                .append(text)
                .append("<br>")
                .append(componentText)
                .append("</html>");

        String finalText = b.toString();

        proceed(component,finalText);
    }

    /**Assignment*/
    pointcut jComponentAssignedToField(javax.swing.JComponent component, Object container) :
            set(javax.swing.JComponent+ *)
                    && args(component)
                    && this(container);

    after (javax.swing.JComponent component, Object container) returning() : jComponentAssignedToField(component,container){
        Field[] fields = container.getClass().getDeclaredFields();
        for(Field f : fields) {
            f.setAccessible(true);
            try {
                if(component == f.get(container)) {

                    String componentText = component.getToolTipText();
                    componentText = (componentText != null) ? componentText.replaceAll("<html>|</html>", "") : "";

                    StringBuilder b = new StringBuilder("<html>")
                            .append(componentText)
                            .append("<b>Assigned To:</b> ")
                            .append(f.getName())
                            .append("<br>")
                            .append("<b>In Class: </b>")
                            .append(container.getClass().getName())
                            .append("<br>")
                            .append("</html>");
                    component.setToolTipText(b.toString());
                    break;
                }
            }catch(IllegalAccessException e) {
                System.out.println("Can't access field make sure security permission 'suppressAccessChecks' ");
            }catch(NullPointerException e) {
                System.out.println("Field  "+component+" assigned in "+container+" before being fully initialised");
            }
        }
    }

}


