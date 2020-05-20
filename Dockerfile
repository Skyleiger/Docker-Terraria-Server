FROM debian:buster-slim

LABEL maintainer="skyleiger"

RUN apt-get update \
  && apt-get upgrade -y \
  && apt-get install -y curl tzdata dos2unix unzip

ADD https://github.com/javabean/su-exec/releases/download/v0.2/su-exec.amd64 /usr/local/bin/su-exec
RUN chmod +x /usr/local/bin/su-exec

RUN addgroup --gid 1000 terraria \
  && useradd -s /bin/false -u 1000 -g terraria -d /home/terraria --create-home terraria \
  && mkdir -m 777 /data \
  && chown terraria:terraria /data /home/terraria

VOLUME ["/data"]
COPY serverconfig.txt /tmp/serverconfig.txt
WORKDIR /data

ENTRYPOINT [ "/start" ]

ENV UID=1000 GID=1000 SERVER_PORT=7777

COPY start* /
RUN dos2unix /start* && chmod +x /start*
