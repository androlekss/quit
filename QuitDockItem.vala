using Plank;
using Cairo;
using Gee;

namespace Quit {

public class QuitDockItem : DockletItem
{

    private Gdk.Pixbuf icon_pixbuf;
    private QuitDockItemPreferences prefs;
    private SettingsWindow? settings_window = null;

    public QuitDockItem.with_dockitem_file(GLib.File file) {
        GLib.Object(Prefs: new QuitDockItemPreferences.with_file(file));
    }

    construct {

        prefs = (QuitDockItemPreferences) Prefs;
        Icon = "resource://" + Quit.G_RESOURCE_PATH + "/icons/quit.png";
        Text = "Click to open session actions";

        ((QuitDockItemPreferences) Prefs).notify["CustomIcon"].connect(() => {
                update_icon();
            });

        update_icon();

        try {
            icon_pixbuf = new Gdk.Pixbuf.from_resource(Quit.G_RESOURCE_PATH + "/icons/quit.png");
        }
        catch(Error e) {
            warning("Error: " + e.message);
        }
    }

    protected override AnimationType on_clicked(PopupButton button, Gdk.ModifierType mod, uint32 event_time)
    {
        if((button & PopupButton.LEFT) != 0)
        {
            new Quit.QuitDialog(null, prefs);
            return AnimationType.NONE;
        }

        return AnimationType.NONE;
    }

    public override ArrayList<Gtk.MenuItem> get_menu_items()
    {
        var items = new ArrayList<Gtk.MenuItem>();

        var shutdown_item = new Gtk.MenuItem.with_label(_("Shut down"));
        shutdown_item.activate.connect(() => {
                Quit.SessionManager.perform_with_confirmation(null, SessionManager.Action.SHUTDOWN, prefs);
            });
        items.add(shutdown_item);

        var reboot_item = new Gtk.MenuItem.with_label(_("Reboot"));
        reboot_item.activate.connect(() => {
                Quit.SessionManager.perform_with_confirmation(null, SessionManager.Action.REBOOT, prefs);
            });
        items.add(reboot_item);

        var logout_item = new Gtk.MenuItem.with_label(_("Log out"));
        logout_item.activate.connect(() => {
                Quit.SessionManager.perform_with_confirmation(null, SessionManager.Action.LOGOUT, prefs);
            });
        items.add(logout_item);
        var quit_item = new Gtk.MenuItem.with_label(_("Session Control"));
        quit_item.activate.connect(() => {
                new Quit.QuitDialog(null, prefs);
            });
        items.add(quit_item);

        var separator = new Gtk.SeparatorMenuItem();
        items.add(separator);

        var settings_item = new Gtk.MenuItem.with_label(_("Settings"));
        settings_item.activate.connect(() => {
                open_settings_window();
            });
        items.add(settings_item);

        return items;
    }

    public void update_icon()
    {
        string custom_icon = prefs.CustomIcon;
        if(custom_icon != null && custom_icon != "")
        {
            Icon = custom_icon;
        }
        else
        {
            Icon = "resource://" + Quit.G_RESOURCE_PATH + "/icons/quit.png";
        }
    }

    private void open_settings_window()
    {
        if(settings_window != null && settings_window.is_visible())
        {
            settings_window.present();
            return;
        }

        settings_window = new SettingsWindow(this, prefs);
        settings_window.set_destroy_with_parent(true);

        settings_window.destroy.connect(() => {
                settings_window = null;
            });

        settings_window.show_all();
    }

}
}


