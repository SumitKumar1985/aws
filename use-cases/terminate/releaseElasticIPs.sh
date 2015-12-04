#!/bin/bash

# Use this script to release Elastic IP addresses
# This expects the name of the profile to use with the aws-cli as the only argument to the script
# The allocationId for Elastic IPs are listed in a file called data.ips.txt

export SCRIPT_NAME="$0"

if [ $# -ne 1 ]
then
	echo "Missing arguments"
	echo "Usage: $SCRIPT_NAME profile"
        exit 1
fi

while read allocationId
do 
	echo "Releasing ElasticIP $allocationId"
	aws --profile $1 ec2 release-address --allocation-id $allocationId
done < data.ips.txt
