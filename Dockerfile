# Use Alpine Linux as our base image so that we minimize the overall size our final container, and minimize the surface area of packages that could be out of date.
FROM alpine:3.7@sha256:7b848083f93822dd21b0a2f14a110bd99f6efb4b838d499df6d04a49d0debf8b

LABEL description="Docker container for building static sites with the Hugo static site generator."
LABEL maintainer="Johannes Mitlmeier <dev.jojomi@yahoo.com>"

COPY ./run.sh /run.sh
ENV HUGO_VERSION=0.37
ADD https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_${HUGO_VERSION}_Linux-64bit.tar.gz /tmp
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

WORKDIR /src
CMD ["/run.sh"]

EXPOSE 1313
