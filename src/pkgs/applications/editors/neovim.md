# neovim

[neovim](https://neovim.io/) is a fork of [vim](https://www.vim.org/) focused
on extensibility and usability. It's an almost drop-in replacement for vim,
although there are a few minor differences. Neovim has a few major advantages
over vim. In terms of performance, neovim is apparently truly asynchronous,
uses the scripting language Lua instead of vimscript with LuaJIT for extra
speed, and has a faster startup time. Neovim also has support for syntax-aware
syntax highlighting and text formatting (through tree-sitter) as well as
built-in support for LSP. In general, neovim is a more modern and extensible
replacement for vim and I've found it basically acts as a drop-in replacement
without much configuration hassle.

See also Daniel's
[config](https://github.com/brownie-in-motion/dotfiles) for inspiration.

## Quickstart

There's at least three ways to configure neovim through Nix.

- NixOS options under `programs.neovim.*`,
- Home Manager options also under `programs.neovim.*`,
- and [NixVim](https://github.com/nix-community/nixvim).

The NixOS module only provides basic support for a configuration
file and not much else. Note that the executable `nvim` is a
wrapped shell script which can be viewed with `nvim $(which nvim)`.
It's therefore possible to have both `programs.enable.neovim = true` for
both NixOS and Home Manager as they live in different places, namely,

- `/run/current-system/sw/bin/nvim` and
- `~/.local/state/nix/profile/bin/nvim`

respectively. This means my ([hardened](#security-conscious-editing))
neovim configuration as root (which uses the NixOS system configuration)
is different from my personal neovim configuration (which uses the Home
Manager user configuration). One advantage is that plugins aren't loaded
when running neovim as root.

The Home Manger module provides a few extra conveniences, most notably, plugin
support (`programs.neovim.plugins`) which uses neovim's built-in plugin loading
mechanism. This can be slower than modern aggressively optimized plugin
managers which compile configuration and recommend manually managing lazy
loading to delay loading plugins until they're truly necessary. My incredibly
bloated configuration with 34 plugins starts in about ~250ms (at the time of
writing), which is perfectly fine. I'd like to get to 100-150ms which feels
"snappier" to me but objectively speaking, it makes no practical difference.

Finally, NixVim is a module system for configuring neovim. I haven't used it
personally since I'm happy with Home Manager and writing Lua, but it's the most
"Nix-like" system (clean modules where someone else does the heavy lifting of
actually translating Nix declarations into final configuration).

(it was only recently that Nix overtook
Lua by lines of code in my configuration!)

## Miscellaneous tips

### No additional plugin/package managers

Since plugins are automatically installed with neovim, the configuration
is more portable. In addition, packages which should installed with neovim
(language server protocol implementations, formatters, linters, etc.) can
be installed with neovim through `programs.neovim.extraPackages`.

### Neovim as a man pager

Neovim can be used to read man pages more easily.

```sh
export MANPAGER="nvim +Man!"
export MANWIDTH=80
```

### Security-conscious editing

While editing passwords, important emails, or other sensitive
information, it's best to have a different configuration so that vim
is sandboxed. By default, vim generates swap files, backup files, etc.
and will load modelines which have had and continue to have [security
vulnerabilities](https://lwn.net/Vulnerabilities/20249/).

See my hardened `init.lua`

```lua
-- pass will automatically do some of this, even with no configuration
-- https://git.zx2c4.com/password-store/tree/contrib/vim/redact_pass.vim

vim.opt.shada = ""
vim.opt.history = 0
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.undofile = false
vim.opt.secure = true
vim.opt.modeline = false
vim.opt.shelltemp = false

-- save file for all modes
vim.keymap.set({ "", "!" }, "<c-s>", "<cmd>w<cr>")
-- exit file for all modes
vim.keymap.set({ "", "!" }, "<c-q>", "<cmd>q!<cr>")
```

which can be used with

```sh
/run/current-system/sw/bin/nvim --clean --noplugin -n -u init.lua "$@"
```

Alias this to `nvim-private`, which can then be used as an value
for `EDITOR`. The commands in `init.lua` were based on this
[Stack Exchange](https://vi.stackexchange.com/questions/6177/).
For posterity, here is a vim-compatible version.

```vim
" pass will automatically do some of this, even with no configuration
" https://git.zx2c4.com/password-store/tree/contrib/vim/redact_pass.vim

set viminfo=
set history=0
set noswapfile
set nobackup
set nowritebackup
set noundofile
set secure
set nomodeline
set noshelltemp

set nocompatible               " turn off vi compatibility mode
set backspace=indent,eol,start " make backspace always work
set showcmd                    " show an incomplete command
set showmode                   " show mode

" save file for all modes
noremap  <c-s> <cmd>w<cr>
noremap! <c-s> <cmd>w<cr>
" exit file for all modes
noremap  <c-q> <cmd>q!<cr>
noremap! <c-q> <cmd>q!<cr>
```

### Reflowing text paragraphs

When editing text in the terminal, it can be helpful for readability to wrap
text to a certain line width (traditionally, less than 80 characters long).
However, greedily wrapping (neovim's default behavior) can make the edges of
paragraphs jagged, which look worse than more rectangular paragraphs.

See my [blog post](https://cgdct.moe/blog/far/) on a simple dynamic programming
algorithm that reflows paragraphs "optimally".

In neovim, `gq` is the operator and the option `'formatprg'` sets the
program invoked on `gq`. I frequently run `gqip` (mnemonic: `gq` **i**n a
**p**aragraph) while writing. I recommend using my program `far` or the
original program it was based on, [par](http://www.nicemice.net/par/).
