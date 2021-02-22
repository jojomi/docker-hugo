# docker-hugo

Docker image for hugo static page generator [Hugo](https://gohugo.io)

## Environment Variables

* `HUGO_THEME`
* `HUGO_WATCH` (set to any value to enable watching)
* `HUGO_DESTINATION` (Path where hugo will render the site. By default `/output`)
* `HUGO_REFRESH_TIME` (in seconds, only applies if not watching, if not set,
the container will build once and exit) `HUGO_BASEURL`

## Executing

```shell
docker run --name "my-hugo" -P -v $(pwd):/src jojomi/hugo
```

Or, more verbosely, and with a specified output mapping:

```shell
docker run --name "my-hugo" --publish-all \
       --volume $(pwd):/src \
       --volume /tmp/hugo-build-output:/output \
       jojomi/hugo
 ```

Find your container:

```shell
$ docker ps | grep "my-hugo"
CONTAINER ID        IMAGE                           COMMAND                CREATED             STATUS              PORTS                   NAMES
ba00b5c238fc        jojomi/hugo:latest   "/run.sh"              7 seconds ago       Up 6 seconds        1313/tcp      my-hugo
```

## Update Image on Docker Hub

First you want to connect this repo to Docker Hub so it
[automatically](https://docs.docker.com/docker-hub/builds/link-source/) builds
from a shell script just set the environment variable to your Docker
organization and then release of Hugo you want. Note, this must be the full
version number including the ".0" or minor release.

If you have automatic build set, then as soon as you push to github, you will
create the docker version:

1. Go to [Docker Hub](https://hub.docker.com)
2. Navigate on the upper left where you see your user name
3. Goto Account Settings > Linked Accounts and authenticate with Github
4. Go to repositories > Builds and select the Github repo
5. Select the source Repo which is your github account/docker-hugo
6. Make sure to Repository Links > Enable for Base Image
7. Now everytime you do a push to master, the docker image will build.
8. Make sure to add some new Build rules so you get
   [tagging](https://stackoverflow.com/questions/25328166/docker-hub-automated-build-tagging)

The regex is very complicated here, but basically it sets the name properly in
the table, but you basically search the Github repo for the Tag name in github
and then generate the appropriate Docker tag or you can look at the example
build rules and copy what this does is to parse the Tag name looking for the
[semver](https://semver.org)
major, minor and patch and generating cascading tags

| Type   | Name                              | Dockerfile Location | Docker Tag |
|--------|-----------------------------------|---------------------|-----------------|
| Branch | master                   | Dockerfile      | latest          |
| Tag    | /^([0-9]+)\.([0-9]+)\.([0-9]+)$/ | Dockerfile  | {\1}            |
| Tag    | /^([0-9]+)\.([0-9]+)\.([0-9]+)$/ | Dockerfile   | {\1}.{\2}       |
| Tag    | /^([0-9]+)\.([0-9]+)\.([0-9]+)$/ | Dockerfile  | {\1}.{\2}.{\3}  |

```shell
export DOCKER_ORG=jojomi
./update.sh 0.81.0
# wait a little bit this will work
docker pull $DOCKER_ORG/hugo:0.81.0
```

## Building The Image Yourself (optional)

```shell
docker build -t jojomi/hugo:latest .
```

The image is conveniently small at **about 20 MB** thanks to [alpine](http://gliderlabs.viewdocs.io/docker-alpine):

```shell
docker images | grep hugo
jojomi/hugo:0.18   latest              b2e7a8364baa        1 second ago      21.9 MB
```

## Creating a new tag

Create a new git branch, change the line `ENV HUGO_VERSION=0.18` in
`Dockerfile` and wire it in the Docker Hub accordingly.

## docker-compose

Using this docker image together with nginx for serving static data.

`docker-compose.yml`

```yaml
hugo:
  image: jojomi/hugo:latest
  volumes:
    - ./src/:/src
    - ./output/:/output
  environment:
    - HUGO_REFRESH_TIME=3600
    - HUGO_THEME=mytheme
    - HUGO_BASEURL=mydomain.com
  restart: always

web:
  image: jojomi/nginx-static
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

```yaml
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
