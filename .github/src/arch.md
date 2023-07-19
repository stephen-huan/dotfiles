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

## tuxedo specifics

- [arch wiki -
  Tuxedo Pulse 15](https://wiki.archlinux.org/title/Tuxedo_Pulse_15)
- install keyboard control

```shell
paru -S tuxedo-keyboard
```

- install power / CPU / fan control

```shell
paru -S tuxedo-control-center-bin
```

- screen brightness (0-255)

```shell
echo 127 | sudo tee /sys/class/backlight/amdgpu_bl0/brightness
```

- keyboard backlight (0-2)

```shell
echo 0 | sudo tee /sys/devices/platform/tuxedo_keyboard/leds/white:kbd_backlight/brightness
```

## USB

- [arch wiki -
  USB storage devices](https://wiki.archlinux.org/title/USB_storage_devices)
- find name of device with `lsblk`
- mount (folder needs to exist, make with `mkdir`)

```shell
sudo mount /dev/sda2 /mnt
```

- unmount

```shell
sudo umount /mnt
```

## live boot

- need to set proper UEFI order (enter UEFI with USB plugged in)
- to get started

```shell
cryptsetup open /dev/nvme0n1p3 cryptlvm
mount /dev/VolumeGroup/root /mnt
arch-chroot /mnt
```

## UEFI

- enter by holding f2 on boot
- or by selecting corresponding entry in GRUB
- settings:
  - put USB first in boot order
  - put GRUB second in boot order
  - turn off secure boot (enable later)
  - disable webcam

## install

### making live USB

- [arch wiki - installation guide](https://wiki.archlinux.org/title/Installation_guide)
- [Download ISO](https://archlinux.org/download/) [torrent link]
- Download PGP signature and check checksums on ISO download page
- Verify PGP signature

```shell
gpg --keyserver-options auto-key-retrieve --verify archlinux-version-x86_64.iso.sig
```

- [arch wiki - USB flash installation medium](https://wiki.archlinux.org/title/USB_flash_installation_medium)
- copy ISO to USB

```shell
cp path/to/archlinux-version-x86_64.iso /dev/sdx
```

- boot from USB (make sure to set correct UEFI order)

### in live environment

- Connect to WiFi

```shell
iwctl
[iwd]# help
[iwd]# station list
[iwd]# station wlan0 connect WIFI_NAME
[iwd]# station list
```

- Check connection

```shell
ping archlinux.org
```

- Set system clock

```shell
timedatectl set-ntp true
```

- Check system time

```shell
timedatectl status
```

#### partition disk

- Partition disks: only need UEFI (EFI system partition) and root (/)
- Swap does not need to be a partition, can be a file for flexibility/ease

```shell
lsblk
fdisk -l
```

If Tuxedo: by default, partitions look like (1 TB drive)

```text
Devic          ...  Size Type
/dev/nvme0n1p1        1G EFI System
/dev/nvme0n1p2      512M Microsoft basic data
/dev/nvme0n1p3      930G Linux filesystem
```

- Normally could use existing EFI partition
- But file format is wrong (we want FAT32 for GRUB, format is ext3)
- Will fix later

#### prepare drive for encryption

- [arch wiki - solid state drive memory cell cleaning](https://wiki.archlinux.org/title/Solid_state_drive/Memory_cell_clearing)
- Can clean SSD before this step if desired
- [arch wiki - prepare drive for dm-crypt](https://wiki.archlinux.org/title/Dm-crypt/Drive_preparation)
- Create temporary encrypted container

```shell
cryptsetup open --type plain -d /dev/urandom /dev/nvme0n1p3 to_be_wiped
```

- Verify that it exists

```shell
lsblk
```

- Wipe container with zeros

```shell
dd if=/dev/zero of=/dev/mapper/to_be_wiped status=progress
```

WARNING: 1 TB disk capacity / (80 MB/s write speed) = ~3.5 hours

- Close temporary container

```shell
cryptsetup close to_be_wiped
```

#### encrypt entire drive

- [arch wiki - dm-crypt encrypting an entire system](https://wiki.archlinux.org/title/Dm-crypt/Encrypting_an_entire_system#LVM_on_LUKS)
- Use LVM on LUKS (logical volume manager inside encrypted disk)
- Create LUKS encrypted partition on system partition

```shell
cryptsetup luksFormat /dev/nvme0n1p3
```

- Open container (decrypted container now at `/dev/mapper/cryptlvm`)

```shell
cryptsetup open /dev/nvme0n1p3 cryptlvm
```

- Create physical volume

```shell
pvcreate /dev/mapper/cryptlvm
```

- Create volume group (name `VolumeGroup`, arbitrary)

```shell
vgcreate VolumeGroup /dev/mapper/cryptlvm
```

- Create logical volumes
- I said we could use a swap file
- If using LVM, easy to re-size partitions, might as well use swap partition
- Make swap partition same size as RAM for easy suspend to disk (hibernate)
- Don't use entire volume group capacity for easy resizing in the future

```shell
lvcreate -L 32G      VolumeGroup -n swap
lvcreate -l 100%FREE VolumeGroup -n root
```

- Format filesystems

```shell
mkswap    /dev/VolumeGroup/swap
mkfs.ext4 /dev/VolumeGroup/root
```

- Mount filesystems

```shell
swapon /dev/VolumeGroup/swap
mount /dev/VolumeGroup/root /mnt
```

- Prepare boot partition

```shell
mkfs.fat -F 32 /dev/nvme0n1p1
mkdir /mnt/boot
mount /dev/nvme0n1p1 /mnt/boot
```

- Select mirrors with `reflector`
- [arch wiki - reflector](https://wiki.archlinux.org/title/Reflector)
- `pacstrap` to install base, kernel, firmware

```shell
pacstrap /mnt base linux linux-firmware
```

- Generate fstab

```shell
genfstab -U /mnt >> /mnt/etc/fstab
```

### switch into new system

- Change root into new system

```shell
arch-chroot /mnt
```

- Install useful packages

```shell
pacman -S man-db man-pages vim fish
```

- Install necessary packages

```shell
pacman -S lvm2 grub efibootmgr iwd
```

- Set timezone

```shell
ln -sf /usr/share/zoneinfo/US/Eastern /etc/localtime
```

- Run `hwclock`

```shell
hwclock --systohc
```

- Edit `/etc/locale.gen` and uncomment `en_US.UTF-8 UTF-8`, run `locale-gen`

```shell
locale-gen
```

- Create `/etc/locale.conf` with the `LANG` variable

```shell
LANG=en_US.UTF-8
```

- Create hostname in `/etc/hostname`

```shell
myhostname
```

- Set root password

```shell
passwd
```

#### edit initramfs

- Add the following to `/etc/mkinitcpio.conf`
  > HOOKS=(base udev autodetect **keyboard** **keymap** **consolefont** modconf block **encrypt** **lvm2** filesystems fsck)
- Recreate initramfs image

```shell
mkinitcpio -P
```

#### install GRUB

- [arch wiki - GRUB](https://wiki.archlinux.org/title/GRUB)
- EFI system partition already mounted to `/boot`
- Install GRUB

```shell
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
```

- Edit `/etc/default/grub` where `device-UUID` is the UUID of `/dev/nvme0n1p1`
- This can be found with `lsblk -f`

```text
GRUB_CMDLINE_LINUX_DEFAULT="cryptdevice=UUID=device-UUID:cryptlvm root=/dev/VolumeGroup/root resume=/dev/VolumeGroup/swap"
```

- Use `grub-mkconfig` to generate `/boot/grub/grub.cfg`

```shell
grub-mkconfig -o /boot/grub/grub.cfg
```

- Reboot

```shell
reboot
```

- Hopefully the following:
  - "Arch Linux" appears in GRUB menu
  - Prompt for encryption key
  - Prompt for username
  - Prompt for password
  - Login successful!

## post-install

- Start WiFi with `iwd` and DNS
- [arch wiki - users and groups](https://wiki.archlinux.org/title/Users_and_groups)
- Add new user account
- Make sure shell is in `/etc/shells` or unable to log in

```shell
useradd -m -s /usr/bin/fish username
```

- Set password

```shell
passwd username
```

- Give `sudo` permission

```shell
EDITOR=vim visudo
```

- Go to "User privilege specification" and add

```conf
USER_NAME   ALL=(ALL) ALL
```

- Logout of root and log in to user account

```shell
exit
```

- or switch user

```
su stephenhuan
```

- [arch wiki - XDG user directories](https://wiki.archlinux.org/title/XDG_user_directories)
- Install xdg-users-dirs

```shell
sudo pacman -S xdg-user-dirs
```

- Create user directories

```shell
xdg-user-dirs-update
```

- Install AUR helper [paru](https://github.com/morganamilo/paru)

```shell
sudo pacman -S --needed git base-devel
git clone https://aur.archlinux.org/paru.git
cd paru
sudo makepkg -si
```

- Get dotfiles with [yadm](https://yadm.io/)

```shell
cd ~
pacman -S yadm
yadm clone https://github.com/stephen-huan/dotfiles
```

- Install display manager

```shell
sudo pacman -S sddm
```

- Enable display manager

```shell
sudo systemctl enable sddm.service
```

- Install window manager (i3-gaps)

```shell
sudo pacman -S i3
```

- Install terminal emulator (alacritty)

```shell
sudo pacman -S alacritty
```

- Enter graphical

```shell
sudo systemctl start sddm.service
```

- If no terminal emulator, can get suck in i3!
- Use ctrl+alt+F1-6 to switch to virtual console
- From virtual console back to graphical

```shell
sudo systemctl restart sddm.service
```

# packages

## boot process

1. Power on --- Tuxedo logo (avoidable?)
2. GRUB
3. Plymouth
4. Display manager (SDDM)
5. Window manager (i3)

## GRUB

### install

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

### microcode

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

### image background, styling, theming

- [ubuntu - grub](https://help.ubuntu.com/community/Grub2/Displays)
- option 1: set `GRUB_BACKGROUND` in `/etc/default/grub`
  - problem: filesystem encrypted, image not accessible by grub!
- option 2: copy an image file to `/boot/grub`
  - solution: `/boot` isn't encrypted
- colors: set "black" for transparent, full list
  [here](https://www.gnu.org/software/grub/manual/grub/html_node/color_005fnormal.html)
- set `GRUB_COLOR_NORMAL` (default) and `GRUB_COLOR_HIGHLIGHT` (selected)

### fix rescue shell before menu

- fix initially entering shell instead of menu
  - but still works with `exit` command
- re-order UEFI entries
  - UEFI NVME Drive BBS Priorities set first to GRUB instead of ubuntu

## Plymouth

[arch wiki - plymouth](https://wiki.archlinux.org/title/Plymouth)

- install plymouth (recommended to use development version, but unstable)

```shell
paru -S plymouth
```

- add plymouth hook to `/etc/mkinitcpio.conf`
  > HOOKS=(base udev autodetect **keyboard** **keymap** **consolefont** modconf block **encrypt** **lvm2** filesystems fsck)
  >
  > HOOKS=(base udev **plymouth** autodetect keyboard keymap consolefont modconf block **plymouth-encrypt** lvm2 filesystems fsck)
- make sure to replace `encrypt` with `plymouth-encrypt`!
- (now: plymouth-encrypt no longer necessary, TODO, 22.02.122-7)
- add `amdgpu` to `MODULES`

```
MODULES=(amdgpu ...)
```

- [arch wiki - silent boot](https://wiki.archlinux.org/title/Silent_boot)
- add kernel parameters:

```conf
quiet loglevel=3 udev.log_level=3 splash vt.global_cursor_default=0 fbcon=nodefer
```

- `splash` necessary, `fbcon=nodefer`: don't try to defer vendor logo
- switch display manager service for smoother transition

```shell
sudo systemctl disable sddm.service
sudo systemctl enable sddm-plymouth.service
```

- can't quite get totally smooth transition (goes
  to black then sddm) but good enough for me :p
- (now: sddm-plymouth no longer necessary, TODO, 22.02.122-7)

### theming

- list themes (can install additional from AUR)

```shell
plymouth-set-default-theme -l
```

- use `-R` to rebuild initramfs

```
plymouth-set-default-theme -R theme
```

- or edit `/etc/plymouth/plymouthd.conf`

```conf
[Daemon]
Theme=simple
```

- and regenerate initramfs with `sudo mkinitcpio -P`
- for themes using ModuleName `two-step`, e.g. spinner (check
  `/usr/share/plymouth/themes/` folder, `.plymouth` file for module)
- add background to `/usr/share/plymouth/themes/theme/background-tile.png`
- can only tile! (seems hardcoded)

#### script module

- problem: many modules compiled into `.so`, hard to modify
- solution: use `script` module, write code in domain-specific language
- language documented on [Plymouth page](https://www.freedesktop.org/wiki/Software/Plymouth/Scripts/) but out of date
- easiest to read [C source](https://gitlab.freedesktop.org/plymouth/plymouth/-/tree/main/src/plugins/splash/script) directly
- and examples:
  - default script theme `/usr/share/plymouth/themes/script`
  - [spinner script theme](https://github.com/f1rstlady/plymouth-theme-logo-spinner)
- language is sort of ... weird
  - everything is an object
  - ... except functions, they seem not to be first-class objects
  - no runtime errors, NULL propagation
  - global easily pollutes namespace
- feels like what I would imagine JavaScript feels
- but to be honest I have written more `.script` than `.js` ...

#### testing

- switch to virtual console with ctrl+alt+F6
- log in as root, run

```shell
plymouthd
plymouth show-splash
plymouth quit
```

- problem: once plymouth starts showing splash, cannot issue commands!
- solution: make shell file, say `test.fish`

```fish
plymouthd --debug --debug-file=/usr/share/plymouth/themes/simple/testing/log.txt
plymouth show-splash
sleep 5
plymouth quit
```

- run with `test.fish`, after 5 seconds automatically kills
- testing messages:

```fish
plymouthd
plymouth show-splash
set message "test message"
sleep 1
plymouth display-message --text=$message
sleep 2
# has to be the same message or callback isn't called
plymouth hide-message --text=$message
sleep 2
```

- testing passwords: need to inject key presses into `/dev/tty1` (by default)
- easiest way (not necessarily best) with [TIOCSTI](https://en.wikipedia.org/wiki/Ioctl)
- see [stackoverflow](https://stackoverflow.com/questions/29614264/unable-to-fake-terminal-input-with-termios-tiocsti/29615101#29615101) - `inject.py`:

```python
import fcntl
import sys
import termios

with open(sys.argv[1], "w") as fd:
    chars = eval(f"'{sys.argv[2]}'")
    for c in chars:
        fcntl.ioctl(fd, termios.TIOCSTI, c)
```

- client script:

```fish
plymouthd
plymouth show-splash
sleep 1
plymouth ask-for-password --prompt="test" &
sleep 1
python inject.py /dev/tty1 "these keypresses are sent to /dev/tty1"
sleep 1
# backspaces
python inject.py /dev/tty1 "\x7f\x7f\x7f\x7f\x7f\x7f\x7f"
sleep 1
python inject.py /dev/tty1 "additional text"
sleep 1
# enter, send password
python inject.py /dev/tty1 "\n"
sleep 2
plymouth quit
```

- useful: `tmux` to have multiple consoles, `vim` settings:

```vim
set autoindent
set expandtab
set shiftwidth=4
set tabstop=4
set colorcolumn=80
```

### multi-head

TODO

## SDDM

- [arch wiki - SDDM](https://wiki.archlinux.org/title/SDDM)
- Install sddm

```shell
sudo pacman -S sddm
```

- Enable sddm

```shell
sudo systemctl enable sddm.service
```

- Default configuration: `/usr/lib/sddm/sddm.conf.d/default.conf` or

```shell
sddm --example-config
```

- Configuration directory: `/etc/sddm.conf.d/`, can place any files in the
  directory e.g. `sddm.conf`, name/extension doesn't matter
- Testing

```shell
sddm-greeter --test-mode --theme /usr/share/sddm/themes/simplicity
```

### Theming

- Install theme

```shell
paru -S simplicity-sddm-theme-git
```

- or my [patch](https://gitlab.com/stephenhuan/simplicity-sddm-theme) that
  fixes an issue where username was empty if real name was not set
- Themes go in `/usr/share/sddm/themes/` by default
- Can edit theme settings by copying default theme file
  `/usr/share/sddm/themes/simplicity/theme.conf` to
  `/usr/share/sddm/themes/simplicity/theme.conf.user` and making custom changes

### Profile Icon

- Add a PNG file `username.face.icon` to `/usr/share/sddm/faces/`
- Or create `~/.face.icon` and let SDDM find it:

```shell
setfacl -m u:sddm:x ~/
setfacl -m u:sddm:r ~/.face.icon
```

## GPU

- [arch wiki - AMDGPU](https://wiki.archlinux.org/title/AMDGPU)
- Install mesa for OpenGL/3D acceleration

```shell
sudo pacman -S mesa
```

- test mesa support

```shell
sudo pacman -S mesa-utils
glxinfo
```

- Install DDX driver for 2D acceleration

```shell
sudo pacman -S xf86-video-amdgpu
```

- Enable vulkan support

```shell
sudo pacman -S amdvlk
```

- test vulkan support

```shell
sudo pacman -S vulkan-tools
vulkaninfo
```

- Accelerated video decoding

```shell
pacman -S libva-mesa-driver mesa-vdpau
```

## i3wm

- TODO
- use `xev` to get keysym names (i.e. "[" is bracketleft)

### picom

- [arch wiki - picom](https://wiki.archlinux.org/title/picom)
- install picom

```shell
pacman -S picom
```

- TODO

### screensaver (xss-lock/i3lock)

- [arch wiki - session lock](https://wiki.archlinux.org/title/Session_lock)
- [arch wiki - power
  management](https://wiki.archlinux.org/title/Power_management#xss-lock)
- [arch wiki - display power
  management signaling](https://wiki.archlinux.org/title/DPMS)
- install xss-lock

```shell
pacman -S xss-lock
```

- set to use `i3lock` as a locker

```shell
xss-lock --transfer-sleep-lock -- i3lock --nofork --image=$HOME/Pictures/config/screensaver &
```

- for `i3lock`, `--nofork` prevents multiple instances and set background image
- manually trigger lock

```shell
loginctl lock-session
```

- TODO

#### picom transparency leaks screen after lock

- picom set to make inactive windows slightly
  transparent (`inactive-opacity = 0.9;`)
- this causes `i3lock` to also become transparent, leaking your desktop screen
- see [reddit - Picom make i3lock opaque](https://www.reddit.com/r/archlinux/comments/q4fo26/picom_make_i3lock_opaque/)
- edit `~/.config/picom/picom.conf`, add

```config
opacity-rule = [ "100:class_g = 'i3lock'" ];
```

##### using picom-trans?

- `man picom`

```man
       --opacity-rule OPACITY:'CONDITION'
           Specify a list of opacity rules, in the format PERCENT:PATTERN, like
           50:name *= "Firefox". picom-trans is recommended over this.
```

- okay, `man picom-trans`, should be ran like

```shell
picom-trans -n "i3lock" 100
```

- however, this has to happen _after_ the window exists
- hard to do, since `i3lock` is should be ran with `--nofork`

##### archive

- below simply doesn't work, works when running `i3lock` from a terminal
  but not when actually triggered (by sleep or with `loginctl lock-session`)
- follow the instructions for slock in the picom article:
  [arch wiki - picom](https://wiki.archlinux.org/title/picom#slock)
- install xwininfo

```shell
sudo pacman -S xorg-xwininfo
```

- run the command and click to get the window id

```shell
xwininfo & i3lock --nofork --image=$HOME/Pictures/config/screensaver
```

- use the discovered id to have picom exclude the window

```shell
picom --daemon --focus-exclude 'id = 0x4600007'
```

### cursor spins on empty background

- see [arch wiki -
  i3](https://wiki.archlinux.org/title/I3#Mouse_cursor_remains_in_waiting_mode)
- see [i3wm user guide](https://i3wm.org/docs/userguide.html#exec)
- see [freedesktop.org - startup-notification-spec](https://www.freedesktop.org/wiki/Specifications/startup-notification-spec/)
- run offending command in i3 config with `exec --no-startup-id`
- i3 has startup notifications, i.e. when an application
  finishes starting, it will signal to i3 that it's finished,
  i3 will change the cursor from waiting to normal.
- but if the application doesn't support startup notifications,
  it'll take 1 minute for the cursor to reset to normal

#### issue in alacritty

- alacritty causes this issue
- see [github - Alacritty causing 1-2 mins of
  busy cursor on i3 desktop, and extreme i3
  performance issues](https://github.com/alacritty/alacritty/issues/868)
- fix cursor

```shell
i3 restart
```

- alacritty refuses to fix this, see [Alacritty causing 1-2 mins of
  busy cursor on i3 desktop (
  re-opening #868)](https://github.com/alacritty/alacritty/issues/6097)

#### archive

- see [reddit - How to get rid of spinning
  cursor?](https://www.reddit.com/r/i3wm/comments/ncbbvn/how_to_get_rid_of_spinning_cursor/)
- see [i3wm faq - What is that thing called --no-startup-id?
  ](https://faq.i3wm.org/question/561/what-is-that-thing-called-no-startup-id/index.html)
- [sddm](#sddm) executes `~/.xprofile` by default
  (check `/usr/share/sddm/scripts/Xsession`).
- nicer to have single script for all commands in
  `~/.xprofile` than preface every command with `exec` in i3
- (imagined) problem: likely caused by daemons in `~/.xprofile`
- seem to have no effect if not directly spawned
  by `exec` in i3 config (`~/.config/i3/config`)

## packaging

### pacman

- TODO
- sudo pacman -S pacman-contrib

#### reflector

- [arch wiki - reflector](https://wiki.archlinux.org/title/Reflector)
- `/etc/xdg/reflector/reflector.conf`

```shell
sudo systemctl start reflector.service
```

- or

```shell
reflector --latest 20 --protocol https --country us --sort rate --save /etc/pacman.d/mirrorlist
```

- TODO

#### pacgraph

- TODO

### AUR helper [paru]

- TODO
- [yay](https://github.com/Jguer/yay)
- [paru](https://github.com/morganamilo/paru)
- if migrating from other AUR helper,

```shell
paru --gendb
```

### nix

```shell
pacman -S nix
```

```shell
sudo systemctl enable nix-daemon.service
sudo systemctl start  nix-daemon.service
```

```shell
sudo gpasswd -a stephenhuan nix-users
```

don't do this

```shell
nix-channel --add https://nixos.org/channels/nixpkgs-unstable
nix-channel --update
```

[nixos - garbage collection](https://nixos.org/manual/nix/stable/package-management/garbage-collection.html)

```shell
nix-collect-garbage
```

`~/.config/nix/nix.conf`

```text
experimental-features = nix-command flakes
```

[home-manager](https://nix-community.github.io/home-manager/)

```shell
nix run home-manager/master -- init --switch
```

- problem:

```shell
home-manager switch
nix-store --gc
home-manager switch
```

- keeps clearing/re-downloading
- looking at the stores: nixpkgs and home-manager, precisely input to flake
- solution: use nix-direnv to register flake inputs as gc root

- [nixos manual](https://nixos.org/manual/nixos/stable/index.html#sec-installing-from-other-distro)

```shell
sudo `which nixos-generate-config` --root /mnt
```

- not risking normal build, try `kexec` to prototype

```shell
pacman -S kexec-tools
```

- [arguments](https://discourse.nixos.org/t/what-are-the-arguments-available-to-a-given-module/11838)
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

## internet/networking

- [arch wiki - network configuration](https://wiki.archlinux.org/title/Network_configuration)

### iwd

- [arch wiki - iwd](https://wiki.archlinux.org/title/Iwd)
- install iwd

```shell
pacman -S iwd
```

- edit configuration in `/etc/iwd/main.conf` to enable DHCP management

```conf
[General]
EnableNetworkConfiguration=true
```

- add DNS with openresolv (see [DNS](#dns))

```conf
[Network]
NameResolvingService=resolvconf
```

- start systemd service

```shell
systemctl enable iwd
systemctl start  iwd
```

- enter prompt

```shell
iwctl
```

- helpful commands in prompt

```shell
[iwd]# help
[iwd]# station list
[iwd]# station wlan0 connect WIFI_NAME
[iwd]# station list
```

- still need DNS, can only use systemd-resolved / resolvconf
- it seems iwd can do its own DNS (or DHCP does DNS?)
- DNS is provided by (g)libc, see [arch wiki - domain name resolution](https://wiki.archlinux.org/title/Domain_name_resolution#Glibc_resolver)

#### eduroam

- generate password hash

```shell
iconv -t utf16le | openssl md4 -provider legacy
```

- EOF to end (don't press enter, sends `'\n'`): press `ctrl-D` twice
- edit `/var/lib/iwd/essid.8021x`, for eduroam `/var/lib/iwd/eduroam.8021x`:

```conf
[Security]
EAP-Method=PEAP
EAP-Identity=anonymous@gatech.edu
# EAP-PEAP-CACert=/path/to/root.crt
# EAP-PEAP-ServerDomainMask=lawn.gatech.edu
EAP-PEAP-Phase2-Method=MSCHAPV2
EAP-PEAP-Phase2-Identity=username@gatech.edu
EAP-PEAP-Phase2-Password-Hash=passwordhash

[Settings]
AutoConnect=true
```

- can't put `EAP-PEAP-CACert` in home directory

#### ead

- ethernet authentication daemon

```shell
systemctl start ead.service
```

- not sure what this does
- replacement for `wpa_supplicant`, see
  [reddit - EAD ethernet authentication daemon](https://www.reddit.com/r/voidlinux/comments/u4kmjo/ead_ethernet_authentication_daemon/)

### ethernet

- [arch wiki - network configuration/ethernet](https://wiki.archlinux.org/title/Network_configuration/Ethernet)
- hypothetically simpler than wifi because directly plugged in
- check network interface name

```shell
ip link show
```

- something like this:

```text
1: lo: ...
    link/loopback ...
2: eno1: ...
    link/ether ...
    altname enp2s0
4: wlan0: ...
    link/ether ...
```

- turn on:

```shell
ip link set eno1 up
```

- turn off:

```shell
ip link set eno1 down
```

#### dhcpcd

- [arch wiki - dhcpcd](https://wiki.archlinux.org/title/Dhcpcd)
- need separate DHCP client for ethernet ---
  iwd has its own, but only for itself (wireless)
- install dhcpcd

```shell
pacman -S dhcpcd
```

- could enable for all interfaces, but only need for ethernet:

```shell
systemctl enable dhcpcd@eno1.service
systemctl start  dhcpcd@eno1.service
```

- hangs on boot up, waiting for IP address
- create `/etc/systemd/system/dhcpcd@eno1.service.d/no-wait.conf`
- could use `systemctl edit `

```config
[Service]
ExecStart=
ExecStart=/usr/bin/dhcpcd -b -q %I
```

- already automatically enables/disables ethernet based on cable plug in/out
- add wifi disable/enable based on ethernet state
  by adding hook to `/etc/dhcpcd.exit-hook` (or in
  `/etc/dhcpcd.enter-hook` or in `/usr/lib/dhcpcd/dhcpcd-hooks`)
- based on [this comment](https://bugs.archlinux.org/task/67382#comment191690)
- see `man dhcpcd-run-hooks` for the values of `$interface`, `$reason`, etc.

```sh
# disable wifi if ethernet connected and enable wifi if ethernet disconnected

wired=eno1
wireless=wlan0

if [ "${interface}" = $wired ]; then
    case "${reason}" in NOCARRIER|BOUND)
    if $if_up; then     # ethernet up means wifi down
        iwctl station $wireless disconnect
    elif $if_down; then # ethernet down means wifi up
        # parse `iwctl known-networks list` and connect to most recent network
        last="$(/home/stephenhuan/bin/iwd-last-network)"
        iwctl station $wireless connect $last
    fi
    ;;
    esac
fi
```

##### losing connection

- connection randomly drops for a few seconds, happens relatively frequently
- `journalctl -u dhcpcd@eno1.service`

```text
May 29 15:17:33 neko dhcpcd[806]: eno1: 00:56:2b:56:19:38(00:00:00:ff:eb:0d) claims 128.61.88.130
May 29 15:17:33 neko dhcpcd[806]: eno1: 00:aa:6e:d4:c0:38(00:00:00:ff:f2:b4) claims 128.61.88.130
May 29 15:17:33 neko dhcpcd[806]: eno1: 10 second defence failed for 128.61.88.130
May 29 15:17:33 neko dhcpcd[806]: eno1: deleting route to 128.61.80.0/20
May 29 15:17:33 neko dhcpcd[806]: eno1: deleting default route via 128.61.80.1
May 29 15:17:34 neko dhcpcd[806]: eno1: rebinding lease of 128.61.88.130
May 29 15:17:34 neko dhcpcd[806]: eno1: probing address 128.61.88.130/20
May 29 15:17:39 neko dhcpcd[806]: eno1: leased 128.61.88.130 for 7200 seconds
May 29 15:17:39 neko dhcpcd[806]: eno1: adding route to 128.61.80.0/20
May 29 15:17:39 neko dhcpcd[806]: eno1: adding default route via 128.61.80.1
```

- [same problem](https://forums.raspberrypi.com/viewtopic.php?t=295979)
  - advice was to fix the ip conflict, hard to do
    - already using dynamic ip instead of static
    - can't change the configuration of other devices
- problem described in [rfc2131](https://datatracker.ietf.org/doc/html/rfc2131)
  > 5.  The client receives the DHCPACK message with configuration
  >     parameters. The client SHOULD perform a final check on the
  >     parameters (e.g., ARP for allocated network address), and notes the
  >     duration of the lease specified in the DHCPACK message. At this
  >     point, the client is configured. If the client detects that the
  >     address is already in use (e.g., through the use of ARP), the
  >     client MUST send a DHCPDECLINE message to the server and restarts
  >     the configuration process. The client SHOULD wait a minimum of ten
  >     seconds before restarting the configuration process to avoid
  >     excessive network traffic in case of looping.
- fits with `journalctl` log:
  - found ip conflict with ARP, someone else is claiming the address
  - `eno1: 00:56:2b:56:19:38(00:00:00:ff:eb:0d) claims 128.61.88.130`
  - wait for ten seconds before restarting
  - `10 second defence failed for 128.61.88.130`
  - re-negotiate lease
  - `eno1: leased 128.61.88.130 for 7200 seconds`
- check ARP with [arp-scan](https://github.com/royhills/arp-scan):

```shell
pacman -S arp-scan
```

- solution proposed in issue [dhcpcd loses
  static IP](https://github.com/NetworkConfiguration/dhcpcd/issues/36)
- certain devices send faulty ARP probes, tell `dhcpcd` to ignore ARP
- `/etc/dhcpcd.conf`

```config
noarp
```

- still might not work
- same issue [DHCPCD fails again, with DAD detection
  this time](https://forums.raspberrypi.com/viewtopic.php?t=302782)
- see [rfc5227](https://datatracker.ietf.org/doc/html/rfc5227)
- as of 2022-06-17 this has not been fixed
- also this error, but probably caused by mullvad

```text
May 31 23:20:37 neko dhcpcd[743]: ps_root_recvmsg: Operation not permitted
```

#### dhclient

- install dhclient

```shell
pacman -S dhclient
```

- start system service

```shell
systemctl enable dhclient@eno1.service
systemctl start  dhclient@eno1.service
```

- dhclient overwrites `/etc/resolv.conf` which is a problem if using vpn, etc.
- see [arch forum - dhclient overwrites resolv.conf even when resolvconf
  is installed](https://bbs.archlinux.org/viewtopic.php?id=265736)
- I can't get this to work, resolvconf processes it in the wrong order
- this could be fixed by hardcoding or just ignoring DNS altogether
  (I get my DNS server from mullvad or 1.1.1.1 anyways)
- patch from arch forum in `/etc/dhclient-enter-hooks`

```sh
	# if [ -f /etc/resolv.conf ]; then
	#     chown --reference=/etc/resolv.conf $new_resolv_conf
	#     chmod --reference=/etc/resolv.conf $new_resolv_conf
	# fi
	# mv -f $new_resolv_conf /etc/resolv.conf

        # use resolvconf
        cat $new_resolv_conf | /usr/bin/resolvconf -a $interface
        rm $new_resolv_conf
```

- use [unbound](#unbound) to prevent DNS servers being in the wrong order

##### operation not permitted

- error `journalctl -u dhclient@eno1.service`

```text
Jun 11 16:22:03 neko dhclient[687]: send_packet: Operation not permitted
Jun 11 16:22:03 neko dhclient[687]: dhclient.c:2996: Failed to send 300 byte long packet over fallback interface.
```

- see [linuxquestions - dhcpd complains "Failed to send
  300 byte long packet over fallback interface."](https://www.linuxquestions.org/questions/linux-networking-3/dhcpd-complains-failed-to-send-300-byte-long-packet-over-fallback-interface-4175548986/#post5705157)
- when it works check `tcpdump` output (`pacman -S tcpdump`)

```shell
sudo tcpdump > out.txt
```

- note that `bootps` is usually port 67 and `bootpc` is usually port 68

```text
02:58:43.767759 IP neko.bootpc > 255.255.255.255.bootps: BOOTP/DHCP, Request from b0:25:aa:44:bd:c2 (oui Unknown), length 300
02:58:43.770219 ARP, Request who-has res388d-128-61-95-198.res.gatech.edu (Broadcast) tell _gateway, length 46
02:58:43.773852 IP _gateway.bootps > neko.bootpc: BOOTP/DHCP, Reply, length 300
02:58:43.774738 IP _gateway.bootps > neko.bootpc: BOOTP/DHCP, Reply, length 300
```

- firewall issue, try using built-in kernel packet filter, front end `iptables`
- [arch wiki - iptables](https://wiki.archlinux.org/title/Iptables)
- [arch wiki - ebtables](https://wiki.archlinux.org/title/Ebtables)
- [arch wiki - nftables](https://wiki.archlinux.org/title/Nftables)
- open `bootps` and `bootpc` ports for DHCP

```shell
iptables -A OUTPUT -p udp --sport 1024:65535 --dport 67 -j ACCEPT
iptables -A OUTPUT -p udp --sport 68 --dport 67 -j ACCEPT

iptables -A INPUT -p udp --sport 1024:65535 --dport 68 -j ACCEPT
iptables -A INPUT -p udp --sport 67 --dport 68 -j ACCEPT
```

- list

```shell
ebtables-nft --list
```

- to undo run

```shell
iptables -F
ebtables-nft -F
```

- firewall created by [mullvad](https://github.com/mullvad/mullvadvpn-app#environment-variables-controlling-the-execution)
- solution: use split tunnel to exclude dhclient from the vpn, see [mullvad -
  How to use the Mullvad CLI](https://mullvad.net/en/help/how-use-mullvad-cli/)
- edit `/etc/dhclient-exit-hooks`

```sh
# exclude dhclient from vpn, also from firewall
mullvad split-tunnel pid add "$(pgrep --oldest dhclient)"
```

#### systemd-networkd

- [arch wiki - systemd-networkd](https://wiki.archlinux.org/title/Systemd-networkd)
- probably just works

#### georgia tech

- need to remember to register new device at
  [portal.lawn.gatech.edu](https://portal.lawn.gatech.edu)!
- otherwise, garbage data when trying to make DNS query
- make sure ethernet is connected and DHCP is working
- check MAC address with `ip link`

```text
2: eno1: ...
    link/ether MAC_ADDRESS brd ff:ff:ff:ff:ff:ff
    altname enp2s0
```

#### ifplugd

- [arch wiki - network configuration/ethernet](https://wiki.archlinux.org/title/Network_configuration/Ethernet#ifplugd_for_laptops)
- not necessary if using dhcpcd, same feature works out of the box
- install ifplugd:

```shell
pacman -S ifplugd
```

- edit config to change default `eth0` device
  to `eno1` at `/etc/ifplugd/ifplugd.conf`

```config
INTERFACES="eno1"
```

- enable service

```shell
systemctl enable ifplugd@eno1.service
systemctl start  ifplugd@eno1.service
```

- can use to disable wifi when ethernet connected
  and enable wifi when ethernet disconnected
- runs `/etc/ifplugd/ifplugd.action` on up/down with two arguments: name of
  ethernet interface and whether it went up or down. Shell script inspired by
  [this link](https://busybox.busybox.narkive.com/yvV73uN2/looking-for-simple-ifplugd-example-script#post2):

```sh
#!/bin/sh
# disable wifi if ethernet connected and enable wifi if ethernet disconnected

case $2 in
    up)   # ethernet up means wifi down
        iwctl station wlan0 disconnect
        ;;
    down) # ethernet down means wifi up
        # parse `iwctl known-networks list` and connect to most recent network
        iwctl station wlan0 connect "$(/home/stephenhuan/bin/iwd-last-network)"
        ;;
esac
```

- remember to mark as executable!

```
chmod +x /etc/ifplugd/ifplugd.action
```

- parsing script `iwd-last-network` simply wraps `iwctl known-networks list`:

```python
#!/usr/bin/env python3
"""
Script to parse `iwctl known-networks list`
and return the most recently connected network.
"""
import subprocess
import datetime

def __known_networks() -> str:
    """ Wraps `iwctl known-networks list`. """
    out = subprocess.run(["iwctl", "known-networks", "list"],
                         capture_output=True, text=True)
    return out.stdout

def get_date(date: str) -> datetime.datetime:
    """ Parse iwctl date format into a datetime object. """
    return datetime.datetime.strptime(date, "%b %d, %H:%M %p")

def get_known_networks() -> list[str]:
    """ Parses the output of iwctl. """
    lines = __known_networks().strip().splitlines()
    return [(row[0], row[1], get_date(" ".join(row[2:])))
            for row in map(str.split, lines[4:])]

if __name__ == "__main__":
    lines = get_known_networks()
    recent = sorted(lines, key=lambda row: row[-1], reverse=True)
    print(recent[0][0])
```

- hang on shutdown: `[  *** ] A stop job is running for ...`
- [forum post](https://bbs.archlinux.org/viewtopic.php?pid=1922083)
- [bug tracker](https://bugs.archlinux.org/task/67382)
- use dhcpcd hook instead?

### DNS

- [arch wiki - domain name resolution](https://wiki.archlinux.org/title/Domain_name_resolution)
- if just need quick functional DNS to install other things: systemd-resolved
- good DNS: openresolv + unbound
- [DHCP](https://wiki.archlinux.org/title/Network_configuration#DHCP) seems
  to either do DNS or allow DNS to be done without an explicit DNS client...
- DNS is provided by (g)libc, see [arch wiki - domain name resolution](https://wiki.archlinux.org/title/Domain_name_resolution#Glibc_resolver)

#### systemd-resolved

- [arch wiki -
  systemd-resolved](https://wiki.archlinux.org/title/Systemd-resolved)

```shell
systemctl start systemd-resolved
```

- probably just works

#### openresolv

- [arch wiki - openresolv](https://wiki.archlinux.org/title/Openresolv)
- openresolv allows multiple programs to edit `/etc/resolv.conf`
- install openresolv

```shell
pacman -S openresolv
```

- configuration file in `/etc/resolvconf.conf`
- it seems openresolv works by itself by just specifying a nameserver:

```conf
# Configuration for resolvconf(8)
# See resolvconf.conf(5) for details

resolv_conf=/etc/resolv.conf
# If you run a local name server, you should uncomment the below line and
# configure your subscribers configuration files below.
#name_servers=127.0.0.1
name_servers=1.1.1.1
```

- `sudo resolvconf -u` to generate `/etc/resolv.conf`

#### unbound

- [arch wiki - unbound](https://wiki.archlinux.org/title/Unbound)
- [dnsprivacy - DNS privacy clients](https://dnsprivacy.org/dns_privacy_clients/#unbound)
- [mullvad - DNS over HTTPS and DNS over TLS](https://mullvad.net/en/help/dns-over-https-and-dns-over-tls/)
- [mullavd - SOCKS5 proxy](https://mullvad.net/en/help/socks5-proxy/)
- install unbound

```shell
pacman -S unbound
```

- install expat for DNSSEC verification

```shell
pacman -S expat
```

- using [openresolv](#openresolv), edit `/etc/resolvconf.conf`

```config
name_servers="::1 127.0.0.1"
resolv_conf_options="trust-ad"

private_interfaces="*"
unbound_conf=/etc/unbound/resolvconf.conf
```

- edit unbound config `/etc/unbound/unbound.conf`

```config
# include: "/etc/unbound/resolvconf.conf"

server:
    prefetch: yes
    hide-identity: yes
    hide-version: yes
    tls-system-cert: yes

    forward-zone:
        name: "."
        forward-addr: 194.242.2.2@853#doh.mullvad.net
        forward-addr: 193.19.108.2@853#doh.mullvad.net
        # forward-addr: 1.1.1.1@853#cloudflare-dns.com
        # forward-addr: 1.0.0.1@853#cloudflare-dns.com
        forward-tls-upstream: yes
```

- if using vpn, resolvconf generated include should probably
  not be used, literally the definition of a DNS leak
- also seems to be broken, can't resolve servers because of mullvad firewall
- if using mullvad, should use local gateway, can't use TLS because domain
  name isn't known (10.64.0.1 corresponds to currently connected mullvad
  server, different hostname depending on which server you're currently
  connected to). This is annoying because then then the fallbacks can't
  use TLS. Could hypothetically fix by specifying a particular host. This
  is doubly annoying because the mullvad doh.mullvad.net DNS servers only
  use TLS, so they can't be used as fallbacks.

```config
    forward-zone:
        name: "."
        # https://mullvad.net/en/help/socks5-proxy/
        forward-addr: 10.64.0.1
        forward-addr: 1.1.1.1
        forward-addr: 1.0.0.1
```

### Mullvad VPN

- [arch wiki - mullvad](https://wiki.archlinux.org/title/Mullvad)
- installing GUI also comes with CLI, nice to have around
- choice of which to install after running below command

```shell
paru -S mullvad-vpn
```

- enable service

```shell
systemctl enable mullvad-daemon.service
systemctl start  mullvad-daemon.service
```

- set auto-connect

```shell
mullvad auto-connect set on
```

- running `mullvad-vpn` opens GUI while `mullvad` is CLI
- opening GUI creates lock icon in bar, but can't seem to close window
  - use i3, mod+alt+q
- quitting app kills vpn connection
- might be easiest to just use CLI:
  - [mullvad CLI](https://mullvad.net/en/help/how-use-mullvad-cli/)
  - [mullvad CLI wireguard](https://mullvad.net/en/help/cli-command-wg/)
- set account number

```shell
mullvad account set 1234123412341234
```

- set protocol to WireGuard

```shell
mullvad relay set tunnel-protocol wireguard
```

- list servers

```shell
mullvad relay list
```

- set server (format 2 character country code, 3 character
  city code, server-name), from `mullvad relay list`

```shell
mullvad relay set location us atl us-atl-001
```

- can give any prefix, e.g. just `set location us`
- connect

```shell
mullvad connect
```

- disconnect

```shell
mullvad disconnect
```

- check status

```shell
mullvad status
```

- external check: [am I mullvad?](https://mullvad.net/en/check/)
- launch `<program>` and exclude it from vpn

```shell
mullvad-exclude <program>
```

- or, for currently running process with `<pid>`

```shell
mullvad split-tunnel pid add <pid>
```

### OpenConnect

- [arch wiki - OpenConnect](https://wiki.archlinux.org/title/OpenConnect)
- install [openconnect](https://www.infradead.org/openconnect/index.html)

```shell
pacman -S openconnect
```

- using [global
  protect](https://www.infradead.org/openconnect/globalprotect.html),
  proprietary vpn used on many university campuses
- problem: authentication isn't with SAML, but with some proprietary 2fa
- surprisingly enough, just works, run openconnect

```shell
sudo openconnect --protocol=gp vpn.gatech.edu
```

- have to paste in password with ctrl-shift-V
- make sure [mullvad](#mullvad-vpn) is disconnected before
- automate login with fish script

```fish
function vpn --description "connect to gatech's proprietary global protect vpn"
    # disconnect mullvad before continuing
    set -g mullvad_status (mullvad status)
    mullvad disconnect

    set password "$(pass school/gatech/gatech.edu | head --lines=1)"
    # 1st line is password, 2nd line is 2fa prompt, and 3rd line is gateway
    echo -e "$password\\npush1\\ndc-ext-gw.vpn.gatech.edu" |
        sudo openconnect \
            --protocol=gp \
            vpn.gatech.edu \
            --user=shuan7 \
            --passwd-on-stdin
end

function vpn-cleanup --on-signal SIGINT --description "post hook"
    # if connected before disconnecting, reconnect to mullvad
    if ! string match --entire --ignore-case -q -- disconnected $mullvad_status
        mullvad connect
    end
end
```

#### nsdo

- [github - nsdo](https://github.com/ausbin/nsdo)
- might be nice

#### GlobalProtect-openconnect

- if using network manager, install package
  `networkmanager-openconnect`, unfortunately I am using iwd
- can use [GlobalProtect-openconnect](https://github.com/yuezk/GlobalProtect-openconnect) or
  [gp-saml-gui](https://github.com/dlenski/gp-saml-gui) to do web login
- surprisingly enough, GlobalProtect-openconnect is on official repositories

```shell
pacman -S globalprotect-openconnect
```

- run

```shell
gpclient
```

- enter `vpn.gatech.edu` for portal address
- doesn't work with proprietary 2fa

```text
Gateway authentication failed

Unknown response for gateway
prelogin interface.
```

## Audio

- [arch wiki - sound system](https://wiki.archlinux.org/title/Sound_system)
- ALSA: kernel driver
- PipeWire/PulseAudio on top

### ALSA

- [arch wiki -
  Advanced Linux Sound Architecture](https://wiki.archlinux.org/title/ALSA)
- no need to install, built-in to kernel
- install userspace utilities:

```shell
pacman -S alsa-utils
```

- for better resampling:

```shell
pacman -S alsa-plugins
```

- unmute channels:

```shell
alsamixer
```

- speaker test:

```shell
speaker-test -c2
```

- hard to use, can't get working
- just install userspace component, you'll have to anyways!

### PipeWire

- [arch wiki - PipeWire](https://wiki.archlinux.org/title/PipeWire)
- modern drop-in replacement for PulseAudio
- install

```shell
pacman -S pipewire
```

- make sure to select "WirePlumber" session manager
- replace ALSA with pipewire

```shell
pacman -S pipewire-alsa
```

- replace pulseaudio with pipewire

```shell
pacman -S pipewire-pulse
```

- also enables bluetooth management
- enable services

```shell
systemctl --user enable pipewire-pulse.service
systemctl --user start  pipewire-pulse.service
```

- check working

```shell
pactl info
```

- speaker test works!

```shell
speaker-test
```

#### pulseaudio userspace

- [arch wiki - PulseAudio](https://wiki.archlinux.org/title/PulseAudio)
- seem to be able to use pulseaudio applications
- e.g. simple mixer

```shell
pacman -S pulsemixer
```

### Bluetooth

- [arch wiki - bluetooth](https://wiki.archlinux.org/title/Bluetooth)
- [arch wiki -
  bluetooth headset](https://wiki.archlinux.org/title/Bluetooth_headset)
- install bluez

```shell
pacman -S bluez
pacman -S bluez-utils
```

- enable service

```shell
systemctl enable bluetooth.service
systemctl start  bluetooth.service
```

- start command line prompt

```shell
bluetoothctl
```

- turn power on, turn agent, start scanning for devices

```shell
[bluetooth]# power on
[bluetooth]# agent on
[bluetooth]# default-agent
[bluetooth]# scan on
```

- find MAC address of device
- note: might be spammed by other devices, exit to prevent
- pair, connect, and trust for future auto-connect

```text
[bluetooth]# pair MAC_ADDRESS
[bluetooth]# connect MAC_ADDRESS
[bluetooth]# trust MAC_ADDRESS
```

- enable auto power-on of bluetooth module in `/etc/bluetooth/main.conf`

```config
[Policy]
AutoEnable=true
```

#### bluetooth randomly stuck

- bluetooth stuck after waking up from sleep
- `sudo systemctl restart bluetooth.service` and the like hangs
- kill daemon directly

```shell
sudo pkill -9 bluetoothd
```

## Music Applications

### cmus

- [arch wiki - cmus](https://wiki.archlinux.org/title/Cmus)
- install

```
pacman -S cmus
```

- make sure pulseaudio backend is used: `:set output_plugin=pulse`
- install backends for specific filetypes, e.g. .mp3:

```
pacman -S libmad
```

- .flac

```
pacman -S flac
```

- note `ffmpeg` provides large number of codecs

#### hangs after close

- hangs if music is paused and then cmus is closed
- trying to open another cmus window results in

```
cmus: Error: an error occured while initializing MPRIS: File exists. MPRIS will be disabled.
cmus: Press <enter> to continue.
```

- MPRIS is the freedesktop specification for
  music player control, see [MPRIS](#mpris)
- seems to be a pipewire issue, see [Delayed exit from paused music in
  cmus](https://gitlab.freedesktop.org/pipewire/pipewire/-/issues/946)
- as well as [Quitting while playback is paused takes
  several seconds](https://github.com/cmus/cmus/issues/1064)
- brought back up again recently, see [Cmus hangs when paused
  for a long time](https://github.com/pop-os/pipewire/issues/6)

### Apple Music

- use web client: [music.apple.com](https://music.apple.com/)
- pros: no installation/configuration
- cons: many
  - need apple device for 2fa sign in
  - feels slow/clunky
  - randomly breaks
  - doesn't store place

#### iTunes

- this is possible to wine but is broken on the latest version
- black screen from some rendering issue
- https://www.theiphonewiki.com/wiki/ITunes
- doesn't seem to be able to import many things, randomly crashes
- https://forums.linuxmint.com/viewtopic.php?t=292556
- https://wiki.archlinux.org/title/IOS
- https://libimobiledevice.org/
- https://github.com/libimobiledevice/ifuse
- https://github.com/libimobiledevice/ifuse/issues/63
- TODO

```fish
function musicsync --description "sync music to phone"
    # mount vlc media folder to ~/mnt
    ifuse --documents org.videolan.vlc-ios ~/mnt
    # see https://superuser.com/questions/1192448/rsync-mkstemp-filename-failed-function-not-implemented-38
    rsync -av --progress --no-perms --no-owner --no-group --exclude "*.m3u" \
        ~/Music/personal ~/mnt/
    # copy playlists from cmus
    set temp (pwd)
    cd ~/Music/personal/playlists
    python cmus_copy.py
    # generate playlists from artists
    python artist_playlist.py
    cd "$temp"
    rsync -av --progress --no-perms --no-owner --no-group \
        ~/Music/personal/playlists ~/mnt/personal
    # done
    umount ~/mnt
end
```

#### cider

- open-source Electron client
- install [cider](https://cider.sh/)

```shell
paru -S cider
```

##### Settings

- many themes are broken, the only light theme I could get
  to work was [iTheme](https://github.com/ciderapp/iTheme)

### MPRIS

- [arch wiki - MPRIS](https://wiki.archlinux.org/title/MPRIS)
- [freedesktop - MPRIS D-Bus Interface Specification](https://specifications.freedesktop.org/mpris-spec/latest/)
- Media Player Remote Interfacing Specification (MPRIS)
- freedesktop specification for music player control
- install [playerctl](https://github.com/altdesktop/playerctl),
  front-end client to control implementing players

```shell
pacman -S playerctl
```

- start daemon to track most player with most
  recent activity, e.g. put in `~/.xprofile`

```shell
playerctld daemon
```

- `XF86Audio` audio control keys are already bound in default i3 config

```config
# Use pactl to adjust volume in PulseAudio.
set $refresh_i3status killall -SIGUSR1 i3status
bindsym XF86AudioRaiseVolume exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@     +10% && $refresh_i3status
bindsym XF86AudioLowerVolume exec --no-startup-id pactl set-sink-volume @DEFAULT_SINK@     -10% && $refresh_i3status
bindsym XF86AudioMute        exec --no-startup-id pactl set-sink-mute   @DEFAULT_SINK@   toggle && $refresh_i3status
bindsym XF86AudioMicMute     exec --no-startup-id pactl set-source-mute @DEFAULT_SOURCE@ toggle && $refresh_i3status
```

- bind `XF86Audio` player control keys to corresponding `playerctl` commands

```config
# my headphones alternate between play/pause while my keyboard just has play
# so to keep it consistent, force both to toggle
bindsym XF86AudioPlay    exec playerctl play-pause
bindsym XF86AudioPause   exec playerctl play-pause
bindsym XF86AudioStop    exec playerctl stop
bindsym XF86AudioPrev    exec playerctl previous
bindsym XF86AudioNext    exec playerctl next
bindsym XF86AudioForward exec playerctl position 1+
bindsym XF86AudioRewind  exec playerctl position 1-
```

## Security

### PGP

- [arch wiki - GnuPG](https://wiki.archlinux.org/title/GnuPG)
- install

```shell
pacman -S gnupg
```

- set `pinentry` program (should use something graphical for background)

```shell
pacman -Ql pinentry | grep /usr/bin/
```

- also add `ssh` support
- edit `~/.gnupg/gpg-agent.conf`

```config
# set SSH_AUTH_SOCK to use gpg-agent instead of ssh-agent
enable-ssh-support

# use alternative pinentry
pinentry-program /usr/bin/pinentry-qt
```

- copy over old data (private keys, revocation certificates)

#### mullvad

- can't import keys from keyserver with mullvad!

### YubiKey

- [arch wiki - YubiKey](https://wiki.archlinux.org/title/YubiKey)
- install manager

```shell
pacman -S yubikey-manager
```

- enable service

```shell
systemctl enable pcscd.service
systemctl start  pcscd.service
```

- for U2F

```shell
pacman -S libfido2
```

- with [PGP](https://developers.yubico.com/PGP/)

### pass

- [arch wiki - pass](https://wiki.archlinux.org/title/Pass)
- install [pass](https://www.passwordstore.org/)

```shell
pacman -S pass
```

- if setup PGP and yubikey, should just work
- comes with dmenu selection

```shell
passmenu
```

#### securing

- set `PASSWORD_STORE_SIGNING_KEY`

```fish
set -gx PASSWORD_STORE_SIGNING_KEY "EA6E27948C7DBF5D0DF085A10FBC2E3BA99DD60E"
```

- this requires a signature on `.gpg-id` and non-system extensions
- if, for example, using remote git to track and pull update to `.gpg-id`
  or malicious extension, won't be used because signature breaks
- generate signature

```shell
gpg --detach-sign .gpg-id
```

- do the same for any non-system extensions (not recommended)
- enable non-system extensions (if extension isn't packaged, e.g.)

```fish
set -gx PASSWORD_STORE_ENABLE_EXTENSIONS "true"
```

#### pass-otp

- install [pass-otp](https://github.com/tadfisher/pass-otp)

```shell
pacman -S pass-otp
```

- automatically updates and checks gpg signature
- probably more secure than copying to `.extensions` folder and signing

#### browserpass

- [browserpass](https://github.com/browserpass/browserpass-extension)
- install [native app](https://github.com/browserpass/browserpass-native)

```shell
pacman -S browserpass
```

- install [firefox
  extension](https://github.com/browserpass/browserpass-extension)

```shell
pacman -S browserpass-firefox
```

- install [chrome
  extension](https://github.com/browserpass/browserpass-extension)

```shell
paru -S browserpass-chrome
```

- remember to quit and re-open chrome!

#### git-credential-manager

- [git book - 7.14 Git Tools - Credential Storage](https://git-scm.com/book/en/v2/Git-Tools-Credential-Storage)
- [git doc - gitcredentials](https://git-scm.com/docs/gitcredentials)
- [git-credential-manager - Credential stores](https://github.com/GitCredentialManager/git-credential-manager/blob/main/docs/credstores.md#gpgpass-compatible-files)
- install [git-credential-manager](https://github.com/GitCredentialManager/git-credential-manager)

```shell
paru -S git-credential-manager-core
```

- run configuration and use gpg/pass files

```shell
git-credential-manager-core configure
git config --global credential.credentialStore gpg
```

- or edit `~/.config/git/config` directly

```ini
[credential]
	helper = /usr/share/git-credential-manager-core/git-credential-manager-core
	credentialStore = gpg
```

- running a `git-credential-manager-core` command seems to break arrow keys?
- next time credential is requested, pop-up appears, can
  authenticate in a variety of ways (browser, token, etc.)
- stores at `~/.password-store/git/https/github.com/stephen-huan.gpg`, e.g.

#### pass-git-helper

- [pass-git-helper](https://github.com/languitar/pass-git-helper)
- seems a bit complicated

## input

### qmk

- [qmk - Setting Up Your QMK Environment](https://docs.qmk.fm/#/newbs_getting_started)
- install qmk

```shell
pacman -S qmk
```

- qmk setup

```shell
qmk setup
```

- or use personal fork

```shell
qmk setup stephen-huan/qmk_firmware
```

- set default keyboard and keymap

```shell
qmk config user.keyboard=dm9records/plaid
qmk config user.keymap=stephen-huan
```

- compile and flash

```shell
qmk compile
qmk flash
```

- see [stephen-huan/plaid](https://github.com/stephen-huan/plaid)

### keyboard (xkb)

- [arch wiki - xmodmap](https://wiki.archlinux.org/title/xmodmap)
- outdated, use xkb instead
- still useful for viewing what modifiers are set to, run with `xmodmap`

```shell
pacman -S xorg-xmodmap
```

- xev, keyboard event viewer, also useful tool, run with `xev`

```shell
pacman -S xorg-xev
```

- [arch wiki - X keyboard extension](https://wiki.archlinux.org/title/X_keyboard_extension)
- install, comes as dependency of `xorg-server`, probably already have it

```shell
pacman -S xorg-xkbcomp
```

- complicated as hell, can't say too much about this
- if you screw up, can make keyboard unusable, first store default config

```shell
xkbcomp $DISPLAY output.xkb
```

- can reset with

```shell
setxkbmap -layout us
```

- once you make custom keymap at `~/.Xkeymap`, put in `~/.xprofile` at startup:

```shell
test -f ~/.Xkeymap && xkbcomp ~/.Xkeymap $DISPLAY
```

#### Super_R as mod3

- use case: qmk ["hyper"](https://docs.qmk.fm/#/mod_tap) (not in
  the linux modifier sense) is ctrl_L + shift_L + alt_L + super_L
- use this as i3 mod, need secondary modifier
  that can't be ctrl/shift/alt/super
- use super_R as unused mod3 to distinguish
- comment out (not necessary, no clue what this does)

```config
    interpret Super_R+AnyOf(all) {
        virtualModifier= Super;
        action= SetMods(modifiers=modMapMods,clearLocks);
    };
```

- change `Super` to `Mod3` here

```config
    interpret Super_R+AnyOfOrNone(all) {
        action= SetMods(modifiers=Super,clearLocks);
    };
```

- change `Mod4` to `Mod3` here

```config
    modifier_map Mod4 { <RWIN> };
```

- n.b.: I no longer use this, it's simpler to make hyper
  shift_L + alt_L + super_L (still unlikely to conflict with
  other keybindings) and use ctrl as a secondary modifier

### imf (ibus)

- [arch wiki - input method](https://wiki.archlinux.org/title/Input_method)
- [arch wiki - ibus](https://wiki.archlinux.org/title/IBus)
- install ibus

```shell
pacman -S ibus
```

- run at startup, set environmental variables, put in `~/.xprofile`

```shell
ibus-daemon --daemonize --replace --xim

export GTK_IM_MODULE=ibus
export QT_IM_MODULE=ibus
export XMODIFIERS=@im=ibus
```

- no clue what `--xim` does, but if left out doesn't work in alacritty, e.g.
- no clue what the environmental variables do,
  but if left out doesn't work in alacritty, e.g.
- can put variables in `/etc/environment` but why
  would you want to? need to edit with sudo, etc.
- edit config, add input methods, etc.

```shell
ibus-setup
```

- can also right-click icon if it's running
- change activation shortcut to whatever you like, etc.

#### japanese ime (mozc)

- [arch wiki - localization/japanese](https://wiki.archlinux.org/title/Localization/Japanese)
- [arch wiki - mozc](https://wiki.archlinux.org/title/Mozc)
- open source version of google's japanese input
- install mozc-ut (mozc with much larger [UT
  dictionary](http://linuxplayers.g1.xrea.com/mozc-ut.html#install-arch-linux))

```shell
paru -S mozc
```

- install communication module with ibus

```shell
paru -S ibus-mozc
```

- add to ibus

```shell
ibus-setup
```

- "IBus Preferences" -> "Input method" -> "Add" -> "Japanese" -> "Mozc"
- startup in hiragana mode, useful if no hardware key for Eisu etc.
- edit `~/.config/mozc/ibus_config.textproto`,
  change `active_on_launch` from `False` to `True`

```config
...
}
active_on_launch: True
```

#### ibus overwrites xkb

- using [xmodmap/xkb](<#keyboard-(xkb)>) to make changes
- [ibus](<#imf-(ibus)>) randomly clears these when switching back and forth
- "IBus Preferences" -> "Advanced" -> "Keyboard Layout" ->
  check "Use system keyboard layout"

## font

- [arch wiki - font configuration](https://wiki.archlinux.org/title/Font_configuration)
- [arch wiki - font configuration/examples](https://wiki.archlinux.org/title/Font_configuration/Examples#Japanese)
- list fonts

```shell
fc-list
```

- query settings

```shell
fc-match --verbose sans
```

- edit `~/.config/fontconfig/fonts.conf`

```xml
<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
<fontconfig>

    <alias>
        <family>serif</family>
        <prefer>
            <family>Noto Serif</family>
            <family>IPAMincho</family>
        </prefer>
    </alias>

    <alias>
        <family>sans-serif</family>
        <prefer>
            <family>Noto Sans</family>
            <family>IPAGothic</family>
        </prefer>
    </alias>

    <alias>
        <family>monospace</family>
        <prefer>
            <family>Noto Sans Mono</family>
            <family>IPAGothic</family>
        </prefer>
    </alias>

</fontconfig>
```

### japanese

- [arch wiki - localization/Japanese](https://wiki.archlinux.org/title/Localization/Japanese)
- install [ipafont](https://moji.or.jp/ipafont/) from
  Japan's [information-technology promotion agency
  (IPA)](https://www.ipa.go.jp/index.html), government agency
- "one of the highest quality open source font" - arch wiki

```shell
pacman -S otf-ipafont
```

- see [wikipedia - IPA フォント](https://ja.wikipedia.org/wiki/IPA%E3%83%95%E3%82%A9%E3%83%B3%E3%83%88)
  for the differences between IPA[/P/Ex/mj] Mincho/Gothic

#### firefox japanese font is wrong

- differences in kanji for chinese and japanese,
  e.g. "語" in 日本語, "直" in 直す
- [ chinese ver.](https://learnjapanese.moe/img/font2.png),
  [japanese ver.](https://learnjapanese.moe/img/font3.png)
- firefox displays chinese version despite setting japanese fonts
- enter `about:config`
- change `font.cjk_pref_fallback_order` from
  `zh-cn,zh-hk,zh-tw,ja,ko` to `ja,zh-cn,zh-hk,zh-tw,ko`
- also, default western font is serif instead of sans-serif for
  some reason, makes japanese also serif, e.g. in myanimelist
- change `font.default.x-western` from `serif` to `sans-serif`
- or just change in normal settings page `about:preferences`, "General" ->
  "Fonts" -> "Fonts for" select Latin, "Proportional" select "Sans Serif"

#### how to tell Noto Sans CJK JP and IPAGothic apart

- katakana "ta": タ
  - ipa horizontal line precisely connects the two parallel lines
  - noto looks kind of like a ヌ, doesn't touch left and juts past right

## developement

### python

#### conda

- install [miniconda](https://docs.conda.io/en/latest/miniconda.html)

```shell
paru -S miniconda3
```

- lightweight installer for
  [conda](https://docs.conda.io/projects/conda/en/latest/) that doesn't
  install as much as [anaconda](https://docs.anaconda.com/anaconda/)
  (over 250 packages by default)
- what they want you to do (and what the post-install message will say)

```shell
source /opt/miniconda3/etc/fish/conf.d/conda.fish
```

- or if on bash/POSIX shell

```shell
source /opt/miniconda3/etc/profile.d/conda.sh
```

- will add `conda` to `PATH`, to make changes permanent

```shell
conda init fish
```

- or

```shell
conda init
```

- but I don't necessarily want to have every shell startup be in (base)
- instead, comment out the addition to the configuration
  file and run the command manually when using conda

```shell
eval /opt/miniconda3/bin/conda "shell.fish" "hook" $argv | source
```

##### terminals database is inaccessible

- [ask ubuntu - clear command - terminals database is
  inaccessible](https://askubuntu.com/questions/988694/clear-command-terminals-database-is-inaccessible/1402408#1402408)

```
export TERMINFO=/usr/share/terminfo
```

## Miscellaneous

### Proper Naming

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
- switch with ctrl+alt+F1-6
- graphical session (if running) is typically terminal 1, at least for SDDM

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

```
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

### Screen Capture

- [arch wiki - screen capture](https://wiki.archlinux.org/title/Screen_capture)
- install [maim](https://github.com/naelstrof/maim)

```shell
pacman -S maim
```

- take full-screenshot

```shell
maim file.png
```

- make selection with mouse (`-D` for click twice instead of click-dragging)

```shell
maim -sD file.png
```

- install [obs](https://obsproject.com/)

```shell
pacman -S obs-studio
```

#### copying images to clipboard with maim/xclip

- see [maim examples](https://github.com/naelstrof/maim#examples)

### Clipboard

- [arch wiki - clipboard](https://wiki.archlinux.org/title/Clipboard)
- managed by X, PRIMARY, CLIPBOARD, and SECONDARY selections
  - PRIMARY: selected text, i.e. highlighted by mouse
  - CLIPBOARD: text that is explicitly copied (e.g. by ctrl-c)
  - SECONDARY: no agreed upon purpose
- install [xclip](https://github.com/astrand/xclip), command-line interface

```shell
pacman -S xclip
```

- by default, clipboard contents lost if application is closed
- this is because X only stores references to the data, not copies
- see [ubuntu wiki -
  ClipboardPersistence](https://wiki.ubuntu.com/ClipboardPersistence)
- see this [reddit post](https://www.reddit.com/r/archlinux/comments/9tkvsl/persistent_clipboard/),
  recommends `clipmenu`.
- however, I can't get `clipmenu` to work and there's a security
  concern: copying passwords/sensitive information to clipboard; most
  clipboard managers (including `clipmenu`) store data on disk as plaintext
- install [clipster](https://github.com/mrichar1/clipster)

```shell
paru -S clipster
```

- disable history
- edit configuration file `~/.config/clipster/clipster.ini`

```ini
[clipster]

# Number of items to save in the history file for each selection.
# 0 - don't save history.
history_size = 0
```

### redshift

- [arch wiki - redshift](https://wiki.archlinux.org/title/redshift)
- install redshift

```shell
pacman -S redshift
```

- add location to configuration file `~/.config/redshift/redshift.conf`

```ini
[redshift]
location-provider=manual

[manual]
lat=33.78
lon=-84.39
```

- can get coordinates with [geonames.org](http://www.geonames.org/)
- note: to convert `xxo yy' zz"` to decimal find `xx + yy/60 + zz/3600`
  (hours minutes seconds)
- note: north and east are positive, south and west are negative
- can also use google maps, right-click location
- start system service

```shell
systemctl --user status redshift.service
```

### LaTeX

- [arch wiki - TeX Live](https://wiki.archlinux.org/title/TeX_Live)
- really the only required package

```shell
pacman -S texlive-core
```

- install a lot of TeX live packages

```shell
pacman -S texlive-most
pacman -S texlive-lang
```

- install [biber](https://www.ctan.org/pkg/biber?lang=en) (biblatex backend)

```shell
pacman -S biber
```

- tlmgr (tex live package manager) is broken, can install alternative

```shell
paru -S tllocalmgr-git
```

- but let's be real, how often do you install something with tlmgr?

### PDF viewer

- [arch wiki - PDF, PS and DjVu](https://wiki.archlinux.org/title/PDF,_PS_and_DjVu)

#### zathura

- [arch wiki - zathura](https://wiki.archlinux.org/title/Zathura)
- [zathura](https://pwmt.org/projects/zathura/) is popular (vim keybinds etc.)

```shell
pacman -S zathura
```

- install specific formats (muPDF backend for PDF), comic book (`.cbz`), etc.

```shell
pacman -S zathura-pdf-mupdf
pacman -S zathura-cb
```

#### sioyek

- relatively new viewer [sioyek](https://sioyek.info/) explicitly
  designed for scientific use (research papers, technical books)

```shell
paru -S sioyek
```

- pretty good, out-of-the-box integration with
  [vimtex](https://github.com/lervag/vimtex)

```vim
let g:vimtex_view_method = 'sioyek'
```

#### simulating greyscale/colorblindness

- [siam](https://epubs.siam.org/journal-authors#illustrations)
  prints in black/white, preview how the document will look
- greyscale: use [mupdf](https://superuser.com/questions/1182578/how-to-convert-pdf-to-grayscale-through-mutool-mupdf-tools),
  package `mupdf-tools`

```shell
mutool draw -c gray -o "output%d.png" input.pdf
```

- colorblind: use [gimp](https://docs.gimp.org/2.10/en/gimp-display-filter-dialog.html#gimp-deficient-vision),
  package `gimp`

### wine

- [arch wiki - wine](https://wiki.archlinux.org/title/Wine)
- this section will be mainly focused on running visual novels,
  see [eshrh's
  gist](https://gist.github.com/eshrh/5bbf4deab58fefdab9eacf77b450efc0)
- also see [TheMoeWay - Visual novels on Linux](https://learnjapanese.moe/vn-linux/)
- need Japanese locale for most games, so generate the locale
- edit `/etc/locale.gen` and uncomment `ja_JP.UTF-8 UTF-8`, run `locale-gen`

```shell
locale-gen
```

- enable the [multilib
  repository](https://wiki.archlinux.org/title/Official_repositories#multilib)
  by uncommenting the right section in `/etc/pacman.conf`

```config
[multilib]
Include = /etc/pacman.d/mirrorlist
```

- install wine

```shell
pacman -S wine
```

- install optional dependencies
- install winetricks (basically a package manger inside wine)

```shell
pacman -S winetricks
```

- install zenity (GUI for winetricks, you could just use the CLI)

```shell
pacman -S zenity
```

- `wine-mono` for .NET

```shell
pacamn -S wine-mono
```

- if getting an error about `ntlm_auth` when
  installing things with `winetricks`, install samba

```shell
pacman -S samba
```

- most visual novels are 32-bit, so set `WINEARCH` to `win32`

```fish
set -gx WINEARCH win32
```

- opt out of microsoft [.NET telemetry](https://docs.microsoft.com/en-us/dotnet/core/tools/telemetry)

```fish
set -gx DOTNET_CLI_TELEMETRY_OPTOUT 1
```

- set windows version to windows XP, sometimes helpful

```shell
winecfg
```

- "Applications" -> "Windows Version:" change to "Windows XP"

#### extra packages and fonts

- if game doesn't work, try installing more libraries

```shell
pacman -S giflib lib32-giflib libpng lib32-libpng libldap lib32-libldap gnutls lib32-gnutls mpg123 lib32-mpg123 openal lib32-openal v4l-utils lib32-v4l-utils libpulse lib32-libpulse libgpg-error lib32-libgpg-error alsa-plugins lib32-alsa-plugins alsa-lib lib32-alsa-lib libjpeg-turbo lib32-libjpeg-turbo sqlite lib32-sqlite libxcomposite lib32-libxcomposite libxinerama lib32-libgcrypt libgcrypt lib32-libxinerama ncurses lib32-ncurses libxslt lib32-libxslt libva lib32-libva gtk3 lib32-gtk3 gst-plugins-base-libs lib32-gst-plugins-base-libs lib32-gst-plugins-good vulkan-icd-loader lib32-vulkan-icd-loader
```

- if game doesn't work, try installing more libraries with winetricks

```shell
winetricks d3dx9 dirac dotnet35 dotnet40 dxvk lavfilters vcrun2003 vcrun2005 vcrun2008
```

- disable wine DLL overrides

```shell
winetricks alldlls=default
```

- start winetricks

```shell
winetricks
```

- "Select the default wineprefix" -> "Install
  a font" -> check `cjkfonts` and `corefonts`

#### running a game

- mount `.iso` as usual, unpack

```shell
sudo mount game.iso /mnt
sudo cp -r /mnt/* game/
```

- run game

```shell
LC_ALL="ja_JP.UTF-8" TZ="Asia/Tokyo" wine game.exe
```

- kill game

```shell
wineserver --kill
```

#### CDemu

- if error along the lines of "disk not plugged in"
- try restarting
- if that doesn't work, use [cdemu](http://www.cdemu.org/)

```shell
sudo pacman -S cdemu-client cdemu-daemon
```

- start daemon

```shell
cdemu-daemon
```

- mount iso

```shell
cdemu load 0 game.iso
```

- check mount point

```shell
lsblk
```

- for me, either `/dev/sr0` or `/dev/sr1`, check by
  file size / run `lsblk` before loading and after
- mount

```shell
mount /dev/sr0 /mnt
```

- add mount point to wine

```shell
winecfg
```

- "Drives" -> "Add...", pick arbitrary letter ("E:" is
  typical), change "Path:" or click on "Browse..." to `/mnt`
- [run game](#running-a-game) as usual, hopefully just works
