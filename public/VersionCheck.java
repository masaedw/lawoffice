import java.awt.*;
import java.applet.Applet;

public class VersionCheck extends Applet
{
    public void init() {
        String version = "Java VM Verison: " + System.getProperty("java.version", "Cannot detect.");
        add(new Label(version));
    }
}
