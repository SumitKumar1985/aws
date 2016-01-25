#!/usr/bin/env bash

SCRIPT_NAME="$0"

regions=$(aws --output text ec2 describe-regions|awk '{ print $NF }')
for region in ${regions}
do
  aws --output text --region ${region} rds describe-db-instances
done
