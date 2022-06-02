# MacOS-Specific Tips

Who needs a desktop environment with a tiling window manger? Kill the desktop
environment via `defaults write com.apple.finder CreateDesktop false` and
reset Finder via `killall Finder`. The background and all files are preserved.

- Hide the menu bar by going to
  System Preferences -> General -> hide and show the menu bar
- Hide the dock by
  System Preferences -> Dock -> hide and show the Dock
- Minimize transitions by
  System Preferences -> Accessibility -> Display -> Reduce motion

I don't recommend this, but if there are random transitions between
desktops, disable application focus switching with System Preferences
-> Mission Control -> When switching to an application, switch to a
Space with open windows for the application. Note that this prevents
switching for something like Spotlight. Also, run:
```console
defaults write com.apple.Dock workspaces-auto-swoosh -bool no
```

## Finder

Run `osascript -e 'tell app "Finder" to quit'` to kill Finder temporarily,
`osascript -e 'tell app "Finder" to run'` to bring it back, or you can click
on it. Finder can still launch because of other apps, so you could move it
to temporary storage then move it back to reactivate.

How do you move Finder when Catalina now loads
macOS system files on a read only boot partition?
```console
sudo mount -uw /
```
System Integrity Protection (SIP) needs to be
disabled but that's a given for Yabai to work well.

Is macOS broken if you disable Finder? Surprisingly, no. Trash is
broken, Atom -> Reveal in Finder crashes Atom, but other than that
everything seems to be working. It really seems to be just another
file explorer, which I've replaced with ranger.

## Dock

There's no point to disable the Dock if Yabai
breaks so the next best thing is to hide the dock.
```console
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

Something I've noticed is that if a folder, e.g. the Downloads folder, is on
the Dock and an file is added to it, the file will bounce to indicate that it
was downloaded even if `launchanim` is set to false. The way to fix this is to
simply remove the offending folder from the dock.

One thing that's useful about Dock is that it shows open GUI applications,
as opposed to commands like `top` and `htop` which show all processes. You
can replace this functionality by using Swift to query for "regular" apps.
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

Cocoa is a fairly expensive import so I'd recommend compiling
this into an executable via `swiftc -o openapps openapps.swift`.

## Spotlight

Spotlight becomes the main way to launch applications without Dock or
Finder. However, by default, it uses an excessive amount of battery and
violates your privacy by sending data over the internet to 3rd parties.

System Preferences -> Spotlight -> Search Results ->
uncheck Other and Spotlight Suggestions
and uncheck "Allow Spotlight Suggestions in Look up". There should be a info
window on how Spotlight will only use disk from now on and not the internet.

## Launchctl

Yabai may drain battery life (honestly, I think my battery life went
up from not running Finder). What better time to optimize performance?

Check battery by Activity Monitor -> energy.

`cd` into one of these directories
```text
~/Library/LaunchAgents         Per-user agents provided by the user.
/Library/LaunchAgents          Per-user agents provided by the administrator.
/Library/LaunchDaemons         System wide daemons provided by the administrator.
/System/Library/LaunchAgents   OS X Per-user agents.
/System/Library/LaunchDaemons  OS X System wide daemons.
```

and run `launchctl unload -wF com.whatever` to stop it from running.
Sometimes you have to run `launchctl disable domain/com.whatever` where
domain is `system`, `gui/uid`, `user/uid`, and other options. Get your
uid by running `id -u`.

`ps aux | grep whatever` to see whether something is still running.

Another (untested) way to disable an application:
run `sudo chmod 000` (755 to revert).

