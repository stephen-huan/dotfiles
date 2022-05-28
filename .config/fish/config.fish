# set defualt directory to Programs folder if in top level shell
if test $SHLVL -le 2
  cdp
end

### USER PATH

_add_path "/Library/TeX/texbin"                           # TeX commands
_add_path "$HOME/Programs/bin"                            # user created shell functions
_add_path "$HOME/Programs/bin/yabai"                      # convert to fish later
_add_path "/usr/local/opt/llvm/bin"                       # llvm
_add_path "/usr/local/opt/gettext/bin" "$HOME/.cargo/bin" # fix weird git thing
_add_path "/Users/stephenhuan/Programs/bin/torch/install/bin/"
_add_path "/Users/stephenhuan/Library/Python/3.8/bin"

### ENVIRONMENT

# overwrite ssh-agent
set -e SSH_AUTH_SOCK
# set -Ux SSH_AUTH_SOCK ~/.ssh/agent
set -Ux SSH_AUTH_SOCK ~/.gnupg/S.gpg-agent.ssh

# handled by plugin(s)
# status --is-interactive; and source (jenv init -|psub)  # java
# status --is-interactive; and source (pyenv init -|psub) # python
# status --is-interactive; and source (rbenv init -|psub) # ruby

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
# eval /Users/stephenhuan/.pyenv/versions/miniconda3-latest/bin/conda "shell.fish" "hook" $argv | source
# <<< conda initialize <<<

# iterm2 shell integration
# test -e /Users/stephenhuan/.iterm2_shell_integration.fish ; and source /Users/stephenhuan/.iterm2_shell_integration.fish ; or true

