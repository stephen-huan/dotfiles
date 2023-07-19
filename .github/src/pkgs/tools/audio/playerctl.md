# playerctl

- [arch wiki - MPRIS](https://wiki.archlinux.org/title/MPRIS)
- [freedesktop - MPRIS D-Bus Interface Specification](https://specifications.freedesktop.org/mpris-spec/latest/)
- Media Player Remote Interfacing Specification (MPRIS)
- freedesktop specification for music player control
- install [playerctl](https://github.com/altdesktop/playerctl),
  front-end client to control implementing players

```shell
pacman -S playerctl
```

- start daemon to track most player with most
  recent activity, e.g. put in `~/.xprofile`

```shell
playerctld daemon
```

- `XF86Audio` audio control keys are already bound in default i3 config

```config
# Use pactl to adjust volume in PulseAudio.
set $refresh_i3status killall -SIGUSR1 i3status
bindsym XF86AudioRaiseVolume exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@     +10% && $refresh_i3status
bindsym XF86AudioLowerVolume exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@     -10% && $refresh_i3status
bindsym XF86AudioMute        exec --no-startup-id pactl set-sink-mute   @DEFAULT_SINK@   toggle && $refresh_i3status
bindsym XF86AudioMicMute     exec --no-startup-id pactl set-source-mute @DEFAULT_SOURCE@ toggle && $refresh_i3status
```

- bind `XF86Audio` player control keys to corresponding `playerctl` commands

```config
# my headphones alternate between play/pause while my keyboard just has play
# so to keep it consistent, force both to toggle
bindsym XF86AudioPlay    exec playerctl play-pause
bindsym XF86AudioPause   exec playerctl play-pause
bindsym XF86AudioStop    exec playerctl stop
bindsym XF86AudioPrev    exec playerctl previous
bindsym XF86AudioNext    exec playerctl next
bindsym XF86AudioForward exec playerctl position 1+
bindsym XF86AudioRewind  exec playerctl position 1-
```
