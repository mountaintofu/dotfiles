#!/bin/sh

# Experimental Auto Display Scaling Script for XFCE4, but Wayland!
# Adjusts scaling based on detected resolution

# Get display resolution using xdpyinfo (replaces xrandr)
RESOLUTION=$(xdpyinfo 2>/dev/null | grep 'dimensions:' | awk '{print $2}')

# Fallback: use xwininfo on root window
if [ -z "$RESOLUTION" ]; then
    WIDTH=$(xwininfo -root 2>/dev/null | grep 'Width:' | awk '{print $2}')
    HEIGHT=$(xwininfo -root 2>/dev/null | grep 'Height:' | awk '{print $2}')
    RESOLUTION="${WIDTH}x${HEIGHT}"
fi

if [ -z "$RESOLUTION" ] || [ "$RESOLUTION" = "x" ]; then
    echo "Error: Could not detect resolution"
    exit 1
fi

WIDTH=$(echo "$RESOLUTION" | cut -d'x' -f1)
HEIGHT=$(echo "$RESOLUTION" | cut -d'x' -f2)

echo "Detected resolution: ${WIDTH}x${HEIGHT}"

# Define scale and DPI based on resolution
# Pre-calculated DPI values (base DPI: 91)
case "${WIDTH}x${HEIGHT}" in
    "1920x1080")
        SCALE=1
        DPI=91
        CURSOR_SIZE=24
        ;;
    "2560x1440")
        SCALE=1.25
        DPI=114
        CURSOR_SIZE=30
        ;;
    "2880x1800")
        SCALE=1.25
        DPI=114
        CURSOR_SIZE=30
        ;;
    "3840x2160")
        SCALE=1.5
        DPI=137
        CURSOR_SIZE=36
        ;;
    "3200x1800")
        SCALE=1.5
        DPI=137
        CURSOR_SIZE=36
        ;;
    *)
        # Auto-calculate based on width
        if [ "$WIDTH" -ge 3840 ]; then
            SCALE=2
            DPI=182
            CURSOR_SIZE=48
        elif [ "$WIDTH" -ge 2560 ]; then
            SCALE=1.25
            DPI=114
            CURSOR_SIZE=30
        else
            SCALE=1
            DPI=91
            CURSOR_SIZE=24
        fi
        ;;
esac

echo "Applying scale: ${SCALE}x (DPI: ${DPI})"

# XFCE Window Scaling (integer only, use for 1x or 2x)
INT_SCALE=${SCALE%%.*}
[ "$INT_SCALE" -lt 1 ] && INT_SCALE=1
xfconf-query -c xsettings -p /Gdk/WindowScalingFactor -s "$INT_SCALE" 2>/dev/null

# Xft DPI scaling (works for fractional scaling)
xfconf-query -c xsettings -p /Xft/DPI -s "$DPI" 2>/dev/null

# Update cursor size proportionally
xfconf-query -c xsettings -p /Gtk/CursorThemeSize -s "$CURSOR_SIZE" 2>/dev/null

# Update panel size (optional)
# PANEL_SIZE=$((SCALE * 28))  # Only works with integer scale
# xfconf-query -c xfce4-panel -p /panels/panel-1/size -s "$PANEL_SIZE"

echo "Display scaling applied successfully!"