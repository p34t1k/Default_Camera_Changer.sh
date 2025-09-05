Default Camera Changer

Default Camera Changer is a Bash script for Kali Linux (and other Debian-based systems) that allows you to list all connected cameras (USB, integrated, virtual, OBS/DroidCam, etc.) and easily toggle the default camera. This ensures that applications like browsers, Cheese, OBS, Zoom, or any other camera-using software automatically use your selected camera, even if they do not provide an option to change it.

Features

Lists all connected cameras with friendly names and type (USB / Virtual).

Shows which camera is currently set as the system default (/dev/video0).

Allows switching the default camera to any connected camera.

Keeps a backup of the original default camera for easy restoration.

Handles integrated, USB, and virtual cameras like DroidCam or OBS Virtual Camera.

Can be run from terminal or integrated into KDE application launcher.

Requirements

Kali Linux 2025 or other Debian-based distributions.

v4l-utils package (v4l2-ctl) for camera detection.

sudo privileges for modifying /dev/video0 symlink.

Install dependencies:

sudo apt update
sudo apt install -y v4l-utils

Installation

Clone the repository:

git clone https://github.com/yourusername/default-camera-changer.git


Navigate to the script folder:

cd default-camera-changer


Make the script executable:

chmod +x Default_camera_changer.sh

Usage

Run the script from terminal:

./Default_camera_changer.sh


You will see:

A list of all connected cameras with their device paths and type.

The current default camera (/dev/video0).

Options to:

Change default camera

Restore original default camera

Exit

Follow the prompts to switch the default camera. After switching, apps will use the new camera as default.

💡 Tip: Some apps or browsers may cache the old camera. Restart them after changing the default.

Optional: Integrate with KDE Menu

Create a .desktop file in ~/.local/share/applications/default-camera-changer.desktop:

[Desktop Entry]
Name=Default Camera Changer
Comment=Switch default camera for apps and browsers
Exec=/full/path/to/Default_camera_changer.sh
Icon=webcam
Terminal=true
Type=Application
Categories=Utility;Settings;
StartupNotify=true


Refresh KDE launcher:

kbuildsycoca5


Search for Default Camera Changer in the application menu and run it.

Restore Original Default Camera

The script automatically creates a backup of the original /dev/video0 as /dev/video0.bak. To restore:

Run the script.

Choose Restore original default camera from the menu.

Notes

The script works by creating a symlink from the selected camera to /dev/video0.

Only one entry per physical/virtual camera is shown, preventing duplicate listings.

Requires sudo because modifying /dev/video0 needs root permissions.

Contributing

Contributions are welcome! You can improve this project by:

Adding GUI support using kdialog or other tools.

Automatically detecting OBS/DroidCam virtual cameras with more descriptive names.

Adding color-coded or more user-friendly menus.
