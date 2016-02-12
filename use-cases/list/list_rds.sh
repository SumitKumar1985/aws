#!/usr/bin/env bash

# List all RDS instances across all AWS regions

SCRIPT_NAME="$0"

if [ -z "$AWS_PROFILE" ]
then
	echo "Missing AWS_PROFILE: Set AWS_PROFILE to the user credential profile to use with aws-cli"
	echo "Usage: $SCRIPT_NAME"
	exit 1
fi

regions=$(aws --output text ec2 describe-regions | awk '{ print $NF }' | sort)

for region in ${regions}
do
    echo "Region: ${region}"
    aws rds describe-db-instances \
        --region ${region} \
        --output text \
        --query 'DBInstances[*].[DBInstanceIdentifier]'
done
