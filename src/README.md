# dotfiles

Notes on [NixOS](/os/nixos/), [Home
Manager](/os/nixos/nixos/home-manager.md), and software in general.

Quickstart:

```shell
git clone https://github.com/stephen-huan/nixos-config ~/.config/home-manager
sudo ln -s ~/.config/home-manager/flake.nix /etc/nixos/flake.nix
sudo nixos-rebuild switch
```
