FROM alpine:3.18.3
ENV FTP_USER=foo \
	FTP_PASS=bar \
	GID=1000 \
	UID=1000 \
    PASV_ADDRESS=0.0.0.0 \
	PASV_MIN_PORT=40000 \
    PASV_MAX_PORT=40009

RUN apk add --no-cache --update \
	vsftpd==3.0.5-r2

COPY [ "/src/vsftpd.conf", "/etc" ]
COPY [ "/src/docker-entrypoint.sh", "/" ]

CMD [ "/usr/sbin/vsftpd" ]
ENTRYPOINT [ "/docker-entrypoint.sh" ]
EXPOSE 20/tcp 21/tcp 40000-40009/tcp
HEALTHCHECK CMD netstat -lnt | grep :21 || exit 1
