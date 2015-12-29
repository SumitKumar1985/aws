#!/usr/bin/env python
import argparse
import json

parser = argparse.ArgumentParser(description='Publish a targeted message to an Android app on a specific handset.')
parser.add_argument('aws-profile-name')
parser.add_argument('application-name')
parser.add_argument('api-key')
parser.add_argument('registration-id')
parser.add_argument('message-text')

args = parser.parse_args()
aws_profile_name = vars(args)['aws-profile-name']
application_name = vars(args)['application-name']
api_key = vars(args)['api-key']
registration_id = vars(args)['registration-id']
message_text = vars(args)['message-text']

from boto3.session import Session

session = Session(profile_name=aws_profile_name)
sns = session.resource('sns')

response = sns.create_platform_application(
    Name=application_name,
    Platform='GCM',
    Attributes={
      'PlatformCredential': api_key
    }
)

platform_application_arn = response.arn

client = session.client('sns')
response = client.create_platform_endpoint(
    PlatformApplicationArn=platform_application_arn,
    Token=registration_id
)

endpoint_arn = response['EndpointArn']
platform_endpoint = sns.PlatformEndpoint(endpoint_arn)

# {"default":"This is the default message","GCM":"{\"delay_while_idle\":true,\"collapse_key\":\"Welcome\",\"data\":{\"message\":\"Visit Amazon!\",\"url\":\"http://www.amazon.com/\"},\"time_to_live\":125,\"dry_run\":false}"}

message_json = {'default':message_text, 'message':message_text, 'GCM':{'data':{'message':message_text}}}
message = json.dumps(message_json)

response = platform_endpoint.publish(
    Message=message,
    MessageStructure='json'
)

message_id = response['MessageId']
if message_id:
    print "Message sent with message Id:", message_id

if endpoint_arn:
    client.delete_endpoint(
        EndpointArn=endpoint_arn
    )

if platform_application_arn:
    client.delete_platform_application(
        PlatformApplicationArn=platform_application_arn
    )
