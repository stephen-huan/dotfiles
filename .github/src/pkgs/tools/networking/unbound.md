# unbound

- [arch wiki - unbound](https://wiki.archlinux.org/title/Unbound)
- [dnsprivacy - DNS privacy clients](https://dnsprivacy.org/dns_privacy_clients/#unbound)
- [mullvad - DNS over HTTPS and DNS over TLS](https://mullvad.net/en/help/dns-over-https-and-dns-over-tls/)
- [mullavd - SOCKS5 proxy](https://mullvad.net/en/help/socks5-proxy/)
- install unbound

```shell
pacman -S unbound
```

- install expat for DNSSEC verification

```shell
pacman -S expat
```

- using [openresolv](/pkgs/tools/networking/openresolv.md),
  edit `/etc/resolvconf.conf`

```config
name_servers="::1 127.0.0.1"
resolv_conf_options="trust-ad"

private_interfaces="*"
unbound_conf=/etc/unbound/resolvconf.conf
```

- edit unbound config `/etc/unbound/unbound.conf`

```config
# include: "/etc/unbound/resolvconf.conf"

server:
    prefetch: yes
    hide-identity: yes
    hide-version: yes
    tls-system-cert: yes

    forward-zone:
        name: "."
        forward-addr: 194.242.2.2@853#doh.mullvad.net
        forward-addr: 193.19.108.2@853#doh.mullvad.net
        # forward-addr: 1.1.1.1@853#cloudflare-dns.com
        # forward-addr: 1.0.0.1@853#cloudflare-dns.com
        forward-tls-upstream: yes
```

- if using vpn, resolvconf generated include should probably
  not be used, literally the definition of a DNS leak
- also seems to be broken, can't resolve servers because of mullvad firewall
- if using mullvad, should use local gateway, can't use TLS because domain
  name isn't known (10.64.0.1 corresponds to currently connected mullvad
  server, different hostname depending on which server you're currently
  connected to). This is annoying because then then the fallbacks can't
  use TLS. Could hypothetically fix by specifying a particular host. This
  is doubly annoying because the mullvad doh.mullvad.net DNS servers only
  use TLS, so they can't be used as fallbacks.

```config
    forward-zone:
        name: "."
        # https://mullvad.net/en/help/socks5-proxy/
        forward-addr: 10.64.0.1
        forward-addr: 1.1.1.1
        forward-addr: 1.0.0.1
```

## unbound

To enable DNSSEC for
[unbound](https://dnsprivacy.org/wiki/display/DP/DNS+Privacy+Clients#DNSPrivacyClients-Unbound),
follow the instructions
[here](https://nlnetlabs.nl/documentation/unbound/howto-anchor/).

Basically, to generate the `root.key` file at `/usr/local/etc/unbound` just run

```shell
sudo unbound-anchor
```

and to generate the `root.hints` file (which is not strictly necessary,
as unbound comes with a default root.hints file, but if your package
manager doesn't update as often, you can update it yourself) run

```shell
curl --output /usr/local/etc/unbound/root.hints https://www.internic.net/domain/named.cache
```

Unbound must be started with sudo to have permissions
to bind to its port, so run with the following:

```shell
sudo brew services start unbound
```
