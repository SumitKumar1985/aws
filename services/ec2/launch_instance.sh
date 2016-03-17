#!/usr/bin/env bash

SCRIPT_NAME="$0"

if [ $# -ne 3 ]
then
    echo "Error: missing argument(s)"
    echo "Usage: ${SCRIPT_NAME} ami-id instance-type number-of-instances"
    echo "Remember to export the AWS profile to use as environment variable AWS_PROFILE"
    exit 1
fi

AMI_ID="$1"
INSTANCE_TYPE="$2"
NUMBER_OF_INSTANCES="$3"

aws ec2 run-instances \
    --image-id ${AMI_ID} \
    --instance-type ${INSTANCE_TYPE} \
    --count ${NUMBER_OF_INSTANCES}
