#!/usr/bin/env bash

# Lists all spot instance requests

SCRIPT_NAME="$0"

if [ $# -lt 1 ]
then
	echo "Error: missing profile argument"
	echo "Usage: ${SCRIPT_NAME} profile [region]"
	exit 1
fi

PROFILE="$1"

ALL_REGIONS=$(aws --profile ${PROFILE} --output text ec2 describe-regions | awk '{ print $NF }' | sort)

if [ $# -eq 2 ]
then
	ALL_REGIONS="$2"
fi

for region in ${ALL_REGIONS}
do	
	echo "Region: ${region}"
	aws --profile ${PROFILE} --region ${region} --output text ec2 describe-spot-instance-requests | grep 'SPOTINSTANCEREQUESTS' | awk '{ print $6 }'
done	