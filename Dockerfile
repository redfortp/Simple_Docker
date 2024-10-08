FROM nginx

WORKDIR /home


HEALTHCHECK --interval=5m --timeout=3s \
    CMD curl -f http://localhost/ || exit 1

RUN apt-get update && apt-get upgrade -y \
    && apt-get install gcc -y \
    libfcgi-dev \
    spawn-fcgi \
    && rm -rf /var/lib/apt/lists

COPY ./nginx/nginx.conf /etc/nginx/nginx.conf
COPY ./server.c /home/server.c
COPY ./run.sh /home/run.sh


RUN chown -R nginx /home \
    && chown -R nginx /etc/nginx/ \
    && chown -R nginx /var/cache/ \
    && chown -R nginx /var/run/ \
    && touch /var/run/nginx.pid \
    && chown -R nginx:nginx /var/run/nginx.pid \
    && chmod u-s /usr/bin/gpasswd \
    && chmod u-s /bin/su \
    && chmod u-s /bin/mount \
    && chmod g-s /sbin/unix_chkpwd \
    && chmod u-s /usr/bin/chsh \
    && chmod u-s /usr/bin/chfn \
    && chmod u-s /usr/bin/passwd \
    && chmod g-s /usr/bin/chage \
    && chmod g-s /usr/bin/expiry \
    && chmod u-s /bin/umount \
    && chmod g-s /usr/bin/wall \
    && chmod u-s /usr/bin/newgrp

USER nginx

ENTRYPOINT ["sh", "run.sh"]