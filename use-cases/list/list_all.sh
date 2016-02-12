#!/usr/bin/env bash

export SCRIPT_NAME="$0"

if [ -z "$AWS_PROFILE" ]
then
	echo "Missing AWS_PROFILE: Set AWS_PROFILE to the user credential profile to use with aws-cli"
	echo "Usage: $SCRIPT_NAME"
	exit 1
fi

echo "Listing EC2 instances"
source list_instance_ids.sh

echo "Listing EC2 spot instance requests"
source list_spot_instance_requests.sh

echo "Listing Elastic IPs"
source list_elastic_ips.sh

echo "Listing CloudWatch alarms"
source list_alarm_names.sh

echo "Listing EBS volumes"
source list_ebs_volumes.sh

echo "Listing EBS snapshots"
source list_snapshots.sh

echo "Listing AMIs"
source list_amis.sh

echo "Listing RDS instances"
source list_rds.sh
