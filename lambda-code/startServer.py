import boto3
import os

def lambda_handler(event, context):
    print("Hello world")
    instance_id = os.environ["instance_id"]
    ec2 = boto3.client('ec2')
    instance_id = 'Your-Instance-ID'
    ec2.start_instances(InstanceIds=[instance_id])
    print('Started EC2 instance: ' + instance_id)