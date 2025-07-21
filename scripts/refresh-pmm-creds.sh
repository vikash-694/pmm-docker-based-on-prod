#!/bin/bash
cd /root/pmm-docker-based-on-prod/ || exit 1

export AWS_ACCOUNTS="364871072205"
export AWS_ROLE_ARNS="arn:aws:iam::364871072205:role/PMM-RDS-Monitoring-Role"

bash pmm-assume-multi-roles.sh

# Now PMM or your monitoring tool can use the aws-creds/aws.env credentials file