#!/usr/bin/env bash

SCRIPT_NAME="$0"

if [ $# -ne 1 ]
then
    echo "Error: missing region argument"
    echo "Usage: ${SCRIPT_NAME} region"
    exit 1
fi

REGION="$1"

STACK_IDS=$(aws opsworks describe-stacks --output text \
    --endpoint-url "https://opsworks.us-east-1.amazonaws.com/" \
    --region ${REGION} \
    --query 'Stacks[*].[StackId]')

echo "${STACK_IDS}"

for stack in ${STACK_IDS}
do
    instance_ids=$(aws opsworks describe-instances --output text \
        --stack-id ${stack} \
        --region ${REGION} \
        --endpoint-url "https://opsworks.us-east-1.amazonaws.com/" \
        --query 'Instances[*].[Ec2InstanceId]')

    echo "${instance_ids}"
    if [ "${instance_ids}" ]
    then
        echo "Stopping instance Ids: ${instance_ids}"
        aws ec2 stop-instances \
          --region ${REGION} \
          --instance-ids ${instance_ids} \
          --output text
    fi
done
