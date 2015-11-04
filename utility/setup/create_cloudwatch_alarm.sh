#!/usr/bin/env bash

# Sets up the instance status check and alarm to alert to email

SCRIPT_NAME="$0"

if [ $# -ne 4 ]
then
  echo "Error: missing arguments"
  echo "Usage: ${SCRIPT_NAME} profile region alert_email instance-id"
  exit 1
fi

PROFILE="$1"
REGION="$2"
ALERT_EMAIL="$3"
INSTANCE_ID="$4"

ALERTING_TOPIC_NAME="instance-status-check-alerting"

# Create the SNS topic and subscription
EXISTING_TOPIC=""
EXISTING_TOPIC=$(aws --profile ${PROFILE} --region ${REGION} --output text sns list-topics | grep ${ALERTING_TOPIC_NAME} | head -1 | awk '{ print $NF }')
ALERTING_TOPIC_ARN=""

if [ -z "${EXISTING_TOPIC}" ]
then
    aws --profile ${PROFILE} --region ${REGION} sns create-topic --name ${ALERTING_TOPIC_NAME}
    ALERTING_TOPIC_ARN=$(aws --profile ${PROFILE} --region ${REGION} --output text sns list-topics | grep ${ALERTING_TOPIC_NAME} | head -1 | awk '{ print $NF }')
    aws --profile ${PROFILE} --region ${REGION} sns subscribe --topic-arn ${ALERTING_TOPIC_ARN} --protocol email --notification-endpoint ${ALERT_EMAIL}
else
    echo "SNS topic in use: ${EXISTING_TOPIC}"
fi

# Create the cloudwatch alarm

ALARM_NAME="status-check-alarm-${INSTANCE_ID}"

aws --profile ${PROFILE} --region ${REGION} cloudwatch put-metric-alarm --alarm-name ${ALARM_NAME} --namespace "AWS/EC2" --alarm-actions ${ALERTING_TOPIC_ARN} --insufficient-data-actions ${ALERTING_TOPIC_ARN} --statistic Maximum --metric-name StatusCheckFailed --unit Count --period 60 --evaluation-periods 3 --comparison-operator GreaterThanOrEqualToThreshold --threshold 1 --dimensions Name=InstanceId,Value=${INSTANCE_ID}
