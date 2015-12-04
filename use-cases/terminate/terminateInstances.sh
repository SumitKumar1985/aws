#!/bin/bash

# Use this script to terminate EC2 instances

### CAUTION ###

# If disableTerminationProtection is set to 'yes'
# we will terminate the instance without warning

### CAUTION ###

# This expects the name of the profile to use with the aws-cli as the only argument to the script
# The instances are listed in a file called data.instanceIds.txt

export SCRIPT_NAME="$0"

if [ $# -ne 2 ]
then
	echo "Missing arguments"
	echo "Usage: $SCRIPT_NAME profile disableTerminationProtection"
        exit 1
fi

while read instanceId
do 
	echo "Terminating instance $instanceId"
        if [[ "$2" = "yes" ]]; then
		echo "Enabling terminate via API ..."
		aws --profile dice ec2 modify-instance-attribute --instance-id $instanceId --no-disable-api-termination
	fi
        aws --profile $1 ec2 terminate-instances --instance-ids $instanceId
done < data.instanceIds.txt
