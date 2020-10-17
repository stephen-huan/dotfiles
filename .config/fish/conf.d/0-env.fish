### ENVIORNMENT

set -gx SHELL "/usr/local/bin/fish"
set -gx CONDA_LOADED 0

### PATH

# reset path to most basic level
# set -gx PATH (string split ":" (getconf PATH))
set -gx PATH "/usr/local/bin" "/usr/local/sbin" $PATH # homebrew

