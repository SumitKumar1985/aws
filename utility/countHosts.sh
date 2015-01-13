#!/bin/bash

# Use this script to look for EC2 instances in all available AWS regions and print them to the console
# This relies on the use of a tag with key "Name" for all of the instances
# This expects the name of the profile to use with the aws-cli as the only argument to the script

while read region
do 
	echo "In region $region"
	aws --profile $1 --region $region ec2 describe-instances | grep Name
	echo "---"
done < aws.regions.txt
