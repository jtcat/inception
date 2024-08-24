FROM alpine:3.19

EXPOSE 3306
EXPOSE 9000

RUN	apk add wget php82 php82-phar php82-fpm php82-iconv fcgi php82-cgi php82-mysqli \
	&& adduser -D -g 'www' www \
	&& mkdir /usr/share/webapps

ADD --chmod=770 https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar /usr/local/bin/wp

RUN wp core download --allow-root --path='/usr/share/webapps/joaoteix.42.fr'

COPY conf/wp-config.php /usr/share/webapps/joaoteix.42.fr/wp-config.php
COPY --chmod=110 tools/wp-setup.sh /tmp/wp-setup.sh

CMD ["/tmp/wp-setup.sh"]
