# NixOS

I have moved to [NixOS](https://nixos.org/). I may still include notes here for
archival purposes, commentary, tutorials, and guides, but the canonical source
of truth remains the [Nix code](https://github.com/stephen-huan/nixos-config).

The structure of this website follows
[nixpkgs](https://github.com/NixOS/nixpkgs/) (you can search
for packages [here](https://search.nixos.org/packages)).

I still have some notes on [Arch Linux](/os/arch).

## installing from arch

One can switch from Arch completely "in-place", i.e.
without re-partitioning any drives. This can be done by
[prototyping](/pkgs/tools/package-management/nix.md) with
[kexec](https://nixos.org/manual/nixos/stable/#sec-booting-via-kexec)
to get a working configuration and then using `NIXOS_LUSTRATE` through the
[lustrate](https://nixos.org/manual/nixos/stable/#sec-installing-from-other-distro)
mechanism (which will move the old root partition to `/old-root`).

After this, it's still possible to get into arch with `chroot`, e.g.

```shell
sudo chroot /old-root /bin/bash
/bin/pacman -Q
```

Note that commands need to be fully qualified as the path is different.

## live boot

- [NixOS Wiki - Change root](https://nixos.wiki/wiki/Change_root)
- can be done from an [arch](/os/arch/#live-boot) live boot
  ```shell
  cryptsetup open /dev/nvme0n1p3 cryptlvm
  mount /dev/VolumeGroup/root /mnt
  mount -o bind /dev /mnt/dev
  mount -o bind /proc /mnt/proc
  mount -o bind /sys /mnt/sys
  chroot /mnt /nix/var/nix/profiles/system/activate
  chroot /mnt /run/current-system/sw/bin/bash
  ```
