### USER PATH

# add user bin to PATH
fish_add_path ~/bin
fish_add_path ~/.local/bin
fish_add_path /usr/lib/rustup/bin
fish_add_path ~/.cargo/bin
# fish_add_path (string split ":" -- (gem environment gempath))
fish_add_path ~/.local/share/gem/ruby/3.0.0/bin
fish_add_path ~/.local/share/nvim/mason/bin

### ENVIRONMENT

# >>> mamba initialize >>>
# !! Contents within this block are managed by 'mamba init' !!
set -gx MAMBA_EXE "/usr/bin/micromamba"
set -gx MAMBA_ROOT_PREFIX "$HOME/micromamba"
$MAMBA_EXE shell hook --shell fish --prefix $MAMBA_ROOT_PREFIX | source
# <<< mamba initialize <<<

### VARIABLES

# conda doesn't recognize alacritty
set -gx TERMINFO /usr/share/terminfo

# restrict openMP from using all CPU resources
# having all cores at close to 100% causes monitor flickering issues
set -gx OMP_NUM_THREADS 4

# most visual novels need 32-bit wine instead of 64-bit wine
set -gx WINEARCH win32

# https://docs.microsoft.com/en-us/dotnet/core/tools/telemetry
set -gx DOTNET_CLI_TELEMETRY_OPTOUT 1

# editors
set -gx VISUAL /usr/bin/nvim
set -gx EDITOR /usr/bin/nvim
# use neovim to read man pages
set -gx MANPAGER "/usr/bin/nvim +Man!"
set -gx MANWIDTH 80

set -gx BROWSER /usr/bin/firefox

# par
set -gx PARINIT "rTbgqR B=.,?'_A_a_@ Q=_s>|"

# notmuch configuration file location
set -gx NOTMUCH_CONFIG "$HOME/.config/notmuch/config"

# fzf
set -gx FZF_DEFAULT_OPTS "--height 40% --reverse --color light --border"
set -gx FZF_LEGACY_KEYBINDINGS 0
set -gx FZF_TMUX_HEIGHT "40%"

# pass
set -gx PASSWORD_STORE_SIGNING_KEY "EA6E27948C7DBF5D0DF085A10FBC2E3BA99DD60E"
# set -gx PASSWORD_STORE_ENABLE_EXTENSIONS "true"

# z
set -gx Z_EXCLUDE "^$HOME\$" "^$HOME/programs\$"
set -gx Z_DECAY 0.99
set -gx Z_MAX_SCORE 9000

# clang
# https://clang.llvm.org/docs/AddressSanitizer.html
# set -gx ASAN_SYMBOLIZER_PATH "/usr/local/opt/llvm/bin/llvm-symbolizer"
# https://clang.llvm.org/docs/UndefinedBehaviorSanitizer.html
set -gx UBSAN_OPTIONS "print_stacktrace=1"
# https://github.com/google/pprof/blob/main/doc/README.md
set -gx PPROF_BINARY_PATH "a.out"

# less
# https://askubuntu.com/questions/522599/
set -gx LESS "RF"
set -gx LESSCHARSET "utf-8"
set -gx LESS_TERMCAP_mb (set_color brred)
set -gx LESS_TERMCAP_md (set_color brred)
set -gx LESS_TERMCAP_me (set_color normal)
set -gx LESS_TERMCAP_se (set_color normal)
set -gx LESS_TERMCAP_so (set_color -b blue bryellow)
set -gx LESS_TERMCAP_ue (set_color normal)
set -gx LESS_TERMCAP_us (set_color brgreen)

# ruby
set -gx GEM_HOME ~/.local/share/gem/ruby/current

# https://github.com/python-poetry/poetry/issues/1917
set -gx PYTHON_KEYRING_BACKEND keyring.backends.null.Keyring

