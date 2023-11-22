# clipboard

For an overview of the X window system's approach to the clipboard, see [Arch
wiki - clipboard](https://wiki.archlinux.org/title/Clipboard). The summary
is that the clipboard is managed by X, and has three distinct _selections_.

- `PRIMARY`: selected text, i.e. highlighted by mouse,
- `CLIPBOARD`: text that is explicitly copied (e.g. by `ctrl-c`),
- `SECONDARY`: no agreed upon purpose.

In order to manage these selections, install some command-line
tool like [xclip](https://github.com/astrand/xclip).

```shell
pacman -S xclip
```

For example, to copy a screenshot (taken with the package
[maim](https://github.com/naelstrof/maim)) to the clipboard,

```shell
maim --select --nodrag | xclip -selection clipboard -target image/png
```

Packages might also use [xsel](https://vergenet.net/~conrad/software/xsel/),
so it's probably best to have both installed.

```shell
pacman -S xsel
```

## losing history

By default, the clipboard contents are lost if the application the is data from
is closed. For example, if one opens a terminal window, types some text, then
copies the text, it can be pasted somewhere else. But once the terminal window
is closed, one can no longer paste the text --- it is lost.

This is because X only stores _references_ to the data, not copies.
See the [Ubuntu wiki](https://wiki.ubuntu.com/ClipboardPersistence)
for more information as well as this
[Reddit post](https://www.reddit.com/r/archlinux/comments/9tkvsl/persistent_clipboard/).
The Ubuntu article recommends Parcellite while the Reddit post recommends
clipmenu. The [Arch wiki](https://wiki.archlinux.org/title/Clipboard#Managers)
also has a list of clipboard managers.

Most clipboard managers don't directly solve the persistence issue. Instead,
they maintain a history of everything that is copied, and if the selection is
lost, one can use a command-line interface or open a GUI to select a previous
entry and re-copy it to the clipboard.

But I don't want to have to manually re-copy the last thing I copied, I
just want to be able to keep the entry in my clipboard if I close the
application. I couldn't get [clipmenu](https://github.com/cdown/clipmenu/)
or [clipcat](https://github.com/xrelkd/clipcat) to work like this.

[xclipboard](https://www.x.org/releases/X11R7.5/doc/man/man1/xclipboard.1.html),
the official X clipboard manager works, but it always
launches a GUI window that can't be easily suppressed.
[Parcellite](http://parcellite.sourceforge.net/) works
but it's old and relies on GTK2. A modern replacement is
[ClipIt](https://github.com/CristianHenzel/ClipIt), but when I used it
reminded me that there was a security concern: I sometimes copy passwords
and other sensitive information to the clipboard, and all of these clipboard
managers store data on disk as plaintext in a temporary directory. I wanted
to find a clipboard manager that supported clipboard persistence without
manual intervention while storing data only in memory, never touching disk.

For these reasons, I settled on [clipster](/pkgs/tools/misc/clipster.md).

## copy/paste

One can use the open-source [tmk/qmk](https://github.com/qmk/qmk_firmware/)
firmware to bind physical keys to copy/paste. The relevant
[keycodes](https://docs.qmk.fm/#/keycodes) are `KC_CUT`, `KC_COPY`, and
`KC_PASTE`. The X keyboard event viewer `xev` (`pacman -S xorg-xev`)
shows that these are mapped to `XF86Cut` (145) `XF86Copy` (141), and
`XF86Paste` (143), respectively. Support for these keys seems to be
built-in to X as well as most GUI applications.
