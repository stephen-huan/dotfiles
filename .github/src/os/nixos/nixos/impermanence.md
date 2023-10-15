# impermanence

[impermanence](https://github.com/nix-community/impermanence/) registers
persistent storage for when root gets wiped on reboot (e.g. tmpfs on `/`).

See

- <https://elis.nu/blog/2020/05/nixos-tmpfs-as-root/>
- <https://elis.nu/blog/2020/06/nixos-tmpfs-as-home/>
- <https://grahamc.com/blog/erase-your-darlings/>

## configuration

Example configurations

- <https://gist.github.com/byrongibson/b279469f0d2954cc59b3db59c511a199>
- <https://github.com/nix-community/impermanence/issues/92>

Configuration is relatively simple, change something like

```nix
  fileSystems."/" = {
    device = "/dev/VolumeGroup/root";
    fsType = "ext4";
  };
```

to

```nix
  fileSystems."/" = {
    fsType = "tmpfs";
    options = [ "defaults" "size=2G" "mode=755" ];
  };
  fileSystems."/persistent" = {
    device = "/dev/VolumeGroup/root";
    fsType = "ext4";
    neededForBoot = true;
  };
  # https://nixos.wiki/wiki/Filesystems
  fileSystems."/nix" = {
    device = "/persistent/nix";
    options = [ "bind" ];
  };
```

Here the name `/persistent` is arbitrary.

## important state

- `/etc/machine-id`: if not stored, new id (re-)generated on every boot
  - used by `systemd`/`journalctl` in`/var/log/journal/<machine-id>`

### persisting passwords

Can use

- `users.users.<name>.password`: (plaintext) password
- `users.users.<name>.hashedPassword`: hashed password from `mkpasswd`
- `users.users.<name>.hashedPasswordFile`: path to hashed password

`hashedPasswordFile` is a file whose [only
line](https://discourse.nixos.org/t/12378) is a hashed password as generated
by `mkpasswd`. Unfortunately `hashedPassword` and `password` overwrite
`hashedPasswordFile`, so if the file is deleted, one can get locked out of
their account. The configuration will warn on rebuild, however.

```text
warning: password file ‘’ does not exist
```

See also [reddit](https://www.reddit.com/r/NixOS/comments/o1er2p/),
impermanence [issue
#120](https://github.com/nix-community/impermanence/issues/120).

## memory used

Can use `df` to measure [tmpfs memory
usage](https://superuser.com/questions/542736).

```shell
df -h
```

```text
Filesystem             Size  Used Avail Use% Mounted on
devtmpfs               1.6G     0  1.6G   0% /dev
tmpfs                   16G  8.0K   16G   1% /dev/shm
tmpfs                  7.7G  6.3M  7.7G   1% /run
tmpfs                   16G  1.2M   16G   1% /run/wrappers
tmpfs                  2.0G  1.6M  2.0G   1% /
/dev/VolumeGroup/root  883G  447G  392G  54% /persistent
tmpfs                  3.1G   32K  3.1G   1% /run/user/1000
```

The relevant line is

```text
tmpfs                  2.0G  1.6M  2.0G   1% /
```

`nixos-rebuild` works in `/build` which can cause
memory [issues](https://discourse.nixos.org/t/13957).

Can check what's about to be cleared with

```shell
ncdu -x /
```

(`-x` means to not cross filesystem boundaries)
