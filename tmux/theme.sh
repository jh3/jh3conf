#### COLOUR

tm_color_active=colour123
tm_color_inactive=colour231
tm_color_feature=colour205
tm_color_music=colour41
tm_active_border_color=$tm_color_feature

# separators
tm_separator_left_bold="◀"
tm_separator_left_thin="❮"
tm_separator_right_bold="▶"
tm_separator_right_thin="❯"

set -g status-left-length 32
set -g status-right-length 150
set -g status-interval 5

# default statusbar colors
# set-option -g status-bg colour0
set-option -g status-style default,bg=colour235,fg=$tm_color_active

# default window title colors
set-window-option -g window-status-style bg=default,fg=$tm_color_inactive
set -g window-status-format "#I #W"

# active window title colors
set-window-option -g window-status-current-format "#[bold]#I #W"
set-window-option -g window-status-current-style bg=default,fg=$tm_color_active

# pane border
set-option -g pane-border-style fg=$tm_color_inactive
set-option -g pane-active-border-style fg=$tm_active_border_color

# message text
set-option -g message-style bg=default,fg=$tm_color_active

# pane number display
set-option -g display-panes-active-colour $tm_color_active
set-option -g display-panes-colour $tm_color_inactive

# clock
set-window-option -g clock-mode-colour $tm_color_active

#tm_tunes="#[fg=$tm_color_music]#(osascript ~/.dotfiles/applescripts/tunes.scpt)"

tm_date="#[fg=$tm_color_inactive] %R %d %b"
tm_host="#[fg=$tm_color_feature,bold]#h"
tm_session_name="#[fg=$tm_color_feature,bold] #S"

set -g status-left $tm_session_name' '
set -g status-right $tm_tunes' '$tm_date' '$tm_host
