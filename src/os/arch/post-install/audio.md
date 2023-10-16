# audio

- [arch wiki - sound system](https://wiki.archlinux.org/title/Sound_system)
- [ALSA](/pkgs/os-specific/linux/alsa-project.md): kernel driver
- [PipeWire](/pkgs/development/libraries/pipewire.md)/[PulseAudio](/pkgs/servers/pulseaudio.md)
  on top
- bluetooth: [bluez](/pkgs/os-specific/linux/bluez.md)
- mpris: [playerctl](/pkgs/tools/audio/playerctl.md)

## Music applications

- [cmus](/pkgs/applications/audio/cmus.md)
- [cider](/pkgs/applications/audio/cider.md)
- [Apple Music](#apple-music)
- [iTunes](#itunes)

### Apple Music

- use web client: [music.apple.com](https://music.apple.com/)
- pros: no installation/configuration
- cons: many
  - need apple device for 2fa sign in
    - this is not true
  - feels slow/clunky
  - randomly breaks
  - doesn't store place

### iTunes

- this is possible to [wine](/pkgs/applications/emulators/wine.md)
  but is broken on the latest version
- black screen from some rendering issue
- version list: <https://www.theiphonewiki.com/wiki/ITunes>
- doesn't seem to be able to import many things, randomly crashes
- <https://forums.linuxmint.com/viewtopic.php?t=292556>
- probably not worth the effort, just use
  [cider](/pkgs/applications/audio/cider.md), an open-source
  electron Apple Music client

## Sync music

### sync to iphone

- to replace sync to iPhone feature see
  [arch wiki - ios](https://wiki.archlinux.org/title/IOS)
- install [ifuse](https://github.com/libimobiledevice/ifuse)
  to allow access to filesystem from linux (uses
  [libimobiledevice](https://libimobiledevice.org/))

```shell
pacman -S ifuse
```

- if freezes on write (see
  [#63](https://github.com/libimobiledevice/ifuse/issues/63),
  probably fixed in newest versions) try aur

```shell
paru -S ifuse-git
```

- use vlc on phone since simple copying
  directly to folder, see provided fish script

```fish
function musicsync --description "sync music to phone"
  # mount vlc media folder to ~/mnt
  ifuse --documents org.videolan.vlc-ios ~/mnt
  # see https://superuser.com/questions/1192448/rsync-mkstemp-filename-failed-function-not-implemented-38
  rsync -av --progress --no-perms --no-owner --no-group --exclude "*.m3u" \
    ~/Music/personal ~/mnt/
  # copy playlists from cmus
  set temp (pwd)
  cd ~/Music/personal/playlists
  python cmus_copy.py
  # generate playlists from artists
  python artist_playlist.py
  cd "$temp"
  rsync -av --progress --no-perms --no-owner --no-group \
    ~/Music/personal/playlists ~/mnt/personal
  # done
  umount ~/mnt
end
```

### sync to android

- see [android-tools](/pkgs/tools/misc/android-tools.md)
- syncing music

```fish
function musicsync --description 'sync music to phone'
    # copy playlists from cmus
    set temp (pwd)
    cd ~/Music/personal/playlists
    python cmus_copy.py
    # generate playlists from artists
    python artist_playlist.py
    cd "$temp"
    # copy over to phone
    adb push --sync ~/Music/ /storage/self/primary/
end
```
