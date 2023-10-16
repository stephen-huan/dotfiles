# Screen capture

- [arch wiki - screen capture](https://wiki.archlinux.org/title/Screen_capture)
- install [maim](https://github.com/naelstrof/maim)

```shell
pacman -S maim
```

- take full-screenshot

```shell
maim file.png
```

- make selection with mouse (`--nodrag`
  for click twice instead of click-dragging)

```shell
maim --select --nodrag file.png
```

- install [obs](https://obsproject.com/)

```shell
pacman -S obs-studio
```

## copying images to clipboard with maim/xclip

- see [maim examples](https://github.com/naelstrof/maim#examples)
