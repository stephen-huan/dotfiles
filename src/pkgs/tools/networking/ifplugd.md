# ifplugd

- [arch wiki - network configuration/ethernet](https://wiki.archlinux.org/title/Network_configuration/Ethernet#ifplugd_for_laptops)
- not necessary if using [dhcpcd](/pkgs/tools/networking/dhcpcd.md),
  same feature works out of the box
- install ifplugd:

```shell
pacman -S ifplugd
```

- edit config to change default `eth0` device
  to `eno1` at `/etc/ifplugd/ifplugd.conf`

```config
INTERFACES="eno1"
```

- enable service

```shell
systemctl enable ifplugd@eno1.service
systemctl start  ifplugd@eno1.service
```

- can use to disable wifi when ethernet connected
  and enable wifi when ethernet disconnected
- runs `/etc/ifplugd/ifplugd.action` on up/down with two arguments: name of
  ethernet interface and whether it went up or down. Shell script inspired by
  [this link](https://busybox.busybox.narkive.com/yvV73uN2/looking-for-simple-ifplugd-example-script#post2):

```sh
#!/bin/sh
# disable wifi if ethernet connected and enable wifi if ethernet disconnected

case $2 in
    up)   # ethernet up means wifi down
        iwctl station wlan0 disconnect
        ;;
    down) # ethernet down means wifi up
        # parse `iwctl known-networks list` and connect to most recent network
        iwctl station wlan0 connect "$(/home/stephenhuan/bin/iwd-last-network)"
        ;;
esac
```

- remember to mark as executable!

```
chmod +x /etc/ifplugd/ifplugd.action
```

- parsing script `iwd-last-network` simply wraps `iwctl known-networks list`:

```python
#!/usr/bin/env python3
"""
Script to parse `iwctl known-networks list`
and return the most recently connected network.

iwd version 1.30-1.
"""
import datetime
import subprocess


def __known_networks() -> str:
    """Wraps `iwctl known-networks list`."""
    out = subprocess.run(
        ["iwctl", "known-networks", "list"],
        capture_output=True,
        text=True,
    )
    return out.stdout


def get_date(date: str) -> datetime.datetime:
    """Parse iwctl date format into a datetime object."""
    return datetime.datetime.strptime(date, "%b %d, %H:%M %p")


def get_known_networks() -> list[str]:
    """Parses the output of iwctl."""
    lines = __known_networks().strip().splitlines()
    header = lines[2].lower()
    fields = header.split()[1:]
    start = header.find(" ")
    starts = {field: header.find(field) - start for field in fields}
    offset = {
        field: (starts[field], starts.get(next_field, len(header)))
        for field, next_field in zip(fields, fields[1:] + [None])
    }
    get_field = lambda line, field: line[
        offset[field][0] + line.find(" ") : offset[field][1] + line.find(" ")
    ].strip()
    return [
        (
            get_field(row, "name"),
            get_field(row, "security"),
            get_field(row, "hidden"),
            get_date(" ".join(row.split()[-4:])),
        )
        for row in lines[4:]
    ]


if __name__ == "__main__":
    lines = get_known_networks()
    recent = sorted(lines, key=lambda row: row[-1], reverse=True)
    print(recent[0][0])
```

- hang on shutdown: `[  *** ] A stop job is running for ...`
- [forum post](https://bbs.archlinux.org/viewtopic.php?pid=1922083)
- [bug tracker](https://bugs.archlinux.org/task/67382)
- use dhcpcd hook instead?
