#!/usr/bin/env bash
# scripts/monitor_process.sh
set -euo pipefail

PROCESS_NAME=${1:-nginx}       # ex: ./monitor_process.sh nginx
CPU_MAX=${CPU_MAX:-80}
MEM_MAX=${MEM_MAX:-500}        # en MB

pids=$(pgrep -f "$PROCESS_NAME" || true)
if [[ -z "$pids" ]]; then
  ./scripts/webhook_notify.sh "ALERT: Process '$PROCESS_NAME' not running"
  exit 1
fi

while read -r pid cpu rss; do
  rss_mb=$((rss/1024))
  if (( $(printf "%.0f" "$cpu") >= CPU_MAX || rss_mb >= MEM_MAX )); then
    ./scripts/webhook_notify.sh "ALERT: $PROCESS_NAME pid=$pid CPU=${cpu}% MEM=${rss_mb}MB"
  fi
done < <(ps -o pid,pcpu,rss -p $(echo "$pids") --no-headers)

