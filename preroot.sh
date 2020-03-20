#!/bin/sh

# Bash script which is executed by bash *BEFORE* installation is started
# (*BEFORE* preinstall but *AFTER* preupdate). Use with caution and remember,
# that all systems may be different!
#
# Exit code must be 0 if executed successfull. 
# Exit code 1 gives a warning but continues installation.
# Exit code 2 cancels installation.
#
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# Will be executed as user "root".
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#
# You can use all vars from /etc/environment in this script.
#
# We add 5 additional arguments when executing this script:
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

# echo "<INFO> Command is: $COMMAND"
# echo "<INFO> Temporary folder is: $TEMPDIR"
# echo "<INFO> (Short) Name is: $PSHNAME"
# echo "<INFO> Installation folder is: $ARGV3"
# echo "<INFO> Plugin version is: $ARGV4"
# echo "<INFO> Plugin CGI folder is: $PCGI"
# echo "<INFO> Plugin HTML folder is: $PHTML"
# echo "<INFO> Plugin Template folder is: $PTEMPL"
# echo "<INFO> Plugin Data folder is: $PDATA"
# echo "<INFO> Plugin Log folder (on RAMDISK!) is: $PLOG"
# echo "<INFO> Plugin CONFIG folder is: $PCONFIG"


# Test if nodejs is installed otherwise install it: 
if [ `which nodejs > /dev/null; echo $?` -ne 0 ] || [ `which npm > /dev/null; echo $?` -ne 0 ]
then 
    if [ `grep Hardware /proc/cpuinfo | grep -E -c 'BCM[0-9]+'` -eq 1 ]
    then 
        # based on https://github.com/audstanley/NodeJs-Raspberry-Pi/
        PICHIP=$(uname -m);
        LINKTONODE=$(curl -sG https://nodejs.org/dist/latest-v9.x/ | awk '{print $2}' | grep -P 'href=\"node-v9\.\d{1,}\.\d{1,}-linux-'$PICHIP'\.tar\.gz' | sed 's/href="//' | sed 's/<\/a>//' | sed 's/">.*//');
        NODEFOLDER=$(echo $LINKTONODE | sed 's/.tar.gz/\//');
        #Next, Creates directory for downloads, and downloads node 8.x
        cd /tmp && mkdir tempNode && cd tempNode && wget https://nodejs.org/dist/latest-v9.x/$LINKTONODE;
        tar -xzf $LINKTONODE; &&
        #Remove the tar after extracing it.
        rm $LINKTONODE;
        #remove older version of node:
        rm -R -f /opt/nodejs/;
        #remove symlinks
        rm /usr/bin/node /usr/sbin/node /sbin/node /sbin/node /usr/local/bin/node /usr/bin/npm /usr/sbin/npm /sbin/npm /usr/local/bin/npm 2> /dev/null;
        #This next line will copy Node over to the appropriate folder.
        mv /tmp/tempNode/$NODEFOLDER /opt/nodejs/;
        #This line will remove the nodeJs tar we downloaded.
        rm -R -f /tmp/tempNode/$LINKTONODE/;
        #Create symlinks to node && npm
        ln -s /opt/nodejs/bin/node /usr/bin/node; ln -s /opt/nodejs/bin/node /usr/sbin/node; 
        ln -s /opt/nodejs/bin/node /sbin/node; ln -s /opt/nodejs/bin/node /usr/local/bin/node; 
        ln -s /opt/nodejs/bin/npm /usr/bin/npm; 
        ln -s /opt/nodejs/bin/npm /usr/sbin/npm; ln -s /opt/nodejs/bin/npm /sbin/npm; 
        ln -s /opt/nodejs/bin/npm /usr/local/bin/npm; 
        exit 0
    else 
        if [ ! -f /etc/apt/sources.list.d/nodesource.list ]
        then 
            /usr/bin/logger "Raumserver installation: nodesources repo not installed. Starting installation now."
            # Nodejs current is recommended as of
            #  https://github.com/ChriD/node-raumserver#requirements
            curl -sL https://deb.nodesource.com/setup_8.x | bash
            apt-get -y install nodejs && exit 0
        fi
    fi
fi

exit 2