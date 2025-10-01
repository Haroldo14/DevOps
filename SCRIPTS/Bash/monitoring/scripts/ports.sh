#!/usr/bin/env bash
# scripts/monitor_ports.sh
set -euo pipefail

PORTS=${PORTS:-"22,80,443"}
IFS=',' read -ra arr <<< "$PORTS"
missing=()

for p in "${arr[@]}"; do
  if ! ss -lnt | awk '{print $4}' | grep -q ":$p$"; then
    missing+=("$p")
  fi
done

if (( ${#missing[@]} )); then
  ./scripts/webhook_notify.sh "ALERT: Ports not listening -> ${missing[*]}"
else
  echo "Ports OK"
fi

