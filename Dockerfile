# Use Alpine Linux as our base image so that we minimize the overall size our final container, and minimize the surface area of packages that could be out of date.
FROM alpine:3.7@sha256:5ce5f501c457015c4b91f91a15ac69157d9b06f1a75cf9107bf2b62e0843983a

LABEL description="Docker container for building static sites with the Hugo static site generator."
LABEL maintainer="Johannes Mitlmeier <dev.jojomi@yahoo.com>"

# config
ENV HUGO_VERSION=0.43
ENV HUGO_TYPE=_extended
# without SCSS/SASS support: ENV HUGO_TYPE=

COPY ./run.sh /run.sh
ADD https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo${HUGO_TYPE}_${HUGO_VERSION}_Linux-64bit.tar.gz /tmp
RUN tar -xf /tmp/hugo_${HUGO_VERSION}_Linux-64bit.tar.gz -C /tmp \
    && mkdir -p /usr/local/sbin \
    && mv /tmp/hugo /usr/local/sbin/hugo \
    && rm -rf /tmp/hugo_${HUGO_VERSION}_linux_amd64 \
    && rm -rf /tmp/hugo_${HUGO_VERSION}_Linux-64bit.tar.gz \
    && rm -rf /tmp/LICENSE.md \
    && rm -rf /tmp/README.md

RUN apk add --update git \
    && apk upgrade \
    && apk add --no-cache ca-certificates

VOLUME /src
VOLUME /output

RUN chmod 0777 /run.sh && ls -lahr / && whoami && cat /run.sh && which sh

WORKDIR /src
CMD ["/run.sh"]

EXPOSE 1313
