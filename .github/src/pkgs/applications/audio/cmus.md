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

## cmus

[cmus](https://cmus.github.io/) is a terminal based music player. It's
lightweight and fast; what more could you ask for? My only complaint is that
if you close the window, the music stops playing. One solution is to put it in
a [tmux](./tmux.md) server (this has the added benefit of being able to open
multiple cmus windows at the same time, because each is a view into the same
running process). These days I'm too lazy to start tmux, so I just put a cmus
window in a high-number workspace and switch to that workspace when I need to.

My friend swears by [mpd](https://www.musicpd.org/) because of its
client-server architecture: that gives the ability to use any client,
from curses-based terminal interfaces to integration in emacs. It also
makes it easy to do cool things like fancy frequency visualizations and
sharing what music you're listening to on a webserver. I don't have
these use cases, so I stick to cmus. And when I tried to setup mpd a
long time ago, I found it hard to do and never got it working.

The highest praise I can give cmus is that I have not
touched the configuration at all, but I use it very often.

### Playlists

The man pages `cmus` and `cmus-tutorial` are pretty good, the only complaint
I have is the playlist creation is not well-explained. Press `3` to go to
playlist view, by default this will have only a single playlist called
"default". Create a new playlist with `:pl-create playlist-name` (by default
this is not bound to any key so you have to use the command) and delete a
playlist with `D`. Playlists are sorted alphabetically but this can probably
be configured somewhere. The asterisk "\*" indicates which playlist new songs
will be added to. To change what the active playlist is, press `<space>` (this
was the confusing part which I could not find documentation on). Finally, to
add songs press `y` on a song (you can also press `y` on albums and artists,
which is very useful). To remove the song from the playlist, go to the playlist
view and press `D` on the song. To change the order, press `p` to move a song
down and `P` to move a song up. Finally, to play the playlist press `<enter>`
and the same controls as usual can be used (`x` to play, `v` to stop, `c` for
play/pause toggle, `z` previous song and `b` next song).

Note that playing from a playlist switches the mode to "playlist mode"
(this means that there can be two highlights at the same time, one in
playlist view and the other in library view). One can press `shift-M`
to switch between modes without interrupting the current song.

### Queue

The queue is well-explained, I just never knew what it was for. My use case
for the queue is if I'm listening to something but I want to hear a particular
song, so I can tell cmus to play that song without interrupting the flow of my
current listening session. The best way to think of the queue is terms of two
concepts: playlists and the _implicit queue_ inherent to cmus.

The "implicit queue" is how I like to think of the "all from library",
"artist from library", and "album from library" modes (toggleable with
`m`). If you select "artist from library" and you play an artist, cmus
essentially adds all of that artist's songs to the queue (the "real" queue
which is accessible through pressing `4` is empty, hence the name implicit
queue). Thus, the modes control which song play next, which is what the
queue does. The toggles `C`, `r`, and `s` also control the implicit queue
--- `C` toggles "continue", which determines whether the next song is
automatically played or not (if not, then you will have to start the next
song manually). `r` toggles "repeat", which determines whether the queue
infinitely cycles, and `s` toggles "shuffle", which determines whether the
queue is permuted. Thus, it is helpful to think of the modes and toggles
and manipulating an implicit queue (the modes determine which songs go
into the queue and the toggles determine how that queue behaves).

To go back to the "real" queue, it behaves similarity to a playlist. One
adds songs with `e` instead of `y`, and the same playlist manipulation can
be done (`D` to remove, `p`/`P` to move around). When cmus determines which
song to play after the current song finishes, it first tries to dequeue a
song from the "real" queue. If the real queue is empty, it dequeues a song
from the implicit queue described above. Thus, if you're listening to an
artist but want to play another song one-off, then you can add that song
to the queue with `e`. When the song ends, you'll be back to listening to
that artist in the same position in the implicit queue you were in.

### `cmus-remote`

`cmus-remote` can be used to control cmus from the command-line, e.g. to
generate a status text based on the current song (which I do for `i3status`)
or to integrate into `ranger`, e.g. when selecting an audio file, add the file
to the queue and play it. See the man page `cmus-remote` for more details.
