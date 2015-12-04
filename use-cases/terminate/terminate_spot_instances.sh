#!/usr/bin/env bash

# Terminates all spot instances across all regions

SCRIPT_NAME="$0"

if [ $# -ne 1 ]
then
	echo "Error: missing profile argument"
	echo "Usage: ${SCRIPT_NAME} profile"
	exit 1
fi

PROFILE="$1"

regions=$(aws --profile ${PROFILE} --output text ec2 describe-regions | awk '{ print $NF }')

for region in ${regions}
do
	echo "Region: ${region}"
	spot_instances=$(aws --profile ${PROFILE} --region ${region} --output text ec2 describe-spot-instance-requests | grep 'SPOTINSTANCEREQUESTS' | awk '{ print $3 }')
	
	for instance_id in ${spot_instances}
	do
		aws --profile ${PROFILE} --region ${region} ec2 terminate-instances --instance-ids ${instance_id}
	done
done 	
