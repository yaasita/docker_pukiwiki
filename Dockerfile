FROM debian:wheezy
MAINTAINER yaasita

#apt
ADD 02proxy /etc/apt/apt.conf.d/02proxy
RUN apt-get update
RUN apt-get upgrade -y

#ssh
RUN apt-get install -y openssh-server
RUN mkdir /var/run/sshd/
RUN mkdir /root/.ssh
ADD authorized_keys /root/.ssh/authorized_keys
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

# rep2
RUN pear install Net_UserAgent_Mobile
COPY rep2_v1_8_103.zip /var/www/
COPY localtime /etc/localtime
COPY timezone /etc/timezone
COPY default /etc/apache2/sites-available/default
RUN cd /var/www/ && unzip rep2_v1_8_103.zip
COPY conf_admin.inc.php /var/www/rep2/conf/conf_admin.inc.php
COPY conf_hostcheck.php /var/www/rep2/conf/conf_hostcheck.php
RUN mkdir /var/www/rep2/data && chmod 777 /var/www/rep2/data/
