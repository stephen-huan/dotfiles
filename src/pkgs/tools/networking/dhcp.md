# dhcp (dhclient)

- install dhclient (n.b. deprecated)

```shell
pacman -S dhclient
```

- start system service

```shell
systemctl enable dhclient@eno1.service
systemctl start  dhclient@eno1.service
```

- dhclient overwrites `/etc/resolv.conf` which is a problem if using vpn, etc.
- see [arch forum - dhclient overwrites resolv.conf even when resolvconf
  is installed](https://bbs.archlinux.org/viewtopic.php?id=265736)
- I can't get this to work, resolvconf processes it in the wrong order
- this could be fixed by hardcoding or just ignoring DNS altogether
  (I get my DNS server from mullvad or 1.1.1.1 anyways)
- patch from arch forum in `/etc/dhclient-enter-hooks`

```sh
	# if [ -f /etc/resolv.conf ]; then
	#     chown --reference=/etc/resolv.conf $new_resolv_conf
	#     chmod --reference=/etc/resolv.conf $new_resolv_conf
	# fi
	# mv -f $new_resolv_conf /etc/resolv.conf

        # use resolvconf
        cat $new_resolv_conf | /usr/bin/resolvconf -a $interface
        rm $new_resolv_conf
```

- use [unbound](/pkgs/tools/networking/unbound.md) to prevent DNS servers being in the wrong order

##### operation not permitted

- error `journalctl -u dhclient@eno1.service`

```text
Jun 11 16:22:03 neko dhclient[687]: send_packet: Operation not permitted
Jun 11 16:22:03 neko dhclient[687]: dhclient.c:2996: Failed to send 300 byte long packet over fallback interface.
```

- see [linuxquestions - dhcpd complains "Failed to send
  300 byte long packet over fallback interface."](https://www.linuxquestions.org/questions/linux-networking-3/dhcpd-complains-failed-to-send-300-byte-long-packet-over-fallback-interface-4175548986/#post5705157)
- when it works check `tcpdump` output (`pacman -S tcpdump`)

```shell
sudo tcpdump > out.txt
```

- note that `bootps` is usually port 67 and `bootpc` is usually port 68

```text
02:58:43.767759 IP neko.bootpc > 255.255.255.255.bootps: BOOTP/DHCP, Request from b0:25:aa:44:bd:c2 (oui Unknown), length 300
02:58:43.770219 ARP, Request who-has res388d-128-61-95-198.res.gatech.edu (Broadcast) tell _gateway, length 46
02:58:43.773852 IP _gateway.bootps > neko.bootpc: BOOTP/DHCP, Reply, length 300
02:58:43.774738 IP _gateway.bootps > neko.bootpc: BOOTP/DHCP, Reply, length 300
```

- firewall issue, try using built-in kernel packet filter, front end `iptables`
- [arch wiki - iptables](https://wiki.archlinux.org/title/Iptables)
- [arch wiki - ebtables](https://wiki.archlinux.org/title/Ebtables)
- [arch wiki - nftables](https://wiki.archlinux.org/title/Nftables)
- open `bootps` and `bootpc` ports for DHCP

```shell
iptables -A OUTPUT -p udp --sport 1024:65535 --dport 67 -j ACCEPT
iptables -A OUTPUT -p udp --sport 68 --dport 67 -j ACCEPT

iptables -A INPUT -p udp --sport 1024:65535 --dport 68 -j ACCEPT
iptables -A INPUT -p udp --sport 67 --dport 68 -j ACCEPT
```

- list

```shell
ebtables-nft --list
```

- to undo run

```shell
iptables -F
ebtables-nft -F
```

- firewall created by [mullvad](https://github.com/mullvad/mullvadvpn-app#environment-variables-used-by-the-service)
- solution: use split tunnel to exclude dhclient from the vpn, see [mullvad -
  How to use the Mullvad CLI](https://mullvad.net/en/help/how-use-mullvad-cli/)
- edit `/etc/dhclient-exit-hooks`

```sh
# exclude dhclient from vpn, also from firewall
mullvad split-tunnel pid add "$(pgrep --oldest dhclient)"
```
