#!/bin/bash

# Use this script to delete snapshots
# This expects the name of the profile to use with the aws-cli as the only argument to the script
# The instances are listed in a file called data.snapshots.txt

export SCRIPT_NAME="$0"

if [ $# -ne 1 ]
then
	echo "Missing arguments"
	echo "Usage: $SCRIPT_NAME profile"
        exit 1
fi

while read snapshotId
do 
	echo "Deleting snapshot $snapshotId"
        aws --profile $1 ec2 delete-snapshot --snapshot-id $snapshotId
done < data.snapshots.txt
