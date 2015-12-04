#!/bin/bash

# Prints a list of all regions currently available for EC2

export SCRIPT_NAME="$0"

if [ $# -ne 1 ]
then
	echo "Missing profile as solitary argument"
	echo "Usage: $SCRIPT_NAME profile"
	exit 1
fi

aws --profile $1 ec2 describe-regions | awk '{ print $3 }' | sort
