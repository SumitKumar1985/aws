#!/usr/bin/env bash

# Toggle DeleteOnTermination for the first EBS volume attached to an instance
# Requires the instance-id and a flag of True or False

SCRIPT_NAME="$0"

if [ $# -ne 2 ]
then
    echo "Error: missing argument(s)"
    echo "Usage: ${SCRIPT_NAME} instance-id True|False"
    echo "Set the environment variable AWS_PROFILE for credentials"
    exit 1
fi

INSTANCE_ID="$1"
SET_TO_VALUE="$2"

SET_TO_VALUE_LOWERCASE="${SET_TO_VALUE}"
if [ "${SET_TO_VALUE}" == "True" ]
then
    SET_TO_VALUE_LOWERCASE="true"
else
      SET_TO_VALUE_LOWERCASE="false"
fi

first_volume_status=$(aws ec2 describe-instance-attribute \
  --instance-id ${INSTANCE_ID} \
  --attribute blockDeviceMapping \
  --output text \
  --query 'BlockDeviceMappings[0].{DeviceName:DeviceName,DeleteOnTermination:Ebs.DeleteOnTermination}')

volume_name=$(echo "${first_volume_status}" | awk '{print $NF}')
volume_status=$(echo "${first_volume_status}" | awk '{print $1}')

if [ "${volume_status}" == "${SET_TO_VALUE}" ]
then
    echo "Volume ${volume_name} is already set to desired status: ${volume_status}"
else
    echo "Volume ${volume_name} is set to status: ${volume_status} other than desired status: ${SET_TO_VALUE}"
    echo "Now setting DeleteOnTermination for ${volume_name} to ${SET_TO_VALUE}"
    echo "[{\"DeviceName\": \"${volume_name}\",\"Ebs\": {\"DeleteOnTermination\": ${SET_TO_VALUE_LOWERCASE}}}]" > change.json
    aws ec2 modify-instance-attribute --instance-id "${INSTANCE_ID}" --block-device-mappings file://change.json
fi
