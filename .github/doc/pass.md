# [pass](https://www.passwordstore.org/)

pass is a simple GPG-based command-line password manger. To install, run
```shell
pacman -S pass
```
Note that the archlinux package comes with dmenu integration, with the binary
```shell
passmenu
```

## Setting a Signing Key

In order to set a signing key, use the
environmental variable `PASSWORD_STORE_SIGNING_KEY`
```fish
set -Ux PASSWORD_STORE_SIGNING_KEY "EA6E27948C7DBF5D0DF085A10FBC2E3BA99DD60E"
```
Setting this is in order to require a signature on `.gpg-id` and non-system
extensions. For example, if you are using a remote git server to track your
password store; if you pull an update to `.gpg-id` that contains a different
key from the one you usually use, you won't encrypt new passwords to the
malicious key because the signature will break. New local extensions or
modifications to existing extensions won't happen for the same reason.

In order to generate a signature, run
```shell
gpg --detach-sign .gpg-id
```
Do the same for any non-system extensions. However, it's probably more secure
to install extensions with your system's package manager, since these packages
will be automatically updated and also signed by the package maintainer. If an
extension isn't packaged, you can enable non-system extensions with
```fish
set -Ux PASSWORD_STORE_ENABLE_EXTENSIONS "true"
```

## TOTP 2fa (pass-otp)

With the [pass-otp](https://github.com/tadfisher/pass-otp) extension, pass
can generate time-based one-time passwords (TOTP). These are commonly used
in two-factor authentication (the 6 digit codes that change every set period
of time, usually every 30 seconds). Usually these are loaded into an app
like Google Authenticator by scanning a QR code. However, one can usually
show the secret directly, which can be stored in pass. Note that storing
two-factor secrets in pass along with your passwords kind of defeats the
point of two-factor authentication; stronger two-factor authentication can
be achieved with hardware tokens like [yubikeys](https://www.yubico.com/).

pass-otp can be installed with
```shell
pacman -S pass-otp
```
A TOTP URI is then added to the password file in the following format:
```text
otpauth://totp/SERVICE:USERNAME?secret=AAAAAAAAAAAAAAAA&issuer=SERVICE
```

## [browserpass](https://github.com/browserpass/browserpass-extension)

pass can be used to autofill username and password forms in the browser
through the browserpass extension. It is installed in two parts, first,
a native messaging host, and second, an extension for the browser.

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
yay -S browserpass-chrome
```
Remember to quit and re-open the browser after installing the extension.

In order to use browserpass, the directory structure and file structure
needs to be organized in a [particular way](
https://github.com/browserpass/browserpass-extension#organizing-password-store).
This was a bit of pain to migrate from whatever ad-hoc format I was using
previously, but it didn't take too long. I recommend putting the password
on the first line with no prefix so things like `pass -c file` still work,
and specifying the username with `username: ...`.

## git-credential-manager

pass can also be used as a [git credential manager](./git.md).

