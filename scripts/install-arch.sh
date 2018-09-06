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
pacman -S grub os-prober sudo vim
grub-install --target=i386-pc --recheck /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg

echo "install early deps / dotfiles"
pacman -S git openssl vim zsh termite

echo "create user account"
useradd -m -g users -s /bin/bash dni
passwd dni
groupadd sudo
usermod -a -G sudo dni

echo "run visudo, uncommeent %sudo rule"
pacman -S sudo
visudo

echo "install window manager"
pacman -S xorg-server xorg-xinit i3-wm i3status dmenu ttf-droid ttf-font-awesome

echo "dotfiles"
su dni
cd
git clone https://github.com/dni/dotfiles/
git clone https://github.com/robbyrussell/oh-my-zsh ~/.oh-my-zsh

ln -s ~/dotfiles/.xinitrc ~/.xinitrc
ln -s ~/dotfiles/.config ~/.config
mkdir ~/.fonts
cp ~/dotfiles/Monaco\ for\ Powerline.otf ~/.fonts

rm -f ~/.zshrc
ln -s ~/dotfiles/.zshrc ~/.zshrc
ln -s ~/dotfiles/.aliases ~/.aliases
chsh -s /bin/zsh

rm -f ~/.vimrc
rm -rf ~/.vim
ln -s ~/dotfiles/.vim ~/.vim
ln -s ~/dotfiles/.vimrc ~/.vimrc

echo "init git submodule for vim"
cd dotfiles
git submodule init
git submodule update
