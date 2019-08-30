FROM vbatts/slackware:latest

RUN sed -i -e 's/DEFAULT_ANSWER=n/DEFAULT_ANSWER=y/g' /etc/slackpkg/slackpkg.conf 
RUN sed -i -e 's/BATCH=off/BATCH=on/g' /etc/slackpkg/slackpkg.conf 
RUN slackpkg update 
RUN slackpkg install httpd 
RUN slackpkg install php 
RUN slackpkg install libaio 
RUN slackpkg install libcgroup 
RUN slackpkg install libiodbc 
RUN slackpkg install libmcrypt 
RUN slackpkg install libunistring 
RUN slackpkg install libxml2
RUN slackpkg install apr-util
RUN slackpkg install sqlite
RUN slackpkg install icu4c
RUN slackpkg install cyrus-sasl
RUN slackpkg install apr
RUN slackpkg install libiodbc
RUN slackpkg install libmcrypt
RUN slackpkg install jemalloc
RUN slackpkg install mariadb

RUN sed -i -e 's;DirectoryIndex index.html;DirectoryIndex index.php index.html index.htm;g' /etc/httpd/httpd.conf 
RUN sed -i -e 's;#Include /etc/httpd/mod_php.conf;Include /etc/httpd/mod_php.conf;g' /etc/httpd/httpd.conf 
RUN touch /srv/httpd/htdocs/index.php 
RUN echo '<html><body bgcolor=black><center><h2><font color=red>HI Frome Slacka</font></h2></center></body></html>'>>/var/www/htdocs/index.html 
RUN echo '<?php phpinfo();?>'>>/srv/httpd/htdocs/index.php 

RUN wget https://files.phpmyadmin.net/phpMyAdmin/4.9.0.1/phpMyAdmin-4.9.0.1-all-languages.tar.gz -P /usr/src/ --no-check-certificate
RUN tar zxf /usr/src/phpMyAdmin-4.9.0.1-all-languages.tar.gz -C /usr/src/
RUN rm /usr/src/phpMyAdmin-4.9.0.1-all-languages.tar.gz
RUN mkdir /var/www/phpMyAdmin
RUN mv /usr/src/phpMyAdmin-4.9.0.1-all-languages/* /var/www/phpMyAdmin/
RUN touch /etc/httpd/phpMyAdmin.conf

RUN cp /var/www/phpMyAdmin/config.sample.inc.php /var/www/phpMyAdmin/config.inc.php
RUN echo '$cfg['"'"'TempDir'"'"'] = '"'"'../tmp/'"'"';'>>/var/www/phpMyAdmin/config.inc.php
RUN sed -i -e 's;localhost;127.0.0.1;g' /var/www/phpMyAdmin/config.inc.php
RUN sed -i -e "s;'';'lhjxbnghfdfzherflhjxbnktdfzherfrfr,svytctqxfccjdctvytj,rjyxfnmcz';g" /var/www/phpMyAdmin/config.inc.php

RUN mkdir /var/www/tmp
RUN chmod 777 /var/www/tmp
RUN echo 'Alias /phpMyAdmin /var/www/phpMyAdmin'>>/etc/httpd/phpMyAdmin.conf
RUN echo 'Alias /phpmyadmin /var/www/phpMyAdmin'>>/etc/httpd/phpMyAdmin.conf
RUN echo '<Directory /var/www/phpMyAdmin>'>>/etc/httpd/phpMyAdmin.conf
RUN echo '  Order allow,deny'>>/etc/httpd/phpMyAdmin.conf
RUN echo '  Allow from all'>>/etc/httpd/phpMyAdmin.conf
RUN echo '  Require all granted'>>/etc/httpd/phpMyAdmin.conf
RUN echo '</Directory>'>>/etc/httpd/phpMyAdmin.conf
RUN echo 'Include /etc/httpd/phpMyAdmin.conf'>>/etc/httpd/httpd.conf
COPY mariadb.sh /usr/local/bin/
RUN chmod 755 /usr/local/bin/mariadb.sh
RUN chmod +x /etc/rc.d/rc.httpd
RUN /etc/rc.d/rc.httpd start
ENTRYPOINT ["/usr/local/bin/mariadb.sh"]
EXPOSE 80
CMD ["/usr/sbin/apache2ctl", "-DFOREGROUND"]
