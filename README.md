# Configuration 

![ss.png](https://raw.githubusercontent.com/stephen-huan/macos_dotfiles/master/ss.png "Screenshot of environment")

Primarily used for [Yabai](https://github.com/koekeishiya/yabai). Includes [skhd](https://github.com/koekeishiya/skhd), [karabiner](https://pqrs.org/osx/karabiner/index.html), and some miscellaneous things.

Follow the instructions at the [Yabai wiki](https://github.com/koekeishiya/yabai/wiki) to get started (they're very helpful and unfortunately Google is not).

This isn't a systematic layout so I can replicate my setup on another computer; this is an ad hoc file sharing protocal.

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

### Fonts

The default status bar uses font icons, install the font by double clicking on final.ttf (constructed from [feather.ttf](https://github.com/AT-UI/feather-font) and [alt.ttf](https://github.com/oblador/react-native-vector-icons/blob/master/Fonts/Feather.ttf)). The first was missing the coffee icon, the second had weirdly glitched icons for some of them. Merged together via [FontForge](https://fontforge.github.io/en-US).

### Miscellaneous Tips

Kill the desktop enviornment via `defaults write com.apple.finder CreateDesktop false`
and reset finder via `killall Finder`. Who needs a desktop when you have a tiling window manger?

Hide the menu bar by going to System Preferences -> General -> hide and show the menu bar

Hide the dock by System Preferences -> Dock -> hide and show the Dock

Minimize transitions by System Preferences -> Accessibility -> Display -> Reduce motion
