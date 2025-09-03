#!/bin/bash
set -e

CRED_DIR="$(cd "$(dirname "$0")/.." && pwd)/aws-creds"
AWS_ENV_FILE="$CRED_DIR/aws.env"

if [[ ! -f "$AWS_ENV_FILE" ]]; then
  echo "[ERROR] No aws.env found. Run refresh-pmm-creds.sh first."
  exit 1
fi

source "$AWS_ENV_FILE"

ROLE_INDEX=${1:-default}

if [[ "$ROLE_INDEX" == "default" ]]; then
    export AWS_ACCESS_KEY_ID
    export AWS_SECRET_ACCESS_KEY
    export AWS_SESSION_TOKEN
    echo "[INFO] AWS default credentials exported"
else
    AWS_ACCESS_KEY_ID_VAR="AWS_ACCESS_KEY_ID_${ROLE_INDEX}"
    AWS_SECRET_ACCESS_KEY_VAR="AWS_SECRET_ACCESS_KEY_${ROLE_INDEX}"
    AWS_SESSION_TOKEN_VAR="AWS_SESSION_TOKEN_${ROLE_INDEX}"

    export AWS_ACCESS_KEY_ID="${!AWS_ACCESS_KEY_ID_VAR}"
    export AWS_SECRET_ACCESS_KEY="${!AWS_SECRET_ACCESS_KEY_VAR}"
    export AWS_SESSION_TOKEN="${!AWS_SESSION_TOKEN_VAR}"

    echo "[INFO] AWS credentials for role index $ROLE_INDEX exported"
fi