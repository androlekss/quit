
namespace Quit {
public class QuitDialog : Gtk.Dialog {

    public QuitDialog(Gtk.Window? parent) {
        // Створюємо модальний діалог
        this.set_transient_for(parent);
        this.set_modal(true);
        this.set_title(_("Session Control"));
        this.set_default_size(300, 100);
        this.set_border_width(12);

        // Додаємо кнопки
        this.add_button(_("Shut down"), Gtk.ResponseType.YES);
        this.add_button(_("Reboot"), Gtk.ResponseType.APPLY);
        this.add_button(_("Log out"), Gtk.ResponseType.OK);
        this.add_button(_("Cancel"), Gtk.ResponseType.CANCEL);

        this.response.connect((response_id) => {
            this.destroy();

            switch (response_id) {
                case Gtk.ResponseType.YES:
                    SessionManager.perform_with_confirmation(parent, SessionManager.Action.SHUTDOWN);
                    break;
                case Gtk.ResponseType.APPLY:
                    SessionManager.perform_with_confirmation(parent, SessionManager.Action.REBOOT);
                    break;
                case Gtk.ResponseType.OK:
                    SessionManager.perform_with_confirmation(parent, SessionManager.Action.LOGOUT);
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
