#!/bin/sh

HUGO_WATCH="${HUGO_WATCH:=false}"
HUGO_SRC="${HUGO_SRC:=/src}"
HUGO_DESTINATION="${HUGO_DESTINATION:=/output}"
echo "HUGO_SRC:" $HUGO_SRC
echo "HUGO_DESTINATION" $HUGO_DESTINATION
echo "HUGO_BASEURL:" $HUGO_BASEURL
echo "HUGO_WATCH:" $HUGO_WATCH
echo "ARGS" $@

HUGO=/usr/local/sbin/hugo
echo "Hugo path: $HUGO"

arguments=(
  --source="$HUGO_SRC"
  --destination="$HUGO_DESTINATION"
  --baseURL="$HUGO_BASEURL"
  --cleanDestinationDir
)

if [[ $HUGO_WATCH != 'false' ]]; then
  arguments+=('--watch')
fi

$HUGO "${arguments[@]}" "$@" || exit 1
exit 0
