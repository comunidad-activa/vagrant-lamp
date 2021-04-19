#!/usr/bin/env bash

# Variables path
php_config_file="/etc/php/7.4/apache2/php.ini"
#xdebug_config_file="/etc/php5/mods-available/xdebug.ini"
mysql_config_file="/etc/mysql/my.cnf"
apache_config_file="/etc/apache2/apache2.conf"
host_document_root="/home/vagrant"
apache_document_root="/var/www/html"
apache_ports_config_file="/etc/apache2/ports.conf"
project_folder_name='public'

# Variables env
DBNAME=vagrant
DBUSER=vagrant
DBPASSWD=vagrant

echo "--- Setup Start ---"

echo "--- update packages ---"
apt-get -qq update

echo "--- install common packages ---"
apt-get -y install vim curl build-essential git curl htop python-pip

echo "--- update command after install common packages ---"
apt-get update

echo "--- Install Apache2 ---"
apt-get install -y apache2

echo "--- Install MongoDB ---"
apt-get install -y mongodb

echo "--- Install RedisDB ---"
apt-get install -y redis-server

echo "--- Install MySql ---"
echo "mysql-server mysql-server/root_password password ${DBPASSWD}" | debconf-set-selections
echo "mysql-server mysql-server/root_password_again password ${DBPASSWD}" | debconf-set-selections
echo "phpmyadmin phpmyadmin/dbconfig-install boolean true" | debconf-set-selections
echo "phpmyadmin phpmyadmin/app-password-confirm password ${DBPASSWD}" | debconf-set-selections
echo "phpmyadmin phpmyadmin/mysql/admin-pass password ${DBPASSWD}" | debconf-set-selections
echo "phpmyadmin phpmyadmin/mysql/app-pass password ${DBPASSWD}" | debconf-set-selections
echo "phpmyadmin phpmyadmin/reconfigure-webserver multiselect none" | debconf-set-selections
apt-get -y install mariadb-server mariadb-client phpmyadmin

mysql -uroot -p${DBPASSWD} -e "CREATE DATABASE ${DBNAME}"
mysql -uroot -p${DBPASSWD} -e "grant all privileges on $DBNAME.* to '${DBUSER}'@'localhost' identified by '${DBPASSWD}'"

echo "--- add PHP repo ---"
apt-get install -y software-properties-common
add-apt-repository ppa:ondrej/php

apt-get update

echo "--- Install PHP ---"
apt-get install -y php7.4 libapache2-mod-php7.4 php7.4-curl php7.4-gd php7.4-mcrypt php7.4-mysql php7.4-common php7.4-curl
apt-get install -y php7.4-cli php7.4-json php7.4-common php7.4-mysql php7.4-zip php7.4-gd php7.4-mbstring php7.4-curl php7.4-xml php7.4-bcmath

#echo "--- Install xDebug ---"
#apt-get install -y php5-xdebug
# cat << EOF | sudo tee -a ${xdebug_config_file}
# xdebug.scream=1
# xdebug.cli_color=1
# xdebug.show_local_vars=1
# EOF

echo "--- update apache config ---"
a2enmod rewrite

sudo rm -rf ${apache_document_root}
sudo ln -fs ${host_document_root}/${project_folder_name} ${apache_document_root}

echo "--- update php.ini and apache2.conf ---"
sed -i "s/error_reporting = .*/error_reporting = E_ALL/" ${php_config_file}
sed -i "s/display_errors = .*/display_errors = On/" ${php_config_file}


sudo sed -i 's/AllowOverride None/AllowOverride All/g' ${apache_config_file}


sudo update-alternatives --set php /usr/bin/php7.4

echo "--- restart Apache2 ---"
service apache2 restart

a2enconf phpmyadmin

echo "--- restart Apache2 ---"
service apache2 restart

echo "--- restart mysql ---"
service mysql restart

echo "--- install composer ---"
curl --silent https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer

echo "--- install lts nodejs NodeJS y NPM ---"
curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
apt-get -y install nodejs

echo "--- install node common packages ---"
npm install -g yarn pm2
