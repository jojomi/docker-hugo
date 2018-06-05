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

arguments="--source=$HUGO_SRC"
arguments="$arguments --destination=$HUGO_DESTINATION"
arguments="$arguments --baseURL=$HUGO_BASEURL"
arguments="$arguments --cleanDestinationDir"

if [[ $HUGO_WATCH != 'false' ]]; then
  arguments="$arguments --watch"
fi

$HUGO $arguments "$@" || exit 1
exit 0
