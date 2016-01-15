#!/usr/bin/env bash

SCRIPT_NAME="$0"

if [ $# -ne 7 ]
then
	echo "Error: one or more missing arguments"
	echo "Usage: ${SCRIPT_NAME} profile auto-scaling-group-name min-size max-size blueprint-instance-id desired-capacity list-of-subnet-ids"
	echo "Note that the instance to serve as the blueprint for the launch configuration must be in 'running' state"
	exit 1
fi

PROFILE="$1"
ASG_NAME="$2"
MIN_SIZE="$3"
MAX_SIZE="$4"
FROM_INSTANCE_ID="$5"
DESIRED_CAPACITY="$6"
SUBNET_IDS="$7"
NAME="${ASG_NAME}"
        
aws --profile ${PROFILE} autoscaling create-auto-scaling-group \
          --auto-scaling-group-name ${ASG_NAME} \
          --min-size ${MIN_SIZE} \
          --max-size ${MAX_SIZE} \
          --instance-id ${FROM_INSTANCE_ID} \
          --desired-capacity ${DESIRED_CAPACITY} \
          --vpc-zone-identifier ${SUBNET_IDS} \
          --tags Key=Name,Value=${NAME}
