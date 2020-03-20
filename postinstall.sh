#!/bin/sh

# Bashscript which is executed by bash *AFTER* complete installation is done
# (but *BEFORE* postupdate). Use with caution and remember, that all systems
# may be different! Better to do this in your own Pluginscript if possible.
#
# Exit code must be 0 if executed successfull.
#
# Will be executed as user "loxberry".
#
# We add 5 arguments when executing the script:
# command <TEMPFOLDER> <NAME> <FOLDER> <VERSION> <BASEFOLDER>
#
# For logging, print to STDOUT. You can use the following tags for showing
# different colorized information during plugin installation:
#
# <OK> This was ok!"
# <INFO> This is just for your information."
# <WARNING> This is a warning!"
# <ERROR> This is an error!"
# <FAIL> This is a fail!"

if [ -d '/opt/loxberry/data/plugins/raumserver' ]
then 
    # change to raumserver folder
    cd /opt/loxberry/data/plugins/raumserver
    
    #check if raumserver already installed
    if [ `npm list | grep -c "node-raumserver"` -ne 1 ]
    then
        /usr/bin/logger "Raumserver installation: node module raumserver not instlled. Starting installation now."
        # otherwise install the server
        npm install github:ChriD/node-raumserver
    fi

    /usr/bin/logger "Raumserver: starting."
    #run the server: 
    cd /opt/loxberry/data/plugins/raumserver/node_modules/node-raumserver/
    node raumserver.js &

    if [ `ps ax | grep -v grep | grep -c raumserver.js` -eq 1 ]
    then
        /usr/bin/logger "Raumserver: Start successful."
    else
        /usr/bin/logger "Raumserver: Start failed."
    fi
fi


# Exit with Status 0
exit 0
