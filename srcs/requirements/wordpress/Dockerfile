FROM alpine:3.19

EXPOSE 3306
EXPOSE 9000

ENV PHP_FPM_USER="www" \
	PHP_FPM_GROUP="www" \
	PHP_FPM_LISTEN_MODE="0660" \
	PHP_MEMORY_LIMIT="512M" \
	PHP_MAX_UPLOAD="50M" \
	PHP_MAX_FILE_UPLOAD="200" \
	PHP_MAX_POST="100M" \
	PHP_DISPLAY_ERRORS="On" \
	PHP_DISPLAY_STARTUP_ERRORS="On" \
	PHP_ERROR_REPORTING="E_COMPILE_ERROR\|E_RECOVERABLE_ERROR\|E_ERROR\|E_CORE_ERROR" \
	PHP_CGI_FIX_PATHINFO=0

RUN	apk add wget php82 php82-phar php82-fpm php82-iconv fcgi php82-cgi php82-mysqli \
	&& adduser -D -g 'www' www \
	&& mkdir /usr/share/webapps

ADD --chmod=770 https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar /usr/local/bin/wp

RUN wp core download --allow-root --path='/usr/share/webapps/joaoteix.42.fr'

COPY conf/wp-config.php /usr/share/webapps/joaoteix.42.fr/wp-config.php
COPY --chmod=110 tools/wp-setup.sh /tmp/wp-setup.sh

CMD ["/tmp/wp-setup.sh"]
