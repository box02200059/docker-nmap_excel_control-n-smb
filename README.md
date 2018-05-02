Docker for nmap_excel_control and smb
===================

## Dockerfile
```
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
    && mkdir /config /shared \
    && touch /shared/target.txt

COPY *.conf /config/
COPY *.py /shared/

RUN addgroup -g 1000 hmg \
    && adduser -D -H -G hmg -s /bin/false -u 1000 hmg \
    && echo -e "1qaz@WSX3edc\n1qaz@WSX3edc" | smbpasswd -a -s -c /config/smb.conf hmg

VOLUME /config /shared

EXPOSE 137/udp 138/udp 139 445

ENTRYPOINT ["supervisord", "-c", "/config/supervisord.conf"]

#Reference pwntr/samba-alpine

```

## Build 
```sh
docker build -t docker-nmap_excel_control-n-smb .
```

## Run
```sh
docker run -dit --net=host -v /path/to/share/:/shared --name scan_machine astroicers/docker-nmap_excel_control-n-smb
```

## HOW TO USE
```sh
docker exec -it scan_machine sh
cd /shared
python nmap_excel_control.py
```
After second step, remember to revise target.txt .
## REFER TO

#### Docker hub
[pwntr/samba-alpine](https://hub.docker.com/r/pwntr/samba-alpine/)

#### Blog
http://www.vixual.net/blog/archives/82

https://www.cyberciti.biz/faq/how-to-enable-and-start-services-on-alpine-linux/