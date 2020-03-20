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

# To use important variables from command line use the following code:
COMMAND=$0    # Zero argument is shell command
PTEMPDIR=$1   # First argument is temp folder during install
PSHNAME=$2    # Second argument is Plugin-Name for scipts etc.
PDIR=$3       # Third argument is Plugin installation folder
PVERSION=$4   # Forth argument is Plugin version
#LBHOMEDIR=$5 # Comes from /etc/environment now. Fifth argument is
              # Base folder of LoxBerry

# Combine them with /etc/environment
PCGI=$LBPCGI/$PDIR
PHTML=$LBPHTML/$PDIR
PTEMPL=$LBPTEMPL/$PDIR
PDATA=$LBPDATA/$PDIR
PLOG=$LBPLOG/$PDIR # Note! This is stored on a Ramdisk now!
PCONFIG=$LBPCONFIG/$PDIR
PSBIN=$LBPSBIN/$PDIR
PBIN=$LBPBIN/$PDIR

if [ -d $PDATA ]
then 
    # change to raumserver folder
    cd $PDATA
    
    #check if raumserver already installed
    if [ `npm list | grep -c "node-raumserver"` -ne 1 ]
    then
        /usr/bin/logger "Raumserver installation: node module raumserver not instlled. Starting installation now."
        # otherwise install the server
        npm install github:ChriD/node-raumserver
    fi

    /usr/bin/logger "Raumserver: starting."
    #run the server: 
    cd $PDATA/node_modules/node-raumserver/
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
