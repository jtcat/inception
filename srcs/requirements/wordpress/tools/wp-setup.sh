#!/bin/sh

# Modifying www.conf

sed -i "s|;listen.owner\s*=\s*nobody|listen.owner = ${PHP_FPM_USER}|g" /etc/php82/php-fpm.d/www.conf
sed -i "s|;listen.group\s*=\s*nobody|listen.group = ${PHP_FPM_GROUP}|g" /etc/php82/php-fpm.d/www.conf
sed -i "s|;listen.mode\s*=\s*0660|listen.mode = ${PHP_FPM_LISTEN_MODE}|g" /etc/php82/php-fpm.d/www.conf
sed -i "s|user\s*=\s*nobody|user = ${PHP_FPM_USER}|g" /etc/php82/php-fpm.d/www.conf
sed -i "s|group\s*=\s*nobody|group = ${PHP_FPM_GROUP}|g" /etc/php82/php-fpm.d/www.conf
sed -i "s|;log_level\s*=\s*notice|log_level = error|g" /etc/php82/php-fpm.d/www.conf #uncommenting line 
sed -i "s|listen\s*=\s*127.0.0.1:9000|listen = wordpress:9000|g" /etc/php82/php-fpm.d/www.conf
# Modifying php.ini

sed -i "s|display_errors\s*=\s*Off|display_errors = ${PHP_DISPLAY_ERRORS}|i" /etc/php82/php.ini
sed -i "s|display_startup_errors\s*=\s*Off|display_startup_errors = ${PHP_DISPLAY_STARTUP_ERRORS}|i" /etc/php82/php.ini
sed -i "s|error_reporting\s*=\s*E_ALL & ~E_DEPRECATED & ~E_STRICT|error_reporting = ${PHP_ERROR_REPORTING}|i" /etc/php82/php.ini
sed -i "s|;*memory_limit =.*|memory_limit = ${PHP_MEMORY_LIMIT}|i" /etc/php82/php.ini
sed -i "s|;*upload_max_filesize =.*|upload_max_filesize = ${PHP_MAX_UPLOAD}|i" /etc/php82/php.ini
sed -i "s|;*max_file_uploads =.*|max_file_uploads = ${PHP_MAX_FILE_UPLOAD}|i" /etc/php82/php.ini
sed -i "s|;*post_max_size =.*|post_max_size = ${PHP_MAX_POST}|i" /etc/php82/php.ini
sed -i "s|;*cgi.fix_pathinfo=.*|cgi.fix_pathinfo= ${PHP_CGI_FIX_PATHINFO}|i" /etc/php82/php.ini

cd /usr/share/webapps/joaoteix.42.fr

sed -i -r "s/DB_NAME_PW/$WORDPRESS_DB_NAME/1" wp-config.php
sed -i -r "s/DB_USER_PW/$WORDPRESS_DB_USER/1" wp-config.php
sed -i -r "s/DB_HOST_PW/$WORDPRESS_DB_HOST/1" wp-config.php
sed -i -r "s/DB_PASSWORD_PW/$(cat $WORDPRESS_DB_PASSWORD_FILE)/1" wp-config.php
#sed -i -r "s/DB_PASSWORD_PW/ananas/1" wp-config.php

#ln -s /usr/share/webapps/wordpress/ /var/www/localhost/htdocs/wordpress

wp core install --allow-root --url=joaoteix.42.fr --title="Inception" --admin_user=wpcli --admin_password=wpcli --admin_email=info@wp-cli.org

wp user create writer writer@42.fr --role=author --user_pass=$(cat /run/secrets/wp_author_password)

exec php-fpm82 -RF
