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

PROFILE="$1"

ALL_REGIONS=$(aws --profile ${PROFILE} --output text ec2 describe-regions |\
								awk '{ print $NF }' | sort)

for region in ${ALL_REGIONS}
do
	echo "Region: $region"
  aws --profile ${PROFILE} --region ${region} ec2 describe-snapshots \
			--owner self --output text | awk '{ print $(NF-4) }'
done
