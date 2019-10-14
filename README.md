# Configuration 

![ss.png](https://github.com/stephen-huan/macos_dotfiles/ss.png "Screenshot of environment")

Primarily used for [Yabai](https://github.com/koekeishiya/yabai). Includes [skhd](https://github.com/koekeishiya/skhd), [karabiner](https://pqrs.org/osx/karabiner/index.html), and some miscellaneous things.

Follow the instructions at the [Yabai wiki](https://github.com/koekeishiya/yabai/wiki) to get started (they're very helpful and unfortunately Google is not).

### [Kitty](https://sw.kovidgoyal.net/kitty/) (terminal emulator):

To theme follow the helpful [instructions](https://github.com/dexpota/kitty-themes)
(I use Tango Light).

Set opacity by editing the config at ~/.config/kitty/kitty.conf. 

### [Ranger](https://ranger.github.io/) (file manager)

Getting ranger to do image previews via kitty:

1. `brew install ranger` (this installs it with Python 2.7)
2. `pip2 install Pillow`
3. `ranger --copy-config rc` to copy the default config file to ~/.config/ranger/rc.conf
4. `export RANGER_LOAD_DEFAULT_RC=false` to prevent double loading
5. `set preview_images true` and `set preview_images_method kitty`

Alternatively (won't depreciate in 2020 but isn't global):
1. `pip install ranger-fm Pillow`
2. Follow the same instructions as before

### Miscellaneous Tips

Kill desktop enviornment via `defaults write com.apple.finder CreateDesktop false`
and reset finder via `killall Finder`.
