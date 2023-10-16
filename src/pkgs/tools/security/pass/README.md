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

## git-credential-manager

- see
  [git credential manager](/pkgs/applications/version-management/git-credential-manager.md)

## detailed notes

[pass](https://www.passwordstore.org/) is a simple
GPG-based command-line password manger. To install, run

```shell
pacman -S pass
```

Note that the archlinux package comes with dmenu integration, with the binary

```shell
passmenu
```

### Setting a signing key

In order to set a signing key, use the
environmental variable `PASSWORD_STORE_SIGNING_KEY`

```fish
set -gx PASSWORD_STORE_SIGNING_KEY "EA6E27948C7DBF5D0DF085A10FBC2E3BA99DD60E"
```

Setting this is in order to require a signature on `.gpg-id` and non-system
extensions. For example, if you are using a remote git server to track your
password store; if you pull an update to `.gpg-id` that contains a different
key from the one you usually use, you won't encrypt new passwords to the
malicious key because the signature will break. New local extensions or
modifications to existing extensions won't happen for the same reason.

In order to generate a signature, run

```shell
gpg --detach-sign .gpg-id
```

Do the same for any non-system extensions. However, it's probably more secure
to install extensions with your system's package manager, since these packages
will be automatically updated and also signed by the package maintainer. If an
extension isn't packaged, you can enable non-system extensions with

```fish
set -gx PASSWORD_STORE_ENABLE_EXTENSIONS "true"
```
