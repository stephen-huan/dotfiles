# ibus-mozc

- [arch wiki - localization/japanese](https://wiki.archlinux.org/title/Localization/Japanese)
- [arch wiki - mozc](https://wiki.archlinux.org/title/Mozc)
- open source version of google's japanese input
- install mozc-ut (mozc with much larger [UT
  dictionary](http://linuxplayers.g1.xrea.com/mozc-ut.html#install-arch-linux))

```shell
paru -S mozc
```

- install communication module with ibus

```shell
paru -S ibus-mozc
```

- add to ibus

```shell
ibus-setup
```

- "IBus Preferences" -> "Input method" -> "Add" -> "Japanese" -> "Mozc"
- startup in hiragana mode, useful if no hardware key for Eisu etc.
- edit `~/.config/mozc/ibus_config.textproto`,
  change `active_on_launch` from `False` to `True`

```config
...
}
active_on_launch: True
```
