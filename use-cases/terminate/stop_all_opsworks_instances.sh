#!/usr/bin/env bash

# Stops all OpsWorks instances

STACK_IDS=$(aws opsworks describe-stacks --output text \
    --region us-east-1 \
    --endpoint-url "https://opsworks.us-east-1.amazonaws.com/" \
    --query 'Stacks[*].[StackId]')

for stack in ${STACK_IDS}
do
    instance_ids=$(aws opsworks describe-instances --output text \
        --stack-id ${stack} \
        --region us-east-1 \
        --endpoint-url "https://opsworks.us-east-1.amazonaws.com/" \
        --query 'Instances[*].[InstanceId]')

    if [ "${instance_ids}" ]
    then
        for instance in ${instance_ids}
        do
            echo "Stopping OpsWorks instance Id: ${instance}"
            aws opsworks stop-instance \
              --instance-id ${instance} \
              --region us-east-1 \
              --endpoint-url "https://opsworks.us-east-1.amazonaws.com/" \
              --output text
        done
    fi
done
