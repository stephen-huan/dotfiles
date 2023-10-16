# GRUB

## install

- [arch wiki - GRUB](https://wiki.archlinux.org/title/GRUB)
- install grub

```shell
sudo pacman -S grub efibootmgr
```

- Assume EFI system partition already mounted to `/boot`
- Install GRUB

```shell
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
```

- Configuration file at `/etc/default/grub`
- Need to run `grub-mkconfig`!
- Use `grub-mkconfig` to generate `/boot/grub/grub.cfg`

```shell
grub-mkconfig -o /boot/grub/grub.cfg
```

- Or can edit `/boot/grub/grub.cfg` directly without `/etc/default/grub`

## microcode

- [arch wiki - microcode](https://wiki.archlinux.org/title/Microcode)
- microcode updates

```shell
pacman -S amd-ucode
```

- update GRUB, automatically adds microcode to startup

```shell
grub-mkconfig -o /boot/grub/grub.cfg
```

- check `amd-ucode.img` before `initramfs-linux.img` in `/boot/grub/grub.cfg`
  > initrd **/boot/amd-ucode.img** /boot/initramfs-linux.img
- check kernel messages for early loading of microcode

```shell
journalctl -k --grep=microcode
```

## image background, styling, theming

- [ubuntu - grub](https://help.ubuntu.com/community/Grub2/Displays)
- option 1: set `GRUB_BACKGROUND` in `/etc/default/grub`
  - problem: filesystem encrypted, image not accessible by grub!
- option 2: copy an image file to `/boot/grub`
  - solution: `/boot` isn't encrypted
- colors: set "black" for transparent, full list
  [here](https://www.gnu.org/software/grub/manual/grub/html_node/color_005fnormal.html)
- set `GRUB_COLOR_NORMAL` (default) and `GRUB_COLOR_HIGHLIGHT` (selected)

## fix rescue shell before menu

- fix initially entering shell instead of menu
  - but still works with `exit` command
- re-order UEFI entries
  - UEFI NVME Drive BBS Priorities set first to GRUB instead of ubuntu
