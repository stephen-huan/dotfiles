## colors 
# lightline atom one colors:
fg='#494b53'
bg='#fafafa'
grey2='#f0f0f0'
grey3='#d0d0d0'
blue='#61afef'
green='#98c379'
purple='#c678dd'
red='#e06c75'
red2='#be5046'
yellow='#e5c07b'

# atom one colors:
mono1='#494b53'
mono2='#696c77'
mono3='#a0a1a7'
mono4='#c2c2c3'
cyan='#0184bc'
blue2='#4078f2'
purple2='#a626a4'
green2='#50a14f'
red3='#e45649'
red4='#ca1243'
orange1='#986801'
orange2='#c18401'

## status bar 
set -g status on
set -g status-position bottom
set -g status-style bg="$grey2"

# left side of status bar (shows whether or not the prefix has been pressed)
# and the different modes (copy mode, sync mode)
set -g status-left-length 100
set -g status-left-style bright,fg="$bg",bg="$grey3"
set -g status-left "#{?client_prefix,#[bg=$blue] PREFIX ,\
#{?pane_in_mode,#[bg=$purple]  COPY  ,\
#{?pane_synchronized,#[bg=$red]  SYNC  ,\
#[bg=$green] NORMAL }}}#[default]"

# window style (shows the active windows)
set -g status-left-length 100
set -gw window-status-current-style fg="$fg",bg="$grey3"
set -gw window-status-current-format " #[fg=$orange1]#I#[default] #W#{?window_flags,#{window_flags}, }#[default$]\
 [#{client_session}]"

# right side of status bar (shows "[host name] (date time)")
# tmux-online-status
set -g @online_icon "#[bright,fg=$green2]o#[default]"
set -g @offline_icon "#[bright,fg=$red]x#[default]"
# tmux-network-bandwith
set-option -g @tmux-network-bandwidth-padding 8

set -g status-right-length 200
set -g status-right-style fg="$fg",bg="$grey2"
set -g status-right "#{?client_utf8,utf-8,}\
 | #{client_termname}\
 | online: #{online_status}\
 | #{network_bandwidth}\
#[fg=$fg] | #[default]#(tmux-mem-cpu-load --interval 2 -m 2 -g 16 -a 3)\
#[fg=$fg] |#[bright,fg=$bg,bg=$blue] #(fish -c 'sgtime') #[default]"

## highlight active window
# setw -g window-style 'bg=#efefef'
# setw -g window-active-style 'bg=#ffffff'
# setw -g pane-active-border-style ''

## highlight activity in status bar
# setw -g window-status-activity-style fg="#3e999f"
# setw -g window-status-activity-style bg="#ffffff"

## pane border and colors
# set -g pane-active-border-style bg=default
# set -g pane-active-border-style fg="#d6d6d6"
# set -g pane-border-style bg=default
# set -g pane-border-style fg="#d6d6d6"

# set -g clock-mode-colour "#4271ae"
# set -g clock-mode-style 24

# set -g message-style bg="#3e999f"
# set -g message-style fg="#000000"

# set -g message-command-style bg="#3e999f"
# set -g message-command-style fg="#000000"

# message bar or "prompt"
# set -g message-style bg="#2d2d2d"
# set -g message-style fg="#cc99cc"

# set -g mode-style bg="#ffffff"
# set -g mode-style fg="#f5871f"

# make background window look like white tab
# set-window-option -g window-status-style bg=default
# set-window-option -g window-status-style fg=white
# set-window-option -g window-status-style none
# set-window-option -g window-status-format '#[fg=#6699cc,bg=colour235] #I #[fg=#999999,bg=#2d2d2d] #W #[default]'

# active terminal yellow border, non-active white
# set -g pane-border-style bg=default
# set -g pane-border-style fg="#999999"
# set -g pane-active-border-style fg="#f99157"
