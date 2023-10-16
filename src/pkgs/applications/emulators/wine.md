# wine

- [arch wiki - wine](https://wiki.archlinux.org/title/Wine)
- this section will be mainly focused on running visual novels,
  see [eshrh's gist](https://gist.github.com/eshrh/5bbf4deab58fefdab9eacf77b450efc0)
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

## extra packages and fonts

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

## running a game

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

## CDemu

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
