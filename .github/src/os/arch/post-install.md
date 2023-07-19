# post-install

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

- Install [display manager](/pkgs/applications/display-managers/sddm.md)

```shell
sudo pacman -S sddm
```

- Enable display manager

```shell
sudo systemctl enable sddm.service
```

- Install window manager ([i3](/pkgs/applications/window-managers/i3.md))

```shell
sudo pacman -S i3
```

- Install terminal emulator ([alacritty](/pkgs/applications/terminal-emulators/alacritty.md))

```shell
sudo pacman -S alacritty
```

- Enter graphical

```shell
sudo systemctl start sddm.service
```

- If no terminal emulator, can get suck in i3!
- Use `ctrl+alt+F[1-6]` to switch to virtual console
- From virtual console back to graphical

```shell
sudo systemctl restart sddm.service
```
