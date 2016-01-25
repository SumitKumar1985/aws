#!/bin/bash

# Use this script to look for EC2 instances in all available AWS regions and print the instanceId to the console
# This expects the name of the profile to use with the aws-cli as the only argument to the script

export SCRIPT_NAME="$0"

if [ -z "$AWS_PROFILE" ]
then
	echo "Missing AWS_PROFILE: Set AWS_PROFILE to the user credential profile to use with aws-cli"
	echo "Usage: $SCRIPT_NAME"
	exit 1
fi

regions=$(aws --output text ec2 describe-regions|awk '{ print $NF }')

for region in "${regions}"
do
	echo "Region: ${region}"
	aws --region ${region} --output text ec2 describe-instances --output text | grep 'INSTANCES' | awk '{ print $8 }'
done
