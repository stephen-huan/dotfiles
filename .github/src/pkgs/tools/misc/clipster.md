# clipster

[Clipster](https://github.com/mrichar1/clipster) is a Python
clipboard manager that can be installed from the AUR:

```shell
paru -S clipster
```

In order to start it, add the command to your `~/.xprofile`
or however you want to run a command on startup.

```shell
clipster --daemon &
```

Clipster supports persistence out of the box
and can be configured to store no history.

Edit the configuration file at `~/.config/clipster/clipster.ini`.

```ini
[clipster]

# Number of items to save in the history file for each selection.
# 0 - don't save history.
history_size = 0
```

Note that you can still check your clipboard history with

```shell
clipster --select
```

This will show the entries you've copied, but this data is stored
in memory instead of on disk. If you kill the daemon (`pkill
clipster`) and re-run it, you'll see that the history is cleared.
