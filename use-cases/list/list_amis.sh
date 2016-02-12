#!/bin/bash

# Use this script to look for all AMIs owned by the account in all available AWS regions and print them to the console

export SCRIPT_NAME="$0"

if [ -z "$AWS_PROFILE" ]
then
	echo "Missing AWS_PROFILE: Set AWS_PROFILE to the user credential profile to use with aws-cli"
	echo "Usage: $SCRIPT_NAME"
	exit 1
fi

ALL_REGIONS=$(aws --output text ec2 describe-regions | awk '{ print $NF }' | sort)

for region in ${ALL_REGIONS}
do
	echo "Region: ${region}"
	aws ec2 describe-images \
			--region $region \
			--owner self \
			--output text \
			--query 'Images[*].[ImageId]'
done
