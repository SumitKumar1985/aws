#!/bin/bash

# Use this script to release Elastic IP addresses
# This expects the name of the profile as the only argument

SCRIPT_NAME="$0"

if [ $# -ne 1 ]
then
		echo "Error: missing argument"
		echo "Usage: $SCRIPT_NAME profile"
    exit 1
fi

PROFILE="$1"

ALLOCATION_IDS=$(aws --profile ${PROFILE} --output text ec2 describe-addresses | cut -f2)

for allocation_id in ${ALLOCATION_IDS}
do
	echo "Releasing ${allocation_id}"
	aws --profile ${PROFILE} ec2 release-address --allocation-id ${allocation_id}
done
