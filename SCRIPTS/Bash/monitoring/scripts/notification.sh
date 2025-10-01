#!/bin/bash#!/usr/bin/env bash# scripts/webhook_notify.sh
set -euo pipefail

MESSAGE=${1:-"No message"}
WEBHOOK_URL=${WEBHOOK_URL:-""}

if [[ -z "$WEBHOOK_URL" ]]; then
  echo "WEBHOOK_URL not set. Printing message locally:"
  echo "$MESSAGE"
  exit 0
fi

payload=$(jq -n --arg text "$MESSAGE" '{text: $text}')
curl -s -X POST -H "Content-Type: application/json" -d "$payload" "$WEBHOOK_URL" >/dev/null || true

