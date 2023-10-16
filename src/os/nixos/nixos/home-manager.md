# Home manager

[Home manager](https://nix-community.github.io/home-manager/)
brings NixOS-like modules to per-user configuration (files in `~`).

If the
[NixOS module](https://nix-community.github.io/home-manager/index.html#sec-flakes-nixos-module)
is used, then the home-manager configuration is built along with NixOS.

There is also a search engine for
[options](https://mipmip.github.io/home-manager-option-search/),
not to be confused with NixOS modules/options.

## not updating

If one deletes a folder managed by home-manager,
`~/.config/nix/nix.conf`, say, it won't necessarily be regenerated
by `sudo nixos-rebuild switch` if the configuration hasn't changed.

A rebuild can be forced with

```shell
sudo systemctl restart home-manager-<user>.service
```
