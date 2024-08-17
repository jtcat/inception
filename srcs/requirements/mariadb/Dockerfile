FROM alpine:3.19

RUN	apk update && apk add bash mariadb mariadb-client

ADD tools/entrypoint.sh /usr/local/bin/entrypoint.sh

RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 3306

CMD ["/usr/local/bin/entrypoint.sh"]
