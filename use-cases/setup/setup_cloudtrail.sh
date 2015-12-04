#!/usr/bin/env bash

# Setups CloudTrail in all regions

SCRIPT_NAME="$0"

if [ $# -ne 2 ]
then
	echo "Error: missing arguments"
	echo "Usage: ${SCRIPT_NAME} profile bucket"
	exit 1
fi

PROFILE="$1"
BUCKET="$2"

ALL_REGIONS=$(aws --profile ${PROFILE} --output text ec2 describe-regions | awk '{ print $NF }' | sort)

for region in ${ALL_REGIONS}
do
	echo "Region: ${region}"
	aws --profile ${PROFILE} --region ${region} cloudtrail create-subscription --name "CloudTrail-${region}" --s3-use-bucket ${BUCKET}
done	