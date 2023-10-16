# sddm

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

## Theming

- Install theme

```shell
paru -S simplicity-sddm-theme-git
```

- or my [patch](https://gitlab.com/stephenhuan/simplicity-sddm-theme) that
  fixes an issue where username was empty if real name was not set
  - currently merged
- Themes go in `/usr/share/sddm/themes/` by default
- Can edit theme settings by copying default theme file
  `/usr/share/sddm/themes/simplicity/theme.conf` to
  `/usr/share/sddm/themes/simplicity/theme.conf.user` and making custom changes

## Profile Icon

- Add a PNG file `username.face.icon` to `/usr/share/sddm/faces/`
- Or create `~/.face.icon` and let SDDM find it:

```shell
setfacl -m u:sddm:x ~/
setfacl -m u:sddm:r ~/.face.icon
```
