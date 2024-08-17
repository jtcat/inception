FROM alpine:3.19.1

RUN	apk update && apk add nginx \
	&& adduser -D -g 'www' www \
	&& mkdir /www \
	&& chown -R www:www /var/lib/nginx \
	&& chown -R www:www /www

COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY --chmod=111 tools/nginx-setup.sh /tmp/nginx-setup.sh

ENTRYPOINT ["tmp/nginx-setup.sh"]

CMD ["nginx"]
