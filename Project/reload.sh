#!/bin/bash

# Останавливаем apache и nginx
service nginx stop
service apache2 stop

# Копируем конфиги для apache и включаем их в его include
rm /etc/apache2/ports.conf /etc/apache2/apache2.conf
cp apache/apache2.conf /etc/apache2/apache2.conf
cp apache/sysinfo.conf /etc/apache2/sites-available/sysinfo.conf

# Копируем конфиги для nginx и включаем их в его include
cp nginx/BALinux.conf /etc/nginx/sites-available/BALinux.conf

# Копируем исполняемые файлы
cp -R cgi-bin /var/www/
chown www-data:www-data /var
chmod 770 /var
chown www-data:www-data -R /var/www
chmod 770 -R /var/www

# Запускаем apache и nginx
service nginx start
service apache2 start
