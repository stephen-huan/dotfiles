# git-credential-manager

- [git book - 7.14 Git Tools - Credential Storage](https://git-scm.com/book/en/v2/Git-Tools-Credential-Storage)
- [git doc - gitcredentials](https://git-scm.com/docs/gitcredentials)
- [git-credential-manager - Credential stores](https://github.com/GitCredentialManager/git-credential-manager/blob/main/docs/credstores.md#gpgpass-compatible-files)
- install [git-credential-manager](https://github.com/GitCredentialManager/git-credential-manager)

```shell
paru -S git-credential-manager-core
```

- run configuration and use gpg/pass files

```shell
git-credential-manager-core configure
git config --global credential.credentialStore gpg
```

- or edit `~/.config/git/config` directly

```ini
[credential]
	helper = /usr/share/git-credential-manager-core/git-credential-manager-core
	credentialStore = gpg
```

- running a `git-credential-manager-core` command seems to break arrow keys?
- next time credential is requested, pop-up appears, can
  authenticate in a variety of ways (browser, token, etc.)
- stores at `~/.password-store/git/https/github.com/stephen-huan.gpg`, e.g.
