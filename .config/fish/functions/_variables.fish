function _variables --description "set variables"
  ### Miscellaneous
  set -Ux EDITOR "/usr/local/bin/vim"
  # use neovim to read man pages
  set -Ux MANPAGER "/usr/local/bin/nvim -u ~/.config/nvim/init-pager.vim +Man!"
  set -Ux HOMEBREW_EDITOR "/usr/local/bin/vim"

  set -Ux YABAI_SCRIPTS "/Users/stephenhuan/Programs/bin/yabai"
  set -Ux STOCKFISH_EXECUTABLE "/usr/local/bin/stockfish"
  set -U  headphones "cc-98-8b-f4-8e-af"
  # pyenv compile options
  set -Ux PYTHON_CONFIGURE_OPTS "--enable-framework"

  set -Ux MACOSX_DEPLOYMENT_TARGET "10.15"
  set -Ux SDKROOT "/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.15.sdk" 

  ### fzf
  set -Ux FZF_DEFAULT_OPTS "--height 40% --reverse --color light --border"
  set -Ux FZF_LEGACY_KEYBINDINGS 0
  set -Ux FZF_TMUX_HEIGHT "40%"

  ### z
  set -Ux Z_EXCLUDE "^/Users/stephenhuan\$" "^/Users/stephenhuan/Programs\$"
  set -Ux Z_DECAY 0.99
  set -Ux Z_MAX_SCORE 9000

  ### Clang
  # https://clang.llvm.org/docs/AddressSanitizer.html
  set -Ux ASAN_SYMBOLIZER_PATH "/usr/local/opt/llvm/bin/llvm-symbolizer"
  set -Ux UBSAN_OPTIONS "print_stacktrace=1"
  set -Ux PPROF_BINARY_PATH "a.out"

  ### less
  # https://askubuntu.com/questions/522599/how-to-get-color-man-pages-under-fish-shell
  set -Ux LESS "R"
  set -Ux LESSCHARSET "utf-8"
  set -Ux LESS_TERMCAP_mb (set_color brred)
  set -Ux LESS_TERMCAP_md (set_color brred)
  set -Ux LESS_TERMCAP_me (set_color normal)
  set -Ux LESS_TERMCAP_se (set_color normal)
  set -Ux LESS_TERMCAP_so (set_color -b blue bryellow)
  set -Ux LESS_TERMCAP_ue (set_color normal)
  set -Ux LESS_TERMCAP_us (set_color brgreen)

  ### Timer
  set -Ux fish_command_timer_enabled 0                  # disable timer
  set -Ux fish_command_timer_export_cmd_duration_str 1  # enable variable exports

  ### Git prompt
  # documented in /usr/local/Cellar/fish/3.1.0_1/share/fish/functions/fish_git_prompt.fish
  # also here: https://fishshell.com/docs/current/cmds/fish_git_prompt.html

  set -Ux __fish_git_prompt_showdirtystate 1             # unstaged (*) and staged (+) changes will be shown next to the branch name
  set -Ux __fish_git_prompt_showstashstate 1             # If something is stashed, then a '$' will be shown next to the branch name.
  set -Ux __fish_git_prompt_showuntrackedfiles 1         # If there are untracked files, then a '%' will be shown next to the branch name.
  set -Ux __fish_git_prompt_showupstream "auto"          # If you would like to see the difference between HEAD and its upstream
  # set -Ux __fish_git_prompt_show_informative_status 1  # Gives prompts like (master↑1↓2|●3✖4✚5…6), no changes, it displays (master|✔).

  set -Ux __fish_git_prompt_char_upstream_prefix " "
  set -Ux __fish_git_prompt_char_upstream_ahead ">"
  set -Ux __fish_git_prompt_char_upstream_behind "<"
  set -Ux __fish_git_prompt_char_upstream_diverged "<>"
  set -Ux __fish_git_prompt_char_upstream_equal "o"      # "=" is default but o is checkmark
  set -Ux __fish_git_prompt_char_stateseparator " "
  set -Ux __fish_git_prompt_char_dirtystate "*"
  set -Ux __fish_git_prompt_char_invalidstate "x"        # "#" is default but x makes more sense
  set -Ux __fish_git_prompt_char_stagedstate "+"
  set -Ux __fish_git_prompt_char_untrackedfiles "%"
  set -Ux __fish_git_prompt_char_stashstate "\$"
  set -Ux __fish_git_prompt_char_cleanstate "o"

  set -Ux __fish_git_prompt_color_branch magenta --bold  # Branch name
  set -Ux __fish_git_prompt_color_upstream green         # Upstream name and flags (with showupstream)

  # __fish_git_prompt_showdirtystate
  set -Ux __fish_git_prompt_color_dirtystate blue        # unstaged changes (*)
  set -Ux __fish_git_prompt_color_stagedstate yellow     # staged changes   (+)
  set -Ux __fish_git_prompt_color_invalidstate red       # HEAD invalid     (#, colored as stagedstate)

  # __fish_git_prompt_showstashstate
  set -Ux __fish_git_prompt_color_stashstate cyan        # stashed changes  ($)

  # __fish_git_prompt_showuntrackedfiles
  set -Ux __fish_git_prompt_color_untrackedfiles $fish_color_normal # untracked files  (%)

  # __fish_git_prompt_showupstream  (all colored as upstream)
  set -Ux __fish_git_prompt_color_upstream_behind red --bold

  # __fish_git_prompt_show_informative_status
  set -Ux __fish_git_prompt_color_cleanstate green --bold # Working directory has no changes (✔)
end

