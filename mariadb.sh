#!/bin/bash
DATA=/var/lib/mysql

if [ ! -f /etc/my.cnf ]; then
cat > /etc/my.cnf <<EOF
[server]
basedir=/usr
datadir=/etc
plugin-dir=/usr/lib64/mysql/plugin
user=mysql
EOF
fi

if [ ! -d ${DATA}/mysql ]; then
 # some settings
 echo "setting"
 mysql_install_db --defaults-extra-file=/etc/my.cnf
 chown mysql:mysql -Rv ${DATA}
fi

#start
exec mysqld_safe --defaults-extra-file=/etc/my.cnf --pid-file=/var/run/mysql/mysql.pid
#after exec
#mysqladmin -u root password '12345678'
