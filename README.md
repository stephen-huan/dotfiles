# Configuration 

![yabai.png](https://raw.githubusercontent.com/stephen-huan/macos_dotfiles/master/screenshots/yabai.png "Screenshot of environment")
![vim_tmux.png](https://raw.githubusercontent.com/stephen-huan/macos_dotfiles/master/screenshots/vim_tmux.png "vim + tmux")

Primarily used for [Yabai](https://github.com/koekeishiya/yabai). Includes 
[spacebar](https://github.com/somdoron/spacebar),
[skhd](https://github.com/koekeishiya/skhd), 
[karabiner](https://pqrs.org/osx/karabiner/index.html), 
[vim](https://www.vim.org/), 
[tmux](https://github.com/tmux/tmux/wiki), 
and some miscellaneous things.

Follow the instructions at the [Yabai wiki](https://github.com/koekeishiya/yabai/wiki) to get started, as they're very helpful and unfortunately Google is not - Yabai isn't very popular.

This isn't a systematic layout so I can replicate my setup on another computer; this is an ad hoc file sharing protocal.

### [Kitty](https://sw.kovidgoyal.net/kitty/) (terminal emulator):

To theme follow the helpful [instructions](https://github.com/dexpota/kitty-themes); I use Tango Light.

Set opacity by editing the config at ~/.config/kitty/kitty.conf. 

### [Ranger](https://ranger.github.io/) (file manager)

Getting ranger to do image previews via kitty:

1. `brew install ranger` (this installs it with Python 2.7)
2. `pip2 install Pillow`
3. `ranger --copy-config rc` to copy the default config file to ~/.config/ranger/rc.conf
4. `export RANGER_LOAD_DEFAULT_RC=false` to prevent double loading
5. `set preview_images true` and `set preview_images_method kitty`

Alternatively, as Python 2.7 is depreciating in 2020:
1. `pip install ranger-fm Pillow` with a Python 3 pip
2. Follow the same instructions as before
3. Alias ranger to the actual path of the ranger executable if you're using pyenv.

#### Image Preview

Set the variable `preview_images` to true and `preview_images_method` to kitty.
Note that it leaves a black rectange in some cases if you quit ranger while on an image (most notably, vim). To fix this, press the left arrow before exiting ranger to unload the image.

#### Syntax Highlighting

`brew install highlight`. To pick a theme, copy the scope via `ranger --copy-config=scope` and edit the variable `HIGHLIGHT_STYLE` near the top. To use a base16 theme, replace the highlight command near the bottom. You can also enable video preview via thumbnails by uncommenting the block (`brew install ffmpegthumbnailer`) and pdf image previews by `pip install pdftoppm` (install the dependancies via `brew install pkg-config poppler`).

### Fonts

The default status bar uses font icons, install the font by double clicking on final.ttf, which was constructed from [feather.ttf](https://github.com/AT-UI/feather-font) and [alt.ttf](https://github.com/oblador/react-native-vector-icons/blob/master/Fonts/Feather.ttf). The first was missing the coffee icon, the second had weirdly glitched icons for some of them. Merged together via [FontForge](https://fontforge.github.io/en-US).

### Miscellaneous Tips

Kill the desktop environment via `defaults write com.apple.finder CreateDesktop false`
and reset finder via `killall Finder`. Who needs a desktop when you have a tiling window manger? Image and files are preserved.

Hide the menu bar by going to System Preferences -> General -> hide and show the menu bar

Hide the dock by System Preferences -> Dock -> hide and show the Dock

Minimize transitions by System Preferences -> Accessibility -> Display -> Reduce motion

Recently, there are sometimes random transitions between desktops.
Disable application focus switching with System Preferences -> Mission Control -> 
When switching to an application, switch to a Space with open windows 
for the application. Note that this prevents switching for something like
Spotlight.
Also, run: 
```bash
defaults write com.apple.Dock workspaces-auto-swoosh -bool no
```

#### Finder

Run `osascript -e 'tell app "Finder" to quit'` to kill Finder (semi-permanently), `osascript -e 'tell app "Finder" to run'` to bring it back, or you can click on it. Finder can still launch because of other apps, so you could move it to temporary storage then move it back to reactivate.

Is macOS broken if you disable Finder? Surprisingly not. Trash is broken, Atom -> Reveal in Finder crashes Atom, but other than that everything seems to be working. It really seems to be just another file explorer, which I've replaced with ranger.

#### Dock

Yabai relies on Dock so this is a bit questionable. The Finder trick doesn't work as it regenerates itself, so the only thing left is to move it; unfortunately that is also impossible as Catalina now loads macOS on a read only boot partition.

Yabai breaks if Dock doesn't exist anyways so the next best thing is to hide the dock.

```
# Hide Dock
defaults write com.apple.dock autohide -bool true 
defaults write com.apple.dock autohide-delay -float 1000 
defaults write com.apple.dock launchanim -bool false 
killall Dock

# Restore Dock
defaults write com.apple.dock autohide -bool false 
defaults delete com.apple.dock autohide-delay 
defaults write com.apple.dock launchanim -bool true 
killall Dock
```

It's helpful to then run the fast yabai reset (`launchctl kickstart -k "gui/${UID}/homebrew.mxcl.yabai"` compared to `brew services restart yabai`).

Something I've noticed is that if a folder, e.g. the Downloads folder is on the Dock and an file is added to it, the file will bounce to indicate that it was downloaded even if launchanim is set to false. The way to fix it is to simply remove the offending folder from the dock.

One thing that's useful about Dock is that it shows open GUI applications, as opposed to commands like top and htop which show all processes. 
You can replace this functionality by using Swift to query for "regular" apps.

```
#!/usr/bin/env swift
import Cocoa

let apps = NSWorkspace.shared.runningApplications
for app in apps {
    if (app.activationPolicy == .regular) {
      print((app.localizedName ?? "Anonymous") + " (" + String(app.processIdentifier) + ")")
    }
}
```

Cocoa is a fairly expensive import so I'd recommend compiling this into an execeutable via `swiftc -o openapps openapps.swift`.

#### Spotlight

Spotlight becomes the main way to launch applications once there is no Dock or Finder. However, by default, it uses a ridiculous amount of battery and violates your privacy by sending data over the internet to Apple, Bing, Google, etc. 

System Preferences -> Search Results -> uncheck Other and Spotlight Suggestions and uncheck "Allow Spotlight Suggestions in Look up".
There should be a info window on how Spotlight will only use disk from now on and not the internet.

#### Launchctl

Yabai may drain battery life. What better time to optimize performance?

Check battery by activity monitor -> energy.

`cd` into one of these directories

```
~/Library/LaunchAgents         Per-user agents provided by the user.
/Library/LaunchAgents          Per-user agents provided by the administrator.
/Library/LaunchDaemons         System wide daemons provided by the administrator.
/System/Library/LaunchAgents   OS X Per-user agents.
/System/Library/LaunchDaemons  OS X System wide daemons.
```

and run `launchctl unload -wF com.whatever` to stop it from running. Sometimes you have to run `launchctl disable domain/com.whatever` where domain is `system`, `gui/uid`, `user/uid`, and other options. Get your uid by running `id -u`.

`ps aux | grep whatever` to see whether something is still running.

Another (untested) way to disable an application: run `sudo chmod 000` (755 to revert).
