#!/bin/bash
# set -o xtrace

VERSION=$1

PORT=1313
NAME=test-hugo

# set version in Dockerfile
sed -i "s/HUGO_VERSION=[0-9.]\+/HUGO_VERSION=$VERSION/g" Dockerfile

# cleanup container
docker stop "$NAME"
docker rm "$NAME"
rm -rf test-output

# build image
docker build --no-cache=true --pull --tag jojomi/hugo:latest .

# verify image build
docker images | grep jojomi/hugo | grep latest

# run container
mkdir --parents test-output
docker run \
  --env HUGO_WATCH=true \
  --env HUGO_BASEURL=http://localhost:$PORT \
  --name "$NAME" \
  --volume "$(pwd)/test-src:/src" \
  --volume "$(pwd)/test-output:/output" \
  --publish "$PORT:1313" \
  --detach \
  jojomi/hugo:latest
docker ps | grep "$NAME"

# verify output
xdg-open http://localhost:$PORT > /dev/null

# ask for continuation
read -r -p "Does it work? [y/N] " prompt

# cleanup container
docker stop "$NAME"
docker rm "$NAME"
sudo rm -rf test-output

if [[ $prompt == "y" || $prompt == "Y" || $prompt == "yes" || $prompt == "Yes" ]]
then
  # git: commit, tag, push
  git add Dockerfile && git commit -m "version $VERSION" && git tag $VERSION && git push && git push --tags
  # open hub.docker.com
  xdg-open https://hub.docker.com/r/jojomi/hugo/builds/ > /dev/null
  xdg-open https://hub.docker.com/r/jojomi/hugo/~/settings/automated-builds/ > /dev/null
fi


