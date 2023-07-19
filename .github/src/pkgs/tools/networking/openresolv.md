# openresolv

- [arch wiki - openresolv](https://wiki.archlinux.org/title/Openresolv)
- openresolv allows multiple programs to edit `/etc/resolv.conf`
- install openresolv

```shell
pacman -S openresolv
```

- configuration file in `/etc/resolvconf.conf`
- it seems openresolv works by itself by just specifying a nameserver:

```conf
# Configuration for resolvconf(8)
# See resolvconf.conf(5) for details

resolv_conf=/etc/resolv.conf
# If you run a local name server, you should uncomment the below line and
# configure your subscribers configuration files below.
#name_servers=127.0.0.1
name_servers=1.1.1.1
```

- `sudo resolvconf -u` to generate `/etc/resolv.conf`
