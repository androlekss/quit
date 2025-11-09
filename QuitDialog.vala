namespace Quit {
public class QuitDialog : Gtk.Dialog {

    public QuitDialog(Gtk.Window? parent, QuitDockItemPreferences prefs) {

        this.set_transient_for(parent);
        this.set_modal(true);
        this.set_title(_("Session"));
        this.set_default_size(400, 100);
        this.set_border_width(6);
        this.set_resizable(false);


        var content = this.get_content_area() as Gtk.Box;
        content.set_spacing(6);

        var hbox = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 12);
        hbox.set_halign(Gtk.Align.CENTER);
        
        var icon = new Gtk.Image.from_icon_name("system-shutdown-symbolic", Gtk.IconSize.DIALOG);
        icon.set_pixel_size(38);
        hbox.pack_start(icon, false, false, 0);
        
        var label = new Gtk.Label(_("Shut down this system now?"));
        label.get_style_context().add_class("h2");
        var attr_list = new Pango.AttrList();
        attr_list.insert(Pango.attr_weight_new(Pango.Weight.BOLD));
        label.set_attributes(attr_list);
        hbox.pack_start(label, false, false, 0);
        
        content.pack_start(hbox, true, true, 0);

        // Add action area buttons
        this.add_button(_("Suspend"), Gtk.ResponseType.NONE);
        this.add_button(_("Cancel"), Gtk.ResponseType.CANCEL);
        this.add_button(_("Restart"), Gtk.ResponseType.APPLY);
        var shutdown_button = this.add_button(_("Shut Down"), Gtk.ResponseType.YES);
        
        shutdown_button.get_style_context().add_class("destructive-action");

        this.response.connect((response_id) => {
            this.destroy();

            switch (response_id) {
                case Gtk.ResponseType.YES:
                    SessionManager.perform_with_confirmation(this, SessionManager.Action.SHUTDOWN, prefs);
                    break;
                case Gtk.ResponseType.APPLY:
                    SessionManager.perform_with_confirmation(this, SessionManager.Action.REBOOT, prefs);
                    break;
                case Gtk.ResponseType.NONE:
                    SessionManager.perform_with_confirmation(this, SessionManager.Action.SUSPEND, prefs);
                    break;
                default:
                    info("[QuitDialog] Cancelled");
                    break;
            }
        });

        this.show_all();
    }
}
}
