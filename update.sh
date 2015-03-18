#!/usr/bin/env bash
# build jojomi/hugo:tag by

RELEASE=${1:-0.13}

case $RELEASE in
    git )
         # for building latest git version go toolchain
         # is assumed to be installed and GOPATH set
         go get -u -v github.com/spf13/hugo
         # move
         mv "$GOPATH/bin/hugo" "hugo_linux_amd64"
         ;;
    * )
        # download
        curl -L https://github.com/spf13/hugo/releases/download/v${RELEASE}/hugo_${RELEASE}_linux_amd64.tar.gz | tar xvz
        # move
        rm "hugo_linux_amd64"
        mv "hugo_${RELEASE}_linux_amd64/hugo_${RELEASE}_linux_amd64" "hugo_linux_amd64"
        rm -rf "hugo_${RELEASE}_linux_amd64"
        ;;
esac

# rebuild image
docker build -t jojomi/hugo:$RELEASE .
