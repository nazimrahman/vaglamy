#!/bin/bash

# Variables
APPENV=local
DBHOST=localhost
DBNAME=master
DBUSER=root
DBPASSWD=root

echo -e "\n--- Update and upgrade ubuntu ---\n"
sudo apt-get update
sudo apt-get upgrade

echo -e "\n--- Install Apache and PHP 7.2 ---\n"
sudo add-apt-repository ppa:ondrej/php -y
sudo apt-get update
sudo apt-get install apache2 libapache2-mod-php7.2 php7.2 php7.2-xml php7.2-gd php7.2-opcache php7.2-mbstring -y

echo -e "\n--- Install MySQL and phpMyAdmin ---\n"
echo "mysql-server mysql-server/root_password password $DBPASSWD" | debconf-set-selections
echo "mysql-server mysql-server/root_password_again password $DBPASSWD" | debconf-set-selections
echo "phpmyadmin phpmyadmin/dbconfig-install boolean true" | debconf-set-selections
echo "phpmyadmin phpmyadmin/app-password-confirm password $DBPASSWD" | debconf-set-selections
echo "phpmyadmin phpmyadmin/mysql/admin-pass password $DBPASSWD" | debconf-set-selections
echo "phpmyadmin phpmyadmin/mysql/app-pass password $DBPASSWD" | debconf-set-selections
echo "phpmyadmin phpmyadmin/reconfigure-webserver multiselect none" | debconf-set-selections
apt-get -y install mysql-server-5.5 phpmyadmin > /dev/null 2>&1

echo -e "\n--- Setting up our MySQL user and db ---\n"
mysql -uroot -p$DBPASSWD -e "CREATE DATABASE $DBNAME"
mysql -uroot -p$DBPASSWD -e "grant all privileges on $DBNAME.* to '$DBUSER'@'localhost' identified by '$DBPASSWD'"

echo -e "\n--- Install GIT ---\n"
sudo apt-get install git

echo -e "\n--- Install Laravel ---\n"
cd /tmp
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer
cd /var/www/html
sudo composer create-project laravel/laravel marketplace --prefer-dist
cd /etc/apache2/sites-available
sudo cp /var/www/laravel.conf .
ls /etc/apache2/sites-available
sudo a2dissite 000-default.conf
sudo a2ensite laravel.conf
sudo a2enmod rewrite
sudo service apache2 restart

echo -e "\n--- Configure Apache ---\n"
sudo chgrp -R www-data /var/www/html/marketplace
sudo chmod -R 775 /var/www/html/marketplace/storage

