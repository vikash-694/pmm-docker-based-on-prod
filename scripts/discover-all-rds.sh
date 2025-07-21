#!/bin/bash
set -e

accounts=(${AWS_ACCOUNTS//,/ })

for index in "${!accounts[@]}"; do
  export AWS_ACCESS_KEY_ID=$(grep "AWS_ACCESS_KEY_ID_$index" aws-creds/aws.env | cut -d'=' -f2)
  export AWS_SECRET_ACCESS_KEY=$(grep "AWS_SECRET_ACCESS_KEY_$index" aws-creds/aws.env | cut -d'=' -f2)
  export AWS_SESSION_TOKEN=$(grep "AWS_SESSION_TOKEN_$index" aws-creds/aws.env | cut -d'=' -f2)

  echo "RDS Instances in ${accounts[$index]}:"
  aws rds describe-db-instances --output table || echo "Error in ${accounts[$index]}"
done

echo "[INFO] RDS discovery completed for all accounts."