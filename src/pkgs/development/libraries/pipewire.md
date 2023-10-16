# pipewire

- [arch wiki - PipeWire](https://wiki.archlinux.org/title/PipeWire)
- modern drop-in replacement for PulseAudio
- install

```shell
pacman -S pipewire
```

- make sure to select "WirePlumber" session manager
- replace ALSA with pipewire

```shell
pacman -S pipewire-alsa
```

- replace pulseaudio with pipewire

```shell
pacman -S pipewire-pulse
```

- also enables bluetooth management
- enable services

```shell
systemctl --user enable pipewire-pulse.service
systemctl --user start  pipewire-pulse.service
```

- check working

```shell
pactl info
```

- speaker test works!

```shell
speaker-test
```
