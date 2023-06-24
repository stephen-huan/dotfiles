# dotfiles

Collection of configuration files ("dotfiles") on archlinux.

Files are managed with [yadm](https://yadm.io/),
see [dotfiles.md](dotfiles.md) for
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
