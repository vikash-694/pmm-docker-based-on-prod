#!/bin/bash
set -e

echo "[INFO] $(date) - Refreshing AWS credentials..."
./scripts/refresh-pmm-creds.sh

#echo "[INFO] Restarting PMM container to load fresh credentials..."
#docker compose -f docker-compose.base.yml --env-file .env restart pmm-server

echo "[INFO] Restarting PMM container to load fresh credentials..."
docker compose -f docker-compose.base.yml -f docker-compose.prod.yml up -d

echo "[INFO] $(date) - Completed AWS credential refresh and PMM restart."