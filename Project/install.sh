#!/bin/bash

# Устанавливаем необходимые утилиты
apt-get -y install apache2 nginx sysstat

# Копируем конфиги для apache и включаем их в его include
rm /etc/apache2/ports.conf /etc/apache2/apache2.conf
cp apache/apache2.conf /etc/apache2/apache2.conf
cp apache/sysinfo.conf /etc/apache2/sites-available/sysinfo.conf
ln -s /etc/apache2/sites-available/sysinfo.conf /etc/apache2/sites-enabled/sysinfo.conf

# Копируем конфиги для nginx и включаем их в его include
cp nginx/BALinux.conf /etc/nginx/sites-available/BALinux.conf
ln -s /etc/nginx/sites-available/BALinux.conf /etc/nginx/sites-enabled/BALinux.conf

# Копируем файлы проекта
cp -R sysinfo /var/www/sysinfo/
chmod 775 -R /var/www/sysinfo

# Создаём крон-задачи и директории им для хранения данных
mkdir /tmp/sysinfo
mkdir /tmp/sysinfo/tcpdump
mkdir /tmp/sysinfo/iostat
mkdir /tmp/sysinfo/procfs
mkdir /tmp/sysinfo/net
mkdir /tmp/sysinfo/netstat
mkdir /tmp/sysinfo/mpstat
mkdir /tmp/sysinfo/df
chmod 777 -R /tmp/sysinfo
crontab cron

# Запускаем apache и nginx
service nginx start
service apache2 restart
