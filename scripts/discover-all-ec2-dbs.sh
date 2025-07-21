#!/bin/bash
set -e

accounts=(${AWS_ACCOUNTS//,/ })

for index in "${!accounts[@]}"; do
  export AWS_ACCESS_KEY_ID=$(grep "AWS_ACCESS_KEY_ID_$index" aws-creds/aws.env | cut -d'=' -f2)
  export AWS_SECRET_ACCESS_KEY=$(grep "AWS_SECRET_ACCESS_KEY_$index" aws-creds/aws.env | cut -d'=' -f2)
  export AWS_SESSION_TOKEN=$(grep "AWS_SESSION_TOKEN_$index" aws-creds/aws.env | cut -d'=' -f2)

  echo "EC2 Database Nodes in ${accounts[$index]}:"
  aws ec2 describe-instances --filters Name=tag:Role,Values=database --output table || echo "Error in ${accounts[$index]}"
done
echo "[INFO] EC2 discovery completed for all accounts."