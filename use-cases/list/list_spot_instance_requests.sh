#!/usr/bin/env bash

# Lists all spot instance requests

SCRIPT_NAME="$0"

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
	aws ec2 describe-spot-instance-requests \
			--region ${region} \
			--output text \
			--query 'SpotInstanceRequests[*].[SpotInstanceRequestId,State]'
done
