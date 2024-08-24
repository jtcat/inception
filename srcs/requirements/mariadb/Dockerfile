FROM alpine:3.19

RUN	apk update && apk add bash mariadb mariadb-client

ADD --chmod=110 tools/entrypoint.sh /usr/local/bin/entrypoint.sh

ADD --chmod=110 tools/db_ready.sh /usr/local/bin/db_ready

EXPOSE 3306

CMD ["/usr/local/bin/entrypoint.sh"]
