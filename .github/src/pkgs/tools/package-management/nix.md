# nix

n.b.: this is a guide for using nix/entering nixos on archlinux

- [arch wiki - nix](https://wiki.archlinux.org/title/Nix)
- install nix

```shell
pacman -S nix
```

- start daemon (allows operations on nix store without `sudo`/root)

```shell
sudo systemctl enable nix-daemon.service
sudo systemctl start  nix-daemon.service
```

- add self to `nix-users`

```shell
sudo gpasswd -a username nix-users
```

- don't use channels because not reproducible, so don't do the below

```shell
nix-channel --add https://nixos.org/channels/nixpkgs-unstable
nix-channel --update
```

- enable flakes and new CLI interface by editing `~/.config/nix/nix.conf`

```text
experimental-features = nix-command flakes
```

- [nix reference manual - garbage collection](https://nixos.org/manual/nix/stable/package-management/garbage-collection.html)

```shell
nix-collect-garbage
```

## home-manager

- generate initial
  [home-manager](https://nix-community.github.io/home-manager/) configuration

```shell
nix run home-manager/master -- init --switch
```

- problem with gc:

```shell
home-manager switch
nix-store --gc
home-manager switch
```

- keeps clearing/re-downloading on every switch
- looking at the stores: nixpkgs and
  home-manager, precisely the inputs to the flake
- solution: use [nix-direnv](https://github.com/nix-community/nix-direnv)
  to register flake inputs as gc root

- problem: [failed](https://github.com/nix-community/home-manager/issues/354)
  to [set locale](https://github.com/NixOS/nixpkgs/issues/38991)
- solution: set `LOCALE_ARCHIVE` to

```shell
/nix/store/{hash}-glibc-locales-{version}/lib/locale/locale-archive
```

## installing nixos with kexec

- [nixos manual - booting into nixos via kexec](https://nixos.org/manual/nixos/stable/index.html#sec-booting-via-kexec)
- generate default/automatic configuration
  (`configuration.nix`/`hardware-configuration.nix`)

```shell
nixos-generate-config
```

- (optional) use flake template for `configuration.nix`

```shell
nix flake new /etc/nixos -t github:nix-community/home-manager#nixos
```

### configuration tips

- need to import `netboot-minimal.nix`

```nix
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      (modulesPath + "/installer/netboot/netboot-minimal.nix")
    ];
```

- [netboot-minimal.nix](https://github.com/NixOS/nixpkgs/blob/master/nixos/modules/installer/netboot/netboot-minimal.nix)
  disables loading `linux-firmware`, preventing gpu from working

```nix
  # overwrite /installer/netboot/netboot-minimal.nix
  hardware.enableRedistributableFirmware = lib.mkForce true;
```

- on luks, probably need to manually specify root partition

```nix
  boot.initrd.luks.devices.cryptlvm.device =
    "/dev/disk/by-uuid/5d57809c-d0e9-49e9-939e-f5d68392faf4";
  # manually specify because `nixos-generate-config` doesn't pick it up
  fileSystems."/" = {
    device = "/dev/VolumeGroup/root";
    fsType = "ext4";
  };
```

- enable kernel flag `boot.shell_on_fail` to debug in case
  [things go wrong](https://discourse.nixos.org/t/26516)

```nix
  boot.kernelParams = [ "boot.shell_on_fail" ];
```

### entering the build

- not risking normal build (overwrites bootloader), try `kexec` to prototype
- [arch wiki - kexec](https://wiki.archlinux.org/title/Kexec)

```shell
pacman -S kexec-tools
```

- generate kernel image

```shell
nix-build '<nixpkgs/nixos>' \
    -I /nix/store/{hash}-nixpkgs \
    --arg configuration ./configuration.nix \
    --attr config.system.build.kexecTree
```

- if using flakes, path to nixpkgs can also be `-I nixpkgs=flake:nixpkgs`

- turn off [kernel mode setting](https://wiki.archlinux.org/title/Kernel_mode_setting)
- `/etc/default/grub`

```text
GRUB_CMDLINE_LINUX_DEFAULT="... quiet loglevel=3 ... nomodeset"
```

- remove `amdgpu` kernel module

- `/etc/mkinitcpio.conf`

```text
MODULES=()
```

- reload grub/initramfs, reboot, go into vt, run `sudo ./result/kexec-boot`
