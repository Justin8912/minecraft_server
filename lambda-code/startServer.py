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

def getServerStatus(ec2, instance_id):
    instance_id = os.environ["instance_id"]
    ec2Response = ec2.describe_instances(InstanceIds=[instance_id], Filters=[
        {
            "Name": "instance-id",
            "Values": [
                instance_id
            ]
        }])

    print("Finding the status of the server")
    isOff = ec2Response["Reservations"][0]["Instances"][0]["State"]["Name"] == "stopped"

    return [isOff,ec2Response]

def postRoute(event, ec2):
    incoming_api_key = json.loads(event["body"]).get("api-key")
    valid_api_key = os.environ["api_key"]
    instance_id = os.environ["instance_id"]

    if (incoming_api_key != valid_api_key):
        validation_error["body"] = json.dumps({"message": "Did not include the required API key"})
        print(validation_error)
        return validation_error

    action = json.loads(event["body"])["action"].lower()

    if (action == "start"):
        print("Starting EC2 instance...")
        try:
            ec2.start_instances(InstanceIds=[instance_id])
            success["body"] = json.dumps({"message":"The server was started successfully."})
            print("Returning the following (s): ", success)
            return success
        except Exception as e:
            print("There was an error when attempting to start the server: ", str(e))

            error["body"] = json.dumps({"message":"The server failed to start. Please try again: " + str(e)})
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
            print("There was an error when attempting to stop the server: ", str(e))
            print("Returning the following (e): ", success)
            error["body"] = json.dumps({"message":"The server failed to stop. Please try again" + str(e)})
            return error
        print('Stopped EC2 instance: ' + instance_id)
    else:
        print("Action was not identified, please try again using the following formatting:\n{\"action\":\"start/stop\"}.")

def getRoute(event, ec2):
    instance_id = os.environ["instance_id"]
    res = getServerStatus(ec2, instance_id)
    isOffline, ec2Response = res[0], res[1]

    if (isOffline):
        print("The server is currently offline")
        success["body"] = json.dumps({"message": "The server is currently off, please start the server to see the ipv4 address."})
        return success

    try:
        print("Attempting to get public ipv4")
        publicIpv4Addr = ec2Response["Reservations"][0]["Instances"][0]["PublicIpAddress"]
        print("Success: ", publicIpv4Addr)
        success["body"] = json.dumps({"message":"The server's address is: " + publicIpv4Addr})
        return success
    except Exception as e :
        print("There was an error when attempting to get the public ipv4 information")
        error["body"] = json.dumps({"message":"There was an error when retrieving the server address. Please try again" + str(e)})
        return error


def lambda_handler(event, context):
    ec2 = boto3.client('ec2')

    if (event["httpMethod"] == "POST"):
        return postRoute(event, ec2)
    elif (event["httpMethod"] == "GET"):
        return getRoute(event, ec2)

