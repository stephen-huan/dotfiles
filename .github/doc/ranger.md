# [ranger](https://ranger.github.io/)

Getting ranger to do image previews via kitty:

1. `brew install ranger` (this installs it with Python 2.7)
2. `pip2 install Pillow`
3. `ranger --copy-config rc` to copy the default config file
    to `~/.config/ranger/rc.conf`
4. `export RANGER_LOAD_DEFAULT_RC=false` to prevent double loading
5. `set preview_images true` and `set preview_images_method kitty`

Alternatively, as Python 2.7 is depreciating in 2020:
1. `pip install ranger-fm Pillow` with a Python 3 pip
2. Follow the same instructions as before
3. Alias ranger to the actual path of the
   ranger executable if you're using pyenv.

## Image Preview

Set the variable `preview_images` to true and `preview_images_method` to kitty.
Note that it leaves a black rectangle in some cases if you quit ranger while on
an image (most notably, vim). To fix this, press the left arrow before exiting
ranger to unload the image.

## Syntax Highlighting

`brew install highlight`. To pick a theme, copy the scope via `ranger
--copy-config=scope` and edit the variable `HIGHLIGHT_STYLE` near the top.
To use a base16 theme, replace the highlight command near the bottom.

You can also enable video preview via thumbnails by uncommenting the block
and installing the right package (`brew install ffmpegthumbnailer`). PDF
image previews are also possible with `pip install pdftoppm` (install the
dependencies via `brew install pkg-config poppler`).

