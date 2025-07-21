#!/bin/bash
set -e

mkdir -p aws-creds

accounts=(${AWS_ACCOUNTS//,/ })
roles=(${AWS_ROLE_ARNS//,/ })

echo "# Auto-generated AWS credentials" > aws-creds/aws.env

for index in "${!accounts[@]}"; do
  role_arn="${roles[$index]}"
  session_name="pmm-session-${accounts[$index]}"

  echo "Assuming Role: $role_arn"
  creds=$(aws sts assume-role --role-arn "$role_arn" --role-session-name "$session_name" --output json)

  AWS_ACCESS_KEY_ID=$(echo "$creds" | jq -r '.Credentials.AccessKeyId')
  AWS_SECRET_ACCESS_KEY=$(echo "$creds" | jq -r '.Credentials.SecretAccessKey')
  AWS_SESSION_TOKEN=$(echo "$creds" | jq -r '.Credentials.SessionToken')

  cat <<EOF >> aws-creds/aws.env

# ${accounts[$index]}
AWS_ACCESS_KEY_ID_$index=$AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY_$index=$AWS_SECRET_ACCESS_KEY
AWS_SESSION_TOKEN_$index=$AWS_SESSION_TOKEN
EOF

done

echo "[INFO] Multi-role credentials saved to aws-creds/aws.env"