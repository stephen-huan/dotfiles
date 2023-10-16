# mupdf

- has a pdf viewing tool

## simulating greyscale/colorblindness

- [siam](https://epubs.siam.org/journal-authors#illustrations)
  prints in black/white, preview how the document will look
- greyscale: use [mupdf](https://superuser.com/questions/1182578/how-to-convert-pdf-to-grayscale-through-mutool-mupdf-tools),
  package `mupdf-tools`

```shell
mutool draw -c gray -o "output%d.png" input.pdf
```

- colorblind: use [gimp](https://docs.gimp.org/2.10/en/gimp-display-filter-dialog.html#gimp-deficient-vision),
  package `gimp`
