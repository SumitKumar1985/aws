#!/usr/bin/env bash

# Retrieves the ARM for the SSL certificated issue from ACM,
# and creates an SSL listener on the load balancer provisioned for the EB environment

SCRIPT_NAME="$0"

if [ $# -ne 3 ]
then
    echo "Error: missing argument(s)"
    echo "Usage: ${SCRIPT_NAME} acm-certificate-cn eb-app eb-app-environment"
    echo "Example: ${SCRIPT_NAME} mysecuresite.example.com mysecuresite-app live-mysecuresite"
    exit 1
fi

CERTIFICATE_CN="$1"
EB_APP="$2"
EB_ENV="$3"

certificate_arn=$(aws acm list-certificates \
    --output text \
    --query 'CertificateSummaryList[*].[DomainName,CertificateArn]' | grep "${CERTIFICATE_CN}" | awk '{ print $NF }')

cp elb_listeners.json.template elb_listeners.json
sed -i "" "s/CERTIFICATE_ARN/$(echo ${certificate_arn} | sed -e 's/[]\/$*.^|[]/\\&/g')/" elb_listeners.json

aws elasticbeanstalk update-environment \
    --application-name ${EB_APP} \
    --environment-name ${EB_ENV} \
    --option-settings file://`pwd`/elb_listeners.json
