#!/usr/bin/env python

import argparse
import boto3

parser = argparse.ArgumentParser(description='Write message to SQS queue')
parser.add_argument('queue-url')

args = parser.parse_args()
queue_url = vars(args)['queue-url']

sqs = boto3.resource('sqs')
queue = sqs.Queue(queue_url)

response = queue.send_message(
    MessageBody = "Message sent"
)

print response
