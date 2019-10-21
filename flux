#!/bin/bash

# toggles the state of flux
# TODO: until sunrise, etc.
state=~/Programs/bin/flux.state

if pgrep -q Flux; then
  # disable flux for a certain amount of time
  ~/Programs/bin/fluxkill &

  echo "Disabled f.lux for an hour"
  echo true > $state
else
  # run flux and disable the disabling
  osascript -e 'tell app "Flux" to run'

  pkill -f fluxkill

  echo "Re-enabling f.lux"
  echo false > $state
fi

~/Programs/bin/toggle
