# mullvad

- [arch wiki - mullvad](https://wiki.archlinux.org/title/Mullvad)
- installing GUI also comes with CLI, nice to have around
- choice of which to install after running below command

```shell
paru -S mullvad-vpn
```

- enable service

```shell
systemctl enable mullvad-daemon.service
systemctl start  mullvad-daemon.service
```

- set auto-connect

```shell
mullvad auto-connect set on
```

- running `mullvad-vpn` opens GUI while `mullvad` is CLI
- opening GUI creates lock icon in bar, but can't seem to close window
  - use [i3](/pkgs/applications/window-managers/i3.md), `mod+alt+q`
- quitting app kills vpn connection
- might be easiest to just use CLI:
  - [mullvad CLI](https://mullvad.net/en/help/how-use-mullvad-cli/)
  - [mullvad CLI wireguard](https://mullvad.net/en/help/cli-command-wg/)
- set account number

```shell
mullvad account set 1234123412341234
```

- set protocol to WireGuard

```shell
mullvad relay set tunnel-protocol wireguard
```

- list servers

```shell
mullvad relay list
```

- set server (format 2 character country code, 3 character
  city code, server-name), from `mullvad relay list`

```shell
mullvad relay set location us atl us-atl-001
```

- can give any prefix, e.g. just `set location us`
- connect

```shell
mullvad connect
```

- disconnect

```shell
mullvad disconnect
```

- check status

```shell
mullvad status
```

- external check: [am I mullvad?](https://mullvad.net/en/check/)
- launch `<program>` and exclude it from vpn

```shell
mullvad-exclude <program>
```

- or, for currently running process with `<pid>`

```shell
mullvad split-tunnel pid add <pid>
```
