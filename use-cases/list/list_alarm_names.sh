#!/usr/bin/env bash

# Use this script to look for CloudWatch alarms in all available AWS regions and print the alarm names to the console
# This expects the name of the profile to use with the aws-cli as the only argument to the script

SCRIPT_NAME="$0"

if [ $# -ne 1 ]
then
		echo "Error: missing profile argument"
		echo "Usage: $SCRIPT_NAME profile"
  	exit 1
fi

PROFILE="$1"
ALL_REGIONS=$(aws --profile ${PROFILE} --output text ec2 describe-regions | awk '{ print $NF }')

for region in ${ALL_REGIONS}
do
		aws --profile ${PROFILE} --region ${region} cloudwatch describe-alarms | grep 'METRIC' | awk '{ print $9 }'
done
