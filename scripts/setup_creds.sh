export instance_id=i-03485a5bde9eaa3bd

export AWS_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY
export AWS_SESSION_TOKEN
export AWS_CREDS

# Obtaining AWS access key and secret access key
while IFS=, read -r col_1 col_2
do
  echo "Setting AWS_ACCESS_KEY_ID to: $col_1"
  AWS_ACCESS_KEY_ID=$col_1
  echo "Setting AWS_SECRET_ACCESS_KEY to: [****${col_2:${#col_2}-4:4}]"
  AWS_SECRET_ACCESS_KEY=$col_2
done < "../secrets/minecraft-server-iam-user.csv"

# Get session tokens
AWS_CREDS=$(aws sts get-session-token --duration-seconds 3600 --output json)

# Set the required keys for interacting with the ec2 instance
AWS_ACCESS_KEY_ID=$(echo "${AWS_CREDS}" |jq -r ".Credentials.AccessKeyId")
AWS_SECRET_ACCESS_KEY=$(echo "${AWS_CREDS}" |jq -r ".Credentials.SecretAccessKey")
AWS_SESSION_TOKEN=$(echo "${AWS_CREDS}" |jq -r ".Credentials.SessionToken")

read -p "Would you like to start or stop the server? (start/stop): " operation

export startupStatus
export waitForStartup
export IPAddress
export command
export commandId
export command_status
export instance_status

# Either starting or stopping the server
if [ "$operation" = "start" ]; then
  echo "Starting the server"
  # Start the server
  aws ec2 start-instances --instance-ids $instance_id

  # Wait for the server to startup before moving on
  startupStatus=$(aws ec2 describe-instance-status --instance-ids "$instance_id" --output json)
  waitForStartup=$(echo $startupStatus | jq -r ".InstanceStatuses[0].InstanceState.Name")
  while [ "$waitForStartup" != "running" ]
  do
    echo "Checking the current status of the server..."
    startupStatus=$(aws ec2 describe-instance-status --instance-ids "$instance_id" --output json)
    waitForStartup=$(echo $startupStatus | jq -r ".InstanceStatuses[0].InstanceState.Name")
  done

  echo "The EC2 instance is running, sleeping for 40 seconds to allow it to start up properly..."
  IPAddress=$(aws ec2 describe-instances --instance-ids "$instance_id" --output json | jq -r '.Reservations[].Instances[].PublicIpAddress')
  sleep 40 | pv -t

  echo "The server has been successfully started. Starting the Minecraft server."
  command=$(aws ssm send-command --instance-ids "$instance_id" --document-name "AWS-RunShellScript" --parameters '{"commands":["cd /home/ec2-user", "bash minecraft_server/scripts/start_server.sh"]}')
  commandId=$(echo "$command" | jq -r ".Command.CommandId")
  command_status=$(aws ssm get-command-invocation --command-id $commandId --instance-id $instance_id)

  while [ $(echo "$command_status" | jq -r ".Status") == "Pending" ] || [ $(echo "$command_status" | jq -r ".Status") == "InProgress" ]
  do
    echo "Finding the status of the start server command..."
    command_status=$(aws ssm get-command-invocation --command-id $commandId --instance-id $instance_id)
    sleep 2
  done

  echo "$command_status"
  if [ $(echo "$command_status" | jq -r ".Status") == "Success" ];
  then
    echo "You may have to wait up to 30 seconds until the server is ready to connect to."
    echo "Please use the following IP Address: {$IPAddress}. Have fun!"
  else
    echo "The command to start the minecraft_server failed for this reason:

[$(echo "$command_status" | jq -r ".StandardErrorContent")]

To begin the server, please address the issue listed above and try again."
  fi
else
  instance_status=$(echo "$(aws ec2 describe-instances --instance-ids "$instance_id" --output json)" | jq -r ".Reservations[0].Instances[0].State.Name")
  if [ "$instance_status" != "stopped" ];
  then
    echo "Stopping the server"
    command=$(aws ssm send-command --instance-ids "$instance_id" --document-name "AWS-RunShellScript" --parameters '{"commands":["bash minecraft_server/scripts/kill_server.sh"]}')
    commandId=$(echo "$command" | jq -r ".Command.CommandId")
    command_status=$(aws ssm get-command-invocation --command-id $commandId --instance-id $instance_id)


    while [ $(echo "$command_status" | jq -r ".Status") == "Pending" ] || [ $(echo "$command_status" | jq -r ".Status") == "InProgress" ]
    do
      echo "Finding the status of the stop server command..."
      command_status=$(aws ssm get-command-invocation --command-id $commandId --instance-id $instance_id)
      sleep 2
    done
    aws ec2 stop-instances --instance-ids $instance_id
    echo "The server has been stopped. Please allow 1-2 minutes for the EC2 instance to fully shut down."
  else
    echo "The server is already stopped. No action required."
  fi
fi
