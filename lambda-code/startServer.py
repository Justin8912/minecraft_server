import boto3
import json
import os

success = {
    'statusCode': 200,
    'headers': {
        'Content-Type': 'application/json'
    },
    'isBase64Encoded': False
}

error = {
    "statusCode": 400,
    'headers': {
        'Content-Type': 'application/json'
    },
    'isBase64Encoded': False
}

validation_error = {
    'statusCode': 403,
    'headers': {
        'Content-Type': 'application/json'
    },
    'isBase64Encoded': False
}

def postRoute(event, ec2):
    incoming_api_key = json.loads(event["body"]).get("api-key")
    valid_api_key = os.environ["api_key"]

    if (incoming_api_key != valid_api_key):
        validation_error["body"] = json.dumps({"message": "Did not include the required API key"})
        print(validation_error)
        return validation_error

    instance_id = os.environ["instance_id"]
    ec2 = boto3.client('ec2')
    action = json.loads(event["body"])["action"].lower()


    if (action == "start"):
        print("Starting EC2 instance...")
        try:
            ec2.start_instances(InstanceIds=[instance_id])
            success["body"] = json.dumps({"message":"The server was started successfully."})
            print("Returning the following (s): ", success)
            return success
        except Exception as e:
            print("There was an error when attempting to start the server:\n ", str(e))

            error["body"] = json.dumps({"message":"The server failed to start. Please try again\n" + str(e)})
            print("Returning the following (e): ", error)
            return error
        print('Started EC2 instance: ' + instance_id)
    elif (action == "stop"):
        print("Stopping EC2 instance...")
        try:
            ec2.stop_instances(InstanceIds=[instance_id])
            success["body"] = json.dumps({"message":"The server was stopped successfully."})
            print("Returning the following (s): ", success)
            return success
        except Exception as e:
            print("There was an error when attempting to stop the server:\n ", str(e))
            print("Returning the following (e): ", success)
            error["body"] = json.dumps({"message":"The server failed to stop. Please try again\n" + str(e)})
            return error
        print('Stopped EC2 instance: ' + instance_id)
    else:
        print("Action was not identified, please try again using the following formatting:\n{\"action\":\"start/stop\"}.")


def getRoute(event, ec2):
    print(ec2.describe_instance())

def lambda_handler(event, context):
    ec2 = boto3.client('ec2')

    if (event["httpMethod"] == "POST"):
        return postRoute(event, ec2)
    elif (event["httpMethod"] == "GET"):
        return getRoute(event, ec2)

