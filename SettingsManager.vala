using GLib;
using Json;

namespace Quit {

public class SettingsManager : GLib.Object
{

    private string config_path;
    private Json.Object settings;

    public SettingsManager()
    {
        config_path = GLib.Path.build_filename(GLib.Environment.get_user_config_dir(), "quitdocklet/settings.json");
        load();
    }

    private void load()
    {
        try {
            var parser = new Json.Parser();
            parser.load_from_file(config_path);
            settings = parser.get_root().get_object();
        }
        catch(Error e) {
            warning("Settings file not found or invalid, creating defaults: %s", e.message);
            settings = new Json.Object();
            set_defaults();
            save();
        }
    }

    private void set_defaults()
    {
        settings.set_boolean_member("confirm-dialogs", true);
        settings.set_string_member("theme", "default");
    }

    public bool get_confirm_dialogs()
    {
        return settings.has_member("confirm-dialogs") ?
               settings.get_boolean_member("confirm-dialogs") : true;
    }

    public void set_confirm_dialogs(bool value)
    {
        settings.set_boolean_member("confirm-dialogs", value);
        save();
    }

    public string get_theme()
    {
        return settings.has_member("theme") ?
               settings.get_string_member("theme") : "default";
    }

    public void set_theme(string value)
    {
        settings.set_string_member("theme", value);
        save();
    }

    private void save()
    {
        try {
            var generator = new Json.Generator();
            var node = new Json.Node(Json.NodeType.OBJECT);
            node.init_object(settings);
            generator.set_root(node);

            string json_text = generator.to_data(null);

            DirUtils.create(GLib.Path.get_dirname(config_path), 0755);
            FileUtils.set_contents(config_path, json_text);
            message("Settings saved to %s", config_path);
        }
        catch(Error e) {
            warning("Failed to save settings: %s", e.message);
        }
    }

}
}

