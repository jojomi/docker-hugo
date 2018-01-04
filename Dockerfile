FROM alpine:latest
MAINTAINER Johannes Mitlmeier <dev.jojomi@yahoo.com>

COPY ./run.sh /run.sh
ENV HUGO_VERSION=0.32.2

#Pick a suitably high GID for sudo group. 
RUN addgroup sudo -g 4001 

ADD https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_${HUGO_VERSION}_Linux-64bit.tar.gz /tmp
RUN tar -xf /tmp/hugo_${HUGO_VERSION}_Linux-64bit.tar.gz -C /tmp \
    && mkdir -p /usr/local/sbin \
    && mv /tmp/hugo /usr/local/sbin/hugo \
    && rm -rf /tmp/hugo_${HUGO_VERSION}_linux_amd64

RUN apk add --update git \
    && apk upgrade \
    && apk add --no-cache ca-certificates \
    && apk add sudo

VOLUME /src
VOLUME /output

WORKDIR /src
COPY ./docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 1313
