# pass

- [arch wiki - pass](https://wiki.archlinux.org/title/Pass)
- install [pass](https://www.passwordstore.org/)

```shell
pacman -S pass
```

- if setup [PGP](/pkgs/tools/security/gnupg.md) and
  [yubikey](/pkgs/tools/misc/yubikey-manager.md), should just work
- comes with dmenu selection

```shell
passmenu
```

## securing

- set `PASSWORD_STORE_SIGNING_KEY`

```fish
set -gx PASSWORD_STORE_SIGNING_KEY "EA6E27948C7DBF5D0DF085A10FBC2E3BA99DD60E"
```

- this requires a signature on `.gpg-id` and non-system extensions
- if, for example, using remote git to track and pull update to `.gpg-id`
  or malicious extension, won't be used because signature breaks
- generate signature

```shell
gpg --detach-sign .gpg-id
```

- do the same for any non-system extensions (not recommended)
- enable non-system extensions (if extension isn't packaged, e.g.)

```fish
set -gx PASSWORD_STORE_ENABLE_EXTENSIONS "true"
```

## pass-otp

- see [pass-otp](/pkgs/tools/security/pass/extensions/otp.md)

## browserpass

- see [browserpass](/pkgs/tools/security/browserpass.md)
