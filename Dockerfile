FROM debian:wheezy
MAINTAINER yaasita

#apt
#ADD 02proxy /etc/apt/apt.conf.d/02proxy
RUN apt-get update
RUN apt-get upgrade -y

#ssh
RUN apt-get install -y openssh-server
RUN mkdir /var/run/sshd/
RUN mkdir /root/.ssh
#ADD authorized_keys /root/.ssh/authorized_keys
RUN perl -i -ple 's/^(permitrootlogin\s)(.*)/\1yes/i' /etc/ssh/sshd_config
RUN echo root:root | chpasswd
CMD /usr/sbin/sshd -D

# supervisor
RUN apt-get install -y supervisor
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
EXPOSE 22 80
CMD ["/usr/bin/supervisord"]

#package
RUN apt-get install -y vim git htop w3m aptitude locales \
 apache2 php5 php-pear php-compat php5-gd php-http-request php-pager php-file php5-curl curl unzip

# pukiwiki
COPY localtime /etc/localtime
COPY timezone /etc/timezone
COPY pukiwiki-1_5_0_utf8.zip /var/www/
RUN cd /var/www/ && unzip pukiwiki-1_5_0_utf8.zip
COPY default /etc/apache2/sites-available/default
COPY pukiwiki.ini.php /var/www/pukiwiki-1_5_0_utf8/pukiwiki.ini.php

