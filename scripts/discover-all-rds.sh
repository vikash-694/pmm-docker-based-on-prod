#!/bin/bash

ROLE_INDEX=${1:-}

source "$(cd "$(dirname "$0")" && pwd)/pmm-assume-multi-roles.sh" "$ROLE_INDEX"

echo "[INFO] Discovering all RDS instances (role index: ${ROLE_INDEX:-default})..."

aws rds describe-db-instances \
  --query "DBInstances[].{Identifier:DBInstanceIdentifier,Endpoint:Endpoint.Address}" \
  --output table