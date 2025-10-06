using Gee;

namespace Quit {

public class SessionManager : Object
{

    public enum Action {
        SHUTDOWN,
        REBOOT,
        LOGOUT
    }

    private static Gee.List<string> shutdown_cmds;
    private static Gee.List<string> reboot_cmds;
    private static Gee.List<string> logout_cmds;


    public static void init_commands() {

        info("[SessionManager] Initializing command lists");

        shutdown_cmds = new Gee.ArrayList<string>();
        shutdown_cmds.add("systemctl poweroff");
        shutdown_cmds.add("shutdown now");
        shutdown_cmds.add("halt");

        reboot_cmds = new Gee.ArrayList<string>();
        reboot_cmds.add("systemctl reboot");
        reboot_cmds.add("reboot");
        reboot_cmds.add("shutdown -r now");

        logout_cmds = new Gee.ArrayList<string>();
        logout_cmds.add("gnome-session-quit --logout --no-prompt");
        logout_cmds.add("xfce4-session-logout --logout");
        logout_cmds.add("mate-session-save --logout");
        logout_cmds.add("cinnamon-session-quit --logout --no-prompt");
    }

    public static void perform_with_confirmation(Gtk.Window? parent, Action action)
    {
        info("[SessionManager] Received action: %s\n", action.to_string());
        init_commands();
        string message;
        switch(action)
        {
        case Action.SHUTDOWN: message = _("Are you sure you want to shut down?"); break;
        case Action.REBOOT:   message = _("Are you sure you want to reboot?"); break;
        case Action.LOGOUT:   message = _("Are you sure you want to log out?"); break;
        default:
            warning("[SessionManager] Unknown action: %s\n", action.to_string());
            return;
        }

        var dialog = new Gtk.MessageDialog(
            parent,
            Gtk.DialogFlags.MODAL,
            Gtk.MessageType.QUESTION,
            Gtk.ButtonsType.OK_CANCEL,
            message
            );

        dialog.set_title(_("Confirm Action"));
        dialog.response.connect((response_id) => {
                dialog.destroy();
                if(response_id == Gtk.ResponseType.OK)
                {
                    perform(action);
                }
                else
                {
                    info("[SessionManager] Action cancelled by user: %s\n", action.to_string());
                }
            });

        dialog.show_all();
    }

    public static void perform(Action action)
    {
        Gee.List<string>? cmds = null;

        switch(action)
        {
        case Action.SHUTDOWN: cmds = shutdown_cmds; break;
        case Action.REBOOT: cmds = reboot_cmds; break;
        case Action.LOGOUT: cmds = logout_cmds; break;
        default:
            warning("[SessionManager] Unknown action: %s\n", action.to_string());
            return;
        }

        if(cmds == null || cmds.size == 0)
        {
            warning("[SessionManager] No command list for action: %s\n", action.to_string());
            return;
        }

        info("[SessionManager] Performing action: %s\n", action.to_string());

        foreach(string cmd in cmds)
        {
            info("[SessionManager] Checking command: %s\n", cmd);
            if(is_command_available(cmd))
            {
                info("[SessionManager] Command available: %s\n", cmd);
                try {
                    Process.spawn_command_line_async(cmd);
                    info("[SessionManager] Executed: %s\n", cmd);
                    return;
                }
                catch(Error e) {
                    warning("[SessionManager] Command failed: %s\n", e.message);
                }
            }
            else
            {
                info("[SessionManager] Command not available: %s\n", cmd);
            }
        }

        warning("[SessionManager] No valid command found for action: %s\n", action.to_string());
    }

    private static bool is_command_available(string cmd)
    {

        string base_cmd = cmd.split(" ")[0];
        string[] check = {
            "/bin/sh", "-c", "command -v " + base_cmd
        };
        int exit_code;
        try {
            Process.spawn_sync(null, check, null, SpawnFlags.SEARCH_PATH, null, null, null, out exit_code);
            return exit_code == 0;
        }
        catch(Error e) {
            return false;
        }
    }
}
}





