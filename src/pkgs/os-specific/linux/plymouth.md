# plymouth

[arch wiki - plymouth](https://wiki.archlinux.org/title/Plymouth)

- install plymouth (recommended to use development version, but unstable)

```shell
paru -S plymouth
```

- add plymouth hook to `/etc/mkinitcpio.conf`
  > HOOKS=(base udev autodetect **keyboard** **keymap** **consolefont** modconf block **encrypt** **lvm2** filesystems fsck)
  >
  > HOOKS=(base udev **plymouth** autodetect keyboard keymap consolefont modconf block **plymouth-encrypt** lvm2 filesystems fsck)
- make sure to replace `encrypt` with `plymouth-encrypt`!
  - (now: `plymouth-encrypt` no longer necessary as of version `22.02.122-7`)
- add `amdgpu` to `MODULES`

```
MODULES=(amdgpu ...)
```

- [arch wiki - silent boot](https://wiki.archlinux.org/title/Silent_boot)
- add kernel parameters:

```conf
quiet loglevel=3 udev.log_level=3 splash vt.global_cursor_default=0 fbcon=nodefer
```

- `splash` necessary, `fbcon=nodefer`: don't try to defer vendor logo
- switch display manager service for smoother transition

```shell
sudo systemctl disable sddm.service
sudo systemctl enable sddm-plymouth.service
```

- can't quite get totally smooth transition (goes
  to black then sddm) but good enough for me :p
  - (now: `plymouth-encrypt` no longer necessary as of version `22.02.122-7`)

## theming

- list themes (can install additional from AUR)

```shell
plymouth-set-default-theme -l
```

- use `-R` to rebuild initramfs

```
plymouth-set-default-theme -R theme
```

- or edit `/etc/plymouth/plymouthd.conf`

```conf
[Daemon]
Theme=simple
```

- and regenerate initramfs with `sudo mkinitcpio -P`
- for themes using ModuleName `two-step`, e.g. spinner (check
  `/usr/share/plymouth/themes/` folder, `.plymouth` file for module)
- add background to `/usr/share/plymouth/themes/theme/background-tile.png`
- can only tile! (seems hardcoded)

### script module

- problem: many modules compiled into `.so`, hard to modify
- solution: use `script` module, write code in domain-specific language
- language documented on [Plymouth page](https://www.freedesktop.org/wiki/Software/Plymouth/Scripts/) but out of date
- easiest to read [C source](https://gitlab.freedesktop.org/plymouth/plymouth/-/tree/main/src/plugins/splash/script) directly
- and examples:
  - default script theme `/usr/share/plymouth/themes/script`
  - [spinner script theme](https://github.com/f1rstlady/plymouth-theme-logo-spinner)
- language is sort of weird
  - everything is an object...
  - ...except functions, they seem not to be first-class objects
  - no runtime errors, `NULL` propagation
  - global easily pollutes namespace
- feels like what I would imagine JavaScript is
  - but to be honest I have written more `.script` than `.js`...

### testing

- switch to virtual console with ctrl+alt+F6
- log in as root, run

```shell
plymouthd
plymouth show-splash
plymouth quit
```

- problem: once plymouth starts showing splash, cannot issue commands!
- solution: make shell file, say `test.fish`

```fish
plymouthd --debug --debug-file=/usr/share/plymouth/themes/simple/testing/log.txt
plymouth show-splash
sleep 5
plymouth quit
```

- run with `test.fish`, after 5 seconds automatically kills
- testing messages:

```fish
plymouthd
plymouth show-splash
set message "test message"
sleep 1
plymouth display-message --text=$message
sleep 2
# has to be the same message or callback isn't called
plymouth hide-message --text=$message
sleep 2
```

- testing passwords: need to inject key presses into `/dev/tty1` (by default)
- easiest way (not necessarily best) with [TIOCSTI](https://en.wikipedia.org/wiki/Ioctl)
- see [stackoverflow](https://stackoverflow.com/questions/29614264/unable-to-fake-terminal-input-with-termios-tiocsti/29615101#29615101) - `inject.py`:

```python
import fcntl
import sys
import termios

with open(sys.argv[1], "w") as fd:
    chars = eval(f"'{sys.argv[2]}'")
    for c in chars:
        fcntl.ioctl(fd, termios.TIOCSTI, c)
```

- client script:

```bash
plymouthd
plymouth show-splash
sleep 1
plymouth ask-for-password --prompt="test" &
sleep 1
python inject.py /dev/tty1 "these keypresses are sent to /dev/tty1"
sleep 1
# backspaces
python inject.py /dev/tty1 "\x7f\x7f\x7f\x7f\x7f\x7f\x7f"
sleep 1
python inject.py /dev/tty1 "additional text"
sleep 1
# enter, send password
python inject.py /dev/tty1 "\n"
sleep 2
plymouth quit
```

- useful: `tmux` to have multiple consoles, `vim` settings:

```vim
set autoindent
set expandtab
set shiftwidth=4
set tabstop=4
set colorcolumn=80
```

## multi-head

[just works!](https://blogs.gnome.org/halfline/2009/09/29/plymouth-multi-head-support/)

careful when scripting:

```c
Window.GetX()
Window.GetY()
```

are not accurate (leads to black bars on multi-head setups
with different resolutions). Basically assume the `Window`'s
top left corner is `(0, 0)` and everything will be ok.
