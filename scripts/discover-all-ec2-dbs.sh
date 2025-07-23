#!/bin/bash

source "$(cd "$(dirname "$0")" && pwd)/pmm-assume-multi-roles.sh"

echo "[INFO] Discovering EC2 database servers (tagged)..."

aws ec2 describe-instances \
  --filters "Name=tag:Module,Values=db" \
  --query "Reservations[].Instances[].{ID:InstanceId,PrivateIP:PrivateIpAddress,State:State.Name}" \
  --output table