#!/usr/bin/env fish

function __yabai_resolution --description "gets the current horizontal resolution"
  # much faster than system_profiler SPDisplaysDataType | grep Resolution
  echo (screenresolution get 2>&1 | grep -oE 'Display 0: [0-9]+' | grep -Eo '[0-9]+$')
end

__yabai_resolution
