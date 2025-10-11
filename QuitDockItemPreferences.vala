using Plank;

namespace Quit {

public class QuitDockItemPreferences : DockItemPreferences
{
    public bool ConfirmDialogs { get; set; default = true; }
    public string CustomIcon { get; set; default = ""; }

    public Quit.QuitDockItemPreferences.with_file(GLib.File file) {
        base.with_file(file);
    }

    protected override void reset_properties () {
        CustomIcon = "";
        ConfirmDialogs = true;
    }

}
}
