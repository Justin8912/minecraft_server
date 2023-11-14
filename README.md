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
bash minecraft_server/scripts/start_server.sh
```

### To kill the server (once inside EC2)
```
bash minecraft_server/scripts/kill_server.sh
```

Here I will outline the steps for starting / stopping the server on the command line
--
1. Set the following variables depending on your IAM user
```
export AWS_ACCESS_KEY        = <>
export AWS_SECRET_ACCESS_KEY = <>
```
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
aws ec2 [start/stop]-instances --instance-ids <instance_id>
```
4. Run the following command to start the server:
```
aws ssm send-command --instance-ids "<instance_id>" --document-name "AWS-RunShellScript" --parameters '{"commands":[".minecraft_server/scripts/start_server.sh"]}'
```

I have created an IAM user as a part of the terraform that is being used here. You will need to get the IAM user access code and secret access key ID. This can be done in the AWS console.

### Note that all of this done above is now done in the script called `startup_creds.sh` 
How to run
--
1. Navigate to the `scripts` directory
2. Run `bash setup_creds.sh` and enter your credentials for AWS (these will come from your IAM user)
3. When you get aws messages that come up press `q` (haven't figured out how to silence these yet)
4. When prompted, either start or stop the server
5. When starting the server, the server will give you an IP address, you must use this to connect to the server.
   - I could have had the same IP address persist, but did not want to pay for an elastic IP Address since it charges based on time that the server is turned off (which I expect will be a majority of the month).
