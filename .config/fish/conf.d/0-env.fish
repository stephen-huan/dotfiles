### ENVIORNMENT

set -gx SHELL "/usr/local/bin/fish"

### PATH

# reset path to most basic level
# set -gx PATH (string split ":" (getconf PATH))
set -gx PATH "/usr/local/bin" "/usr/local/sbin" $PATH # homebrew

### Z

set -g Z_EXCLUDE "^/Users/stephenhuan\$" "^/Users/stephenhuan/Programs\$"   

