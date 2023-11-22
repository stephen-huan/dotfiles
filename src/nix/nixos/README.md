# NixOS

The canonical source of truth is the [Nix
code](https://github.com/stephen-huan/nixos-config).

There is a search engine for [options](https://search.nixos.org/options).

## testing configuration

I couldn't get
[`nix-instantiate --eval`](https://nixos.org/manual/nix/stable/command-ref/nix-instantiate)
to play well with flakes, so I use the following setup.

Although I don't usually use a REPL for most languages (python,
julia, e.g.), preferring file-based development, unfortunately
I couldn't find a more ergonomic setup than using the
[REPL](https://aldoborrero.com/posts/2022/12/02/learn-how-to-use-the-nix-repl-effectively/).

I wrap [`nix
repl`](https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-repl)
with a shell script like

```sh
#!/bin/sh

nix repl \
  --file "$(dirname "$0")/repl.nix" \
  --argstr username "$(whoami)" \
  --argstr hostname "$(hostname)" \
  --argstr path "/persistent$HOME/.config/home-manager"
```

that loads a `repl.nix` placed in the same directory.

```nix
{ username, hostname, path }:

let
  self = builtins.getFlake path;
  nixos = self.nixosConfigurations.${hostname};
in
{
  inherit self;
  ${hostname} = nixos;
  ${username} = nixos.config.home-manager.users.${username};
  inherit (nixos) config pkgs options;
  inherit (nixos.pkgs) lib;
}
```

This can be then used like

```nix
nix-repl> <hostname>.config.
```

and press `<tab>` to see completions. `:p` can be used to force evaluation.

If I have something I want to inspect over and over again, I use a wrapper of
[nix eval](https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-eval)

```sh
nix eval ".#nixosConfigurations.$(hostname)" --apply "$(hostname): $1"
```

like so.

```shell
nixos-eval "<hostname>.config.system.activationScripts.usrbinenv"
```

## updating

Simple script to make sure `/boot` is mounted before updating.

```sh
#!/bin/sh

if [ ! "$(findmnt /boot)" ]; then
    sudo mkdir --parents /boot
    sudo mount --onlyonce /dev/nvme0n1p1 /boot
fi
sudo nixos-rebuild switch
```

`nixos-rebuild` has a few possible commands.

- `switch`: activate and make boot default
- `boot`: make boot default but don't activate
- `test`: activate but don't make boot default
- `build`: neither activate nor make boot default
  - the result is a symlink placed in `./result`

## miscellaneous

### installing from arch

One can switch from [Arch Linux](/os/arch) completely "in-place",
i.e. without re-partitioning any drives. This can be done by
[prototyping](/pkgs/tools/package-management/nix.md) with
[kexec](https://nixos.org/manual/nixos/stable/#sec-booting-via-kexec) to get a
working configuration and then using `NIXOS_LUSTRATE` through the
[lustrate](https://nixos.org/manual/nixos/stable/#sec-installing-from-other-distro)
mechanism (which will move the old root partition to `/old-root`).

After this, it's still possible to get into arch with `chroot`, e.g.

```shell
sudo chroot /old-root /bin/bash
/bin/pacman -Q
```

Note that commands need to be fully qualified as `$PATH` is still from NixOS.

### live boot

Live boot can be done from an [Arch](/os/arch/#live-boot) live boot
(see [NixOS Wiki - Change root](https://nixos.wiki/wiki/Change_root)).

```shell
cryptsetup open /dev/nvme0n1p3 cryptlvm
mount /dev/VolumeGroup/root /mnt
mount -o bind /dev /mnt/dev
mount -o bind /proc /mnt/proc
mount -o bind /sys /mnt/sys
chroot /mnt /nix/var/nix/profiles/system/activate
chroot /mnt /run/current-system/sw/bin/bash
```

### /bin/sh

Having `/bin/sh` is technically an impurity as applications can reference it
without knowing the exact version. However, it's required to do `system()`
calls in [libc](https://man7.org/linux/man-pages/man3/system.3.html),
so it can't be easily disabled entirely. This can cause
[issues](https://github.com/NixOS/nixpkgs/issues/1424) with
[reproducibility](https://github.com/NixOS/nix/issues/6081)
but progress in fixing this seems to have
[stalled](https://github.com/NixOS/nixpkgs/pull/4998).

(see also: [NixOS Discourse - Add /bin/bash to avoid
unnecessary pain](https://discourse.nixos.org/t/5673),
[NixOS Wiki - Command Shell](https://nixos.wiki/wiki/Command_Shell))

I think the cleanest thing to do is to use the
default sandbox shell provided in the default
[stdenv](https://github.com/NixOS/nix/blob/d070d8b7460f412a657745698dba291c66792402/flake.nix#L128-L130),
[currently](https://github.com/NixOS/nixpkgs/blob/master/pkgs/os-specific/linux/busybox/sandbox-shell.nix)
a statically linked ash shell from [busybox](https://www.busybox.net/).
The reasoning being that if `/bin/sh` matches the one used at build-time,
there's less chance of a runtime error due to possible incompatibility.

```nix
environment.binsh = "${pkgs.busybox-sandbox-shell}/bin/busybox";
```

It does
[warn](https://github.com/NixOS/nixpkgs/blob/b3f4040512b360397bb8989a85776335ff3c2847/modules/config/shells-environment.nix#L140-L150)
about changing from bash, but considering
it's over 10 years old, it's probably fine now.

### /usr/bin/env

Like `/bin/sh`, `/usr/bin/env` is an
[impurity](https://github.com/NixOS/nix/issues/1205) that does not
exist at [build time](https://github.com/NixOS/nixpkgs/issues/6227).

Unlike `sh`, it can be disabled relatively
[easily](https://github.com/NixOS/nixpkgs/blob/df82096af06deaa8ddd53accaaa488474575b6d6/nixos/modules/system/activation/activation-script.nix#L97-L109).

```nix
environment.usrbinenv = null;
```

This can cause issues for unpatched software that
rely on `env`, e.g. `prettier` installed with `npm`.

There are (currently) also a few minor spurious errors that should be
fixed, see this [issue](https://github.com/NixOS/nixpkgs/issues/260658).

```nix
system.activationScripts.usrbinenv =
  lib.mkIf (config.environment.usrbinenv == null) (
    lib.mkForce ''
      rm -f /usr/bin/env
      mkdir -p /usr/bin
      rmdir --ignore-fail-on-non-empty /usr/bin /usr
    ''
  );
systemd.services.systemd-update-done.serviceConfig.ExecStart = [
  "" # clear
  (
    pkgs.writeShellScript "systemd-update-done-wrapper" ''
      mkdir -p /usr
      ${pkgs.systemd}/lib/systemd/systemd-update-done
      rmdir --ignore-fail-on-non-empty /usr
    ''
  )
];
```

### vulnix

[vulnix](https://github.com/nix-community/vulnix)
scans the dependencies of the entire system for CVEs.

```shell
vulnix --system
```
