# pacman

```shell
sudo pacman -S pacman-contrib
```

- TODO

## reflector

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

## pacgraph

- TODO

## AUR helper [paru]

- [yay](https://github.com/Jguer/yay)
- [paru](https://github.com/morganamilo/paru)
- if migrating from other AUR helper,

```shell
paru --gendb
```

- TODO
