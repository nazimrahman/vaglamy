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

echo -e "\n--- Install GIT ---\n"
sudo apt-get install git

echo -e "\n--- Install Laravel ---\n"
cd /tmp
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer
cd /var/www/html
sudo composer create-project laravel/laravel marketplace --prefer-dist

echo -e "\n--- Configure Apache ---\n"
sudo chgrp -R www-data /var/www/html/marketplace
sudo chmod -R 775 /var/www/html/marketplace/storage


