# install

## making live USB

- [arch wiki - installation guide](https://wiki.archlinux.org/title/Installation_guide)
- [Download ISO](https://archlinux.org/download/) [torrent link]
- Download PGP signature and check checksums on ISO download page
- Verify PGP signature

```shell
gpg --keyserver-options auto-key-retrieve --verify archlinux-version-x86_64.iso.sig
```

- [arch wiki - USB flash installation medium](https://wiki.archlinux.org/title/USB_flash_installation_medium)
- copy ISO to USB

```shell
cp path/to/archlinux-version-x86_64.iso /dev/sdx
```

- boot from USB (make sure to set correct [UEFI](#uefi) order)

## in live environment

- Connect to WiFi

```shell
iwctl
[iwd]# help
[iwd]# station list
[iwd]# station wlan0 connect WIFI_NAME
[iwd]# station list
```

- Check connection

```shell
ping archlinux.org
```

- Set system clock

```shell
timedatectl set-ntp true
```

- Check system time

```shell
timedatectl status
```

### partition disk

- Partition disks: only need UEFI (EFI system partition) and root (/)
- Swap does not need to be a partition, can be a file for flexibility/ease

```shell
lsblk
fdisk -l
```

If Tuxedo: by default, partitions look like (1 TB drive)

```text
Devic          ...  Size Type
/dev/nvme0n1p1        1G EFI System
/dev/nvme0n1p2      512M Microsoft basic data
/dev/nvme0n1p3      930G Linux filesystem
```

- Normally could use existing EFI partition
- But file format is wrong (we want FAT32 for GRUB, format is ext3)
- Will fix later

### prepare drive for encryption

- [arch wiki - solid state drive memory cell cleaning](https://wiki.archlinux.org/title/Solid_state_drive/Memory_cell_clearing)
- Can clean SSD before this step if desired
- [arch wiki - prepare drive for dm-crypt](https://wiki.archlinux.org/title/Dm-crypt/Drive_preparation)
- Create temporary encrypted container

```shell
cryptsetup open --type plain -d /dev/urandom /dev/nvme0n1p3 to_be_wiped
```

- Verify that it exists

```shell
lsblk
```

- Wipe container with zeros

```shell
dd if=/dev/zero of=/dev/mapper/to_be_wiped status=progress
```

WARNING: 1 TB disk capacity / (80 MB/s write speed) = ~3.5 hours

- Close temporary container

```shell
cryptsetup close to_be_wiped
```

### encrypt entire drive

- [arch wiki - dm-crypt encrypting an entire system](https://wiki.archlinux.org/title/Dm-crypt/Encrypting_an_entire_system#LVM_on_LUKS)
- Use LVM on LUKS (logical volume manager inside encrypted disk)
- Create LUKS encrypted partition on system partition

```shell
cryptsetup luksFormat /dev/nvme0n1p3
```

- Open container (decrypted container now at `/dev/mapper/cryptlvm`)

```shell
cryptsetup open /dev/nvme0n1p3 cryptlvm
```

- Create physical volume

```shell
pvcreate /dev/mapper/cryptlvm
```

- Create volume group (name `VolumeGroup`, arbitrary)

```shell
vgcreate VolumeGroup /dev/mapper/cryptlvm
```

- Create logical volumes
- I said we could use a swap file
- If using LVM, easy to re-size partitions, might as well use swap partition
- Make swap partition same size as RAM for easy suspend to disk (hibernate)
- Don't use entire volume group capacity for easy resizing in the future

```shell
lvcreate -L 32G      VolumeGroup -n swap
lvcreate -l 100%FREE VolumeGroup -n root
```

- Format filesystems

```shell
mkswap    /dev/VolumeGroup/swap
mkfs.ext4 /dev/VolumeGroup/root
```

- Mount filesystems

```shell
swapon /dev/VolumeGroup/swap
mount /dev/VolumeGroup/root /mnt
```

- Prepare boot partition

```shell
mkfs.fat -F 32 /dev/nvme0n1p1
mkdir /mnt/boot
mount /dev/nvme0n1p1 /mnt/boot
```

- Select mirrors with `reflector`
- [arch wiki - reflector](https://wiki.archlinux.org/title/Reflector)
- `pacstrap` to install base, kernel, firmware

```shell
pacstrap /mnt base linux linux-firmware
```

- Generate fstab

```shell
genfstab -U /mnt >> /mnt/etc/fstab
```

## switch into new system

- Change root into new system

```shell
arch-chroot /mnt
```

- Install useful packages

```shell
pacman -S man-db man-pages vim fish
```

- Install necessary packages

```shell
pacman -S lvm2 grub efibootmgr iwd
```

- Set timezone

```shell
ln -sf /usr/share/zoneinfo/US/Eastern /etc/localtime
```

- Run `hwclock`

```shell
hwclock --systohc
```

- Edit `/etc/locale.gen` and uncomment `en_US.UTF-8 UTF-8`, run `locale-gen`

```shell
locale-gen
```

- Create `/etc/locale.conf` with the `LANG` variable

```shell
LANG=en_US.UTF-8
```

- Create hostname in `/etc/hostname`

```shell
myhostname
```

- Set root password

```shell
passwd
```

### edit initramfs

- Add the following to `/etc/mkinitcpio.conf`
  > HOOKS=(base udev autodetect **keyboard** **keymap** **consolefont** modconf block **encrypt** **lvm2** filesystems fsck)
- Recreate initramfs image

```shell
mkinitcpio -P
```

### install GRUB

- [arch wiki - GRUB](https://wiki.archlinux.org/title/GRUB)
- EFI system partition already mounted to `/boot`
- Install [GRUB](/pkgs/tools/misc/grub.md)

```shell
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
```

- Edit `/etc/default/grub` where `device-UUID` is the UUID of `/dev/nvme0n1p1`
- This can be found with `lsblk -f`

```text
GRUB_CMDLINE_LINUX_DEFAULT="cryptdevice=UUID=device-UUID:cryptlvm root=/dev/VolumeGroup/root resume=/dev/VolumeGroup/swap"
```

- Use `grub-mkconfig` to generate `/boot/grub/grub.cfg`

```shell
grub-mkconfig -o /boot/grub/grub.cfg
```

- Reboot

```shell
reboot
```

- Hopefully the following:
  - "Arch Linux" appears in GRUB menu
  - Prompt for encryption key
  - Prompt for username
  - Prompt for password
  - Login successful!
