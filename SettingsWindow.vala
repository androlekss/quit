using Gtk;

namespace Quit {
public class SettingsWindow : Gtk.Window
{
    private QuitDockItemPreferences prefs;

    public SettingsWindow (QuitDockItem parent, QuitDockItemPreferences prefs)
    {
        this.prefs = prefs;

        prefs.notify["CustomIcon"].connect(() => {
                parent.update_icon();
            });

        title = "QuitDocklet Settings";
        set_default_size(300, 100);
        set_border_width(10);
        set_position(Gtk.WindowPosition.CENTER);

        var vbox = new Gtk.Box(Gtk.Orientation.VERTICAL, 10);
        add(vbox);

        var toggle = new Gtk.CheckButton.with_label("Show confirmation dialogs");
        toggle.active = prefs.ConfirmDialogs;
        vbox.pack_start(toggle, false, false, 0);

        var custom_icon_button = new Gtk.Button.with_label("Choose Custom Icon");
        var reset_icon_button = new Gtk.Button.with_label("Reset to Default Icon");

        var icon_buttons_box = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 10);
        vbox.pack_start(icon_buttons_box, false, false, 0);

        icon_buttons_box.pack_start(custom_icon_button, true, true, 0);
        icon_buttons_box.pack_start(reset_icon_button, true, true, 0);

        var buttons_box = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 10);
        vbox.pack_start(buttons_box, false, false, 0);

        var save_button = new Gtk.Button.with_label("Save");
        buttons_box.pack_start(save_button, true, true, 0);

        var cancel_button = new Gtk.Button.with_label("Cancel");
        buttons_box.pack_start(cancel_button, true, true, 0);

        custom_icon_button.clicked.connect(() => {
                show_icon_picker();
            });


        reset_icon_button.clicked.connect(() => {
                prefs.CustomIcon = "";
                prefs.notify_property("CustomIcon");
            });

        save_button.clicked.connect(() => {
                prefs.ConfirmDialogs = toggle.active;
                prefs.notify_property("ConfirmDialogs");
                print("Settings saved: ConfirmDialogs = %s\n", toggle.active.to_string());
                destroy();
            });

        cancel_button.clicked.connect(() => {
                destroy();
            });

        show_all();
    }

    private void show_icon_picker()
    {
        var file_chooser = new Gtk.FileChooserDialog(
            _("Select Custom Icon"),
            this,
            Gtk.FileChooserAction.OPEN,
            _("Cancel"), Gtk.ResponseType.CANCEL,
            _("Select"), Gtk.ResponseType.ACCEPT
            );

        string[] icon_paths = {
            "/usr/share/icons",
            "/usr/share/pixmaps",
            GLib.Environment.get_home_dir() + "/.local/share/icons"
        };

        foreach(var path in icon_paths)
        {
            var dir = File.new_for_path(path);
            if(dir.query_exists())
            {
                file_chooser.set_current_folder(path);
                break;
            }
        }

        var filter = new Gtk.FileFilter();
        filter.set_name(_("Image Files"));
        filter.add_mime_type("image/png");
        filter.add_mime_type("image/jpeg");
        filter.add_mime_type("image/svg+xml");
        filter.add_mime_type("image/webp");
        filter.add_pattern("*.png");
        filter.add_pattern("*.jpg");
        filter.add_pattern("*.jpeg");
        filter.add_pattern("*.svg");
        filter.add_pattern("*.xpm");
        filter.add_pattern("*.webp");
        file_chooser.add_filter(filter);

        var preview = new Gtk.Image();
        preview.set_size_request(128, 128);
        file_chooser.set_preview_widget(preview);
        file_chooser.set_use_preview_label(false);

        file_chooser.update_preview.connect(() => {
                string? filename = file_chooser.get_preview_filename();
                if(filename == null)
                {
                    file_chooser.set_preview_widget_active(false);
                    return;
                }

                try {
                    var pixbuf = new Gdk.Pixbuf.from_file_at_scale(filename, 128, 128, true);
                    preview.set_from_pixbuf(pixbuf);
                    file_chooser.set_preview_widget_active(true);
                }
                catch(Error e) {
                    file_chooser.set_preview_widget_active(false);
                }
            });

        if(file_chooser.run() == Gtk.ResponseType.ACCEPT)
        {
            string uri = file_chooser.get_uri();
            prefs.CustomIcon = uri;
            prefs.notify_property("CustomIcon");
        }

        file_chooser.destroy();
    }
}
}

