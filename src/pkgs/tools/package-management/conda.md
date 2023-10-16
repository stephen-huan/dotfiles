# conda

- install [miniconda](https://docs.conda.io/en/latest/miniconda.html)

```shell
paru -S miniconda3
```

- lightweight installer for
  [conda](https://docs.conda.io/projects/conda/en/latest/) that doesn't
  install as much as [anaconda](https://docs.anaconda.com/anaconda/)
  (over 250 packages by default)
- or [micromamba](/pkgs/tools/package-management/micromamba.md),
  extremely minimal and fast re-implementation of conda
- what they want you to do (and what the post-install message will say)

```shell
source /opt/miniconda3/etc/fish/conf.d/conda.fish
```

- or if on bash/POSIX shell

```shell
source /opt/miniconda3/etc/profile.d/conda.sh
```

- will add `conda` to `PATH`, to make changes permanent

```shell
conda init fish
```

- or

```shell
conda init
```

- but I don't necessarily want to have every shell startup be in (base)
- instead, comment out the addition to the configuration
  file and run the command manually when using conda

```shell
eval /opt/miniconda3/bin/conda "shell.fish" "hook" $argv | source
```

## terminals database is inaccessible

- [ask ubuntu - clear command - terminals database is inaccessible](https://askubuntu.com/questions/988694/clear-command-terminals-database-is-inaccessible/1402408#1402408)

```
export TERMINFO=/usr/share/terminfo
```
