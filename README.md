# docker-hugo

Docker image for hugo static page generator (https://gohugo.io)

HEY THIS IS A THING FRIEND


## Environment Variables

* `HUGO_WATCH` (set to any value to enable watching)
* `HUGO_SRC` (Path where hugo will search for the site. By default `/src`)
* `HUGO_DESTINATION` (Path where hugo will render the site. By default `/output`)
* `HUGO_REFRESH_TIME` (in seconds, only applies if not watching, if not set, the container will build once and exit)
* `HUGO_BASEURL`
* `HUGO_APPEND_PORT`


## Executing

    docker run --name "my-hugo" -P -v $(pwd):/src thall/hugo

Or, more verbosely, and with a specified output mapping:

    docker run --name "my-hugo" --publish-all \
           --volume $(pwd):/src \
           --volume /tmp/hugo-build-output:/output \
           thall/hugo

Find your container:

    docker ps | grep "my-hugo"
    CONTAINER ID        IMAGE                           COMMAND                CREATED             STATUS              PORTS                   NAMES
    ba00b5c238fc        thall/hugo:latest   "/run.sh"              7 seconds ago       Up 6 seconds        1313/tcp      my-hugo


## Building The Image Yourself (optional)

    docker build -t thall/hugo:latest .

The image is conveniently small at **about 20 MB** thanks to [alpine](http://gliderlabs.viewdocs.io/docker-alpine):

    docker images | grep hugo
    thall/hugo:0.18   latest              b2e7a8364baa        1 second ago      21.9 MB



## Creating a new tag

Create a new git branch, change the line `ENV HUGO_VERSION=0.18` in `Dockerfile` and wire it in the Docker Hub accordingly.


## docker-compose

Using this docker image together with nginx for serving static data.

`docker-compose.yml`

```
hugo:
  image: thall/hugo:latest
  volumes:
    - ./src/:/src
    - ./output/:/output
  environment:
    - HUGO_REFRESH_TIME=3600
    - HUGO_BASEURL=mydomain.com
  restart: always

web:
  image: thall/nginx-static
  volumes:
    - ./output:/var/www
  environment:
    - VIRTUAL_HOST=mydomain.com
  ports:
    - 80
  restart: always
```

`VIRTUAL_HOST` is set for use with jwilder's `nginx-proxy`:

`docker-compose.yml`

```
proxy:
  image: jwilder/nginx-proxy
  ports:
    - 80:80
    - 443:443
  volumes:
    - /var/run/docker.sock:/tmp/docker.sock
    - vhost.d:/etc/nginx/vhost.d:ro
  restart: always
```


## Update Image on Hugo Update

```./update.sh 0.25```
