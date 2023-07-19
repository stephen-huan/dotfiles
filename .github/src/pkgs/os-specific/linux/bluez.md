# bluez

- [arch wiki - bluetooth](https://wiki.archlinux.org/title/Bluetooth)
- [arch wiki - bluetooth headset](https://wiki.archlinux.org/title/Bluetooth_headset)
- install bluez

```shell
pacman -S bluez
pacman -S bluez-utils
```

- enable service

```shell
systemctl enable bluetooth.service
systemctl start  bluetooth.service
```

- start command line prompt

```shell
bluetoothctl
```

- turn power on, turn agent, start scanning for devices

```shell
[bluetooth]# power on
[bluetooth]# agent on
[bluetooth]# default-agent
[bluetooth]# scan on
```

- find MAC address of device
- note: might be spammed by other devices, exit to prevent
- pair, connect, and trust for future auto-connect

```text
[bluetooth]# pair MAC_ADDRESS
[bluetooth]# connect MAC_ADDRESS
[bluetooth]# trust MAC_ADDRESS
```

- enable auto power-on of bluetooth module in `/etc/bluetooth/main.conf`

```config
[Policy]
AutoEnable=true
```

## bluetooth randomly stuck

- bluetooth stuck after waking up from sleep
- `sudo systemctl restart bluetooth.service` and the like hangs
- kill daemon directly

```shell
sudo pkill -9 bluetoothd
```

## device not showing up

- [arch wiki - bluetooth](https://wiki.archlinux.org/title/Bluetooth#Device_does_not_show_up_in_scan)
- certain bluetooth low energy (BLE) devices don't show up in scan
- set `transport le`
```shell
[bluetooth]# menu scan
[bluetooth]# transport le
[bluetooth]# back
[bluetooth]# scan on
[bluetooth]# devices
```
- still doesn't work with
  [MM712 mouse](https://www.coolermaster.com/catalog/peripheral/mice/mm712/),
  TODO
