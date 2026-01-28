#!/bin/bash

# Name should match WM_CLASS name for each application (case insensitive)
apps=("brave" "ghostty" "nautilus")

# Icons for each application
icons=("" "" "")

# Launch commands
launch_commands=(
    "brave"
    "ghostty"
    "nautilus"
)

# Colors
color_inactive="#545c7e"  # Gray for inactive apps
color_running="#7aa2f7"   # Blue for running apps
color_focused="#bb9af7"   # Purple for focused app

# Function to convert number to superscript
to_superscript() {
    echo "$1" | sed 'y/0123456789/⁰¹²³⁴⁵⁶⁷⁸⁹/'
}

# Function to count windows for an application
count_windows() {
    local app="$1"
    if [ "${app,,}" = "ghostty" ]; then
        xdotool search --class "${app,,}" 2>/dev/null | wc -l
    else
        wmctrl -l 2>/dev/null | grep -i "${app,,}" | wc -l
    fi
}

cycle_windows() {
    local app="$1"
    local window_ids
    local current_window

    if [ "${app,,}" = "ghostty" ]; then
        window_ids=($(xdotool search --class "${app,,}" 2>/dev/null))
        current_window=$(xdotool getactivewindow 2>/dev/null)
    else
        window_ids=($(wmctrl -l 2>/dev/null | grep -i "${app,,}" | awk '{print $1}'))
        current_window=$(xprop -root _NET_ACTIVE_WINDOW 2>/dev/null | awk -F ' ' '{print $5}' | tr -d ',')
        current_window=$(printf "0x%08x" "$((current_window))" 2>/dev/null)
    fi

    if [ ${#window_ids[@]} -eq 0 ]; then
        return
    fi

    local next_window

    for i in "${!window_ids[@]}"; do
        if [ "${window_ids[$i]}" = "${current_window}" ]; then
            next_window="${window_ids[$(( (i + 1) % ${#window_ids[@]} ))]}"
            break
        fi
    done

    if [ -z "$next_window" ]; then
        next_window="${window_ids[0]}"
    fi

    wmctrl -i -a "$next_window" 2>/dev/null
}

# Function to generate output for running applications
generate_running_app_output() {
    local app="$1"
    local icon="$2"
    local launch_command="$3"
    local focused_class="$4"
    local window_count="$5"

    local output=""
    if [[ "${focused_class,,}" == *"${app,,}"* ]]; then
        output+="%{F$color_focused}"
    else
        output+="%{F$color_running}"
    fi

    if [ "$window_count" -gt 1 ]; then
        local superscript_count=$(to_superscript "$window_count")
        output+="%{A1:$0 cycle_windows ${app,,}:}%{A3:$launch_command &:}$icon$superscript_count%{A}%{A}"
    else
        output+="%{A1:wmctrl -x -a ${app,,} || $launch_command &:}%{A3:$launch_command &:}$icon%{A}%{A}"
    fi

    output+="%{F-}"
    echo "$output"
}

# Check if we're being called to cycle windows
if [ "$1" = "cycle_windows" ]; then
    cycle_windows "$2"
    exit 0
fi

# Get the class of the focused window (suppress errors)
focused_class=$(xdotool getwindowfocus getwindowclassname 2>/dev/null)

output=""
for i in "${!apps[@]}"; do
    app="${apps[$i]}"
    icon="${icons[$i]}"
    launch_command="${launch_commands[$i]}"

    if [ $i -ne 0 ]; then
        output+="  "
    fi

    window_count=$(count_windows "$app")

    if [ "$window_count" -gt 0 ]; then
      output+=$(generate_running_app_output "$app" "$icon" "$launch_command" "$focused_class" "$window_count")
    else
      output+="%{F$color_inactive}%{A1:$launch_command &:}$icon%{A}%{F-}"
    fi
done

echo "$output"
