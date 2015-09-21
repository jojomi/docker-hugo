#!/usr/bin/env sh

WATCH="${HUGO_WATCH:=false}"
SLEEP="${HUGO_REFRESH_TIME:=-1}"
echo "HUGO_WATCH:" $WATCH
echo "HUGO_REFRESH_TIME:" $HUGO_REFRESH_TIME
echo "HUGO_THEME:" $HUGO_THEME
echo "HUGO_BASEURL" $HUGO_BASEURL

HUGO=/usr/bin/hugo

while [ true ]
do
    if [[ $HUGO_WATCH != 'false' ]]; then
        $HUGO server --watch=true --source="/src" --theme="$HUGO_THEME" --destination="/output" --baseUrl="$HUGO_BASEURL" || exit 1
    else
        $HUGO --source="/src" --theme="$HUGO_THEME" --destination="/output" --baseUrl="$HUGO_BASEURL" || exit 1
    fi

    if [[ $HUGO_REFRESH_TIME == -1 ]]; then
        exit 0
    fi
    sleep $SLEEP
done

