#!/bin/bash

# Останавливаем apache и nginx
service nginx stop
service apache2 stop

# Останавливаем крон-задачи
crontab -r

# Копируем конфиги для apache и включаем их в его include
rm /etc/apache2/apache2.conf
cp apache/apache2.conf /etc/apache2/apache2.conf
cp apache/sysinfo.conf /etc/apache2/sites-available/sysinfo.conf

# Копируем конфиги для nginx и включаем их в его include
cp nginx/BALinux.conf /etc/nginx/sites-available/BALinux.conf

# Копируем файлы проекта
cp -R sysinfo /var/www/

# Делаем исполняемыми крон-задачи и запускаем их
crontab cron

# Запускаем apache и nginx
service nginx start
service apache2 start
