#!/usr/bin/env fish

function __yabai_smart --description "intelligently changes the borders"
    set ids (yabai -m query --spaces --space | jq '.windows | .[]')
    # only count actual windows
    set count 0
    for id in $ids
        set role (yabai -m query --windows --window $id | jq -r ".subrole")
        if test "$role" = "AXStandardWindow"
            set count (math $count + 1)
        end
    end

    if test $count -eq 1
        # turn off borders, turn off gaps and padding
        yabai -m config window_border off
        yabai -m space --padding abs:0:0:0:0
        yabai -m space --gap abs:0
    else if test $count -ge 2
        # turn on border for each window, turn on gaps and padding
        yabai -m config window_border on
        yabai -m space --padding abs:20:20:20:20
        yabai -m space --gap abs:10
    end
end

__yabai_smart
