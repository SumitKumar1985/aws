#!/usr/bin/env bash

# Attach a life-cycle configuration to expire objects in the named bucket

SCRIPT_NAME="$0"

if [ $# -ne 3 ]
then
	echo "Error: missing arguments"
	echo "Usage: $SCRIPT_NAME profile bucket numberOfDaysExpiry"
	exit 1
fi

PROFILE="$1"
BUCKET="$2"
EXPIRY_IN_DAYS="$3"

cp lifecycle_configuration.json.template lifecycle_configuration.json
sed -i '' "s/BUCKET/${BUCKET}/" lifecycle_configuration.json
sed -i '' "s/EXPIRY_IN_DAYS/${EXPIRY_IN_DAYS}/" lifecycle_configuration.json

aws --profile ${PROFILE} s3api put-bucket-lifecycle --bucket ${BUCKET} --lifecycle-configuration file://lifecycle_configuration.json
