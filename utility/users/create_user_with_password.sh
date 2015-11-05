#!/usr/bin/env bash

# Create an IAM user that belongs to the specified group, and set a password to allow AWS console login

SCRIPT_NAME="$0"

if [ $# -ne 4 ]
then
	echo "Erorr: missing arguments"
	echo "Usage: $SCRIPT_NAME profile user group password"
	exit 1
fi

PROFILE="$1"
USER_NAME="$2"
GROUP_NAME="$3"
PASSWORD="$4"

user_exists=$(aws --profile ${PROFILE} --output text iam list-users | grep ${USER_NAME} | awk '{ print $NF }')
if [ "${USER_NAME}" == "${user_exists}" ]
then
	echo "User with name ${USER_NAME} already exists. Will not create user."
	exit 0
fi

group_exists=$(aws --profile ${PROFILE} --output text iam list-groups | grep ${GROUP_NAME} | awk '{ print $(NF-1) }')
if [ "${GROUP_NAME}" != "${group_exists}" ]
then
	echo "Group named ${GROUP_NAME} does not exist. Will not create user."
	exit 0
fi

aws --profile ${PROFILE} iam create-user --user-name ${USER_NAME}
aws --profile ${PROFILE} iam add-user-to-group --group-name ${GROUP_NAME} --user-name ${USER_NAME}
aws --profile ${PROFILE} iam create-login-profile --user-name ${USER_NAME} --password ${PASSWORD} --password-reset-required
