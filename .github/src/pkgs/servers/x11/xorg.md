# xorg

## xkb

- [arch wiki - xmodmap](https://wiki.archlinux.org/title/xmodmap)
- outdated, use xkb instead
- still useful for viewing what modifiers are set to, run with `xmodmap`

```shell
pacman -S xorg-xmodmap
```

- xev, keyboard event viewer, also useful tool, run with `xev`

```shell
pacman -S xorg-xev
```

- [arch wiki - X keyboard extension](https://wiki.archlinux.org/title/X_keyboard_extension)
- install, comes as dependency of `xorg-server`, probably already have it

```shell
pacman -S xorg-xkbcomp
```

- complicated as hell, can't say too much about this
- if you screw up, can make keyboard unusable, first store default config

```shell
xkbcomp $DISPLAY output.xkb
```

- can reset with

```shell
setxkbmap -layout us
```

- once you make custom keymap at `~/.Xkeymap`, put in `~/.xprofile` at startup:

```shell
test -f ~/.Xkeymap && xkbcomp ~/.Xkeymap $DISPLAY
```

### Super_R as mod3

- use case: [qmk](/pkgs/tools/misc/qmk.md)
  ["hyper"](https://docs.qmk.fm/#/mod_tap) (not in the linux
  modifier sense) is `ctrl_L + shift_L + alt_L + super_L`
- use this as [i3](/pkgs/applications/window-managers/i3.md) mod,
  need secondary modifier that can't be `ctrl/shift/alt/super`
- use `super_R` as unused `mod3` to distinguish
- comment out (not necessary, no clue what this does)

```config
    interpret Super_R+AnyOf(all) {
        virtualModifier= Super;
        action= SetMods(modifiers=modMapMods,clearLocks);
    };
```

- change `Super` to `Mod3` here

```config
    interpret Super_R+AnyOfOrNone(all) {
        action= SetMods(modifiers=Super,clearLocks);
    };
```

- change `Mod4` to `Mod3` here

```config
    modifier_map Mod4 { <RWIN> };
```

- n.b.: I no longer use this, it's simpler to make `hyper`
  `shift_L + alt_L + super_L` (still unlikely to conflict with
  other keybindings) and use `ctrl` as a secondary modifier
