#!/bin/bash

# Устанавливаем необходимые утилиты
apt-get -y install apache2 nginx

# Копируем конфиги для apache и включаем их в его include
rm /etc/apache2/ports.conf /etc/apache2/apache2.conf
cp apache/apache2.conf /etc/apache2/apache2.conf
cp apache/sysinfo.conf /etc/apache2/sites-available/sysinfo.conf
ln -s /etc/apache2/sites-available/sysinfo.conf /etc/apache2/sites-enabled/sysinfo.conf

# Копируем конфиги для nginx и включаем их в его include
rm /etc/nginx/nginx.conf
cp nginx/nginx.conf /etc/nginx/nginx.conf
cp nginx/BALinux.conf /etc/nginx/sites-available/BALinux.conf
ln -s /etc/nginx/sites-available/BALinux.conf /etc/nginx/sites-enabled/BALinux.conf

# Копируем исполняемые файлы
cp -R cgi-bin /var/www/
chown www-data:www-data /var
chmod 770 /var
chown www-data:www-data -R /var/www
chmod 770 -R /var/www

# Перезапускаем apache и nginx
service nginx start
service apache2 start
service nginx restart
service apache2 restart
