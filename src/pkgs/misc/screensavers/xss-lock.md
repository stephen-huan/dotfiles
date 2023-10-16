# screensaver (xss-lock/i3lock)

- [arch wiki - session lock](https://wiki.archlinux.org/title/Session_lock)
- [arch wiki - power
  management](https://wiki.archlinux.org/title/Power_management#xss-lock)
- [arch wiki - display power
  management signaling](https://wiki.archlinux.org/title/DPMS)
- install xss-lock

```shell
pacman -S xss-lock
```

- set to use `i3lock` as a locker

```shell
xss-lock --transfer-sleep-lock -- i3lock --nofork --image=$HOME/Pictures/config/screensaver &
```

- for `i3lock`, `--nofork` prevents multiple instances and set background image
- manually trigger lock

```shell
loginctl lock-session
```

## picom transparency leaks screen after lock

- picom set to make inactive windows slightly
  transparent (`inactive-opacity = 0.9;`)
- this causes `i3lock` to also become transparent, leaking your desktop screen
- see [reddit - Picom make i3lock opaque](https://www.reddit.com/r/archlinux/comments/q4fo26/picom_make_i3lock_opaque/)
- edit `~/.config/picom/picom.conf`, add

```config
opacity-rule = [ "100:class_g = 'i3lock'" ];
```

### using picom-trans?

- `man picom`

```man
       --opacity-rule OPACITY:'CONDITION'
           Specify a list of opacity rules, in the format PERCENT:PATTERN, like
           50:name *= "Firefox". picom-trans is recommended over this.
```

- okay, `man picom-trans`, should be ran like

```shell
picom-trans -n "i3lock" 100
```

- however, this has to happen _after_ the window exists
- hard to do, since `i3lock` is should be ran with `--nofork`

### archive

- below simply doesn't work, works when running `i3lock` from a terminal
  but not when actually triggered (by sleep or with `loginctl lock-session`)
- follow the instructions for slock in the picom article:
  [arch wiki - picom](https://wiki.archlinux.org/title/picom#slock)
- install xwininfo

```shell
sudo pacman -S xorg-xwininfo
```

- run the command and click to get the window id

```shell
xwininfo & i3lock --nofork --image=$HOME/Pictures/config/screensaver
```

- use the discovered id to have picom exclude the window

```shell
picom --daemon --focus-exclude 'id = 0x4600007'
```
