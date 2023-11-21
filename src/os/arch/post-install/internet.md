# internet/networking

- [arch wiki - network configuration](https://wiki.archlinux.org/title/Network_configuration)
- wifi: [iwd](/pkgs/os-specific/linux/iwd.md)
- [ethernet](#ethernet)
- dhcp: [dhcpcd](/pkgs/tools/networking/dhcpcd.md) or
  [dhclient](/pkgs/tools/networking/dhcp.md) (deprecated)
- [dns](#dns): [openresolv](/pkgs/tools/networking/openresolv.md) +
  [unbound](/pkgs/tools/networking/unbound.md)
- vpn: [mullvad](/pkgs/tools/networking/mullvad.md),
  [openconnect](/pkgs/tools/networking/openconnect.md)

## ethernet

- [arch wiki - network configuration/ethernet](https://wiki.archlinux.org/title/Network_configuration/Ethernet)
- hypothetically simpler than wifi because directly plugged in
- check network interface name

```shell
ip link show
```

- something like this:

```text
1: lo: ...
    link/loopback ...
2: eno1: ...
    link/ether ...
    altname enp2s0
4: wlan0: ...
    link/ether ...
```

- turn on:

```shell
ip link set eno1 up
```

- turn off:

```shell
ip link set eno1 down
```

### systemd-networkd

- [arch wiki - systemd-networkd](https://wiki.archlinux.org/title/Systemd-networkd)
- probably just works

### georgia tech

- need to remember to register new device at
  [portal.lawn.gatech.edu](https://portal.lawn.gatech.edu)!
- otherwise, garbage data when trying to make DNS query
- make sure ethernet is connected and DHCP is working
- check MAC address with `ip link`

```text
2: eno1: ...
    link/ether MAC_ADDRESS brd ff:ff:ff:ff:ff:ff
    altname enp2s0
```

## DNS

- [arch wiki - domain name resolution](https://wiki.archlinux.org/title/Domain_name_resolution)
- if just need quick functional DNS to install
  other things: [systemd-resolved](#systemd-resolved)
- good DNS: [openresolv](/pkgs/tools/networking/openresolv.md) +
  [unbound](/pkgs/tools/networking/unbound.md)
- [DHCP](https://wiki.archlinux.org/title/Network_configuration#DHCP) seems
  to either do DNS or allow DNS to be done without an explicit DNS client...
- DNS is provided by (g)libc, see [arch wiki - domain name resolution](https://wiki.archlinux.org/title/Domain_name_resolution#Glibc_resolver)

### systemd-resolved

- [arch wiki -
  systemd-resolved](https://wiki.archlinux.org/title/Systemd-resolved)

```shell
systemctl start systemd-resolved
```

- probably just works

### nsdo

- [github - nsdo](https://github.com/ausbin/nsdo)
- might be nice
