dotfiles
========
yeah yeah yeah
dni's .dotfiles


# install arch
loadkeys de-latin1

## network
ping 8.8.8.8

### network troubles
#### lan
systemctl stop dhcpcd@ -> TAB
ip link
ip link set enp0s25 up
systemctl start dhcpcd@ -> TAB
#### or wifi
wifi-menu

### prepare disk
fdisk -l
fdisk /dev/sda
## create partitions
## n > p > return > +2G
mkfs.ext4 /dev/sda1
mkfs.ext4 /dev/sda3
mkswap /dev/sda2
swapon /dev/sda2

## mounting disk and init pacstrap
mount /dev/sda1 /mnt
mkdir /mnt/home
mount /dev/sda3 /mnt/home
pacstrap /mnt base linux linux-firmware

### fstab
genfstab /mnt >> /mnt/etc/fstab
cat /mnt/etc/fstab

### enter root filesystem
arch-chroot /mnt

### pre install
pacman -S wget

### install script
wget https://raw.githubusercontent.com/dni/dotfiles/master/scripts/install-arch.sh
sh install-arch.sh

### login as user
su dni
cd
wget https://raw.githubusercontent.com/dni/dotfiles/master/scripts/install-arch-os.sh
sh install-arch-os.sh

### setup secret keys from some cold storage


# downgade kernel in arch
### lookup kernerl
ls /var/pacman/cache/
### cache
pacman -U /var/cache/pacman/pkg/package-old_version.pkg.tar.xz
### download from cache
pacman -U https://archive.archlinux.org/packages/l/linux/packagename.pkg.tar.xz

# UEFI
pacman -S grub efibootmgr dosfstools os-prober mtools
mkdir /boot/EFI
mount /dev/sda1 /boot/EFI  #Mount FAT32 EFI partition
grub-install --target=x86_64-efi  --bootloader-id=grub_uefi --recheck
