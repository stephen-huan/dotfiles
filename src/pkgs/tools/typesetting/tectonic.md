# tectonic (LaTeX compiler)

- [arch wiki - TeX Live](https://wiki.archlinux.org/title/TeX_Live)
- really the only required package

```shell
pacman -S texlive-core
```

- install a lot of TeX live packages

```shell
pacman -S texlive-most
pacman -S texlive-lang
```

- install [biber](https://www.ctan.org/pkg/biber?lang=en) (biblatex backend)

```shell
pacman -S biber
```

- tlmgr (tex live package manager) is broken, can install alternative

```shell
paru -S tllocalmgr-git
```

- but let's be real, how often do you install something with `tlmgr`?
