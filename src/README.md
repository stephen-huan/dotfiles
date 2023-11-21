# dotfiles

Collection of configuration files ("dotfiles") on [NixOS](./os/nixos/).

Files are managed with [home-manager](/os/nixos/nixos/home-manager.md),
see [dotfiles management](/dotfiles.md) for other dotfile systems.

Quickstart:

```shell
git clone https://github.com/stephen-huan/nixos-config ~/.config/home-manager
sudo ln -s ~/.config/home-manager/flake.nix /etc/nixos/flake.nix
sudo nixos-rebuild switch
```
