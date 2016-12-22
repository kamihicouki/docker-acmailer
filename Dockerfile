FROM ubuntu:latest

# configration for anywhere run to cgi.
RUN \
  apt update \
  && apt install -y apache2 perl \
  && a2enmod cgid \
  && sed -i "s/\#AddHandler cgi-script .cgi/AddHandler cgi-script .cgi/g" /etc/apache2/mods-available/mime.conf \
  && sed -i "s/Options Indexes FollowSymLinks/Options Indexes FollowSymLinks ExecCGI/g" /etc/apache2/apache2.conf

WORKDIR /var/www/html

# Download CGI
RUN \
  VERSION=$(curl -sL https://www.acmailer.jp/download/ | grep app_name | grep -o 'acmailer[0-9]\.[0-9]\.[0-9]') \
  && curl  -G --data-urlencode "app_name=${VERSION}" --data-urlencode 'perl_path=#!/usr/bin/perl'  http://www.acmailer.jp/cgi/install/makeinstall2.cgi -o install.cgi \
  && chmod +x install.cgi

# Adjust directory permission
RUN \
  chown -R www-data:www-data /var/www/html
  
EXPOSE 80
CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
