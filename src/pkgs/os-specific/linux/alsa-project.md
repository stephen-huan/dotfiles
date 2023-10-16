# alsa-project

- [arch wiki - Advanced Linux Sound Architecture](https://wiki.archlinux.org/title/ALSA)
- no need to install, built-in to kernel
- install userspace utilities:

```shell
pacman -S alsa-utils
```

- for better resampling:

```shell
pacman -S alsa-plugins
```

- unmute channels:

```shell
alsamixer
```

- speaker test:

```shell
speaker-test -c2
```

- hard to use, can't get working
- just install userspace component, you'll have to anyways!
