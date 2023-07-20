# alacritty

I used to use [kitty](https://sw.kovidgoyal.net/kitty/) and there
really wasn't anything wrong with it. The reason I switched was mainly
philosophical, kitty just did too much like the whole integrated tab / window
splitting and so on. Terminal emulators should be relatively simple and
leave the complexity to other programs (your window manager, tmux, etc.).
[Alacritty](https://github.com/alacritty/alacritty) doesn't too much, but
has all the features I've come to expect from a terminal emulator. Also, the
vim mode is sometimes useful if you really don't want to use the mouse.

See [features.md](https://github.com/alacritty/alacritty/blob/master/docs/features.md)
for an overview of supported features.

## Bugs

### Keybindings Like "$" in Vim Mode Don't Work

The default keybindings that involve shift and non-letter keys don't
work. This is an X-specific issue caused by a bug in the upstream
library [winit](https://github.com/rust-windowing/winit)'s handling
of virtual keycodes. See

- [github - WindowEvent missing virtual_keycode while DeviceEvent contains
  it on Linux](https://github.com/rust-windowing/winit/issues/1443)
- [github - WindowEvent missing virtual keycode on Linux](https://github.com/alacritty/alacritty/issues/3460)
- [github - Keybinding doesn't work (Shift + Key4)](https://github.com/alacritty/alacritty/issues/3460)

To fix, use the scancodes instead of the key
names. Edit `~/.config/alacritty/alacritty.yml`:

```yaml
key_bindings:
  # specify scancode to get around invalid virtual keycode provided by winit
  - { key: 5, mods: Shift, mode: Vi|~Search, action: Last }
  - { key: 7, mods: Shift, mode: Vi|~Search, action: FirstOccupied }
  - { key: 6, mods: Shift, mode: Vi|~Search, action: Bracket }
  - { key: 53, mods: Shift, mode: Vi|~Search, action: SearchBackward }
```

The scancodes can be found with

```shell
sudo showkey --keycodes
```

There is theoretically a difference between interpreted
keycodes and raw scancodes. See [arch wiki - keyboard
input](https://wiki.archlinux.org/title/Keyboard_input) for the
details. However, the keycodes shown by `showkey --keycodes` seem
to be the same as the ones shown by `showkey --scancodes`, both of
which are different than the keycodes or keysyms shown by `xev`.
For example, if I press the letter "a" on my keyboard:

- `showkey --scancodes`: 0x1e (30)
- `showkey --scancodes`: 0x9e (158) is also shown
- `showkey --keycodes`: 30
- `xev` keycode field: 38
- `xev` keysym field: 0x61 (97), ASCII value for "a"

For Alacritty, you should be using the (decimal) keycode in common between
`showkey --scancodes` and `showkey --keycodes`. It's possible to get these
from `showkey --scancodes` but you have to convert the hex to decimal, and
when I press a key it seems to alternate between two different values.
`showkey --keycodes` is easier to use and works.

### Cursor Spins on Empty Background

This is especially applicable to i3wm users. The problem is that if the mouse
cursor is on the desktop background (not hovering over an active window), then
it's stuck in the "spinning" or "waiting" state. For why this happens, see:

- [arch wiki - i3](https://wiki.archlinux.org/title/I3#Mouse_cursor_remains_in_waiting_mode)
- [i3wm user guide](https://i3wm.org/docs/userguide.html#exec)
- [freedesktop.org - startup-notification-spec](https://www.freedesktop.org/wiki/Specifications/startup-notification-spec/)

The summary is that the freedesktop startup-notification-spec provides a
mechanism by which applications upon launching can signal through X that
they have began started up, and finished starting up. This allows your
cursor to appear "busy" when the application is starting up, and turn back
to normal once the application opens. This also allows i3 to guarantee that
the application's window is put where it was originally launched from.
However, if i3 launches an application with `exec` and expects startup
notifications when the application does not send them, then i3 assumes the
application is taking a long time to startup, timing out after 60 seconds,
causing the cursor to appear busy for 60 seconds. This can be fixed by
starting the offending application with `exec --no-startup-id`.

Alacritty does not support startup notification events,
causing the busy cursor. The default i3 configuration
launches a terminal with the following line:

```config
bindsym Mod1+Return exec i3-sensible-terminal
```

`i3-sensible-terminal`, as the name implies, looks for a sensible terminal
in the user's path and since the application is launched with `exec` and
not `exec --no-startup-id`, the cursor will be busy for 60 seconds after
launching an alacritty window. See:

- [github - Alacritty causing 1-2 mins of busy
  cursor on i3 desktop, and extreme i3 performance
  issues](https://github.com/alacritty/alacritty/issues/868)
- [github - Alacritty causing 1-2 mins of busy cursor on i3 desktop
  (re-opening #868)](https://github.com/alacritty/alacritty/issues/6097)

The first issue is a nearly 5 year old issue, and the second issue was
re-filed by me because new evidence came out that it was in fact Alacritty's
noncompliance to startup-notification-spec that causes the issue. Alacritty
maintainers refuse to fix this since the issue is (mostly) cosmetic.

Note that the cursor can be fixed immediately by restarting i3.

```shell
i3 restart
```

### Improper Spacing on Certain Characters

The characters "★" (Unicode codepoint `0x2605`) and "☆" (`0x2606`)
are displayed improperly for "most" monospace fonts. This is because
the Unicode specification considers them single-width characters but
they but are rendered as double-width, causing them to clip into
their neighbors. See the issue I filed, [alacritty/alacritty/#6144](https://github.com/alacritty/alacritty/issues/6144). I've tested:

- Noto Sans Mono (`noto-fonts`)
- IPAGothic (`otf-ipafont`)
- Source Code Pro (`adobe-source-code-pro-fonts`)

The fonts which I've found to work has been:

- DejaVu Sans Mono (`ttf-dejavu`)

It's a bit misleading to call this a "bug" since it's pretty much impossible to
determine the _display_ width of Unicode characters (it's font specific). That
being said, "GUI" programs like Firefox, Signal, and Emacs (but not gvim) seem
to have figured it out, so there's no real reason a terminal emulator couldn't.
