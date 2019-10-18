#!/bin/bash

# kills some application every few minutes

read -r state<~/Programs/bin/zap.state

if [ "$state" = "true" ]; then
  ~/Programs/bin/zapkill &
else
  pkill -f zapkill
fi

~/Programs/bin/toggle t c
~/Programs/bin/toggle_bool $state > ~/Programs/bin/zap.state
