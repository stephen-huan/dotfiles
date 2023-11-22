# archlinux on a tuxedo pulse

- CPU: AMD Ryzen 7 4800H with Radeon graphics
- [wikipedia - radeon](https://en.wikipedia.org/wiki/Radeon_RX_Vega_series)
- Renoir (2020) table, Ryzen 7 4800H -> GCN 5th gen architecture
- GPU: Radeon RX Vega 7 (AMD ATI 04:00.0 Renoir)
- Driver AMDGPU
- fn + space to change keyboard backlight
- LVM on LUKS (LVM in encrypted drive)
  - what tuxedo does by default
- filesystem: ext4
- bootloader: grub

[tuxedo specific configuration](/pkgs/os-specific/linux/tuxedo-keyboard.md)

## uefi

- enter by holding `F2` on boot
- or by selecting corresponding entry in GRUB
- settings:
  - put USB first in boot order
  - put GRUB second in boot order
  - turn off secure boot (enable later)
  - disable webcam

## live boot

- need to set proper UEFI order (enter [UEFI](#uefi) with USB plugged in)
- to get started

```shell
cryptsetup open /dev/nvme0n1p3 cryptlvm
mount /dev/VolumeGroup/root /mnt
arch-chroot /mnt
```

## boot process

1. Power on --- Tuxedo logo (avoidable?)
2. bootloarder: [grub](/pkgs/tools/misc/grub.md)
3. splash screen: [plymouth](/pkgs/os-specific/linux/plymouth.md)
4. display manager: [sddm](/pkgs/applications/display-managers/sddm.md)
5. window manager: [i3](/pkgs/applications/window-managers/i3.md)

## miscellaneous

### usb

- [arch wiki - USB storage devices](https://wiki.archlinux.org/title/USB_storage_devices)
- find name of device with `lsblk -f`
- mount (folder needs to exist, make with `mkdir`)

```shell
sudo mount /dev/sda2 /mnt
```

- unmount

```shell
sudo umount /mnt
```

### pdf viewers

- [arch wiki - PDF, PS and DjVu](https://wiki.archlinux.org/title/PDF,_PS_and_DjVu)
- [sioyek](/pkgs/applications/misc/sioyek.md) or
  [zathura](/pkgs/applications/misc/zathura.md) or
  [mupdf](/pkgs/applications/misc/mupdf.md)

### mkinitcpio

- `sudo mkinitcpio -P`

```shell
==> WARNING: Possibly missing firmware for module: xhci_pci
-> Running build hook: [keymap]
-> Running build hook: [consolefont]
-> Running build hook: [modconf]
-> Running build hook: [block]
==> WARNING: Possibly missing firmware for module: wd719x
==> WARNING: Possibly missing firmware for module: qla2xxx
==> WARNING: Possibly missing firmware for module: qed
==> WARNING: Possibly missing firmware for module: qla1280
==> WARNING: Possibly missing firmware for module: aic94xx
==> WARNING: Possibly missing firmware for module: bfa
-> Running build hook: [plymouth-encrypt]
==> WARNING: Possibly missing firmware for module: qat_4xxx
```

- can install
  [mkinitcpio-firmware](https://aur.archlinux.org/packages/mkinitcpio-firmware)

```shell
paru -S mkinitcpio-firmware
```

- however, warnings are harmless if nothing is broken
- one of those cases where the "solution"
  may be more dangerous than the problem

### virtual terminal

- [arch wiki - linux console](https://wiki.archlinux.org/title/Linux_console)
- switch with `ctrl+alt+F[1-6]`
- graphical session (if running) is typically terminal 1, at
  least for [sddm](/pkgs/applications/display-managers/sddm.md)

#### set consolefont

- [arch wiki -
  linux console](https://wiki.archlinux.org/title/Linux_console#Fonts)
- `sudo mkinitcpio -P`

```text
==> WARNING: consolefont: no font found in configuration
```

- list of fonts `/usr/share/kbd/consolefonts/`, installed by the kbd package
- switch to virtual terminal for the following
- display font table

```shell
showconsolefont
```

- set font

```shell
setfont
```

- edit configuration file `/etc/vconsole.conf`, see `man vconsole.conf `

```text
FONT=Lat2-Terminus16
```

- default font [cp437](https://en.wikipedia.org/wiki/CP437),
  appears not to be in folder and instead built-in to kernel
- [webpage of
  fonts](https://alexandre.deverteuil.net/docs/archlinux-consolefonts/)
- `.psfu` indicates Unicode translation map built-in
- package for popular
  [terminus font](http://terminus-font.sourceforge.net/index.html),
  includes more sizes than kbd

```shell
pacman -S terminus-font
```

### proper naming

- [arch wiki - arch
  terminology](https://wiki.archlinux.org/title/Arch_terminology#Arch_Linux)

  > ## Arch Linux
  >
  > Arch should be referred to as:
  >
  > - **Arch Linux**
  > - **Arch** (Linux implied)
  > - **archlinux** (UNIX name)
  >
  > Archlinux, ArchLinux, archLinux, aRcHlInUx,
  > etc. are all weird, and weirder mutations.
  >
  > Officially, the 'Arch' in "Arch Linux" is pronounced /ˈɑrtʃ/ as in an
  > "archer"/bowman, or "arch-nemesis", and not as in "ark" or "archangel".

- can never remember what the "official" names are
