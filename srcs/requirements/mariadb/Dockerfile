FROM alpine:3.19.1

RUN	apk add mysql mysql-client \
	&& rc-service mariadb setup \
	&& mysql_secure_installation \
	&& rc-update add mariadb default
