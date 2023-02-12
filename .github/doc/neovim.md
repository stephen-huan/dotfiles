# [neovim](https://neovim.io/)

First, install [packer.nvim](https://github.com/wbthomason/packer.nvim) with:
```shell
git clone --depth 1 https://github.com/wbthomason/packer.nvim\
 ~/.local/share/nvim/site/pack/packer/start/packer.nvim
```
Then, run `:PackerSync` to install the various plugins.

## neovim

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
[config](https://github.com/brownie-in-motion/dotfiles/tree/master/.config/nvim)
for inspiration.

## Miscellaneous tips

### Neovim as a man pager

Neovim can be used to read man pages more easily.
```fish
set -gx MANPAGER "/usr/bin/nvim -u ~/.config/nvim/init-pager.vim +Man!"
set -gx MANWIDTH 80
```

### Security-conscious editing

If you're editing passwords, important emails, or other sensitive
information, it's best to have a different configuration so that you
sandbox vim. By default, vim generates swap files, backup files, etc.
and will load modelines which have had and continue to have [security
vulnerabilities](https://lwn.net/Vulnerabilities/20249/). See my hardened
[init.lua](../../.config/nvim/init-private.lua) which can be used with:
```shell
/usr/bin/nvim --clean --noplugin -nu ~/.config/nvim/init-private.lua "$@"
```

Alias this to `vim-private`, which you can then use as an value
for `EDITOR`. The commands in `init.lua` were based on this [Stack
Exchange](https://vi.stackexchange.com/questions/6177/); here is
a vim-compatible version.
```vimscript
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
noremap  <c-s> :w<CR>
noremap! <c-s> <esc>:w<CR>li
" exit file for all modes
noremap  <c-q> <esc>:q!<CR>
noremap! <c-q> <esc>:q!<CR>
```

### Reflowing text paragraphs

When writing text in vim, it's helpful to re-format the text to a
certain line width (usually less than 80 characters long) and to
make paragraphs look nice by making them more rectangular. See my
[blog post](https://cgdct.moe/blog/far/) on the matter.

Long story short, `gq` is the operator and you can set the option
`'formatprg'` to set the program. I recommend using my program `far` or
the original program it was based on, [par](http://www.nicemice.net/par/).

