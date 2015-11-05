#!/usr/bin/env bash

# Deletes the user. First removes any access keys, and removes the user from any groups

SCRIPT_NAME="$0"

if [ $# -ne 2 ]
then
	echo "Error: missing arguments"
	echo "Usage: ${SCRIPT_NAME} profile user"
	exit 1
fi

PROFILE="$1"
USER_NAME="$2"

user_exists=$(aws --profile ${PROFILE} --output text iam list-users | grep ${USER_NAME} | awk '{ print $NF }')
if [ "${USER_NAME}" != "${user_exists}" ]
then
	echo "User ${USER_NAME} does not exist. Exiting"
	exit 0
fi

access_keys=$(aws --profile ${PROFILE} --output text iam list-access-keys --user-name ${USER_NAME} | awk '{ print $2 }')
for key in ${access_keys}
do
	aws --profile ${PROFILE} iam delete-access-key --access-key-id ${key} --user-name ${USER_NAME}
done

groups=$(aws --profile ${PROFILE} --output text iam list-groups-for-user --user-name ${USER_NAME} | awk '{ print $(NF-1) }')
for group in ${groups}
do
	aws --profile ${PROFILE} iam remove-user-from-group --group-name ${group} --user-name ${USER_NAME}
done

aws --profile ${PROFILE} iam delete-login-profile --user-name ${USER_NAME}
aws --profile ${PROFILE} iam delete-user --user-name ${USER_NAME}
