# redshift

- [arch wiki - redshift](https://wiki.archlinux.org/title/redshift)
- install redshift

```shell
pacman -S redshift
```

- add location to configuration file `~/.config/redshift/redshift.conf`

```ini
[redshift]
location-provider=manual

[manual]
lat=33.78
lon=-84.39
```

- can get coordinates with [geonames.org](http://www.geonames.org/)
- note: to convert `xxo yy' zz"` to decimal find `xx + yy/60 + zz/3600`
  (hours minutes seconds)
- note: north and east are positive, south and west are negative
- can also use google maps, right-click location
- start system service

```shell
systemctl --user status redshift.service
```
