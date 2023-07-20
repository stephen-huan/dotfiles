# android-tools

- [arch wiki - android debug bridge](https://wiki.archlinux.org/title/Android_Debug_Bridge)
- install [adb](https://developer.android.com/tools)

```shell
pacman -S android-tools
```

- install udev rules

```shell
pacman -S android-udev
```

- enable usb debugging on phone

  - e.g., about phone, tap build number 7 times
  - system -> developer options -> usb debugging, enable

- shows up in

```shell
adb devices
```

- copy file from phone

```shell
adb pull src dest
```

- copy file to phone

```shell
adb push src dest
```
