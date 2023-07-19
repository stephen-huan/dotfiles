# dotfiles management

See [dotfiles.github.io](https://dotfiles.github.io/).

## Home Manager

[Home manager](https://nix-community.github.io/home-manager/) is a system for
managing user files with tools from the [Nix](https://nixos.org/) ecosystem.
In particular, it allows packages to be installed declaratively with Nix and
exposes Nix modules for configuration. As a result, in inherits the benefits
of Nix (reproducibility, safe rollbacks, atomic transactions, etc.).

The practical implication is that configuration files are now stored
read-only in the Nix store (`/nix/store/*`), generated from a
declarative configuration which can be version controlled with git.

## yadm

[`yadm`](https://yadm.io/) uses `git` to avoid symlinking. You edit
files in `$HOME` as usual and use `yadm add` to add them to tracking.
yadm stores its git repository in `~/.local/share/yadm/repo.git`, so
if you have an existing dotfiles repository you can copy its `.git`
to that path. Because yadm restricts itself to `$HOME`, file paths
are simple --- they just mirror your actual `$HOME`. `yadm` itself
is just as thin wrapper over `git` with some extra features.

Finally, `yadm bootstrap` allows `~/.config/yadm/bootstrap`
to be executed after install.

```shell
yadm bootstrap
```

## rcm

It's simple, it works, but the documentation is pretty hard to figure out.

[`rcm`](https://github.com/thoughtbot/rcm) is a dotfiles manager. Basically
you put all your dotfiles in one place (`~/.dotfiles` by default) and it
symlinks everything to its proper place. It does this with a few implicit
rules: it stores files in the `~/.dotfiles` folder _without_ a dot, e.g.
`~/.vimrc` is saved as `~/.dotfiles/vimrc`. When symlinking a path, a dot is
always added on to the front (unless explicitly told otherwise) and file paths
are preserved. For example, `~/.dotfiles/vimrc` is linked to `~/.vimrc` and
`~/.dotfiles/config/fish/config.fish` becomes `~/.config/fish/config.fish`.
If it really wanted to be general, it'd maintain a key-value store to map
dotfiles path to a target path but the current system works well enough.

For all the commands, add `-v` to see what's going on.

- `lsrc`: list files tracked by `rcm` (i.e. files in `~/.dotfiles`).

- `mkrc`: move a file to `~/.dotfiles` and symlink.

`mkrc ~/.vimrc` would move `~/.vimrc` to `~/.dotfiles/vimrc` and link.

`mkrc ~/.config/fish/config.fish` would move `config.fish`
to `~/.dotfiles/config/fish/config.fish`

You can move files by hand and symlink later with the next command.

- `rcup`: symlink everything.

- `rcdn`: remove symlinks.
