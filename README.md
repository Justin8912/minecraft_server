# minecraft_server
Minecraft Server

I will document all the plans I have for making this server as well as the architecture of the current solution I have.

Goals
==
1. I will use Terraform to spin up an EC2 instance. My choice right now is a `M5.large`.
2. I will download Minecraft's server file (which can be found [here](https://www.minecraft.net/en-us/download/server)).
3. I will create a way to Spool up the server without logging into AWS

Stretch Goals
==
1. I will add a way for Robin to be able to turn it on using IAM permissions.
2. I will periodically back up the save files of the game so saves can be reverted
3. I will add a monitoring tool that will shut off the server if there has been no activity for a certain amount of time

Some notes
==
To see if the server is running, log into the EC2 instance and run the following command:
```
sudo lsof -i :25565
```

### To run the server
```
bash start_server.sh
```
