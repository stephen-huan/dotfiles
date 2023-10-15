# Flakes

Flakes are a (currently) experimental feature replacing the
[channel](https://nixos.org/manual/nix/stable/package-management/basic-package-mgmt.html)
mechanism along with a few other Nix interfaces (`default.nix`, `shell.nix`).
Reproducibility is achieved by declaring inputs in `flake.nix` whose resolved
versions are pinned in `flake.lock`, like the package managers for many
programming languages, enabling easy updates of dependencies. In addition,
the project's interface is also declared in `flake.nix`, creating a unified
experience for interacting with any Flake project.

