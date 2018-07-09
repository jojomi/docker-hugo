#!/bin/sh


WATCH="${HUGO_WATCH:=false}"
SLEEP="${HUGO_REFRESH_TIME:=-1}"
HUGO_DESTINATION="${HUGO_DESTINATION:=/output}"
#Try to detect our public IP
HUGO_IP=$(awk 'END{print $1}' /etc/hosts)
#Should we create a new site first?
HUGO_NEW=${HUGO_NEW:=false}

echo "HUGO_WATCH: " $WATCH
echo "HUGO_REFRESH_TIME: " $HUGO_REFRESH_TIME
echo "HUGO_THEME: " $HUGO_THEME
echo "HUGO_BASEURL: " $HUGO_BASEURL
echo "HUGO_IP: " $HUGO_IP
echo "HUGO_NEW: " $HUGO_NEW
echo "HUGO_BASEURL_IS_IP: " $HUGO_BASEURL_IS_IP
echo "Arguments: " $@

HUGO=/usr/local/sbin/hugo
echo "Hugo path: $HUGO"

if test "$HUGO_NEW" = 'true' && test ! -f "/src/config.toml" ;then
    echo "Creating a new Hugo installation under /src"
    $HUGO new site /src
    cd /src
    $HUGO new posts/my-first-post.md
fi
   
#Force the baseURL to IP if requested
if test "$HUGO_BASEURL_IS_IP"  = 'true'; then
    HUGO_BASEURL=$HUGO_IP
fi


while :
do
    if test "$HUGO_WATCH" = 'true' ; then
	echo "Watching..."
	echo "$HUGO server --watch=true --source="/src" --theme="$HUGO_THEME" --destination="$HUGO_DESTINATION" --baseURL="$HUGO_BASEURL" --bind="$HUGO_IP" "$@" || exit 1"
        $HUGO server --watch=true --source="/src" --theme="$HUGO_THEME" --destination="$HUGO_DESTINATION" --baseURL="$HUGO_BASEURL" --bind="$HUGO_IP" "$@" || exit 1
    else
	echo "Building one time..."
        $HUGO --source="/src" --theme="$HUGO_THEME" --destination="$HUGO_DESTINATION" --baseURL="$HUGO_BASEURL" "$@" || exit 1
    fi

    if test "$HUGO_REFRESH_TIME" = '-1' ; then
        exit 0
    fi
    echo "Sleeping for $HUGO_REFRESH_TIME seconds..."
    sleep $SLEEP
done
