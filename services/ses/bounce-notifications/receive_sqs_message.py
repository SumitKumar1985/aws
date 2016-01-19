#!/usr/bin/env python

import argparse
import boto3

# Set the CLI profile to use by exporting AWS_PROFILE
parser = argparse.ArgumentParser(description='Receive message from SQS queue')
parser.add_argument('queue-url')

args = parser.parse_args()
queue_url = vars(args)['queue-url']

sqs = boto3.resource('sqs')
queue = sqs.Queue(queue_url)

list = queue.receive_messages()

if len(list) > 0:
    message = list[0]
    print message.body
