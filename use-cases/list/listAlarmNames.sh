#!/bin/bash

# Use this script to look for CloudWatch alarms in all available AWS regions and print the alarm names to the console
# This expects the name of the profile to use with the aws-cli as the only argument to the script

export SCRIPT_NAME="$0"

if [ $# -ne 1 ]
then
	echo "Missing profile as solitary argument"
	echo "Usage: $SCRIPT_NAME profile"
        exit 1
fi

aws --profile $1 cloudwatch describe-alarms | grep 'METRIC' | awk '{ print $9 }'
