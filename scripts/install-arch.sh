echo "begin pacstrap"
pacstrap /mnt base base-devel

echo "generate fstab"
genfstab /mnt >> /mnt/etc/fstab
echo "fstab: \n"
cat /mnt/etc/fstab

echo "enter chroot: \n"
arch-chroot /mnt

echo "time / data: \n"
ln -sf /usr/share/zoneinfo/Europe/Vienna /etc/localtime
hwclock --systohc

echo "uncomment en_* and de_AT.UTF8"
vi /etc/locale.gen
locale-gen
echo "LANG=de_AT.UTF-8" > /etc/locale.conf
echo "KEYMAP=de-latin1" > /etc/vconsole.conf

echo "hostname / hosts"
echo "arch" > /etc/hostname
echo "127.0.1.1 arch.localdomain arch" > /etc/hosts

echo "enable lan on startup"
systemctl enable dhcpcd

echo "root pwd"
passwd

echo "bootloader"
pacman -Syu
pacman -S grub os-prober sudo
grub-install --target=i386-pc --recheck /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg

echo "create user account"
useradd -m -g users -s /bin/bash dni
passwd dni
groupadd sudo
usermod -a -G sudo dni

echo "run visudo, uncommeent %sudo rule"
visudo

echo "install window manager"
pacman -S xorg-server xorg-xinit xorg-utils xorg-server-utils i3-wmi3
