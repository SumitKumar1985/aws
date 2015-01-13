#!/bin/bash

# Use this script to list the state of EC2 instances
# This expects the name of the profile to use with the aws-cli as the only argument to the script
# The instances are listed in a file called data.instanceIds.txt

export SCRIPT_NAME="$0"

if [ $# -ne 1 ]
then
	echo "Missing arguments"
	echo "Usage: $SCRIPT_NAME profile"
        exit 1
fi

while read instanceId
do
	echo -n "Instance state for $instanceId: "
	aws --profile $1 ec2 describe-instances --instance-ids $instanceId --output text | grep -w STATE | awk '{ print $3 }'
done < data.instanceIds.txt
