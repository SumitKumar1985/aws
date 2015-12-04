#!/usr/bin/env bash

# Cancels all existing spot instance request across all regions for the account

SCRIPT_NAME="$0"

if [ $# -ne 1 ]
then
	echo "Error: missing profile argument"
	echo "Usage: $SCRIPT_NAME profile"
	exit 1
fi

PROFILE="$1"

regions=$(aws --profile ${PROFILE} --output text ec2 describe-regions | awk '{ print $NF }' | sort)

for region in ${regions}
do
	echo "Region: ${region}"
	spot_instance_requests=$(aws --profile ${PROFILE} --region ${region} --output text ec2 describe-spot-instance-requests | grep 'SPOTINSTANCEREQUESTS' | awk '{ print $6 }')
	
	for request in ${spot_instance_requests}
	do
		aws --profile ${PROFILE} --region ${region} ec2 cancel-spot-instance-requests --spot-instance-request-ids ${request}
	done
done 	
	
	