# nix

- n.b.: this is a guide for using nix/entering nixos on archlinux
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

- don't use channels because not reproducible, so don't do this

```shell
nix-channel --add https://nixos.org/channels/nixpkgs-unstable
nix-channel --update
```

- [nixos - garbage collection](https://nixos.org/manual/nix/stable/package-management/garbage-collection.html)

```shell
nix-collect-garbage
```

- enable flakes and new CLI interface by editing `~/.config/nix/nix.conf`

```text
experimental-features = nix-command flakes
```

- [home-manager](https://nix-community.github.io/home-manager/)

```shell
nix run home-manager/master -- init --switch
```

- problem:

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

- [nixos manual](https://nixos.org/manual/nixos/stable/index.html#sec-installing-from-other-distro)

```shell
nixos-generate-config --root /mnt
```

- not risking normal build (overwriting bootloader), try `kexec` to prototype
- [arch wiki - kexec](https://wiki.archlinux.org/title/Kexec)

```shell
pacman -S kexec-tools
```

- flake template for `configuration.nix`

```shell
nix flake new /etc/nixos -t github:nix-community/home-manager#nixos
```

```shell
nix-build '<nixpkgs/nixos>' \
    -I /nix/store/{hash}-nixpkgs \
    --arg configuration ./configuration.nix \
    --attr config.system.build.kexecTree
```

- turn off `amdgpu` and [kernel mode setting](https://wiki.archlinux.org/title/Kernel_mode_setting)
- `/etc/default/grub`

```text
GRUB_CMDLINE_LINUX_DEFAULT="... quiet loglevel=3 ... nomodeset"
```

- `/etc/mkinitcpio.conf`

```text
MODULES=()
```

- reload grub/initramfs, reboot, go into vt, run `sudo ./result/kexec-boot`
