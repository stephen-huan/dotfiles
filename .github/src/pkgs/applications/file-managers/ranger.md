# [ranger](https://ranger.github.io/)

ranger is a terminal file manager. Moving around and manipulating files with
ranger tends to be faster than the equivalent `cd`/`ls`/`mv`/`cp`/`rm`/etc.
shell commands. For exploring a file system, ranger is much faster than
`cd` and `ls` since one just presses `h` and `l` to go up and down the
file hierarchy and always can see the current files. The operations on
files `mv`/`cp`/`rm`/etc. require typing the paths of both the source and
destination, while in ranger one simply acts on the file currently under the
cursor. In general, operations in ranger are faster since the path does not
need to be explicitly specified unlike shell commands in the terminal.

## Previews

- Image previews

Edit `rc.conf`:

```config
set preview_images true
set preview_images_method ueberzug
```

`preview_images_method` can also be set to `w3m` for general terminals.

For the rest of the previews, edit `scope.sh`:

- Videos

```shell
pacman -S ffmpegthumbnailer
```

- PDF

```shell
pacman -S pdftoppm
```

- Syntax highlighting (without `bat`)

Use the package `highlight`. To pick a theme, copy the scope via `ranger
--copy-config=scope` and edit the variable `HIGHLIGHT_STYLE` near the top.
To use a base16 theme, replace the highlight command near the bottom.

- Syntax highlighting (with `bat`)

```shell
pacman -S bat
```
