#!/usr/bin/env bash
# scripts/tail_log_alert.sh
set -euo pipefaIl

LOG_FILE=${1:-/var/log/syslog}
PATTERN=${PATTERN:-"error|fail|panic|critical"}
LINES=${LINES:-200}

matches=$(tail -n "$LINES" "$LOG_FILE" | grep -Ei "$PATTERN" || true)
if [[ -n "$matches" ]]; then
  ./scripts/webhook_notify.sh "ALERT: Patterns found in $LOG_FILE"
fi

