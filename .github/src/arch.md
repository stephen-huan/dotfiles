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

- set screen brightness (0-255)

```shell
echo 127 | sudo tee /sys/class/backlight/amdgpu_bl0/brightness
```

- set keyboard backlight (0-2)

```shell
echo 0 | sudo tee /sys/devices/platform/tuxedo_keyboard/leds/white:kbd_backlight/brightness
```

## UEFI

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

## USB

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

## internet/networking

- [arch wiki - network configuration](https://wiki.archlinux.org/title/Network_configuration)
- wifi: [iwd](/pkgs/os-specific/linux/iwd.md)
- [ethernet](#ethernet)
- dhcp: [dhclient](/pkgs/tools/networking/dhcpcd.md)
  or [dhcp](/pkgs/tools/networking/dhcp.md) (deprecated)
- [dns](#dns): [openresolv](/pkgs/tools/networking/openresolv.md) +
  [unbound](/pkgs/tools/networking/unbound.md)
- vpn: [mullvad](/pkgs/tools/networking/mullvad.md),
  [openconnect](./pkgs/tools/networking/openconnect.md)

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

### DNS

- [arch wiki - domain name resolution](https://wiki.archlinux.org/title/Domain_name_resolution)
- if just need quick functional DNS to install
  other things: [systemd-resolved](#systemd-resolved)
- good DNS: [openresolv](/pkgs/tools/networking/openresolv.md) +
  [unbound](/pkgs/tools/networking/unbound.md)
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

#### nsdo

- [github - nsdo](https://github.com/ausbin/nsdo)
- might be nice

## Audio

- [arch wiki - sound system](https://wiki.archlinux.org/title/Sound_system)
- [ALSA](/pkgs/os-specific/linux/alsa-project.md): kernel driver
- [PipeWire](/pkgs/development/libraries/pipewire.md)/[PulseAudio](/pkgs/servers/pulseaudio.md)
  on top
- bluetooth: [bluez](/pkgs/os-specific/linux/bluez.md)
- mpris: [playerctl](/pkgs/tools/audio/playerctl.md)

### Music applications

- [cmus](/pkgs/applications/audio/cmus.md)
- [cider](/pkgs/applications/audio/cider.md)
- [Apple Music](#apple-music)
- [iTunes](#itunes)

#### Apple Music

- use web client: [music.apple.com](https://music.apple.com/)
- pros: no installation/configuration
- cons: many
  - need apple device for 2fa sign in
    - this is not true
  - feels slow/clunky
  - randomly breaks
  - doesn't store place

#### iTunes

- this is possible to wine but is broken on the latest version
- black screen from some rendering issue
- <https://www.theiphonewiki.com/wiki/ITunes>
- doesn't seem to be able to import many things, randomly crashes
- <https://forums.linuxmint.com/viewtopic.php?t=292556>
- <https://wiki.archlinux.org/title/IOS>
- <https://libimobiledevice.org/>
- <https://github.com/libimobiledevice/ifuse>
- <https://github.com/libimobiledevice/ifuse/issues/63>
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

## Security

- pgp: [gnupg](/pkgs/tools/security/gnupg.md)
- hardware security key: [yubikey](/pkgs/tools/misc/yubikey-manager.md)
- password manger: [pass](/pkgs/tools/security/pass.md)
- git authentication: [git-credential-manager](/pkgs/applications/version-management/git-credential-manager.md)
  or [pass-git-helper](./pkgs/applications/version-management/pass-git-helper)

## input

- keyboard firmware: [tmk/qmk](./pkgs/tools/misc/qmk.md)
- remapping: [xkb](./pkgs/servers/x11/xorg.md#xkb)
- ime: [ibus](/pkgs/tools/inputmethods/ibus.md) with
  [mozc](/pkgs/tools/inputmethods/ibus-engines/ibus-mozc.md)

## Miscellaneous

### Proper naming

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

### Screen capture

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

### PDF viewers

- [arch wiki - PDF, PS and DjVu](https://wiki.archlinux.org/title/PDF,_PS_and_DjVu)
- [sioyek](/pkgs/applications/misc/sioyek.md) or
  [zathura](/pkgs/applications/misc/zathura.md) or
  [mupdf](/pkgs/applications/misc/mupdf.md)
