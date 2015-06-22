FROM        debian:jessie
MAINTAINER  Joeri Verdeyen <info@jverdeyen.be>

ENV HOME /root

RUN apt-get update && \
    apt-get install -y nginx \
    supervisor \
    curl \
    git \
    php5-fpm \
    php5-pgsql \
    php-apc \
    php5-mcrypt \
    php5-curl \
    php5-gd \
    php5-json \
    php5-cli \
    libssh2-php \
    php5-sqlite && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists

RUN sed -i -e "s/short_open_tag = Off/short_open_tag = On/g" /etc/php5/fpm/php.ini && \
    sed -i -e "s/post_max_size = 8M/post_max_size = 20M/g" /etc/php5/fpm/php.ini && \
    sed -i -e "s/upload_max_filesize = 2M/upload_max_filesize = 20M/g" /etc/php5/fpm/php.ini && \
    curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer

RUN echo "cgi.fix_pathinfo = 0;" >> /etc/php5/fpm/php.ini && \
    echo "max_input_vars = 10000;" >> /etc/php5/fpm/php.ini && \
    echo "date.timezone = Europe/Brussels;" >> etc/php5/fpm/php.ini && \
    echo "    StrictHostKeyChecking no" >> /etc/ssh/ssh_config

COPY supervisor/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY config/nginx.conf /etc/nginx/nginx.conf
COPY config/default.conf /etc/nginx/sites-available/default

ADD ./ /var/www/

RUN cd /var/www/ && composer update && \
    /var/www/vendor/bin/nut database:update && \
    /var/www/vendor/bin/nut user:add admin Admin admin@bolt.cm admin root && \
    ln -sf /var/www/vendor/bolt/bolt/theme/base-2014 /var/www/public/theme/base-2014 && \
    ln -sf /var/www/vendor/bolt/bolt/theme /var/www/theme && \
    chown -R www-data /var/www/app

EXPOSE 80
EXPOSE 443

CMD ["/usr/bin/supervisord", "-n"]
