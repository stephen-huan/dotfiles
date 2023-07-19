# dhcpcd

- [arch wiki - dhcpcd](https://wiki.archlinux.org/title/Dhcpcd)
- need separate DHCP client for ethernet
  --- [iwd](/pkgs/os-specific/linux/iwd.md)
  has its own, but only for itself (wireless)
- install dhcpcd

```shell
pacman -S dhcpcd
```

- could enable for all interfaces, but only need for ethernet:

```shell
systemctl enable dhcpcd@eno1.service
systemctl start  dhcpcd@eno1.service
```

- hangs on boot up, waiting for IP address
- create `/etc/systemd/system/dhcpcd@eno1.service.d/no-wait.conf`
- could use `systemctl edit `

```toml
[Service]
ExecStart=
ExecStart=/usr/bin/dhcpcd -b -q %I
```

- already automatically enables/disables ethernet based on cable plug in/out
- add wifi disable/enable based on ethernet state
  by adding hook to `/etc/dhcpcd.exit-hook` (or in
  `/etc/dhcpcd.enter-hook` or in `/usr/lib/dhcpcd/dhcpcd-hooks`)
- based on [this comment](https://bugs.archlinux.org/task/67382#comment191690)
- see `man dhcpcd-run-hooks` for the values of `$interface`, `$reason`, etc.

```sh
# disable wifi if ethernet connected and enable wifi if ethernet disconnected

wired=eno1
wireless=wlan0

if [ "${interface}" = $wired ]; then
    case "${reason}" in NOCARRIER|BOUND)
    if $if_up; then     # ethernet up means wifi down
        iwctl station $wireless disconnect
    elif $if_down; then # ethernet down means wifi up
        # parse `iwctl known-networks list` and connect to most recent network
        last="$(/home/stephenhuan/bin/iwd-last-network)"
        iwctl station $wireless connect $last
    fi
    ;;
    esac
fi
```

## losing connection

- connection randomly drops for a few seconds, happens relatively frequently
- `journalctl -u dhcpcd@eno1.service`

```text
May 29 15:17:33 neko dhcpcd[806]: eno1: 00:56:2b:56:19:38(00:00:00:ff:eb:0d) claims 128.61.88.130
May 29 15:17:33 neko dhcpcd[806]: eno1: 00:aa:6e:d4:c0:38(00:00:00:ff:f2:b4) claims 128.61.88.130
May 29 15:17:33 neko dhcpcd[806]: eno1: 10 second defence failed for 128.61.88.130
May 29 15:17:33 neko dhcpcd[806]: eno1: deleting route to 128.61.80.0/20
May 29 15:17:33 neko dhcpcd[806]: eno1: deleting default route via 128.61.80.1
May 29 15:17:34 neko dhcpcd[806]: eno1: rebinding lease of 128.61.88.130
May 29 15:17:34 neko dhcpcd[806]: eno1: probing address 128.61.88.130/20
May 29 15:17:39 neko dhcpcd[806]: eno1: leased 128.61.88.130 for 7200 seconds
May 29 15:17:39 neko dhcpcd[806]: eno1: adding route to 128.61.80.0/20
May 29 15:17:39 neko dhcpcd[806]: eno1: adding default route via 128.61.80.1
```

- [same problem](https://forums.raspberrypi.com/viewtopic.php?t=295979)
  - advice was to fix the ip conflict, hard to do
    - already using dynamic ip instead of static
    - can't change the configuration of other devices
- problem described in [rfc2131](https://datatracker.ietf.org/doc/html/rfc2131)
  > 5.  The client receives the DHCPACK message with configuration
  >     parameters. The client SHOULD perform a final check on the
  >     parameters (e.g., ARP for allocated network address), and notes the
  >     duration of the lease specified in the DHCPACK message. At this
  >     point, the client is configured. If the client detects that the
  >     address is already in use (e.g., through the use of ARP), the
  >     client MUST send a DHCPDECLINE message to the server and restarts
  >     the configuration process. The client SHOULD wait a minimum of ten
  >     seconds before restarting the configuration process to avoid
  >     excessive network traffic in case of looping.
- fits with `journalctl` log:
  - found ip conflict with ARP, someone else is claiming the address
  - `eno1: 00:56:2b:56:19:38(00:00:00:ff:eb:0d) claims 128.61.88.130`
  - wait for ten seconds before restarting
  - `10 second defence failed for 128.61.88.130`
  - re-negotiate lease
  - `eno1: leased 128.61.88.130 for 7200 seconds`
- check ARP with [arp-scan](https://github.com/royhills/arp-scan):

```shell
pacman -S arp-scan
```

- solution proposed in issue [dhcpcd loses
  static IP](https://github.com/NetworkConfiguration/dhcpcd/issues/36)
- certain devices send faulty ARP probes, tell `dhcpcd` to ignore ARP
- `/etc/dhcpcd.conf`

```text
noarp
```

- still might not work
- same issue [DHCPCD fails again, with DAD detection
  this time](https://forums.raspberrypi.com/viewtopic.php?t=302782)
- see [rfc5227](https://datatracker.ietf.org/doc/html/rfc5227)
- as of 2022-06-17 this has not been fixed
- also this error, but probably caused by mullvad

```text
May 31 23:20:37 neko dhcpcd[743]: ps_root_recvmsg: Operation not permitted
```
