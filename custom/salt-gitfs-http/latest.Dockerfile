FROM alpine:latest

# The container listens on port 80
EXPOSE 80

# This is where the repositories will be stored, and
# should be mounted from the host (or a volume container)
VOLUME ["/repos"]

RUN apk add --update nginx && \
    apk add --update git && \
    apk add --update supervisor && \
    apk add --update uwsgi && \
    rm -rf /var/cache/apk/*

COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY conf/users /etc/nginx/auth-users
COPY conf/uwsgi.yml /etc/uwsgi/gitfs.yml
COPY conf/supervisord.conf /etc/supervisord.conf

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
