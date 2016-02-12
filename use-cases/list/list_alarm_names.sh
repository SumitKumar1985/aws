#!/usr/bin/env bash

# Use this script to look for CloudWatch alarms in all available AWS regions and print the alarm names to the console

SCRIPT_NAME="$0"

if [ -z "$AWS_PROFILE" ]
then
	echo "Missing AWS_PROFILE: Set AWS_PROFILE to the user credential profile to use with aws-cli"
	echo "Usage: $SCRIPT_NAME"
	exit 1
fi

ALL_REGIONS=$(aws --output text ec2 describe-regions | awk '{ print $NF }' | sort)

for region in ${ALL_REGIONS}
do
		aws cloudwatch describe-alarms \
				--output text \
				--query 'MetricAlarms[*].[Namespace,AlarmName]'
done
