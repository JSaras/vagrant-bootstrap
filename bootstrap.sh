#!/usr/bin/env bash

echo "-----Starting up installation script-----"

echo "-----Updating packages list-----"
sudo apt-get update

echo "----- MySQL ------"
sudo debconf-set-selections<<< 'mysql-server mysql-server/root_password password root'
sudo debconf-set-selections<<< 'mysql-server mysql-server/root_password_again password root'

echo "---- Installing base packages -----"

sudo apt-get install -y vim curl python-software-properties

echo "---- Updating packages list ----"
sudo apt-get update

echo "---- Installing PHP Repo ----"
sudo add-apt-repository -y ppa:ondrej/php5

echo "---- Updating packages list ----"
sudo apt-get update

echo "---- Installing LAMP Stack and stuff ----"
sudo apt-get install -y php5 apache2 libapache2-mod-php5 php5-cli php5-cgi php5-common php5-dbg php5-curl php5-dev php5-gd php5-mcrypt mysql-server php5-mysql git

echo "---- Restart Apache ----"
sudo service apache2 restart

echo "---- Installing Xdebug ----"
sudo apt-get install -y php5-xdebug

cat << EOF | sudo tee -a /etc/php5/mods-available/xdebug.ini
xdebug.scream=1
xdebug.cli_color=1
xdebug.show_local_vars=1
EOF

echo "---- Mod Rewrite ----"
sudo a2enmod rewrite

echo "---- Setting document root for apache ----"
sudo rm -rf /var/www
sudo ln -fs /vagrant /var/www

echo "---- PHP Error Reporting ----"
sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php5/apache2/php.ini
sed -i "s/display_errors = .*/display_errors = On/" /etc/php5/apache2/php.ini

echo "---- Installing composer ----"
curl -sS http://getcomposer.org/installer | php
sudo mv composer.phar /usr/bin/composer
