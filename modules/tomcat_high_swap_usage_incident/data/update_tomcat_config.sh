

#!/bin/bash



# Set the path to the Tomcat configuration file

TOMCAT_CONFIG=${PATH_TO_TOMCAT_CONFIG_FILE}



# Set the desired heap size

HEAP_SIZE=${DESIRED_HEAP_SIZE}



# Backup the original configuration file

cp $TOMCAT_CONFIG $TOMCAT_CONFIG.bak



# Edit the configuration file to set the heap size

sed -i "s/-Xmx[0-9]*[mMgG]/-Xmx${HEAP_SIZE}/g" $TOMCAT_CONFIG



# Restart Tomcat to apply the new configuration

systemctl restart tomcat