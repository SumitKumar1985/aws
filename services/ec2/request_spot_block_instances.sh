#!/usr/bin/env bash

# Setup spot "block" instances for a duration of 1 to 6 hours

SCRIPT_NAME="$0"

if [ $# -ne 8 ]
then
    echo "Error: missing arguments"
    echo "Usage: $SCRIPT_NAME profile spot-price number-of-instances duration-in-hours instance-type ami-id key-name security-group-id"
    echo "Specify an integer duration that ranges from 1 to 6 hours"
    echo "See http://aws.amazon.com/ec2/spot/pricing/ for spot pricing (Fixed duration)"
    exit 1
fi

PROFILE="$1"
SPOT_PRICE="$2"
NUMBER_OF_INSTANCES="$3"
DURATION_IN_MINUTES="$((60 * $4))"
INSTANCE_TYPE="$5"
AMI_ID="$6"
KEY_NAME="$7"
SECURITY_GROUP_ID="$8"

echo "${DURATION_IN_MINUTES}"

cp launch-specification.json.template launch-specification.json
sed -i '' "s/AMI-ID/${AMI_ID}/" launch-specification.json
sed -i '' "s/KEY-NAME/${KEY_NAME}/" launch-specification.json
sed -i '' "s/SECURITY-GROUP/${SECURITY_GROUP_ID}/" launch-specification.json
sed -i '' "s/INSTANCE-TYPE/${INSTANCE_TYPE}/" launch-specification.json

aws --profile ${PROFILE} --output text ec2 request-spot-instances \
  --type "one-time" \
  --spot-price "${SPOT_PRICE}" \
  --instance-count ${NUMBER_OF_INSTANCES} \
  --block-duration-minutes ${DURATION_IN_MINUTES} \
  --launch-specification file://launch-specification.json

rm launch-specification.json
