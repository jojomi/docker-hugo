#!/usr/bin/env sh

echo -e 'HUGO_WATCH: \t'   ${HUGO_WATCH:-false}
echo -e 'HUGO_THEME: \t'   ${HUGO_THEME:-undefined}
echo -e 'HUGO_BASEURL: \t' ${HUGO_BASEURL:-undefined}
echo -e 'ARGS: \t' $@

if [[ $HUGO_WATCH != 'false' ]]; then
    echo "Watching...";
    exec hugo \
            server \
                --watch=true \
                --source="/src" \
                --theme="$HUGO_THEME" \
                --destination="/output" \
                --baseUrl="$HUGO_BASEURL" \
                --bind="0.0.0.0" "$@";
else
    echo "Building one time...";
    exec hugo \
            --source="/src" \
            --theme="$HUGO_THEME" \
            --destination="/output" \
            --baseUrl="$HUGO_BASEURL" "$@";
fi
