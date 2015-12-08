#!/bin/bash

# Use this script to delete snapshots owned by your account

SCRIPT_NAME="$0"

if [ $# -ne 2 ]
then
		echo "Error: missing arguments"
		echo "Usage: $SCRIPT_NAME profile account-id"
		exit 1
fi

PROFILE="$1"
ACCOUNT_ID="$2"

SNAPSHOT_IDS=$(aws --profile ${PROFILE} --output text ec2 describe-snapshots \
 		--owner-ids ${ACCOUNT_ID} | awk '{ print $(NF-4) }')

for snapshot_id in ${SNAPSHOT_IDS}
do
	echo "Deleting snapshot ${snapshot_id}"
  aws --profile ${PROFILE} ec2 delete-snapshot --snapshot-id ${snapshot_id}
done
