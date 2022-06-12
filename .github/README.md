# dotfiles

Collection of configuration files ("dotfiles") on archlinux.

Files are managed with [yadm](https://yadm.io/),
see [dotfiles.md](./doc/dotfiles.md) for
other dotfile systems and how to use `yadm`.

Quickstart:
```shell
cd ~
# make sure yadm is installed
sudo pacman -S yadm
yadm clone https://github.com/stephen-huan/dotfiles
# if yadm does not prompt automatically
yadm bootstrap
yadm status
```

## Configuration

- desktop environment
    - i3-gaps, tiling window manager
    - i3bar, top bar with icons
    - i3status, status line
- programming tools
    - [alacritty](./doc/alacritty.md), terminal emulator
    - [fish](./doc/fish.md), shell
    - [vim](./doc/vim.md), text editor
    - [git](./doc/git.md), version control
- command line interfaces (terminal programs)
    - [tmux](./doc/tmux.md), terminal multiplexer
    - [ranger](./doc/ranger.md), file manager
    - [pass](./doc/pass.md), password manager
    - [neomutt](./doc/neomutt.md), mail user agent
    - [cmus](./doc/cmus.md), music player
- keyboard
    - [tmk/qmk](https://github.com/stephen-huan/qmk_firmware/tree/vusb-nkro),
      open-source firmware for mechanical keyboards
    - [clipster](./doc/clipster.md), clipboard manager
- internet
    - DNS: [unbound](./doc/unbound.md), recursive DNS resolver with caching

