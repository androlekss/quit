public static void docklet_init(Plank.DockletManager manager)
{
    manager.register_docklet(typeof (Quit.QuitDocklet));
}

namespace Quit {
/**
 * Resource path for the icon
 */
public const string G_RESOURCE_PATH = "/at/greyh/quit";

public class QuitDocklet : Object, Plank.Docklet
{
    public unowned string get_id()
    {
        return "Quit";
    }

    public unowned string get_name()
    {
        return _("Quit");
    }

    public unowned string get_description()
    {
        return _("A small Quit");
    }

    public unowned string get_icon()
    {
        return "resource://" + Quit.G_RESOURCE_PATH + "/icons/quit.png";
    }

    public bool is_supported()
    {
        return true;
    }

    public Plank.DockElement make_element(string launcher, GLib.File file)
    {
        return new QuitDockItem.with_dockitem_file(file);
    }
}
}


