#!/usr/bin/env bash
# set -o xtrace

echo "usage: DOCKER_ORG=richt ./update.sh 0.81.0"

VERSION="${VERSION:-"$1"}"
DOCKER_ORG="${DOCKER_ORG:-jojomi}"
PORT="${PORT:-1313}"
NAME=test-hugo
OUTPUT="${OUTPUT:-"$(mktemp)"}"

# set version in Dockerfile
sed -i "s/HUGO_VERSION=[0-9.]\+/HUGO_VERSION=$VERSION/g" Dockerfile

# cleanup container
docker stop "$NAME"
docker rm "$NAME"
rm -rf "$OUTPUT"

# build image
docker build --no-cache=true --pull --tag "$DOCKER_ORG/hugo:$VERSION" .

# verify image build
docker images | grep "$DOCKER_ORG/hugo" | grep "$VERSION"

# run container
mkdir --parents test-output
docker run \
  --env HUGO_WATCH=true \
  --env "HUGO_BASEURL=http://localhost:$PORT" \
  --name "$NAME" \
  --volume "$PWD/test-src:/src" \
  --volume "$OUTPUT:/output" \
  --publish "$PORT:1313" \
  --detach \
  "$DOCKER_ORG/hugo:$VERSION"
docker ps | grep "$NAME"

# verify output
OPEN="${OPEN:-xdg-open}"
if [[ $OSTYPE =~ darwin ]]; then
  OPEN=open
fi
"$OPEN" "http://localhost:$PORT" > /dev/null

# ask for continuation
read -r -p "Does it work if should I push to git hub? [y/N] " prompt

# cleanup container
docker stop "$NAME"
docker rm "$NAME"
rm -rf "$OUTPUT"

if [[ $prompt =~ ^[yY] ]]
then
  # git: commit, tag, push
  git add Dockerfile && \
    git commit -m "version $VERSION" && git tag "$VERSION" && git push && git push --tags
  # open hub.docker.com
  "$OPEN" "https://hub.docker.com/r/$DOCKER_ORG/hugo/builds/" > /dev/null
  "$OPEN" "https://hub.docker.com/r/$DOCKER_ORG/hugo/~/settings/automated-builds/" > /dev/null
fi
