# ibus

- [arch wiki - input method](https://wiki.archlinux.org/title/Input_method)
- [arch wiki - ibus](https://wiki.archlinux.org/title/IBus)
- install ibus

```shell
pacman -S ibus
```

- run at startup, set environmental variables, put in `~/.xprofile`

```shell
ibus-daemon --daemonize --replace --xim

export GTK_IM_MODULE=ibus
export QT_IM_MODULE=ibus
export XMODIFIERS=@im=ibus
```

- no clue what `--xim` does, but if left out doesn't work in alacritty, e.g.
- no clue what the environmental variables do,
  but if left out doesn't work in alacritty, e.g.
- can put variables in `/etc/environment` but why
  would you want to? need to edit with sudo, etc.
- edit config, add input methods, etc.

```shell
ibus-setup
```

- can also right-click icon if it's running
- change activation shortcut to whatever you like, etc.

# mozc (japanese ime)

- see [mozc](/pkgs/tools/inputmethods/ibus-engines/ibus-mozc.md)

## ibus overwrites xkb

- using [xmodmap/xkb](/pkgs/servers/x11/xorg.md#xkb) to make changes
- ibus randomly clears these when switching back and forth
- "IBus Preferences" -> "Advanced" -> "Keyboard Layout" ->
  check "Use system keyboard layout"
