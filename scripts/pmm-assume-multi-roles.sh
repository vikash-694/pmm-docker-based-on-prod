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
  creds=$(aws sts assume-role --role-arn "$role_arn" --role-session-name "$session_name" --output json) || {
    echo "[ERROR] Failed to assume role: $role_arn"
    echo "Response was: $creds"
    exit 1
  }

  echo "Assume Role output for index $index:"
  echo "$creds" | jq .

  AWS_ACCESS_KEY_ID=$(echo "$creds" | jq -r '.Credentials.AccessKeyId')
  AWS_SECRET_ACCESS_KEY=$(echo "$creds" | jq -r '.Credentials.SecretAccessKey')
  AWS_SESSION_TOKEN=$(echo "$creds" | jq -r '.Credentials.SessionToken')

  if [[ -z "$AWS_ACCESS_KEY_ID" || -z "$AWS_SECRET_ACCESS_KEY" || -z "$AWS_SESSION_TOKEN" ]]; then
    echo "[ERROR] Credentials missing or empty for role $role_arn"
    exit 1
  fi

  cat <<EOF >> aws-creds/aws.env

# ${accounts[$index]}
AWS_ACCESS_KEY_ID_$index=$AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY_$index=$AWS_SECRET_ACCESS_KEY
AWS_SESSION_TOKEN_$index=$AWS_SESSION_TOKEN
EOF

  # Save first creds for later default export
  if [[ "$index" == 0 ]]; then
    FIRST_AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
    FIRST_AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
    FIRST_AWS_SESSION_TOKEN=$AWS_SESSION_TOKEN
  fi
done

# Append default AWS_* env vars based on first account credentials
cat <<EOF >> aws-creds/aws.env

AWS_ACCESS_KEY_ID=$FIRST_AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY=$FIRST_AWS_SECRET_ACCESS_KEY
AWS_SESSION_TOKEN=$FIRST_AWS_SESSION_TOKEN
EOF

echo "[INFO] Multi-role credentials saved to aws-creds/aws.env"

# Export the first role's creds to environment (adjust if you want to use others)
source aws-creds/aws.env
export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
export AWS_SESSION_TOKEN=$AWS_SESSION_TOKEN

echo "[INFO] Exported temporary credentials for account ${accounts[0]}"

# Example: Run RDS describe command automatically
# echo "[INFO] Running 'aws rds describe-db-instances' with assumed credentials..."
# aws rds describe-db-instances --output table