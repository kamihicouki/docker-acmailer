FROM ubuntu:trusty

# configration for anywhere run to cgi.
RUN \
  apt update \
  && apt install -y apache2 perl \
  && a2enmod cgid \
  && sed -i "s/\#AddHandler cgi-script .cgi/AddHandler cgi-script .cgi/g" /etc/apache2/mods-available/mime.conf \
  && sed -i "s/Options Indexes FollowSymLinks/Options Indexes FollowSymLinks ExecCGI/g" /etc/apache2/apache2.conf

# for AWS SES
RUN \
  apt install -y dh-make-perl \
  && apt-file update \
  && dh-make-perl locate Net::SMTP::SSL


WORKDIR /var/www/html

EXPOSE 80
CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
