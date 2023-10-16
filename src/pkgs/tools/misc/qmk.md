# qmk

- [qmk - Setting Up Your QMK Environment](https://docs.qmk.fm/#/newbs_getting_started)
- install qmk

```shell
pacman -S qmk
```

- qmk setup

```shell
qmk setup
```

- or use personal fork

```shell
qmk setup stephen-huan/qmk_firmware
```

- set default keyboard and keymap

```shell
qmk config user.keyboard=dm9records/plaid
qmk config user.keymap=stephen-huan
```

- compile and flash

```shell
qmk compile
qmk flash
```

- see [stephen-huan/plaid](https://github.com/stephen-huan/plaid)
