# modules

The [list of arguments](https://discourse.nixos.org/t/11838) to a module are

- `config`: option definitions (setting options)
- `lib`: Nixpkg's library functions
- `pkgs`: reference to [Nixpkgs](https://github.com/NixOS/nixpkgs)
- `options`: option declarations (defining options)
- `modulesPath`: path to Nixpkg's
  [NixOS modules](https://github.com/NixOS/nixpkgs/tree/master/nixos/modules)

These are documented in [NixOS Manual - Writing NixOS
Modules](https://nixos.org/manual/nixos/stable/#sec-writing-modules).

Using `lib` instead of `pkgs.lib` can
sometime prevent infinite recursion errors.
