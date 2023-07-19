# pass-otp

- install [pass-otp](https://github.com/tadfisher/pass-otp)

```shell
pacman -S pass-otp
```

- automatically updates and checks gpg signature
- probably more secure than copying to `.extensions` folder and signing

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
