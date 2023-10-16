# fontconfig

- [arch wiki - font configuration](https://wiki.archlinux.org/title/Font_configuration)
- [arch wiki - font configuration/examples](https://wiki.archlinux.org/title/Font_configuration/Examples#Japanese)
- list fonts

```shell
fc-list
```

- query settings

```shell
fc-match --verbose sans
```

- edit `~/.config/fontconfig/fonts.conf`

```xml
<?xml version="1.0" ?>
<!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
<fontconfig>
  <alias>
    <family>serif</family>
    <prefer>
      <family>Noto Serif</family>
      <family>IPAMincho</family>
    </prefer>
  </alias>

  <alias>
    <family>sans-serif</family>
    <prefer>
      <family>Noto Sans</family>
      <family>IPAGothic</family>
    </prefer>
  </alias>

  <alias>
    <family>monospace</family>
    <prefer>
      <family>Noto Sans Mono</family>
      <family>IPAGothic</family>
    </prefer>
  </alias>
</fontconfig>
```

# japanese

- see [ipafont](/pkgs/data/fonts/ipafont.md)

## firefox japanese font is wrong

- differences in kanji for chinese and japanese,
  e.g. "語" in 日本語, "直" in 直す
- [ chinese ver.](https://learnjapanese.moe/img/font2.png),
  [japanese ver.](https://learnjapanese.moe/img/font3.png)
- firefox displays chinese version despite setting japanese fonts
- enter `about:config`
- change `font.cjk_pref_fallback_order` from
  `zh-cn,zh-hk,zh-tw,ja,ko` to `ja,zh-cn,zh-hk,zh-tw,ko`
- also, default western font is serif instead of sans-serif for
  some reason, makes japanese also serif, e.g. in myanimelist
- change `font.default.x-western` from `serif` to `sans-serif`
- or just change in normal settings page `about:preferences`, "General" ->
  "Fonts" -> "Fonts for" select Latin, "Proportional" select "Sans Serif"

## how to tell Noto Sans CJK JP and IPAGothic apart

- katakana "ta": タ
  - ipa horizontal line precisely connects the two parallel lines
  - noto looks kind of like a ヌ, doesn't touch left and juts past right
