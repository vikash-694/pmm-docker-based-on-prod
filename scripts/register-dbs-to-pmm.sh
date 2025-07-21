#!/bin/bash
set -e

PMM_URL="https://10.3.10.41:443" # Replace with your PMM server URL
PMM_API_USER="admin"
PMM_API_PASSWORD="${PMM_ADMIN_PASSWORD:-Freecharge123!}"

DB_INSTANCES=("db-instance-1" "db-instance-2")  # Example DB names

for db in "${DB_INSTANCES[@]}"; do
  curl -sk -u "$PMM_API_USER:$PMM_API_PASSWORD" \
    -X POST "$PMM_URL/v1/management/DB/Register" \
    -H "Content-Type: application/json" \
    -d '{"name": "'"$db"'", "type": "mysql"}'

  echo "[INFO] Registered DB $db to PMM"
done
echo "[INFO] All DBs registered to PMM successfully."