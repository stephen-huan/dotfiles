# iwd

- [arch wiki - iwd](https://wiki.archlinux.org/title/Iwd)
- install iwd

```shell
pacman -S iwd
```

- edit configuration in `/etc/iwd/main.conf` to enable DHCP management

```conf
[General]
EnableNetworkConfiguration=true
```

- add DNS with openresolv (see [DNS](/os/arch/post-install/internet.md#dns))

```conf
[Network]
NameResolvingService=resolvconf
```

- start systemd service

```shell
systemctl enable iwd
systemctl start  iwd
```

- enter prompt

```shell
iwctl
```

- helpful commands in prompt

```shell
[iwd]# help
[iwd]# station list
[iwd]# station wlan0 connect WIFI_NAME
[iwd]# station list
```

- still need DNS, can only use systemd-resolved / resolvconf
- it seems iwd can do its own DNS (or DHCP does DNS?)
- DNS is provided by (g)libc, see [arch wiki - domain name resolution](https://wiki.archlinux.org/title/Domain_name_resolution#Glibc_resolver)

## eduroam

- generate password hash

```shell
iconv -t utf16le | openssl md4 -provider legacy
```

- EOF to end (don't press enter, sends `'\n'`): press `ctrl-D` twice
- edit `/var/lib/iwd/essid.8021x`, for eduroam `/var/lib/iwd/eduroam.8021x`:

```conf
[Security]
EAP-Method=PEAP
EAP-Identity=anonymous@gatech.edu
# EAP-PEAP-CACert=/path/to/root.crt
# EAP-PEAP-ServerDomainMask=lawn.gatech.edu
EAP-PEAP-Phase2-Method=MSCHAPV2
EAP-PEAP-Phase2-Identity=username@gatech.edu
EAP-PEAP-Phase2-Password-Hash=passwordhash

[Settings]
AutoConnect=true
```

- can't put `EAP-PEAP-CACert` in home directory

## ead

- ethernet authentication daemon

```shell
systemctl start ead.service
```

- not sure what this does
- replacement for `wpa_supplicant`, see
  [reddit - EAD ethernet authentication daemon](https://www.reddit.com/r/voidlinux/comments/u4kmjo/ead_ethernet_authentication_daemon/)
