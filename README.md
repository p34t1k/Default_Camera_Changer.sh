
Default Camera Changer
A Bash script for Kali Linux and Debian-based systems that allows you to easily manage and switch between connected cameras, making any camera the system default (/dev/video0).

Features
Lists all connected cameras with friendly names and types (USB/Virtual)

Shows the current default camera

Allows switching the default camera to any connected camera

Maintains a backup of the original default camera for easy restoration

Handles integrated, USB, and virtual cameras (OBS, DroidCam, etc.)

Terminal-based interface with simple menu options

Requirements
Kali Linux 2025 or other Debian-based distributions

v4l-utils package (for v4l2-ctl command)

sudo privileges for modifying device symlinks

Installation
Install dependencies:

bash
sudo apt update && sudo apt install -y v4l-utils
Make the script executable:

bash
chmod +x Default_camera_changer.sh
Usage
Run the script:

bash
./Default_camera_changer.sh
You'll see:

A list of all connected cameras with device paths and types

The current default camera

Menu options to change or restore the default camera

Menu Options
Change default camera - Select from detected cameras

Restore original default camera - Revert to the original setup

Exit - Quit the program

Integration with KDE Menu
Create a desktop file at ~/.local/share/applications/default-camera-changer.desktop:

ini
[Desktop Entry]
Name=Default Camera Changer
Comment=Switch default camera for apps and browsers
Exec=/path/to/Default_camera_changer.sh
Icon=webcam
Terminal=true
Type=Application
Categories=Utility;Settings;
StartupNotify=true
Refresh the application menu:

bash
kbuildsycoca5
How It Works
The script creates a symbolic link from your selected camera device to /dev/video0, which is the default camera path that most applications use. It automatically backs up the original /dev/video0 device as /dev/video0.bak for easy restoration.

Notes
Some applications may need to be restarted to recognize the new default camera

Requires sudo privileges to modify device links

Only shows one entry per camera type to avoid duplicates

Virtual cameras (OBS, DroidCam) are properly detected and handled

Troubleshooting
If you encounter issues:

Ensure v4l-utils is installed

Check that your cameras are properly connected and detected by the system

Verify you have sudo privileges

Contributing
Contributions are welcome! Potential improvements include:

Adding GUI support (kdialog, zenity)

Enhanced virtual camera detection

Color-coded menu interface

Automatic application restart after changes
