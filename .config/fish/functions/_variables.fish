function _variables --description "set variables"
  ### fish stuff

  # prompt
  set -U fish_color_user brgreen
  set -U fish_color_host brred
  set -U fish_color_cwd cyan

  # timer
  set -U fish_command_timer_enabled 0                  # disable timer
  set -U fish_command_timer_export_cmd_duration_str 1  # enable variable exports

  # git prompt
  # documented in `man fish_git_prompt`
  # https://fishshell.com/docs/current/cmds/fish_git_prompt.html

  set -U __fish_git_prompt_showdirtystate 1             # unstaged (*) and staged (+) changes will be shown next to the branch name
  set -U __fish_git_prompt_showstashstate 1             # If something is stashed, then a '$' will be shown next to the branch name.
  set -U __fish_git_prompt_showuntrackedfiles 1         # If there are untracked files, then a '%' will be shown next to the branch name.
  set -U __fish_git_prompt_showupstream "auto"          # If you would like to see the difference between HEAD and its upstream
  # set -U __fish_git_prompt_show_informative_status 1  # Gives prompts like (master↑1↓2|●3✖4✚5…6), no changes, it displays (master|✔).

  set -U __fish_git_prompt_char_upstream_prefix " "
  set -U __fish_git_prompt_char_upstream_ahead ">"
  set -U __fish_git_prompt_char_upstream_behind "<"
  set -U __fish_git_prompt_char_upstream_diverged "<>"
  set -U __fish_git_prompt_char_upstream_equal "o"      # "=" is default but o is checkmark
  set -U __fish_git_prompt_char_stateseparator " "
  set -U __fish_git_prompt_char_dirtystate "*"
  set -U __fish_git_prompt_char_invalidstate "x"        # "#" is default but x makes more sense
  set -U __fish_git_prompt_char_stagedstate "+"
  set -U __fish_git_prompt_char_untrackedfiles "%"
  set -U __fish_git_prompt_char_stashstate "\$"
  # set -U __fish_git_prompt_char_cleanstate "o"

  set -U __fish_git_prompt_color_branch magenta --bold  # Branch name
  set -U __fish_git_prompt_color_upstream green         # Upstream name and flags (with showupstream)

  # __fish_git_prompt_showdirtystate
  set -U __fish_git_prompt_color_dirtystate blue        # unstaged changes (*)
  set -U __fish_git_prompt_color_stagedstate yellow     # staged changes   (+)
  set -U __fish_git_prompt_color_invalidstate red       # HEAD invalid     (#, colored as stagedstate)

  # __fish_git_prompt_showstashstate
  set -U __fish_git_prompt_color_stashstate cyan        # stashed changes  ($)

  # __fish_git_prompt_showuntrackedfiles
  set -U __fish_git_prompt_color_untrackedfiles $fish_color_normal # untracked files  (%)

  # __fish_git_prompt_showupstream  (all colored as upstream)
  set -U __fish_git_prompt_color_upstream_behind red --bold

  # __fish_git_prompt_show_informative_status
  set -U __fish_git_prompt_color_cleanstate green --bold # Working directory has no changes (✔)
end

