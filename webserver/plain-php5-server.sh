echo "deb http://download.webmin.com/download/repository sarge contrib" >> /etc/apt/sources.list
wget http://www.webmin.com/jcameron-key.asc
sudo apt-key add jcameron-key.as

apt-get update && apt-get upgrade -y
apt-get install -y webmin git wget zsh curl apache2 php5 git vim imagemagick graphicsmagick php5 php5-imagick php5-curl php5-mysql sendmail php5-gd php5-mcrypt pure-ftpd-mysql

echo -n "cloning dotfiles"
git clone --recursive git://github.com/dni/dotfiles ~/dotfiles

echo -n "setup apache2"
phpini=/etc/php5/apache2/php.ini
cp $phpini /etc/php5/apache2/php.ini.orig
cp ~/dotfiles/webserver/vhosts-aws.conf /etc/apache2/vhosts.conf
echo "Include vhosts.conf\n \
<Directory /srv/>\n \
  \tOptions Indexes FollowSymLinks\n \
  \tAllowOverride None\n \
  \tRequire all granted\n \
</Directory>" >> /etc/apache2/apache2.conf
rm /etc/apache2/sites-enabled/000-default.conf

sed -i 's/post_max_size = 8M/post_max_size = 200M/' $phpini
sed -i 's/memory_limit = 128M/memory_limit = 2048M/' $phpini
sed -i 's/upload_max_filesize = 2M/upload_max_filesize = 200M/' $phpini
sed -i 's/max_execution_time = 30/max_execution_time = 240/' $phpini
sed -i 's/;max_input_vars = 1000/max_input_vars = 2000/' $phpini
sed -i 's/;opcache.enable=0/opcache.enable=1/' $phpini
sed -i 's/;opcache.memory_consumption=64/opcache.memory_consumption=256/' $phpini

a2enmod rewrite headers deflate php5 expires ssl proxy
php5enmod mcrypt opcache
service apache2 restart

echo "Initializing vim configs..."
cd ~/dotfiles
git submodule init && git submodule update
ln -s ~/dotfiles/.vim ~/.vim
ln -s ~/dotfiles/.vimrc ~/.vimrc

echo "Initializing zsh..."
git clone git://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
mv ~/.zshrc ~/.zshrc.old 2> /dev/null
ln -s ~/dotfiles/.zshrc ~/.zshrc
ln -s ~/dotfiles/.aliases ~/.aliases
chsh -s /bin/zsh

typo3=8.7.3
mkdir /srv/root/
wget http://get.typo3.org/$typo3 -P /srv/root/
tar -xvzf /srv/root/$typo3 -C /srv
rm /srv/root/$typo3

echo "MYSQL NOT INSTALLED RUN apt-get install mysql-server"
