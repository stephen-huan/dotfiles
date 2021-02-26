# [vim](https://www.vim.org/)

First, install [vim-plug](https://github.com/junegunn/vim-plug) with:
```bash
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
```

Then, run `:PlugInstall` to install the various plugins.

### neovim
[neovim](https://neovim.io/) is a fork of vim focused on extensibility and
usability. It's an almost drop-in replacement for vim, although there are
minor differences (you can't literally copy your vimrc into a init.vim).
Although it's nice for a few specific things, e.g. as a man page parser:
```shell
set MANPAGER /usr/local/bin/nvim -u ~/.config/nvim/init-pager.vim +Man!
```
there's not really a "killer feature" that would make me prefer it over
vim. It has slightly slower startup times so I stick with vanilla vim.

## Getting Started
Run `vimtutor` for a command-line tutor.
Then, read the user manual by starting vim and running `:help user-manual`.
Warning: it takes a long time to be proficient
(e.g. I still move around 99% of the time with arrow keys).

## Security-conscious Editing
If you're editing passwords, important emails, or other sensitive
information, it's best to have a different configuration so that you
sandbox vim. By default, vim generates swap files, backup files, etc.
and will load modelines which have had and continue to have [security
vulnerabilities](https://lwn.net/Vulnerabilities/20249/).

Alias this to `vim-private`, which you can then use as an value for `EDITOR`.
The commands in `vimrc-private` were taken from this 
[stackexchange](https://vi.stackexchange.com/questions/6177/the-simplest-way-to-start-vim-in-private-mode).
```bash
/usr/local/bin/vim --clean --noplugin -nu ~/.vim/vimrc-private
```

## macOS Integration
Make an application with Automator from the tips given
[here](https://gregrs-uk.github.io/2018-11-01/open-files-neovim-iterm2-macos-finder/).
When launching Automator, pick "application" as the type,
and add a new "Run AppleScript" task.
Copy the `applications/vim-kitty.swift` file into the task and
press "export" in the menu bar options to create a new application.
This application can now be set as the default application to open files in,
and double clicking on an appropriate file in Finder will now open it in a
kitty window, which contains an instance of vim.
Changing the icon of the application can be done by opening the image you want
as an icon in Preview, copying to clipboard, right clicking on the application,
"Get Info", click on the icon in the top left, and pasting with command-v. 

