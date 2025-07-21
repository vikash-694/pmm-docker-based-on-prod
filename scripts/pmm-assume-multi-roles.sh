#!/bin/bash

CRED_DIR="$(cd "$(dirname "$0")/.." && pwd)/aws-creds"
AWS_ENV_FILE="$CRED_DIR/aws.env"

if [[ ! -f "$AWS_ENV_FILE" ]]; then
  echo "[ERROR] No aws.env found. Run refresh-pmm-creds.sh first."
  exit 1
fi

source "$AWS_ENV_FILE"

export AWS_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY
export AWS_SESSION_TOKEN

echo "[INFO] AWS credentials exported from $AWS_ENV_FILE"
