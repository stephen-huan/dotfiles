# dotfiles management

Check out [dotfiles.github.io](https://dotfiles.github.io/)
and [yet another dotfiles manager (yadm)](https://yadm.io/#).

I can't really figure out yadm (it's just a git repo?) so I ended
up using [rcm](https://github.com/thoughtbot/rcm). It's simple,
it works, but the documentation is pretty hard to figure out.

## [rcm](https://github.com/thoughtbot/rcm)

`rcm` is a dotfiles manager. Basically you put all your dotfiles in one place
(`~/.dotfiles` by default) and it symlinks everything to its proper place.
It does this with a few implicit rules: it stores files in the `~/.dotfiles`
folder _without_ a dot, e.g. `~/.vimrc` is saved as `~/.dotfiles/vimrc`. When
symlinking a path, a dot is always added on to the front (unless explicitly
told otherwise) and file paths are preserved. For example, `~/.dotfiles/vimrc`
is linked to `~/.vimrc` and `~/.dotfiles/config/fish/config.fish` becomes
`~/.config/fish/config.fish`. If it really wanted to be general, it'd maintain
a key-value store to map dotfiles path to a target path but the current system
works well enough.

For all the commands, add `-v` to see what's going on.

- `lsrc`: list files tracked by `rcm` (i.e. files in `~/.dotfiles`).

- `mkrc`: move a file to `~/.dotfiles` and symlink.

`mkrc ~/.vimrc` would move `~/.vimrc` to `~/.dotfiles/vimrc` and link. 

`mkrc ~/.config/fish/config.fish` would move `config.fish` to `~/.dotfiles/config/fish/config.fish` 

You can move files by hand and symlink later with the next command.

- `rcup`: symlink everything.

- `rcdn`: remove symlinks.

