#!/bin/bash

echo "Running the user data script"
echo "$PWD"
cd /home/ec2-user/minecraft_server/app
echo "Changing directories"
echo "$PWD"
echo "Starting server"
sudo java -Xmx4G -Xms4G -jar server.jar nogui &
echo "Server started"

# Using spigot
#java -Xmx4G -Xms4G -jar spigot-1.20.6.jar --nogui