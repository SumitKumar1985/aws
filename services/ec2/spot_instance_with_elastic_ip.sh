#!/usr/bin/env bash

# Creates a spot instance request for fixed duration and associates the Elastic IP with the spot instance

SCRIPT_NAME="$0"

if [ $# -ne 8 ]
then
    echo "Error: missing arguments"
    echo "Usage: $SCRIPT_NAME profile spot-price number-of-instances duration-in-hours instance-type ami-id key-name security-group-id"
    echo "Specify an integer duration that ranges from 1 to 6 hours"
    echo "See http://aws.amazon.com/ec2/spot/pricing/ for spot pricing (Fixed duration)"
    exit 1
fi

PROFILE="$1"
SPOT_PRICE="$2"
NUMBER_OF_INSTANCES="$3"
DURATION_IN_HOURS="$4"
INSTANCE_TYPE="$5"
AMI_ID="$6"
KEY_NAME="$7"
SECURITY_GROUP_ID="$8"

SPOT_INSTANCE_REQUEST_ID=$(./request_spot_block_instances.sh \
    ${PROFILE} \
    ${SPOT_PRICE} \
    ${NUMBER_OF_INSTANCES} \
    ${DURATION_IN_HOURS} \
    ${INSTANCE_TYPE} \
    ${AMI_ID} \
    ${KEY_NAME} \
    ${SECURITY_GROUP_ID} | grep SPOTINSTANCEREQUESTS | awk '{ print $5 }')

echo "Created spot instance request: ${SPOT_INSTANCE_REQUEST_ID}"

while true
do
    SPOT_INSTANCE_ID=$(aws --profile ${PROFILE} --output text ec2 describe-instances \
        | grep "${SPOT_INSTANCE_REQUEST_ID}" | awk '{ print $8 }')

    if [ -n "${SPOT_INSTANCE_ID}" ]
    then
        break
    fi

    echo "Waiting for spot instance in response to spot request ..."
    sleep 10
done


if [ -n "${SPOT_INSTANCE_ID}" ]
then
    echo "Spot instance Id: ${SPOT_INSTANCE_ID}"


# Can only associate Elastic IP when instance is in state "running"

    IS_RUNNING=0
    while true
    do
        IS_RUNNING=$(aws --profile ${PROFILE} --output text ec2 describe-instances \
            --instance-ids ${SPOT_INSTANCE_ID} \
            --filters "Name=instance-state-name,Values=running" | wc -l)

        if [ "${IS_RUNNING}" -gt 0 ]
        then
            IP_ADDRESS=$(aws --profile ${PROFILE} --output text ec2 allocate-address \
                --domain vpc | awk '{ print $NF }')
            echo "Allocated Elastic IP: ${IP_ADDRESS}"

            aws --profile ${PROFILE} ec2 associate-address \
                --instance-id ${SPOT_INSTANCE_ID} \
                --public-ip ${IP_ADDRESS}

            break
        fi

        echo "Waiting for instance to progress to 'running' state ..."
        sleep 5
    done
fi
