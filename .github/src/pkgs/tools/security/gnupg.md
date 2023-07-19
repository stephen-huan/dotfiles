# gnupg

- [arch wiki - GnuPG](https://wiki.archlinux.org/title/GnuPG)
- install

```shell
pacman -S gnupg
```

- set `pinentry` program (should use something graphical for background)

```shell
pacman -Ql pinentry | grep /usr/bin/
```

- also add `ssh` support
- edit `~/.gnupg/gpg-agent.conf`

```config
# set SSH_AUTH_SOCK to use gpg-agent instead of ssh-agent
enable-ssh-support

# use alternative pinentry
pinentry-program /usr/bin/pinentry-qt
```

- copy over old data (private keys, revocation certificates)

## mullvad

- can't import keys from keyserver with
  [mullvad](/pkgs/tools/networking/mullvad.md)!

## yubikey

- see [yubikey](/pkgs/tools/misc/yubikey-manager.md)
