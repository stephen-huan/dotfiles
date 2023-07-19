# cmus

- [arch wiki - cmus](https://wiki.archlinux.org/title/Cmus)
- install

```
pacman -S cmus
```

- make sure pulseaudio backend is used: `:set output_plugin=pulse`
- install backends for specific filetypes, e.g. .mp3:

```
pacman -S libmad
```

- .flac

```
pacman -S flac
```

- note `ffmpeg` provides large number of codecs

## hangs after close

- hangs if music is paused and then cmus is closed
- trying to open another cmus window results in

```
cmus: Error: an error occured while initializing MPRIS: File exists. MPRIS will be disabled.
cmus: Press <enter> to continue.
```

- MPRIS is the freedesktop specification for
  music player control, see [MPRIS](#mpris)
- seems to be a pipewire issue, see [Delayed exit from paused music in
  cmus](https://gitlab.freedesktop.org/pipewire/pipewire/-/issues/946)
- as well as [Quitting while playback is paused takes
  several seconds](https://github.com/cmus/cmus/issues/1064)
- brought back up again recently, see [Cmus hangs when paused
  for a long time](https://github.com/pop-os/pipewire/issues/6)
