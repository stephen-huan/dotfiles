# Nixpkgs

[Nixpkgs](https://github.com/NixOS/nixpkgs) is the package repository.
There are search engines for [packages](https://search.nixos.org/packages)
and [library functions](https://noogle.dev/).

## NUR

Like Arch, there is a [Nix User
Repository](https://github.com/nix-community/NUR) with an associated
[package repository](https://github.com/nix-community/nur-combined)
and [search engine](https://nur.nix-community.org/).

## nix-index

[nix-index](https://github.com/nix-community/nix-index)
is a nixpkgs search tool. There are also [pre-built
databases](https://github.com/nix-community/nix-index-database)
and an [auto-run](https://github.com/nix-community/comma) wrapper.

Generate the index with

```shell
nix-index --nixpkgs flake:nixpkgs
```

and search for something with

```shell
nix-locate bin/mdbook
```

```text
mdbook-open-on-gh.out                         3,824,576 x /nix/store/7f33s7i9q9qr3l4ahpbpgrqp2icgml0n-mdbook-open-on-gh-2.4.1/bin/mdbook-open-on-gh
mdbook-i18n-helpers.out                       4,095,192 x /nix/store/v06r1p7zpy9x6jlfrrssrf6nbqqm64pk-mdbook-i18n-helpers-0.2.4/bin/mdbook-gettext
mdbook-i18n-helpers.out                       3,807,080 x /nix/store/v06r1p7zpy9x6jlfrrssrf6nbqqm64pk-mdbook-i18n-helpers-0.2.4/bin/mdbook-i18n-normalize
mdbook-i18n-helpers.out                       4,140,880 x /nix/store/v06r1p7zpy9x6jlfrrssrf6nbqqm64pk-mdbook-i18n-helpers-0.2.4/bin/mdbook-xgettext
mdbook-kroki-preprocessor.out                 8,566,376 x /nix/store/f5gxdaa8fw43ar0wcrsz5bc52yzsjkr2-mdbook-kroki-preprocessor-0.2.0/bin/mdbook-kroki-preprocessor
mdbook-linkcheck.out                         13,164,440 x /nix/store/4kicypw0dc07i1syzv6abnyfzfns6n1m-mdbook-linkcheck-0.7.7/bin/mdbook-linkcheck
mdbook-man.out                                3,166,272 x /nix/store/s1rmgghpfxam6f0bf5kb9q8ag2305ld7-mdbook-man-unstable-2022-11-05/bin/mdbook-man
mdbook-mermaid.out                            5,643,400 x /nix/store/1z7b8af7j3plzkk6i5p4176i5w839b4j-mdbook-mermaid-0.12.6/bin/mdbook-mermaid
mdbook.out                                   16,064,552 x /nix/store/44ygcgxpw8q7d7gldihkpbjlxd0181gn-mdbook-0.4.34/bin/mdbook
mdbook-admonish.out                           5,479,400 x /nix/store/rnpfm3pk7rhj4f7l0lcy0d91630qwa45-mdbook-admonish-1.12.1/bin/mdbook-admonish
mdbook-d2.out                                 2,453,072 x /nix/store/jyziwz01h3ykich7wcanyw05rbjk8swc-mdbook-d2-unstable-2023-03-30/bin/mdbook-d2
mdbook-epub.out                               9,321,376 x /nix/store/v2q8j9gbbwis37x41w53r4p2a07m6pjz-mdbook-epub-unstable-2022-12-25/bin/mdbook-epub
mdbook-pdf.out                               10,520,968 x /nix/store/mr5hz1vbpx9jgc27f29890w4k25p3c7c-mdbook-pdf-0.1.7/bin/mdbook-pdf
mdbook-plantuml.out                           6,485,488 x /nix/store/09dvwh1ifpr32bj940xsg5p0w1zshvad-mdbook-plantuml-0.8.0/bin/mdbook-plantuml
mdbook-graphviz.out                           4,792,168 x /nix/store/lynyplv8i5yq9kigpl0ibslp6hq6l3sl-mdbook-graphviz-0.1.6/bin/mdbook-graphviz
mdbook-cmdrun.out                             3,254,448 x /nix/store/mk8d2xv5kpyznpd4yk8b73q6s0qak1cb-mdbook-cmdrun-unstable-2023-01-10/bin/mdbook-cmdrun
mdbook-pagetoc.out                            3,700,888 x /nix/store/c46jrg5bj2yg0cqixraxj0jwhjxipdqv-mdbook-pagetoc-0.1.7/bin/mdbook-pagetoc
mdbook-toc.out                                2,347,464 x /nix/store/1jzsc6yvhd0daqnwrk1k14y31xwl0lqm-mdbook-toc-0.14.1/bin/mdbook-toc
mdbook-katex.out                              2,630,344 x /nix/store/x961ynwvdnjlxmdvp0d5lzvj2bmqlf32-mdbook-katex-0.5.8/bin/mdbook-katex
mdbook-emojicodes.out                         3,890,048 x /nix/store/kic0qqckp1y8jda1g724nldfyn0xyrh8-mdbook-emojicodes-0.3.0/bin/mdbook-emojicodes
```
