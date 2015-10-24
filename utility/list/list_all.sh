#!/usr/bin/env bash

export SCRIPT_NAME="$0"

if [ $# -ne 1 ]
then
	echo "Missing profile as solitary argument"
	echo "Usage: $SCRIPT_NAME profile"
	exit 1
fi

echo "Listing EC2 instances"
source listInstanceIds.sh $1

echo "Listing Elastic IPs"
source listElasticIPs.sh $1

echo "Listing CloudWatch alarms"
source listAlarmNames.sh $1

echo "Listing EBS volumes"
source list_volumes.sh $1

echo "Listing AMIs"
source listAMIs.sh $1

echo "Listing EBS snapshots"
source listSnapshots.sh $1
