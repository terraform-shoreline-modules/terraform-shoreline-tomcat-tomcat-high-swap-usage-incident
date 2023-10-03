

#!/bin/bash



# Stop the Tomcat server

sudo systemctl stop tomcat.service



# Wait for 10 seconds to ensure the server has stopped

sleep 10



# Clear the swap memory usage

sudo swapoff -a && sudo swapon -a



# Start the Tomcat server

sudo systemctl start tomcat.service