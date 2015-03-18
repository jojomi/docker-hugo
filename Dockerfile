FROM gliderlabs/alpine:3.1
MAINTAINER Johannes Mitlmeier <dev.jojomi@yahoo.com>

RUN apk add --update \
    bash \
  && rm -rf /var/cache/apk/*

COPY ./hugo_linux_amd64 /bin/hugo
COPY ./run.sh /run.sh

VOLUME /src
VOLUME /output

WORKDIR /src
CMD ["/run.sh"]

EXPOSE 1313
