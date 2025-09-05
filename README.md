🎥 Default Camera Changer








Easily switch your default camera on Kali Linux / Debian-based systems — works with USB, integrated, and virtual cameras like DroidCam or OBS Virtual Camera.

✨ Features
Feature	Description
✅ List Cameras	Detects all connected cameras with friendly names and type (USB / Virtual).
✅ Show Default	Shows the current default camera (/dev/video0).
✅ Change Default	Set any camera as the system default.
✅ Restore	Restore original default camera safely.
✅ Virtual Cameras	Works with OBS, DroidCam, and other virtual cams.
✅ KDE Integration	Can be added to KDE launcher for quick access.
🖥 Screenshots / Demo


Preview of connected cameras and options menu.

You can also add a GIF for live demo:

⚡ Installation
# Clone repository
git clone https://github.com/yourusername/default-camera-changer.git

# Navigate into folder
cd default-camera-changer

# Make script executable
chmod +x Default_camera_changer.sh

🚀 Usage

Run the script:

./Default_camera_changer.sh


Menu options:

<details> <summary>Click to expand</summary>

Change default camera – select a camera to make it /dev/video0.

Restore original default camera – revert backup /dev/video0.bak.

Exit – close the script without changes.

</details>

💡 Tip: Restart apps/browsers after changing the camera to ensure they pick up the new default.

🛠 KDE Integration

Create .desktop file in ~/.local/share/applications/default-camera-changer.desktop:

[Desktop Entry]
Name=Default Camera Changer
Comment=Switch default camera for apps and browsers
Exec=/full/path/to/Default_camera_changer.sh
Icon=webcam
Terminal=true
Type=Application
Categories=Utility;Settings;
StartupNotify=true


Refresh KDE menu:

kbuildsycoca5


Search Default Camera Changer in application launcher and run it.

🔄 Restore Original Default Camera

The script keeps a backup of /dev/video0 as /dev/video0.bak. To restore:

# Run the script
./Default_camera_changer.sh

# Select "Restore original default camera" from menu

💡 How It Works

Detects all /dev/video* devices.

Filters duplicate entries to show one entry per camera.

Uses a symlink from /dev/video0 → selected camera.

Works with USB, integrated, and virtual cameras.

📈 Roadmap / Future Improvements
<details> <summary>Click to expand</summary>

Add GUI with kdialog for native KDE look.

Auto-detect OBS/DroidCam virtual cameras with proper names.

Color-coded terminal menu for USB vs virtual cameras.

Add versioning badges and live build/test indicators.

</details>
