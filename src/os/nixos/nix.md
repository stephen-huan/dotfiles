# Nix

"Nix" is an ambiguous term that can refer to the Nix programming
language, the package manager, the collection of packages
Nixpkgs, and the operating system NixOS (at the very least).

These parts are documented in the [Nix Reference
Manual](https://nixos.org/manual/nix/stable/), the [Nixpkgs
Manual](https://nixos.org/manual/nixpkgs/stable/), the [NixOS
Manual](https://nixos.org/manual/nixos/stable/), and a short-form
tutorial series called the [Nix Pills](https://nixos.org/guides/nix-pills/).

## nix (language)

The first layer in the stack is the Nix DSL (or the Nix expression language).
The [official documentation](https://nix.dev/tutorials/nix-language)
provides a quick tutorial and the [official
manual](https://nixos.org/manual/nix/stable/language/) provides
a comprehensive reference.

The editor tooling I use is

- lsp: [nil](https://github.com/oxalica/nil)
- formatter: [nixpkgs-fmt](https://github.com/nix-community/nixpkgs-fmt)
- linter: [nixpkgs-lint](https://github.com/nix-community/nixpkgs-lint)

Despite the relative simplicity of the language ("JSON with functions"),
there can still be unusual behavior. Within a few days of playing around
with the expression language, I found what I thought was a interpreter
bug. I posted it on the [Discourse](https://discourse.nixos.org/t/30070)
(and filed an [issue](https://github.com/NixOS/nix/issues/8658)), which
caught the attention of a long-time Nix contributor, which led to increased
attention on a [few](https://github.com/NixOS/nix/issues/3341) old
[outstanding](https://github.com/NixOS/nix/issues/7115) issues and finally
led to a [fix](https://github.com/NixOS/nix/pull/8664) which landed in
[2.17](https://nixos.org/manual/nix/stable/release-notes/rl-2.17). So
even very simple languages can have nasty parser bugs!

## nix (package manager)

Important paths

- `/nix/store`: Nix store (built derivations, where everything lives)
- `/nix/var/nix/gcroots`: Roots of the [garbage collector](https://nixos.org/manual/nix/stable/package-management/garbage-collector-roots)
- `/nix/var/nix/profiles`: System [profiles](https://nixos.org/manual/nix/stable/package-management/profiles)
- `/nix/var/nix/profiles/system`: Current system
- `/etc/profiles/per-user/<user>`: User [packages](https://discourse.nixos.org/t/17004)
- `~/.local/state/nix/profiles`: User profiles (if using xdg)
- `~/.local/state/nix/profiles/home-manager`: Current home-manager generation
- `~/.nix-profile` (if not using xdg)

## nix (cli)

Here are some quick recipies for common tasks

- [query](https://nixos.org/manual/nix/stable/command-ref/nix-store/query)
  list of dependencies of (current) system

  ```shell
  nix-store --query --requisites /nix/var/nix/profiles/system
  ```

- in tree format

  ```shell
  nix-store --query --tree /nix/var/nix/profiles/system
  ```

- list of things referring to a store path

  ```shell
  nix-store --query --referrers <store-path>
  ```

- [optimize](https://nixos.org/manual/nix/stable/command-ref/nix-store/optimise)
  nix store (dedup)

  ```shell
  nix-store --optimise
  ```

- [garbage collection](https://nixos.org/manual/nix/stable/package-management/garbage-collection)

  ```sh
  nix-env --delete-generations old # all non-current generations
  nix-env --delete-generations 14d # generations older than 14 days
  nix-store --gc
  ```

- or use `nix-collect-garbage -d` which essentially wraps the above

  ```shell
  nix-collect-garbage --delete-old
  nix-collect-garbage --delete-older-than 14d
  ```

- difference between `sudo` (system) and no `sudo` (user) (try `--dry-run`)

- [why](https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-why-depends)
  does one package depend on another?

  ```shell
  nix why-depends nixpkgs#zotero nixpkgs#nss
  ```

  ```text
  /nix/store/ihp6sm6xn1q19pblxb968q3cm8x9aimq-zotero-6.0.27
  └───/nix/store/mbyn9dp2pf3vfsp82g0a289ldck3xibw-nss-3.90
  ```

- why does my (current) system depend on a package?

  ```shell
  nix why-depends /nix/var/nix/profiles/system nixpkgs#nss
  ```

  ```text
  /nix/store/7hjlhfzzf4ricswgm1wzvpaac34pwvbm-nixos-system-sora-23.11.20231009.f99e5f0
  └───/nix/store/bvsjja2xsx2z68h52wxwcriw9vjjzazb-etc
      └───/nix/store/6xk1k4kl42qqkds2vrprm0mbp1k2mn0l-user-environment
          └───/nix/store/baxyh4bqi0amw2pi6gv5c28b6lr75jzb-home-manager-path
              └───/nix/store/ihp6sm6xn1q19pblxb968q3cm8x9aimq-zotero-6.0.27
                  └───/nix/store/mbyn9dp2pf3vfsp82g0a289ldck3xibw-nss-3.90
  ```

- pass `--precise` to see more information on each edge

  ```text
  /nix/store/7hjlhfzzf4ricswgm1wzvpaac34pwvbm-nixos-system-sora-23.11.20231009.f99e5f0
      → /nix/store/bvsjja2xsx2z68h52wxwcriw9vjjzazb-etc
          → /nix/store/6xk1k4kl42qqkds2vrprm0mbp1k2mn0l-user-environment
              → /nix/store/baxyh4bqi0amw2pi6gv5c28b6lr75jzb-home-manager-path
                  → /nix/store/ihp6sm6xn1q19pblxb968q3cm8x9aimq-zotero-6.0.27
                      → /nix/store/mbyn9dp2pf3vfsp82g0a289ldck3xibw-nss-3.90
  └───activate: …fsx38qi-setup-etc.pl /nix/store/bvsjja2xsx2z68h52wxwcriw9vjjzazb-etc/etc...if (( _localstatus > …
      └───etc/profiles/per-user/ikue -> /nix/store/6xk1k4kl42qqkds2vrprm0mbp1k2mn0l-user-environment
          └───bin/accessdb -> /nix/store/baxyh4bqi0amw2pi6gv5c28b6lr75jzb-home-manager-path/bin/accessdb
              └───bin/.zotero-wrapped -> /nix/store/ihp6sm6xn1q19pblxb968q3cm8x9aimq-zotero-6.0.27/bin/.zotero-wrapped
                  └───usr/lib/zotero-bin-6.0.27/gmp-clearkey/0.1/libclearkey.so: …sm01mc-nspr-4.35/lib:/nix/store/mbyn9dp2pf3vfsp82g0a289ldck3xibw-nss-3.90/lib:/nix/store/73whsps…
  ```

- and `--all` for all paths, not just the shortest one (or both flags)

  ```shell
  nix why-depends /nix/var/nix/profiles/system nixpkgs#nss
  ```

  ```text
  /nix/store/7hjlhfzzf4ricswgm1wzvpaac34pwvbm-nixos-system-sora-23.11.20231009.f99e5f0
  └───/nix/store/bvsjja2xsx2z68h52wxwcriw9vjjzazb-etc
      ├───/nix/store/6xk1k4kl42qqkds2vrprm0mbp1k2mn0l-user-environment
      │   └───/nix/store/baxyh4bqi0amw2pi6gv5c28b6lr75jzb-home-manager-path
      │       ├───/nix/store/ihp6sm6xn1q19pblxb968q3cm8x9aimq-zotero-6.0.27
      │       │   └───/nix/store/mbyn9dp2pf3vfsp82g0a289ldck3xibw-nss-3.90
      │       └───/nix/store/9qmg4vg8hrs6pbbd4cxjrq4jb8fcyxk7-chromium-117.0.5938.149
      │           └───/nix/store/ypas0qsb3ikz6k84bk8q89qjlyr9snk5-chromium-unwrapped-117.0.5938.149
      │               └───/nix/store/mbyn9dp2pf3vfsp82g0a289ldck3xibw-nss-3.90
      └───/nix/store/hrm25v2z602j1qywsia9x638wv1l41f5-system-units
          └───/nix/store/3dxhmg5jabmihc14j8m0b1rlaq6p3inq-unit-home-manager-ikue.service
              └───/nix/store/j6xq61kffmfzqcnhgd32ia13z8yl3hk0-home-manager-generation
                  ├───/nix/store/baxyh4bqi0amw2pi6gv5c28b6lr75jzb-home-manager-path
                  └───/nix/store/fncqlph162dpxh4x4879m2y6zy33fkyf-home-manager-files
                      └───/nix/store/3haw6qx1gmyka60xnrs8mi7d4c81pv6l-hm_fontconfigconf.d10hmfonts.conf
                          └───/nix/store/baxyh4bqi0amw2pi6gv5c28b6lr75jzb-home-manager-path
  ```
