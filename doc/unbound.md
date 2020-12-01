# [Unbound](https://dnsprivacy.org/wiki/display/DP/DNS+Privacy+Clients#DNSPrivacyClients-Unbound)

To enable DNSSEC, follow the instructions
[here](https://nlnetlabs.nl/documentation/unbound/howto-anchor/).

Basically, to generate the `root.key` file at `/usr/local/etc/unbound` just run 
```bash
sudo unbound-anchor
```

and to generate the `root.hints` file (which is not strictly necessary,
as unbound comes with a default root.hints file, but if your package manager
doesn't update as often, you can update it yourself) run
```bash
curl --output /usr/local/etc/unbound/root.hints https://www.internic.net/domain/named.cache
```

Unbound must be started with sudo to have permissions to bind to its port, 
so run with the following:
```bash
sudo brew services start unbound
```
