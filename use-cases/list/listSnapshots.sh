#!/bin/bash

# Use this script to look for all snapshots owned by the account in all available AWS regions and print them to the console
# This expects the name of the profile to use with the aws-cli as the only argument to the script

export SCRIPT_NAME="$0"

if [ $# -ne 1 ]
then
	echo "Missing profile as solitary argument"
	echo "Usage: $SCRIPT_NAME profile"
        exit 1
fi

while read region
do 
	echo "In region $region"
        aws --profile $1 --region $region ec2 describe-snapshots --owner self --output text | awk '{ print $12 }'
	echo "---"
done < aws.regions.txt
