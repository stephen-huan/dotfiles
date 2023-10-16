# picom

- [arch wiki - picom](https://wiki.archlinux.org/title/picom)
- install picom

```shell
pacman -S picom
```

- edit config at `~/.config/picom/picom.conf`
- use opengl

```toml
# use OpenGL as the rendering backend
backend = "glx";
```

- screen tears without fading, default fading animation is too slow

```toml
# without fading, some screen tears
fading = true;
# speed up default fade speed
fade-delta = 3;
```

- transparency for aesthetic

```toml
# make inactive windows slightly transparent
inactive-opacity = 0.9;
```

- exclude [i3lock](/pkgs/misc/screensavers/xss-lock.md) from
  transparency to prevent desktop leaking and exclude floating windows

```toml
opacity-rule = [
    # exclude screensaver (i3lock) window
    "100:class_g = 'i3lock'",
    # exclude floating windows
    "100:I3_FLOATING_WINDOW@:c",
];
```
