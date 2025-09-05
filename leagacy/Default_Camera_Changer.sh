#!/bin/bash
# Default_camera_changer - Smart version (single entry per camera)
# Kali Linux 2025 / Debian-based

set -e

# Check dependencies
if ! command -v v4l2-ctl &>/dev/null; then
    echo "v4l2-ctl not found. Installing v4l-utils..."
    sudo apt update && sudo apt install -y v4l-utils
fi

BACKUP="/dev/video0.bak"

echo "===== Default Camera Changer ====="
echo

# Detect video devices and group duplicates
declare -A CAMERAS
for DEV in /dev/video*; do
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
    if [ -z "${CAMERAS[$NAME]}" ]; then
        CAMERAS["$NAME"]="$DEV|$TYPE"
    fi
done

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
DEFAULT="/dev/video0"
if [ -L "$DEFAULT" ]; then
    CURRENT=$(readlink -f "$DEFAULT")
    echo
    echo "Current default camera: $DEFAULT -> $CURRENT"
fi

echo
echo "Options:"
echo "0) Change default camera"
echo "1) Restore original default camera"
echo "2) Exit"
read -p "Enter choice: " OPTION

case $OPTION in
    0)
        read -p "Enter the number of the camera you want to set as default: " CHOICE
        if ! [[ "$CHOICE" =~ ^[0-9]+$ ]] || [ -z "${INDEX_MAP[$CHOICE]}" ]; then
            echo "Invalid choice!"
            exit 1
        fi

        SELECTED="${INDEX_MAP[$CHOICE]}"
        echo "You selected $SELECTED"

        # Backup current default camera if not already backed up
        if [ ! -e "$BACKUP" ] && [ -e "/dev/video0" ]; then
            sudo mv /dev/video0 "$BACKUP"
        fi

        # Remove existing /dev/video0
        if [ -e "/dev/video0" ]; then
            sudo rm /dev/video0
        fi

        # Create symlink
        sudo ln -s "$SELECTED" /dev/video0
        echo "Default camera changed successfully to $SELECTED!"
        ;;
    1)
        if [ -e "$BACKUP" ]; then
            if [ -e "/dev/video0" ]; then
                sudo rm /dev/video0
            fi
            sudo mv "$BACKUP" /dev/video0
            echo "Original default camera restored!"
        else
            echo "No backup found to restore."
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
