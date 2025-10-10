using Gtk;

namespace Quit {
public class SettingsWindow : Gtk.Window {

    public SettingsWindow () {

        title = "QuitDocklet Settings";
        set_default_size(300, 100);
        set_border_width(10);
        set_position(Gtk.WindowPosition.CENTER);

        var vbox = new Box(Orientation.VERTICAL, 10);
        add(vbox);

        var toggle = new CheckButton.with_label("Show confirmation dialogs");
        vbox.pack_start(toggle, false, false, 0);

        var buttons_box = new Box(Orientation.HORIZONTAL, 10);
        vbox.pack_start(buttons_box, false, false, 0);
        var save_button = new Button.with_label("Save");
        buttons_box.pack_start(save_button, true, true, 0);
        var cancel_button = new Button.with_label("Cancel");
        buttons_box.pack_start(cancel_button, true, true, 0);

        var settings = new SettingsManager();
        toggle.active = settings.get_confirm_dialogs();

        save_button.clicked.connect(() => {
            settings.set_confirm_dialogs(toggle.active);
            print("Settings saved: confirm-dialogs = %s\n", toggle.active.to_string());
        });

        show_all();
    }
}
}
