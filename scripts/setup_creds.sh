read -p "Enter your IAM User's access key id: " AWS_ACCESS_KEY_ID
read -p "Enter your IAM User's secret access key id: " AWS_SECRET_ACCESS_KEY

export AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
export AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}

export stuff=$(aws sts get-session-token --duration-seconds 3600 --output json)

export AWS_ACCESS_KEY_ID=$(echo "${stuff}" |jq -r ".Credentials.AccessKeyId")
export AWS_SECRET_ACCESS_KEY=$(echo "${stuff}" |jq -r ".Credentials.SecretAccessKey")
export AWS_SESSION_TOKEN=$(echo "${stuff}" |jq -r ".Credentials.SessionToken")

read -p "Would you like to start or stop the server?" operation

if [ "$operation" = "start" ]; then
  echo "Starting the server"
  aws ec2 start-instances --instance-ids i-03485a5bde9eaa3bd

  export startupStatus=$(aws ec2 describe-instance-status --instance-ids "i-03485a5bde9eaa3bd" --output json)
  export waitForStartup=$(echo $startupStatus | jq -r ".InstanceStatuses[0].InstanceState.Name")
  while [ "$waitForStartup" != "running" ]
  do
    echo "Checking the current status of the server..."
    export startupStatus=$(aws ec2 describe-instance-status --instance-ids "i-03485a5bde9eaa3bd" --output json)
    export waitForStartup=$(echo $startupStatus | jq -r ".InstanceStatuses[0].InstanceState.Name")
  done

  echo "The EC2 instance is running, sleeping for 40 seconds to allow it to start up properly..."
  export IPAddress=$(aws ec2 describe-instances --instance-ids "i-03485a5bde9eaa3bd" --output json | jq -r '.Reservations[].Instances[].PublicIpAddress')
  sleep 40 | pv -t

  echo "The server has been successfully started. Starting the Minecraft server."
  aws ssm send-command --instance-ids "i-03485a5bde9eaa3bd" --document-name "AWS-RunShellScript" --parameters '{"commands":["bash minecraft_server/scripts/start_server.sh"]}'

  echo "You may have to wait up to 30 seconds until the server is ready to connect to."
  echo "Please use the following IP Address: {$IPAddress}. Have fun!"
else
  echo "Stopping the server"
  aws ssm send-command --instance-ids "i-03485a5bde9eaa3bd" --document-name "AWS-RunShellScript" --parameters '{"commands":["bash minecraft_server/scripts/kill_server.sh"]}'
  aws ec2 stop-instances --instance-ids i-03485a5bde9eaa3bd
  echo "The server has been stopped. Please allow 1-2 minutes for the server to fully shut down."
fi
