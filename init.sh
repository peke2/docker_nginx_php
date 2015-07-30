#!/bin/sh

sudo docker run --name test-db -e MYSQL_ROOT_PASSWORD=root -p 3306:3306 --expose 3306 -v /var/db/mysql:/var/lib/mysql -d mysql:5.6.25
sudo docker run --name nginx-php --link test-db:test_db -p 80:80 -v /var/www:/var/www -d nginx-php:1.0
