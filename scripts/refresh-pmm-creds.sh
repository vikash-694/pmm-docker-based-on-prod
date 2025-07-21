#!/bin/bash
set -e

# Configurable: List of Role ARNs (comma-separated)
AWS_ROLE_ARNS="arn:aws:iam::364871072205:role/PMM-RDS-Monitoring-Role"

# Output path (repo root aws-creds)
CRED_DIR="$(cd "$(dirname "$0")/.." && pwd)/aws-creds"
mkdir -p "$CRED_DIR"
AWS_ENV_FILE="$CRED_DIR/aws.env"

# Clear old credentials
echo "# Auto-generated AWS credentials" > "$AWS_ENV_FILE"
echo "" >> "$AWS_ENV_FILE"

index=0

IFS=',' read -ra ROLES <<< "$AWS_ROLE_ARNS"
for ROLE_ARN in "${ROLES[@]}"; do
  echo "[INFO] Assuming Role: $ROLE_ARN"

  ACCOUNT_ID=$(echo "$ROLE_ARN" | cut -d':' -f5)
  
  ASSUME_ROLE_OUTPUT=$(aws sts assume-role \
    --role-arn "$ROLE_ARN" \
    --role-session-name "pmm-session-${ACCOUNT_ID}")

  AWS_ACCESS_KEY_ID=$(echo "$ASSUME_ROLE_OUTPUT" | jq -r '.Credentials.AccessKeyId')
  AWS_SECRET_ACCESS_KEY=$(echo "$ASSUME_ROLE_OUTPUT" | jq -r '.Credentials.SecretAccessKey')
  AWS_SESSION_TOKEN=$(echo "$ASSUME_ROLE_OUTPUT" | jq -r '.Credentials.SessionToken')

  {
    echo "# $ACCOUNT_ID"
    echo "AWS_ACCESS_KEY_ID_${index}=$AWS_ACCESS_KEY_ID"
    echo "AWS_SECRET_ACCESS_KEY_${index}=$AWS_SECRET_ACCESS_KEY"
    echo "AWS_SESSION_TOKEN_${index}=$AWS_SESSION_TOKEN"
    echo ""
  } >> "$AWS_ENV_FILE"

  index=$((index + 1))

done

# Set default env to last assumed account
{
  echo "AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID"
  echo "AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY"
  echo "AWS_SESSION_TOKEN=$AWS_SESSION_TOKEN"
} >> "$AWS_ENV_FILE"

echo "[INFO] Credentials saved to $AWS_ENV_FILE"
