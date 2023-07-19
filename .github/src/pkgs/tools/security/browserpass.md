# browserpass

- [browserpass](https://github.com/browserpass/browserpass-extension)
- install [native app](https://github.com/browserpass/browserpass-native)

```shell
pacman -S browserpass
```

- install [firefox extension](https://github.com/browserpass/browserpass-extension)

```shell
pacman -S browserpass-firefox
```

- install [chrome extension](https://github.com/browserpass/browserpass-extension)

```shell
paru -S browserpass-chrome
```

- remember to quit and re-open chrome!

## browserpass

pass can be used to autofill username and password forms in the browser through
the [browserpass](https://github.com/browserpass/browserpass-extension)
extension. It is installed in two parts, first, a native messaging host, and
second, an extension for the browser.

The [native app](https://github.com/browserpass/browserpass-native)
can be installed with

```shell
pacman -S browserpass
```

Install the [Firefox
extension](https://github.com/browserpass/browserpass-extension) with

```shell
pacman -S browserpass-firefox
```

Or the [Chrome
extension](https://github.com/browserpass/browserpass-extension) (AUR) with

```shell
paru -S browserpass-chrome
```

Remember to quit and re-open the browser after installing the extension.

In order to use browserpass, the directory structure
and file structure needs to be organized in a
[particular way](https://github.com/browserpass/browserpass-extension#organizing-password-store).
This was a bit of pain to migrate from whatever ad-hoc format I was using
previously, but it didn't take too long. I recommend putting the password
on the first line with no prefix so things like `pass -c file` still work,
and specifying the username with `username: ...`.
