#!/bin/sh

# Auto Display Scale Script for XFCE4
# Adjusts scaling based on detected resolution

# Get primary display resolution
RESOLUTION=$(xrandr | grep ' connected primary' | grep -oP '\d+x\d+' | head -1)

# Fallback: if no primary, get first connected display
if [ -z "$RESOLUTION" ]; then
    RESOLUTION=$(xrandr | grep ' connected' | grep -oP '\d+x\d+' | head -1)
fi

WIDTH=$(echo "$RESOLUTION" | cut -d'x' -f1)
HEIGHT=$(echo "$RESOLUTION" | cut -d'x' -f2)

echo "Detected resolution: ${WIDTH}x${HEIGHT}"

# Define scale based on resolution
case "${WIDTH}x${HEIGHT}" in
    "1920x1080")
        SCALE=1
        ;;
    "2560x1440")
        SCALE=1.25
        ;;
    "2880x1800")
        SCALE=1.25
        ;;
    "3840x2160")
        SCALE=1.5
        ;;
    "3200x1800")
        SCALE=1.5
        ;;
    *)
        # Auto-calculate based on DPI (assuming 91 DPI as baseline)
        if [ "$WIDTH" -ge 3840 ]; then
            SCALE=2
        elif [ "$WIDTH" -ge 2560 ]; then
            SCALE=1.25
        else
            SCALE=1
        fi
        ;;
esac

echo "Applying scale: ${SCALE}x"

# Method 1: XFCE Window Scaling (integer only, use for 1x or 2x)
INT_SCALE=$(printf "%.0f" "$SCALE")
xfconf-query -c xsettings -p /Gdk/WindowScalingFactor -s "$INT_SCALE" 2>/dev/null

# Method 2: Xft DPI scaling (works for fractional scaling)
DPI=$(echo "$SCALE * 91" | bc)
xfconf-query -c xsettings -p /Xft/DPI -s "$DPI"

# Method 3: xrandr scaling (for non-HiDPI aware apps)
# Only apply if fractional scaling is needed
if [ "$SCALE" != "1" ] && [ "$SCALE" != "2" ]; then
    XRANDR_SCALE=$(echo "scale=4; 1/$SCALE" | bc)
    PRIMARY=$(xrandr | grep ' connected primary' | awk '{print $1}')
    if [ -z "$PRIMARY" ]; then
        PRIMARY=$(xrandr | grep ' connected' | awk '{print $1}' | head -1)
    fi
    xrandr --output "$PRIMARY" --scale "${XRANDR_SCALE}x${XRANDR_SCALE}"
fi

# Update cursor size proportionally
CURSOR_SIZE=$(echo "$SCALE * 24" | bc | cut -d'.' -f1)
xfconf-query -c xsettings -p /Gtk/CursorThemeSize -s "$CURSOR_SIZE"

# Update panel size (optional)
# xfconf-query -c xfce4-panel -p /panels/panel-1/size -s $(echo "$SCALE * 28" | bc | cut -d'.' -f1)

echo "Display scaling applied successfully!"
