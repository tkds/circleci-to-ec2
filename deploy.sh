#!/bin/sh
set -ex

export AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}
export AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}
export AWS_DEFAULT_REGION="us-east-1"

MYSECURITYGROUP=${AWS_SECURITY_GROUP}
EC2_HOST=${AWS_EC2_HOST}
MYIP=`curl checkip.amazonaws.com`

aws ec2 authorize-security-group-ingress --group-id $MYSECURITYGROUP --protocol tcp --port 22 --cidr $MYIP/32
ssh -o "StrictHostKeyChecking=no" ec2-user@$EC2_HOST sh <<SHELL
touch test.txt
SHELL
aws ec2 revoke-security-group-ingress --group-id $MYSECURITYGROUP --protocol tcp --port 22 --cidr $MYIP/32
