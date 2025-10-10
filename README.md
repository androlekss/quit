# Quit
A Quit docklet for [Plank Reloaded](https://github.com/zquestz/plank-reloaded).

## Features
Lightweight Plank docklet for Linux desktop environments that provides quick access to session actions: 
Shut down, Reboot, and Log out. 
Supports Cinnamon, GNOME, MATE, XFCE, KDE, and LXDE via adaptive command detection.

## Dependencies

- vala
- gtk+-3.0
- plank-reloaded
- glib-2.0
- json-glib-1.0

## Installation

### Method 1: Build from source

```bash
# Clone the repository
git clone https://github.com/androlekss/quit.git
cd quit

# Build and install
meson setup --prefix=/usr build
meson compile -C build
sudo meson install -C build
```
## Setup

After installation, open the Plank Reloaded settings, navigate to "Docklets", and drag and drop Quit onto your dock.

## Usage

- Left-click on the docklet icon opens a dialog with three action buttons

- Integrated with Plank Reloaded via DockletItem

- Automatically detects the desktop environment using XDG_CURRENT_DESKTOP

- Displays confirmation dialogs before executing system-level actions

## What’s new in 0.1.1

- Added a setting to control whether confirmation dialogs are shown before performing actions.

## License

This project is licensed under the GNU General Public License v3.0 (GPL-3.0). See the LICENSE file for details.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
