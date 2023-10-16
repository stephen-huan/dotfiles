# globalprotect-openconnect

- if using network manager, install package `networkmanager-openconnect`,
  unfortunately I am using [iwd](/pkgs/os-specific/linux/iwd.md)
- can use [GlobalProtect-openconnect](https://github.com/yuezk/GlobalProtect-openconnect) or
  [gp-saml-gui](https://github.com/dlenski/gp-saml-gui) to do web login
- surprisingly enough, GlobalProtect-openconnect is on official repositories

```shell
pacman -S globalprotect-openconnect
```

- run

```shell
gpclient
```

- enter `vpn.gatech.edu` for portal address
- doesn't work with proprietary 2fa

```text
Gateway authentication failed

Unknown response for gateway
prelogin interface.
```
