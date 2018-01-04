#!/usr/bin/env sh

##############################################
# Runs once and then block for you to debug. #
# If you want to re-run this, deletethe log  #
# file and "start" again.		     #
##############################################

if [ -f "/tmp/already.ran.lock" ]; then
    echo "Already ran the Entrypoint once. Holding indefinitely for debugging."
    tail -f /dev/null
fi

#Create the run file                                                                                                                                                                                    
touch /tmp/already.ran.lock

############################################################################################
# In order to avoid running as "root", we'll detect the invoking user's uid/gid		   #
# based on the injected/myuser file and create an identical user within this container.	   #
# This has the added side affect of not having to mess with permissions on the bind mount. #
############################################################################################
WHO=/myuser
TARGETUSER=hugo
echo "Checking if user 'hugo' exists - we will create one to match your local user"
id -u $TARGETUSER
USEREXISTS=$?
if [[ $USEREXISTS != 0 ]]; then
    stat $WHO > /dev/null || (echo You must mount a file to "$WHO" in order to properly assume user && exit 1)
    USERID=$(stat -c %u $WHO)
    GROUPID=$(stat -c %g $WHO)
    echo "User $TARGETUSER UID = $USERID"
    echo "User $TARGETUSER GID = $GROUPID"
    
    #Create a user with aligned UID/GID as invoking user
    deluser $TARGETUSER
    addgroup -g $GROUPID $TARGETUSER
    adduser -u $USERID -G $TARGETUSER -D -s /bin/sh $TARGETUSER
    echo "Your users dropped principal is"
    sudo -u $TARGETUSER id
else
    echo "User $TARGETUSER already created..."
fi

echo "Saving username to $WHO for run process to use"
echo "$TARGETUSER" > $WHO

#Re-own the /src directory
echo "Giving permissions on /src, /output (bind mounted) to $TARGETUSER"
chown $TARGETUSER /src /output -Rv

#Finally execute the actual target
exec sudo -E -u $TARGETUSER  "/run.sh" "$@"
