# downgade kernel in arch
## lookup kernerl
ls /var/pacman/cache/
## cache
pacman -U /var/cache/pacman/pkg/package-old_version.pkg.tar.xz
### download from cache
pacman -U https://archive.archlinux.org/packages/l/linux/packagename.pkg.tar.xz
