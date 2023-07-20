# clipboard

- [arch wiki - clipboard](https://wiki.archlinux.org/title/Clipboard)
- managed by X, `PRIMARY`, `CLIPBOARD`, and `SECONDARY` selections
  - `PRIMARY`: selected text, i.e. highlighted by mouse
  - `CLIPBOARD`: text that is explicitly copied (e.g. by `ctrl-c`)
  - `SECONDARY`: no agreed upon purpose
- install [xclip](https://github.com/astrand/xclip), command-line interface

```shell
pacman -S xclip
```

- by default, clipboard contents lost if application is closed
- this is because X only stores references to the data, not copies
- see [ubuntu wiki - ClipboardPersistence](https://wiki.ubuntu.com/ClipboardPersistence)
- see this [reddit post](https://www.reddit.com/r/archlinux/comments/9tkvsl/persistent_clipboard/),
  recommends `clipmenu`.
- however, I can't get `clipmenu` to work and there's a security
  concern: copying passwords/sensitive information to clipboard; most
  clipboard managers (including `clipmenu`) store data on disk as plaintext
- install [clipster](https://github.com/mrichar1/clipster)

```shell
paru -S clipster
```

- disable history
- edit configuration file `~/.config/clipster/clipster.ini`

```ini
[clipster]

# Number of items to save in the history file for each selection.
# 0 - don't save history.
history_size = 0
```

## detailed notes

For a general overview of the X window system's approach to the
[clipboard](https://wiki.archlinux.org/title/Clipboard), see [Arch
wiki - clipboard](https://wiki.archlinux.org/title/Clipboard). The
summary is that the clipboard is managed by X, and has three distinct
_selections_: `PRIMARY`, `CLIPBOARD`, and `SECONDARY` selections:

- `PRIMARY`: selected text, i.e. highlighted by mouse
- `CLIPBOARD`: text that is explicitly copied (e.g. by ctrl-c)
- `SECONDARY`: no agreed upon purpose

In order to manage these selections, install some command-line
tools like [xclip](https://github.com/astrand/xclip).

```shell
pacman -S xclip
```

For example, to copy a screenshot (taken with the package
[maim](https://github.com/naelstrof/maim)) to the clipboard you can use:

```shell
maim --select --nodrag | xclip -selection clipboard -target image/png
```

Packages will also use [xsel](https://vergenet.net/~conrad/software/xsel/), so
you'll probably have both installed even if you don't explicitly install them.

```shell
pacman -S xsel
```

By default, the clipboard contents are lost if the application you got the data
from is closed. For example, if you open a terminal window, type some text into
it, and copy the text, you can paste the text somewhere else. But if you close
the terminal window, you can no longer paste the text --- it is lost. This is
because X only stores _references_ to the data, not copies. See the [Ubuntu
wiki - ClipboardPersistence](https://wiki.ubuntu.com/ClipboardPersistence)
for more information as well as this this [reddit post](https://www.reddit.com/r/archlinux/comments/9tkvsl/persistent_clipboard/). The
Ubuntu article recommends Parcellite while the Reddit post recommends clipmenu.
The [Arch wiki](https://wiki.archlinux.org/title/Clipboard#Managers) also has
a list of clipboard managers. I tried a lot of these, and here's my commentary.

For most clipboard managers, they don't solve the aforementioned persistence
issue. Instead, they maintain a history of everything that is copied, and
if you lose your selection, you can use a command-line interface or open
a GUI to select a previous entry and re-copy it to your clipboard. But I
don't want to have to manually re-copy the last thing I copied, I just want
to be able to keep the entry in my clipboard if I close the application. I
couldn't get [clipmenu](https://github.com/cdown/clipmenu/), the program
mentioned in the Reddit post to work like this, and I also couldn't get
[clipcat](https://github.com/xrelkd/clipcat) to work.

[xclipboard](https://www.x.org/releases/X11R7.5/doc/man/man1/xclipboard.1.html), the
official X clipboard manager works, but it always launches a GUI window that
it seems can't be suppressed. [Parcellite](http://parcellite.sourceforge.net/)
works but it's a bit old and relies on GTK2. A modern replacement
is [ClipIt](https://github.com/CristianHenzel/ClipIt), but when I
used it reminded me that there was a security concern: I sometimes
copy passwords and other sensitive information to the clipboard,
and all of these clipboard managers store data on disk as plaintext
in a temporary directory. I wanted to find a clipboard manager that
supported clipboard persistence without manual intervention while only
storing data in memory and not disk. I settled on Clipster.

### copy/paste

Interestingly enough, one can also use the open-source
[qmk](https://github.com/qmk/qmk_firmware/) firmware to bind physical keys
to copy/paste. The relevant [keycodes](https://docs.qmk.fm/#/keycodes)
are `KC_CUT`, `KC_COPY`, and `KC_PASTE`. The X keyboard event viewer
`xev` (`pacman -S xorg-xev`) shows that these are mapped to `XF86Cut`
(145) `XF86Copy` (141), and `XF86Paste` (143). Support for these keys
seems to be built-in to X as well as most GUI applications.
