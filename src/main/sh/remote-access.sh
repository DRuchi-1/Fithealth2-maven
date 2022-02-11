#!/bin/bash
sudo sed -i 's/^bind-address.*/bind-address   =   0.0.0.0/g' /etc/mysql/mysql.conf.d/mysqld.cnf
sudo systemctl restart mysql
sudo mysql -uroot -proot </tmp/createUser.sql
sudo mysql -ufithealthappuser -pWelcome@1 </tmp/db-schema.sql