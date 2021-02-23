# Use Alpine Linux as our base image so that we minimize the overall size our final container, and minimize the surface area of packages that could be out of date.
FROM alpine:3.13@sha256:a75afd8b57e7f34e4dad8d65e2c7ba2e1975c795ce1ee22fa34f8cf46f96a3be

LABEL description="Docker container for building static sites with the Hugo static site generator."
LABEL maintainer="Johannes Mitlmeier <dev.jojomi@yahoo.com>"

# config
ENV HUGO_VERSION=0.81.0
#ENV HUGO_TYPE=
ENV HUGO_TYPE=_extended

COPY ./run.sh /run.sh
ENV HUGO_ID=hugo${HUGO_TYPE}_${HUGO_VERSION}
RUN wget -O - https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/${HUGO_ID}_Linux-64bit.tar.gz | tar -xz -C /tmp \
    && mkdir -p /usr/local/sbin \
    && mv /tmp/hugo /usr/local/sbin/hugo \
    && rm -rf /tmp/${HUGO_ID}_linux_amd64 \
    && rm -rf /tmp/LICENSE.md \
    && rm -rf /tmp/README.md

RUN apk add --update git asciidoctor libc6-compat libstdc++ \
    && apk upgrade \
    && apk add --no-cache ca-certificates \
    && chmod 0777 /run.sh

VOLUME /src
VOLUME /output

WORKDIR /src
CMD ["/run.sh"]

EXPOSE 1313
