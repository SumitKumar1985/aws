#!/usr/bin/env bash

export SCRIPT_NAME="$0"

if [ $# -ne 1 ]
then
	echo "Missing profile as solitary argument"
	echo "Usage: $SCRIPT_NAME profile"
	exit 1
fi

PROFILE="$1"

echo "Listing EC2 instances"
source listInstanceIds.sh ${PROFILE}

echo "Listing EC2 spot instance requests"
source list_spot_instance_requests.sh ${PROFILE}

echo "Listing Elastic IPs"
source listElasticIPs.sh ${PROFILE}

echo "Listing CloudWatch alarms"
source list_alarm_names.sh ${PROFILE}

echo "Listing EBS volumes"
source list_ebs_volumes.sh ${PROFILE}

echo "Listing AMIs"
source listAMIs.sh ${PROFILE}

echo "Listing EBS snapshots"
source list_snapshots.sh ${PROFILE}
