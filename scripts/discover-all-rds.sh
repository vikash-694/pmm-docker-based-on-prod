#!/bin/bash

source "$(cd "$(dirname "$0")" && pwd)/pmm-assume-multi-roles.sh"

echo "[INFO] Discovering all RDS instances..."
aws rds describe-db-instances --query "DBInstances[].{Identifier:DBInstanceIdentifier,Endpoint:Endpoint.Address}" --output table
