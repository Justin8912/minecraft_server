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

### To run the server (once inside EC2)
```
bash start_server.sh
```

### To kill the server (once inside EC2)
```
bash kill_server.sh
```

Here I will outline the steps for starting / stopping the server on the command line
==
1. Run this command in order to get a session started
```
aws sts get-session-token --duration-seconds <desired-time>
```
2. Copy and paste the credentials given
```
export AWS_ACCESS_KEY_ID     = <>
export AWS_SECRET_ACCESS_KEY = <>
export AWS_SESSION_TOKEN     = <>
```
3. Run the following command depending on whether you want to start or stop the server
```
aws ec2 [start/stop]-instances --instance-ids i-0569782c5091a09b7
```


One thing I did not do here is I manually create the Role that is attached to the `minecraft-iam-user`. I am not sure if this is a huge deal since I gave the IAM user full EC2 privileges, but this is something to be weary of.
