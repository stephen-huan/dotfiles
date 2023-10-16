# pacman

- [arch wiki - pacman](https://wiki.archlinux.org/title/Pacman)
- [arch wiki - pacman/tips and tricks](https://wiki.archlinux.org/title/Pacman/Tips_and_tricks)

```shell
pacman -S pacman-contrib
```

## basic operations

- update

```shell
pacman -Syu
```

- if using [aur helper](#aur-helper)

```shell
paru
```

- install package ([package search](https://archlinux.org/packages/)
  or search in [aur](https://aur.archlinux.org/packages))

```shell
pacman -S pkgname
```

- if in AUR

```shell
paru -S pkgname
```

- remove package and its dependencies and configuration files

```shell
pacman -Rns pkgname
```

### searching

- package list

```shell
pacman -Q
```

- search for package

```shell
pacman -Qs query
```

- package information

```shell
pacman -Qi pkgname
```

- list of files installed by package

```shell
pacman -Ql pkgname
```

- list aur packages

```shell
pacman -Qm
```

- list explicitly installed packages

```shell
pacman -Qe
```

- list all explicitly installed native packages (not
  aur) that are not direct or optional dependencies

```shell
pacman -Qent
```

### orphans

- list and remove all orphan packages

```shell
pacman -Qtdq | pacman -Rns -
```

- include optional requirements as well

```
pacman -Qttdq
```

- even more aggressive (account for cycles etc.)

```shell
pacman -Qqd | pacman -Rsu --print -
```

### cache

- clear cache (`/var/cache/pacman/pkg/`) except
  for last three versions (from `pacman-contrib`)

```shell
paccache -r
```

- clear cache except for currently installed packages

```shell
pacman -Sc
```

- clear cache completely

```shell
pacman -Scc
```

## rollbacks

- check `/var/cache/pacman/pkg/` for old version
- use `pacman -U pkgname.pkg.tar.zst` if it exists
- otherwise check
  [Arch Linux Archive](https://wiki.archlinux.org/title/Arch_Linux_Archive)
  available at <https://archive.archlinux.org/packages/>

```shell
pacman -U https://archive.archlinux.org/packages/path/packagename.pkg.tar.zst
```

- if downgrade, pin version so pacman doesn't update it
- edit `/etc/pacman.conf` and add package to `IgnorePkg`

```text
# Pacman won't upgrade packages listed in IgnorePkg and members of IgnoreGroup
IgnorePkg   = pkgname
```

## reflector

- [arch wiki - reflector](https://wiki.archlinux.org/title/Reflector)
- install reflector

```shell
pacman -S reflector
```

- automatically update mirrorlist to select fastest mirrors
- edit `/etc/xdg/reflector/reflector.conf`

```text
--save /etc/pacman.d/mirrorlist # set the output path
--protocol https # force https
--country us # set country (get list with `reflector --list-countries`)
--latest 50 # use only the 50 most recently synchronized mirrors (--latest)
--sort rate # sort the mirrors by download speed
```

```shell
sudo systemctl start reflector.service
```

- or

```shell
reflector --protocol https --country us --latest 50 --sort rate --save /etc/pacman.d/mirrorlist
```

- I like `https://iad.mirrors.misaka.one/archlinux/$repo/os/$arch` :)

## AUR helper

- [yay](https://github.com/Jguer/yay)
- [paru](https://github.com/morganamilo/paru)
  - written in rust so it must be better
  - also forces you to check `PKGBUILD`s (which we do read carefully right?)
  - if migrating from other AUR helper
  ```shell
  paru --gendb
  ```

## pacgraph

- [pacgraph](http://kmkeen.com/pacgraph/) makes
  a graph visualization of all installed packages

```shell
paru -S pacgraph
```

- generate graph (svg)

```shell
pacgraph -f packages
```

- convert to png with imagemagick

```shell
convert packages.svg packages.png
```

- or ffmpeg

```shell
ffmpeg -i packages.svg packages.png
```

- mine below

![graph of my packages (18495 MB)](/assets/packages.svg)
