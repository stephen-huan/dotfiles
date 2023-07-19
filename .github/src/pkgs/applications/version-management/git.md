# [git](https://git-scm.com/)

I use git for all of my projects that need version control.

## Git Credential Caching

By default, git will prompt you on every operation that needs authentication to
provide a username/password. It is possible to use the built-in storage methods
to either cache credentials in memory for 15 minutes, or to store credentials
permanently on disk as plaintext. If one wants permanent encrypted credential
storage, it requires some additional setup.

See

- [git book - 7.14 Git Tools - Credential Storage](https://git-scm.com/book/en/v2/Git-Tools-Credential-Storage)
- [git doc - gitcredentials](https://git-scm.com/docs/gitcredentials)
- [git-credential-manager - Credential stores](https://github.com/GitCredentialManager/git-credential-manager/blob/main/docs/credstores.md#gpgpass-compatible-files)

The simplest thing to do is to install the [git-credential-manager](https://github.com/GitCredentialManager/git-credential-manager)
which is developed by [GitHub](https://github.blog/2022-04-07-git-credential-manager-authentication-for-everyone/).

```shell
paru -S git-credential-manager-core
```

It's possible to configure git-credential-manger to
use the GPG-based password manger [pass](./pass.md).

```shell
git-credential-manager configure
git config --global credential.credentialStore gpg
```

or just edit `~/.config/git/config` directly

```ini
[credential]
	helper = /usr/bin/git-credential-manager
	credentialStore = gpg
```

Next time a credential is requested, a pop-up appears and one
can authenticate in a variety of ways (through browser login,
through a personal access token, etc.). It then stores the data at

```text
~/.password-store/git/https/github.com/stephen-huan.gpg
```

for GitHub, for example.

Another program that uses `pass` to perform git credential caching is
[pass-git-helper](https://github.com/languitar/pass-git-helper), but it
seems a bit more complicated. One advantage of git-credential-manager
is that it is able to use different methods to store its secrets.
