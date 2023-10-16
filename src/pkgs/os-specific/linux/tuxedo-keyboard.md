# tuxedo-keyboard

- [arch wiki - Tuxedo Pulse 15](https://wiki.archlinux.org/title/TUXEDO_Pulse_15)
- install keyboard control

```shell
paru -S tuxedo-keyboard
```

- install power / CPU / fan control

```shell
paru -S tuxedo-control-center-bin
```

- set screen brightness (0-255)

```shell
echo 32 | sudo tee /sys/class/backlight/amdgpu_bl0/brightness
```

- set keyboard backlight (0-2)

```shell
echo 0 | sudo tee /sys/devices/platform/tuxedo_keyboard/leds/white:kbd_backlight/brightness
```
