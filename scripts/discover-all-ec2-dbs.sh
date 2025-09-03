#!/bin/bash

ROLE_INDEX=${1:-}  # optional role index

source "$(cd "$(dirname "$0")" && pwd)/pmm-assume-multi-roles.sh" "$ROLE_INDEX"

echo "[INFO] Discovering EC2 database servers (role index: ${ROLE_INDEX:-default})..."

aws ec2 describe-instances \
  --filters "Name=tag:Module,Values=db" \
  --query "Reservations[].Instances[].{ID:InstanceId,PrivateIP:PrivateIpAddress,State:State.Name}" \
  --output table