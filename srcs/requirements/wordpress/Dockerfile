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

RUN	apk add wget php82 php82-fpm fcgi php82-cgi php82-mysqli \
	&& adduser -D -g 'www' www

ADD https://wordpress.org/latest.tar.gz /usr/share/webapps/

RUN cd /usr/share/webapps && tar -xzvf latest.tar.gz \
	&& rm latest.tar.gz \
	&& mv wordpress "joaoteix.42.fr"

COPY conf/wp-config.php /usr/share/webapps/joaoteix.42.fr/wp-config.php
COPY --chmod=111 tools/wp-setup.sh /tmp/wp-setup.sh

ENTRYPOINT ["tmp/wp-setup.sh"]

CMD ["php-fpm82", "-RF"]
