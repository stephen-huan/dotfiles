# set defualt directory to Programs folder if in top level shell
if test $SHLVL -le 2
  cdp
end

set -gx SHELL "/usr/local/bin/fish"

### PATH

# reset path to most basic level
# set -gx PATH (string split ":" (getconf PATH))

set -gx PATH "/usr/local/bin" "/usr/local/sbin" $PATH # homebrew

### ENVIRONMENT

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

### USER PATH

# broken: /usr/bin/iconv, /usr/local/opt/ncurses/bin/tabs
_add_path "/Library/TeX/texbin"                           # TeX commands
_add_path "$HOME/Programs/bin"                            # user created shell functions
_add_path "$HOME/Programs/bin/yabai"                      # convert to fish later
_add_path "/usr/local/opt/llvm/bin"                       # llvm
_add_path "/usr/local/opt/gettext/bin" "$HOME/.cargo/bin" # fix weird git thing
_add_path "$HOME/Programs/bin/catdoc-0.95/src"            # catdoc

### TIMER

set -g fish_command_timer_enabled 0                  # disable timer
set -g fish_command_timer_export_cmd_duration_str 1  # enable variable exports

### GIT PROMPT
# documented in /usr/local/Cellar/fish/3.1.0_1/share/fish/functions/fish_git_prompt.fish
# also here: https://fishshell.com/docs/current/cmds/fish_git_prompt.html

set -g __fish_git_prompt_showdirtystate 1             # unstaged (*) and staged (+) changes will be shown next to the branch name
set -g __fish_git_prompt_showstashstate 1             # If something is stashed, then a '$' will be shown next to the branch name.
set -g __fish_git_prompt_showuntrackedfiles 1         # If there are untracked files, then a '%' will be shown next to the branch name.
set -g __fish_git_prompt_showupstream "auto"          # If you would like to see the difference between HEAD and its upstream
# set -g __fish_git_prompt_show_informative_status 1  # Gives prompts like (master↑1↓2|●3✖4✚5…6), no changes, it displays (master|✔).

set -g __fish_git_prompt_char_upstream_prefix " "
set -g __fish_git_prompt_char_upstream_ahead ">"
set -g __fish_git_prompt_char_upstream_behind "<"
set -g __fish_git_prompt_char_upstream_diverged "<>"
set -g __fish_git_prompt_char_upstream_equal "o"      # "=" is default but o is checkmark
set -g __fish_git_prompt_char_stateseparator " "
set -g __fish_git_prompt_char_dirtystate "*"
set -g __fish_git_prompt_char_invalidstate "x"        # "#" is default but x makes more sense
set -g __fish_git_prompt_char_stagedstate "+"
set -g __fish_git_prompt_char_untrackedfiles "%"
set -g __fish_git_prompt_char_stashstate "\$"
set -g __fish_git_prompt_char_cleanstate "o"

set -g __fish_git_prompt_color_branch magenta --bold  # Branch name
set -g __fish_git_prompt_color_upstream green         # Upstream name and flags (with showupstream)

# __fish_git_prompt_showdirtystate
set -g __fish_git_prompt_color_dirtystate blue        # unstaged changes (*)
set -g __fish_git_prompt_color_stagedstate yellow     # staged changes   (+)
set -g __fish_git_prompt_color_invalidstate red       # HEAD invalid     (#, colored as stagedstate)

# __fish_git_prompt_showstashstate
set -g __fish_git_prompt_color_stashstate cyan        # stashed changes  ($)

# __fish_git_prompt_showuntrackedfiles
set -g __fish_git_prompt_color_untrackedfiles $fish_color_normal # untracked files  (%)

# __fish_git_prompt_showupstream  (all colored as upstream)
set -g __fish_git_prompt_color_upstream_behind red --bold

# __fish_git_prompt_show_informative_status
set -g __fish_git_prompt_color_cleanstate green --bold # Working directory has no changes (✔)

