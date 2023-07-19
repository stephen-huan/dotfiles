# OpenConnect

- [arch wiki - OpenConnect](https://wiki.archlinux.org/title/OpenConnect)
- install [openconnect](https://www.infradead.org/openconnect/index.html)

```shell
pacman -S openconnect
```

- using [global
  protect](https://www.infradead.org/openconnect/globalprotect.html),
  proprietary vpn used on many university campuses
- problem: authentication isn't with SAML, but with some proprietary 2fa
- surprisingly enough, just works, run openconnect

```shell
sudo openconnect --protocol=gp vpn.gatech.edu
```

- have to paste in password with ctrl-shift-V
- make sure [mullvad](#mullvad-vpn) is disconnected before
- automate login with fish script

```fish
function vpn --description "connect to gatech's proprietary global protect vpn"
    # disconnect mullvad before continuing
    set -g mullvad_status (mullvad status)
    mullvad disconnect

    set password "$(pass school/gatech/gatech.edu | head --lines=1)"
    # 1st line is password, 2nd line is 2fa prompt, and 3rd line is gateway
    echo -e "$password\\npush1\\ndc-ext-gw.vpn.gatech.edu" |
        sudo openconnect \
            --protocol=gp \
            vpn.gatech.edu \
            --user=shuan7 \
            --passwd-on-stdin
end

function vpn-cleanup --on-signal SIGINT --description "post hook"
    # if connected before disconnecting, reconnect to mullvad
    if ! string match --entire --ignore-case -q -- disconnected $mullvad_status
        mullvad connect
    end
end
```
