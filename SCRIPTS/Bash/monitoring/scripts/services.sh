#!/usr/bin/env bash
# scripts/monitor_service.sh
set -euo pipefail

FILE="${1:-config/services.txt}"   # liste des services à surveiller
while read -r svc; do
  [[ -z "$svc" || "$svc" =~ ^# ]] && continue
  if ! systemctl is-active --quiet "$svc"; then
    ./scripts/webhook_notify.sh "ALERT: Service '$svc' is NOT active"
  fi
done < "$FILE"

