#!/bin/bash

# Use this script to look for EC2 instances in all available AWS regions

export SCRIPT_NAME="$0"

if [ -z "$AWS_PROFILE" ]
then
	echo "Missing AWS_PROFILE: Set AWS_PROFILE to the user credential profile to use with aws-cli"
	echo "Usage: $SCRIPT_NAME"
	exit 1
fi

regions=$(aws --output text ec2 describe-regions | awk '{ print $NF }')

for region in ${regions}
do
	echo "Region: ${region}"
	aws ec2 describe-instances \
		--region ${region} \
		--output text \
		--query 'Reservations[*].Instances[*].[InstanceId]'
done
