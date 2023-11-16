export instance_id=i-03485a5bde9eaa3bd

while IFS=, read -r col_1 col_2
do
  echo "Setting AWS_ACCESS_KEY_ID to: $col_1"
  export AWS_ACCESS_KEY_ID=$col_1
  echo "Setting AWS_SECRET_ACCESS_KEY to: [****${col_2:${#col_2}-4:4}]"
  export AWS_SECRET_ACCESS_KEY=$col_2
done < "../secrets/minecraft-server-iam-user.csv"

export AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
export AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}

export stuff=$(aws sts get-session-token --duration-seconds 3600 --output json)

export AWS_ACCESS_KEY_ID=$(echo "${stuff}" |jq -r ".Credentials.AccessKeyId")
export AWS_SECRET_ACCESS_KEY=$(echo "${stuff}" |jq -r ".Credentials.SecretAccessKey")
export AWS_SESSION_TOKEN=$(echo "${stuff}" |jq -r ".Credentials.SessionToken")

read -p "Would you like to start or stop the server?" operation

if [ "$operation" = "start" ]; then
  echo "Starting the server"
  aws ec2 start-instances --instance-ids $instance_id

  export startupStatus=$(aws ec2 describe-instance-status --instance-ids "$instance_id" --output json)
  export waitForStartup=$(echo $startupStatus | jq -r ".InstanceStatuses[0].InstanceState.Name")
  while [ "$waitForStartup" != "running" ]
  do
    echo "Checking the current status of the server..."
    export startupStatus=$(aws ec2 describe-instance-status --instance-ids "$instance_id" --output json)
    export waitForStartup=$(echo $startupStatus | jq -r ".InstanceStatuses[0].InstanceState.Name")
  done

  echo "The EC2 instance is running, sleeping for 40 seconds to allow it to start up properly..."
  export IPAddress=$(aws ec2 describe-instances --instance-ids "$instance_id" --output json | jq -r '.Reservations[].Instances[].PublicIpAddress')
  sleep 40 | pv -t

  echo "The server has been successfully started. Starting the Minecraft server."
  aws ssm send-command --instance-ids "$instance_id" --document-name "AWS-RunShellScript" --parameters '{"commands":["bash minecraft_server/scripts/start_server.sh"]}'

  echo "You may have to wait up to 30 seconds until the server is ready to connect to."
  echo "Please use the following IP Address: {$IPAddress}. Have fun!"
else
  echo "Stopping the server"
  aws ssm send-command --instance-ids "$instance_id" --document-name "AWS-RunShellScript" --parameters '{"commands":["bash minecraft_server/scripts/kill_server.sh"]}'
  aws ec2 stop-instances --instance-ids $instance_id
  echo "The server has been stopped. Please allow 1-2 minutes for the EC2 instance to fully shut down."
fi
