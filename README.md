
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Tomcat High Swap Usage Incident
---

Tomcat High Swap Usage Incident refers to an event where Tomcat, a popular open-source web server, is experiencing high swap usage. Swap usage is a memory management technique used by the operating system to temporarily move data from RAM to the hard disk. When Tomcat is consuming high swap memory, it can cause the server to slow down or even crash, resulting in downtime for the website or application hosted on the server. This incident type requires immediate attention to identify the root cause and resolve the issue to prevent further downtime.

### Parameters
```shell
export PATH_TO_TOMCAT_LOG_FILES="PLACEHOLDER"

export PATH_TO_TOMCAT_CONFIGURATION_FILES="PLACEHOLDER"

export TOMCAT_PORT_NUMBER="PLACEHOLDER"

export PATH_TO_TOMCAT_CONFIG_FILE="PLACEHOLDER"

export DESIRED_HEAP_SIZE="PLACEHOLDER"
```

## Debug

### Check swap usage
```shell
free -h
```

### Check which processes are using the most swap space
```shell
sudo swapon --show --bytes | awk '{print $1}' | xargs -n 1 sudo swapstat -p | sort -k3 -n -r | head -n 10
```

### Check which processes are consuming the most memory
```shell
ps -eo pid,ppid,%mem,%cpu,cmd --sort=-%mem | head -n 11
```

### Check the Tomcat log files for any errors or warnings
```shell
sudo tail -f ${PATH_TO_TOMCAT_LOG_FILES}
```

### Check the Tomcat configuration files for any misconfigurations
```shell
sudo cat ${PATH_TO_TOMCAT_CONFIGURATION_FILES}
```

### Check the Tomcat server status
```shell
sudo systemctl status tomcat
```

### Check the system resource usage
```shell
top
```

### Check network connections to the Tomcat server
```shell
sudo netstat -tulpn | grep ${TOMCAT_PORT_NUMBER}
```

### Check if any other services or applications are consuming high resources
```shell
sudo top
```

## Repair

### Review the Tomcat server configuration settings to ensure that the JVM heap size is optimized correctly.
```shell


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


```

### Restart the Tomcat server to clear the swap memory usage.
```shell


#!/bin/bash



# Stop the Tomcat server

sudo systemctl stop tomcat.service



# Wait for 10 seconds to ensure the server has stopped

sleep 10



# Clear the swap memory usage

sudo swapoff -a && sudo swapon -a



# Start the Tomcat server

sudo systemctl start tomcat.service


```