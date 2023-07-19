# yubikey-manager

- [arch wiki - YubiKey](https://wiki.archlinux.org/title/YubiKey)
- install manager

```shell
pacman -S yubikey-manager
```

- enable service

```shell
systemctl enable pcscd.service
systemctl start  pcscd.service
```

- for U2F

```shell
pacman -S libfido2
```

- with [PGP](https://developers.yubico.com/PGP/)
