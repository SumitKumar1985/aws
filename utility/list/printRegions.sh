#!/bin/bash

# Prints a list of all regions currently available for EC2

aws ec2 describe-regions | awk '{ print $3 }'
