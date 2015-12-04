#!/bin/bash

# Use this script to look for all AMIs owned by the account in all available AWS regions and print them to the console
# This expects the name of the profile to use with the aws-cli as the only argument to the script

export SCRIPT_NAME="$0"

if [ $# -ne 1 ]
then
	echo "Missing profile as solitary argument"
	echo "Usage: $SCRIPT_NAME profile"
        exit 1
fi

while read amiId
do 
	AMI_TYPE=`aws --profile $1 ec2 describe-images --image-ids $amiId --output text | grep -w IMAGES | awk '{ print $11 }'`
done < aws.regions.txt
