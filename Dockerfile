FROM alpine:3.6

RUN set -xe \
    && apk update \
    && apk upgrade \
    && apk add --update \
    && apk add samba \
    && apk add samba-common-tools \
    && apk add supervisor \
    && apk add python \
    && apk add python-dev \
    && apk add py-pip \
    && apk add build-base \
    && apk add vim \
    && apk add nmap \
    && pip install --upgrade pip \
    && pip install python-nmap \
    && pip install openpyxl \
    && rm -rf /var/cache/apk/* \
    && mkdir /config /shared

VOLUME /config /shared
COPY *.conf /config/
COPY *.py /shared/

RUN addgroup -g 1000 hmg \
    && adduser -D -H -G hmg -s /bin/false -u 1000 hmg \
    && echo -e "1qaz@WSX3edc\n1qaz@WSX3edc" | smbpasswd -a -s -c /config/smb.conf hmg \
    && touch /shared/target.txt



EXPOSE 137/udp 138/udp 139 445

ENTRYPOINT ["supervisord", "-c", "/config/supervisord.conf"]

#Reference pwntr/samba-alpine