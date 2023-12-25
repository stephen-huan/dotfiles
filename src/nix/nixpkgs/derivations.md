# writing derivations

Ultimately almost everything in Nix is a
[_derivation_](https://nixos.org/manual/nix/stable/language/derivations.html)
--- a specification for producing outputs given fixed inputs. Indeed,
the entire NixOS system can be seen as a single large derivation with
many inputs. Writing derivations is a skill developed through trial and
error. Here I attempt to document implicit conventions, lessons, common
gotcha's, and other tips and tricks for writing derivations.

## hacking on nixpkgs

Build the NixOS configuration from a nixpkgs fork with

```
sudo nixos-rebuild test --override-input nixpkgs . --fast
```

## pull requests

For reference, here is a list of pull requests I've
submitted to nixpkgs, ordered by submission time.

- [nixos/activation-script: check rmdir in usrbinenv](https://github.com/NixOS/nixpkgs/pull/264523) (open)
- [nixos/mullvad-vpn: use resolvconf if enabled](https://github.com/NixOS/nixpkgs/pull/264521) (merged)
- [amd-libflame: fix various build errors](https://github.com/NixOS/nixpkgs/pull/267237) (merged)
- [blis: fix so version](https://github.com/NixOS/nixpkgs/pull/267360) (merged)
- [backintime: fix backintime-qt_polkit](https://github.com/NixOS/nixpkgs/pull/267426) (merged)
