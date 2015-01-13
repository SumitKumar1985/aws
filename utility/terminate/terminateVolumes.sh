#!/bin/bash

# Use this script to terminate EBS volumes
# This expects the name of the profile to use with the aws-cli as the only argument to the script
# The instances are listed in a file called data.volumes.txt

export SCRIPT_NAME="$0"

if [ $# -ne 1 ]
then
	echo "Missing arguments"
	echo "Usage: $SCRIPT_NAME profile"
        exit 1
fi

while read volumeId
do 
	echo "Deleting volume $volumeId"
        aws --profile $1 ec2 delete-volume --volume-id $volumeId
done < data.volumes.txt
