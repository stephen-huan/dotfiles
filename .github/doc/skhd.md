# [skhd](https://github.com/koekeishiya/skhd)

skhd modifies hotkeys at a higher level than Karabiner,
and is used for the actual Yabai interaction.

By default, however, it uses the current shell in order to run shell
commands. If your shell is fish, any instance of a fish shell is a fish
user shell, which means it sources your startup configuration. This is
a problem, because that means every keystroke read by skhd now takes on
the order of 100ms-1 second to execute. In order to fix this, edit the
plist at `/usr/local/Cellar/skhd/VERSION/homebrew.mxcl.skhd.plist` by
changing the `SHELL` to `/bin/bash`.

