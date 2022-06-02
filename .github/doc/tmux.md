# [tmux](https://github.com/tmux/tmux/wiki)

tmux is a "terminal multiplexer", meaning its main
functionality is in splitting terminal windows and
controlling multiple terminals from the same window.

In practice, I use it to detach a terminal window from the window itself (e.g.
putting cmus in a tmux server and then detaching means the music still plays,
even if the window is closed. The music player can then be brought up again
with `tmux attach`, if I want to switch songs or adjust the volume.)

This is also helpful for ssh connections, when you run commands on a remote
server so that your commands run even after you close the connection.

