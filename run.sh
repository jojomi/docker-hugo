#!/usr/bin/env sh

WATCH="${HUGO_WATCH:=false}"
SLEEP="${HUGO_REFRESH_TIME:=-1}"
echo "HUGO_WATCH:" $WATCH
echo "HUGO_REFRESH_TIME:" $HUGO_REFRESH_TIME
echo "HUGO_THEME:" $HUGO_THEME


while [ true ]
do
    if [[ $HUGO_WATCH != 'false' ]]; then
        /bin/hugo server --watch=true --source="/src" --theme="$HUGO_THEME" --destination="/output" || exit 1
    else
        /bin/hugo --source="/src" --theme="$HUGO_THEME" --destination="/output" || exit 1
    fi

    if [[ $HUGO_REFRESH_TIME == -1 ]]; then
        exit 0
    fi
    sleep $SLEEP
done

