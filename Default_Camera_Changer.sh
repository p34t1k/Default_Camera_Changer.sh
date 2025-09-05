#!/bin/bash
# Default_camera_changer - Smart version (single entry per camera)
# Kali Linux 2025 / Debian-based
# Improved version with better UX and error handling

set -euo pipefail

# Check dependencies
if ! command -v v4l2-ctl &>/dev/null; then
    echo "v4l2-ctl not found. Installing v4l-utils..."
    sudo apt update && sudo apt install -y v4l-utils
fi

BACKUP="/dev/video0.bak"
DEFAULT="/dev/video0"

echo "===== Default Camera Changer ====="
echo

# Detect video devices and group duplicates
declare -A CAMERAS
for DEV in /dev/video*; do
    [ ! -e "$DEV" ] && continue
    # Get card name
    NAME=$(v4l2-ctl -d "$DEV" --info 2>/dev/null | grep "Card type" | sed 's/Card type: //')
    [ -z "$NAME" ] && NAME="Unknown / Virtual"

    # Detect USB or virtual
    if udevadm info -q property -n "$DEV" 2>/dev/null | grep -q "ID_USB_DRIVER"; then
        TYPE="USB"
    else
        TYPE="Virtual"
    fi

    # Only add first occurrence of each card name
    if [ -z "${CAMERAS[$NAME]+x}" ]; then
        CAMERAS["$NAME"]="$DEV|$TYPE"
    fi
done

# Ensure at least one camera found
if [ "${#CAMERAS[@]}" -eq 0 ]; then
    echo "No cameras detected!"
    exit 1
fi

# List cameras
INDEX=0
declare -A INDEX_MAP
echo "Connected cameras:"
for NAME in "${!CAMERAS[@]}"; do
    DEV_TYPE="${CAMERAS[$NAME]}"
    DEV="${DEV_TYPE%%|*}"
    TYPE="${DEV_TYPE##*|}"
    echo "$INDEX) $DEV - $NAME ($TYPE)"
    INDEX_MAP[$INDEX]="$DEV"
    INDEX=$((INDEX+1))
done

# Show current default camera
if [ -L "$DEFAULT" ]; then
    CURRENT=$(readlink -f "$DEFAULT")
    echo
    echo "Current default camera: $DEFAULT -> $CURRENT"
elif [ -e "$DEFAULT" ]; then
    echo
    echo "Current default camera: $DEFAULT"
else
    echo
    echo "No /dev/video0 found."
fi

echo
echo "Options:"
echo "0) Change default camera"
echo "1) Restore original default camera"
echo "2) Exit"
read -rp "Enter choice: " OPTION

case $OPTION in
    0)
        read -rp "Enter the number of the camera you want to set as default: " CHOICE
        if ! [[ "$CHOICE" =~ ^[0-9]+$ ]] || [ -z "${INDEX_MAP[$CHOICE]+x}" ]; then
            echo "Invalid choice!"
            exit 1
        fi

        SELECTED="${INDEX_MAP[$CHOICE]}"
        echo "You selected $SELECTED"

        # Backup current default camera if not already backed up
        if [ ! -e "$BACKUP" ] && [ -e "$DEFAULT" ]; then
            sudo mv "$DEFAULT" "$BACKUP"
        fi

        # Remove existing /dev/video0 if exists
        if [ -e "$DEFAULT" ] || [ -L "$DEFAULT" ]; then
            sudo rm -f "$DEFAULT"
        fi

        # Create symlink
        sudo ln -s "$SELECTED" "$DEFAULT"
        echo "✅ Default camera changed successfully to $SELECTED!"
        ;;
    1)
        if [ -e "$BACKUP" ]; then
            [ -e "$DEFAULT" ] && sudo rm -f "$DEFAULT"
            sudo mv "$BACKUP" "$DEFAULT"
            echo "✅ Original default camera restored!"
        else
            echo "⚠️ No backup found to restore."
        fi
        ;;
    2)
        echo "Exiting."
        exit 0
        ;;
    *)
        echo "Invalid option!"
        exit 1
        ;;
esac
