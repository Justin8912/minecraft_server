# Minecraft Server
I will document all the plans I have for making this server as well as the architecture of the current solution I have.

Goals
==
1. I will use Terraform to spin up an EC2 instance. My choice right now is a `M5.large`. [DONE]
2. I will download Minecraft's server file (which can be found [here](https://www.minecraft.net/en-us/download/server)). [DONE]
3. I will create a way to Spool up the server without logging into AWS [DONE]

Stretch Goals
==
1. I will add a way for Robin to be able to turn it on using IAM permissions. [DONE]
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

I have created an IAM user as a part of the terraform that is being used here. You will need to get the IAM user access code and secret access key ID.

This can be done in two ways:
1. Create the credentials in the aws console, or
2. Look through the `terraform.tfstate` file that is created after running terraform. The access key id and secret access key will be available here.

### Note that all of this done above is now done in the script called `startup_creds.sh` 
How to run
--
1. Create a file called `secrets` in the root directory of this project
2. Create a file called `minecraft-server-iam-user.csv` and populate it like this:
```csv
<your access key id>,<you secret access key>
```
*** it is imperative that you have no spaces in this file

3. Navigate to the `scripts` directory
4. Run `bash setup_creds.sh` 
5. When you get aws messages that come up press `q` (haven't figured out how to silence these yet)
6. When prompted, either start or stop the server
7. When starting the server, the server will give you an IP address, you must use this to connect to the server.
   - I could have had the same IP address persist, but did not want to pay for an elastic IP Address since it charges based on time that the server is turned off (which I expect will be a majority of the month).


Setup in the EC2 instance
==
### Getting the server to run on start
1. Go to the `etc/init.d` directory and add your bash script 
2. Modify the permissions on the file to make it executable 

`sudo chmod -x [filename]`

3. Create a symbolic link to the `etc/rc.d` directory with the following command 

`sudo ln -s [filename] etc/rc.d`

4. To chech to make sure the link was made correctly, run the following command:

`sudo ls -l etc/rc.d/[filename]`

5. You should see a symbolic link that was created.

What this is doing is linking up the executable file that was defined to the startup process of the linux server.

I ended up pasting this in the "user data" section of the EC2 instance. I am convinced that the above steps are not needed, but need to verify.
```
Content-Type: multipart/mixed; boundary="//"
MIME-Version: 1.0

--//
Content-Type: text/cloud-config; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="cloud-config.txt"

#cloud-config
cloud_final_modules:
- [scripts-user, always]

--//
Content-Type: text/x-shellscript; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="userdata.txt"

#!/bin/bash
/bin/echo "Hello World" >> /tmp/testfile.txt
echo "Running the user data script"
echo "$PWD"
cd /home/ec2-user/minecraft_server/app
echo "Changing directories"
echo "$PWD"
echo "Starting server"
sudo java -Xmx4G -Xms4G -jar server.jar nogui &
echo "Server started"
--//--
```

It's my assumption that this is somehow setting cloud-init to run correctly on the EC2 instance but I really dont understand why this works.


### Setting a password to use EC2 Serial console
[Look here](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/configure-access-to-serial-console.html#set-user-password) for more context

1. Run the following command to set the password:

`sudo passwd root`

### Setting up the environment
1. Install java 

`sudo yum install java`

2. Install git

`sudo yum install git`

3. Clone this git repo 

`sudo git clone `

### Using Spigot
Apparently Spigot is a better minecrafter server version and they maintain a lot of software that makes using plugins for mc servers. 

[Here](https://danieldusek.com/create-an-interactive-map-of-your-minecraft-world.html) is the link I was following to figure out how to generate a map of the server.
