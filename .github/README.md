# dotfiles

Collection of configuration files ("dotfiles") on archlinux.

Files are managed with [yadm](https://yadm.io/),
see [dotfiles.md](./doc/dotfiles.md) for
other dotfile systems and how to use `yadm`.

Quickstart:
```shell
cd ~
# make sure yadm is installed
yay -S yadm-git
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
- keyboard
    - [tmk/qmk](https://github.com/stephen-huan/qmk_firmware),
      open-source firmware for mechanical keyboards
- command line interfaces (terminal programs)
    - alacritty, terminal emulator
    - [fish](./doc/fish.md), shell
    - [ranger](./doc/ranger.md), file manager
    - [tmux](./doc/tmux.md), terminal multiplexer
    - [vim](./doc/vim.md), text editor
    - [cmus](./doc/cmus.md), music player
    - [mutt](./doc/mutt.md), mail user agent
- internet
    - DNS: [unbound](./doc/unbound.md), recursive DNS resolver with caching

