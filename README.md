# Configuration 

![yabai.png](https://raw.githubusercontent.com/stephen-huan/macos_dotfiles/master/screenshots/yabai.png "Screenshot of environment")
![vim_tmux.png](https://raw.githubusercontent.com/stephen-huan/macos_dotfiles/master/screenshots/vim_tmux.png "vim + tmux")

Primarily used for [Yabai](#yabai-window-manager). Includes 
[spacebar](#spacebar-icons),
[skhd](#skhd-hotkeys), 
[karabiner](#karabiner-keyboard-shortcuts)
[kitty](#kitty-terminal-emulator),
[fish](#fish-shell,
[vim](#vim-text-editor), 
[tmux](https://github.com/tmux/tmux/wiki),
[stubby](#stubby-dns),
[unbound](#unbound-dns),
and some other miscellaneous things.

This isn't a systematic layout so I can replicate my setup on another computer; 
this is an ad-hoc file sharing protocol.

## [Yabai](https://github.com/koekeishiya/yabai) (window manager):

Follow the instructions at the 
[Yabai wiki](https://github.com/koekeishiya/yabai/wiki) to get started, 
as they're very helpful and unfortunately Google is not - 
Yabai isn't very popular.

#### [Spacebar](https://github.com/somdoron/spacebar) Icons

Spacebar is the bar that used to be part of Yabai, but was removed.
The default spacebar status bar uses font icons, 
install the font by double clicking on final.ttf, 
which was constructed from [feather.ttf](https://github.com/AT-UI/feather-font) 
and [alt.ttf](https://github.com/oblador/react-native-vector-icons/blob/master/Fonts/Feather.ttf). 
The first was missing the coffee icon, 
the second had weirdly glitched icons for some of them. 
Merged together via [FontForge](https://fontforge.github.io/en-US).

## [Karabiner](https://pqrs.org/osx/karabiner/index.html) (keyboard shortcuts):

Karabiner is a kernel extension, so it can modify keybindings at a low level.
However, its configuration is through a JSON file,
and the syntax is slightly verbose.
To make it more usable, I created an transpiler from skhd-style syntax
to karabiner syntax. Check the 
[karabiner.py](https://github.com/stephen-huan/macos-dotfiles/blob/master/bin/pybin/karabiner.py) file.
`SOURCE` is a file where `karabiner.py` will add rules onto,
and will put those generated rules into `karabiner.json`, 
which is the file actually interpreted by karabiner. `RULES`
is a skhd-style syntax file, and an example can be found
[here](https://github.com/stephen-huan/macos-dotfiles/blob/master/.config/karabiner/rulesrc)
which utilizes all the implemented features:
any series of modifiers and then a valid karabiner key
can be mapped into another sequence of modifiers and a valid karabiner key,
mapping to multiple different keys can be done with a comma,
and having different behavior when held or tapped can be done. 

Simply run `python karabiner.py` when the variables are set properly
to compile `RULES` and `SOURCE` into `OUTPUT`.

### [skhd](https://github.com/koekeishiya/skhd) (hotkeys):

skhd modifies hotkeys at a higher level than Karabiner, and is used 
for the actual Yabai interaction.
By default, however, it uses the current shell in order to run shell commands.
If your shell is fish, any instance of a fish shell is a fish user shell,
which means it sources your startup configuration. 
This is a problem, because that means every keystroke read by skhd
now takes on the order of 100ms-1 second to execute.
In order to fix this, edit the plist at
`/usr/local/Cellar/skhd/VERSION/homebrew.mxcl.skhd.plist`
by changing the `SHELL` to `/bin/bash`.

## [Kitty](https://sw.kovidgoyal.net/kitty/) (terminal emulator):

To theme follow the helpful 
[instructions](https://github.com/dexpota/kitty-themes); I use Tango Light.

Set opacity by editing the config at ~/.config/kitty/kitty.conf. 

## [Fish](http://fishshell.com/) (shell)

Fish is a non-POSIX compliant shell that can do a lot of interesting things.
Check my [asciinema](https://asciinema.org/~vazae) for inspiration.
Package manager is [fisher](https://github.com/jorgebucaran/fisher)
although it has its quirks (can only update all packages).

## [Ranger](https://ranger.github.io/) (file manager)

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
Note that it leaves a black rectangle in some cases if you quit ranger 
while on an image (most notably, vim).
To fix this, press the left arrow before exiting ranger to unload the image.

#### Syntax Highlighting

`brew install highlight`. 
To pick a theme, copy the scope via `ranger --copy-config=scope` 
and edit the variable `HIGHLIGHT_STYLE` near the top. 
To use a base16 theme, replace the highlight command near the bottom.
You can also enable video preview via thumbnails by uncommenting the block 
(`brew install ffmpegthumbnailer`) and pdf image previews by `pip install pdftoppm` 
(install the dependancies via `brew install pkg-config poppler`).

## [Vim](https://www.vim.org/) (text editor)
First, install [vim-plug](https://github.com/junegunn/vim-plug) with:
```bash
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
```

Then, run `:PlugInstall` to install the various plugins.

#### Getting Started
Run `vimtutor` for a command-line tutor.
Then, read the user manual by starting vim and running `:help user-manual`.
Warning: it takes a long time to be proficient
(e.g. I still move around 99% of the time with arrow keys).

#### Security-conscious Editing
If you're editing passwords, important emails, or other sensitive information,
it's best to have a different configuration so that you sandbox vim.
By default, vim generates swap files, backup files, etc. and will load
modelines which have had in the past and continue to have
[security vulnerabilities](https://lwn.net/Vulnerabilities/20249/).

Alias this to `vim-private`, which you can then use as an value for `EDITOR`.
The commands in `vimrc-private` were taken from this 
[stackexchange](https://vi.stackexchange.com/questions/6177/the-simplest-way-to-start-vim-in-private-mode).
```bash
/usr/local/bin/vim --clean --noplugin -nu ~/.vim/vimrc-private
```

## [Stubby](https://dnsprivacy.org/wiki/display/DP/DNS+Privacy+Daemon+-+Stubby) (DNS) 
It's recommended to use Stubby and Unbound in conjunction
(Stubby for some TLS managing functionality Unbound doesn't have,
and Unbound for the caching of DNS queries).
However, I can't get Stubby to play nice with Unbound and Unbound
seems to do a well enough job on its own.

In order to get [Cloudflare DNS](https://1.1.1.1/) to work with Stubby,
it's necessary to generate TLS pinsets which can be done with the following: 
```bash
echo | openssl s_client -connect 1.1.1.1:853 2>/dev/null | openssl x509 -pubkey -noout | openssl pkey -pubin -outform der | openssl dgst -sha256 -binary | openssl enc -base64
```

### [Unbound](https://dnsprivacy.org/wiki/display/DP/DNS+Privacy+Clients#DNSPrivacyClients-Unbound) (DNS)
To enable DNSSEC, follow the instructions
[here](https://nlnetlabs.nl/documentation/unbound/howto-anchor/).

Basically, to generate the `root.key` file at `/usr/local/etc/unbound` just run 
```bash
sudo unbound-anchor
```

and to generate the `root.hints` file (which is not strictly necessary,
as unbound comes with a default root.hints file, but if your package manager
doesn't update as often, you can update it yourself) run
```bash
curl --output /usr/local/etc/unbound/root.hints https://www.internic.net/domain/named.cache
```

Unbound must be started with sudo to have permissions to bind to its port, 
so run with the following:
```bash
sudo brew services start unbound
```

## MacOS-Specific Tips

Who needs a desktop environment with a tiling window manger?
Kill the desktop environment via 
`defaults write com.apple.finder CreateDesktop false`
and reset Finder via `killall Finder`. 
The background and all files are preserved.

- Hide the menu bar by going to System Preferences -> General -> hide and show the menu bar
- Hide the dock by System Preferences -> Dock -> hide and show the Dock
- Minimize transitions by System Preferences -> Accessibility -> Display -> Reduce motion

I don't recommend this,
but if there are random transitions between desktops, 
disable application focus switching with System Preferences -> Mission Control -> 
When switching to an application, switch to a Space with open windows 
for the application. Note that this prevents switching for something like
Spotlight.
Also, run: 
```bash
defaults write com.apple.Dock workspaces-auto-swoosh -bool no
```

### Finder

Run `osascript -e 'tell app "Finder" to quit'` to kill Finder temporarily, 
`osascript -e 'tell app "Finder" to run'` to bring it back, 
or you can click on it. Finder can still launch because of other apps, 
so you could move it to temporary storage then move it back to reactivate.

How do you move Finder when Catalina now loads 
macOS system files on a read only boot partition?
```bash
sudo mount -uw /
```
System Integrity Protection (SIP) needs to be disabled
but that's a given for Yabai to work well.

Is macOS broken if you disable Finder? Surprisingly, no. 
Trash is broken, Atom -> Reveal in Finder crashes Atom, 
but other than that everything seems to be working. 
It really seems to be just another file explorer, 
which I've replaced with ranger.

### Dock

There's no point to disable the Dock if 
Yabai breaks so the next best thing is to hide the dock.

```bash
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

It's helpful to then run the fast yabai reset 
(`launchctl kickstart -k "gui/${UID}/homebrew.mxcl.yabai"`
compared to `brew services restart yabai`).

Something I've noticed is that if a folder, 
e.g. the Downloads folder is on the Dock and an file is added to it, 
the file will bounce to indicate that it was downloaded
even if `launchanim` is set to false. 
The way to fix this is to simply remove the offending folder from the dock.

One thing that's useful about Dock is that it shows open GUI applications, 
as opposed to commands like `top` and `htop` which show all processes. 
You can replace this functionality by using Swift to query for "regular" apps.

```swift
#!/usr/bin/env swift
import Cocoa

let apps = NSWorkspace.shared.runningApplications
for app in apps {
    if (app.activationPolicy == .regular) {
      print((app.localizedName ?? "Anonymous") + " (" + String(app.processIdentifier) + ")")
    }
}
```

Cocoa is a fairly expensive import so I'd recommend 
compiling this into an executable via `swiftc -o openapps openapps.swift`.

### Spotlight

Spotlight becomes the main way to launch applications without Dock or Finder. 
However, by default, it uses an excessive amount of battery and 
violates your privacy by sending data over the internet to 3rd parties.

System Preferences -> Spotlight -> Search Results -> uncheck Other and Spotlight Suggestions 
and uncheck "Allow Spotlight Suggestions in Look up".
There should be a info window on how Spotlight 
will only use disk from now on and not the internet.

### Launchctl

Yabai may drain battery life
(honestly, I think my battery life went up from not running Finder). 
What better time to optimize performance?

Check battery by Activity Monitor -> energy.

`cd` into one of these directories

```
~/Library/LaunchAgents         Per-user agents provided by the user.
/Library/LaunchAgents          Per-user agents provided by the administrator.
/Library/LaunchDaemons         System wide daemons provided by the administrator.
/System/Library/LaunchAgents   OS X Per-user agents.
/System/Library/LaunchDaemons  OS X System wide daemons.
```

and run `launchctl unload -wF com.whatever` to stop it from running. 
Sometimes you have to run `launchctl disable domain/com.whatever` 
where domain is `system`, `gui/uid`, `user/uid`, and other options. 
Get your uid by running `id -u`.

`ps aux | grep whatever` to see whether something is still running.

Another (untested) way to disable an application: 
run `sudo chmod 000` (755 to revert).

