import boto3
import os

def lambda_handler(event, context):
    instance_id = os.environ["instance_id"]
    ec2 = boto3.client('ec2')
    action = event.get("action").lower()
    if (action == "start"):
        print("Starting EC2 instance...")
        try:
            ec2.start_instances(InstanceIds=[instance_id])
        except (error):
            print("There was an error when attempting to start the server:\n ", error)
        print('Started EC2 instance: ' + instance_id)
    elif (action == "stop"):
        print("Stopping EC2 instance...")
        try:
            ec2.stop_instances(InstanceIds=[instance_id])
        except (error):
            print("There was an error when attempting to stop the server:\n ", error)
        print('Stopped EC2 instance: ' + instance_id)
    else:
        print("Action was not identified, please try again using the following formatting:\n{\"action\":\"start/stop\"}.")