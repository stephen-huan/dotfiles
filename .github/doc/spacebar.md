# [Spacebar](https://github.com/cmacrae/spacebar)

`spacebar` is the bar that used to be part of `yabai`, but was removed.
Additional features have been added since its humble origins.

### Icons

The default `spacebar` status bar uses font icons, install the
font by double clicking on final.ttf, which was constructed
from [feather.ttf](https://github.com/AT-UI/feather-font)
and [alt.ttf](https://github.com/oblador/react-native-vector-icons/blob/master/Fonts/Feather.ttf).
The first was missing the coffee icon, the second had
weirdly glitched icons for some of them. Merged together
via [FontForge](https://fontforge.github.io/en-US).

### Version

I stick to v0.5.0 as it has all the features I need while keeping the
underline which indicates the currently active space. The simplest way
to install a specific version used to be to `brew install` a raw URL
pointing to the Formula, e.g.
```console
brew install "https://raw.githubusercontent.com/cmacrae/homebrew-formulae/6db39a0f2ce45efbe5189bde4a43258781f5a416/spacebar.rb"
```

This does not work anymore, and the proper thing to do is to `brew extract`.
`brew extract` is incredibly confusing: the first argument is the formula, in
this case `cmacrae/formulae/spacebar`. The second argument is a tap, which is
just a collection of `*.rb` formulas. We can make a tap without needing to
make a GitHub repository by using `brew tap-new` (note that you can name the
tap whatever you want, I just call mine `stephen-huan/local-formulae`).
```console
brew tap-new stephen-huan/local-formulae
brew extract --version=0.5.0 cmacrae/formulae/spacebar stephen-huan/local-formulae
brew install stephen-huan/local-formulae/spacebar@0.5.0
```

The formula must be referred to as `spacebar@0.5.0` e.g.
```console
brew services start spacebar@0.5.0
```

